# Local runtime substrate

Three files, 107 lines, and they carry more of the system's security posture
than anything else in the repository.

This folder builds the **SFTP server** that gives the four legacy roles real
operating-system separation. Not application-level permission checks — Unix
groups and setgid directory modes. It is what turns *"the loader cannot see a
card number"* from a promise into a fact enforced by the kernel.

```text
infra/local/sftp/
├── Dockerfile      Alpine pinned by digest, openssh-server, nothing else
├── sshd_config     the hardening
└── entrypoint.sh   the role and zone permission matrix
```

---

## The image

```dockerfile
FROM alpine:3.22@sha256:14358309a308569c32bdc37e2e0e9694be33a9d99e68afb0f5ff33cc1f695dce
```

Pinned by **digest**, not by tag. `alpine:3.22` can be republished; that digest
cannot. The proof ledgers in [`../plans/legacy.md`](../plans/legacy.md) record
the resulting image identity, and it reproduced byte-identically across every
runtime built during the autonomous run.

The image installs exactly one package. There is no shell for any user, no
package manager left in the run path, and no application code.

---

## `sshd_config` — six locks

| Directive | What it prevents |
|---|---|
| `AllowGroups sftpusers` | Anyone outside that group authenticating at all |
| `ChrootDirectory /sftp/shared` | Seeing any filesystem above the shared root |
| `ForceCommand internal-sftp -d /` | Obtaining a shell, running a command, using SCP |
| `PermitRootLogin no` | The obvious |
| `AllowTcpForwarding no` · `PermitTunnel no` | Using the jail as a network pivot |
| `PermitEmptyPasswords no` · `KbdInteractiveAuthentication no` | Credential-free entry |

Every account is additionally created with `/sbin/nologin`. Two independent
mechanisms deny a shell, which is the correct posture for a host that holds
restricted bytes.

`PasswordAuthentication yes` is deliberate and **local-only**. The credentials
live in `.env.example` as visible fixtures. This stack never runs outside a
developer machine.

---

## `entrypoint.sh` — the matrix

Four roles, eight zones, every zone `2770` (`rwxrws---`). The setgid bit is
load-bearing: files created in a zone inherit that zone's group, which is what
makes a handoff between two roles work without either one widening its own
permissions.

| Zone | owner:group | raw-publisher | processor | loader | operator |
|---|---|:-:|:-:|:-:|:-:|
| `raw/incoming` | `root:rawincoming` | ✓ | ✓ | — | ✓ |
| `raw/processing` | `root:rawprocessing` | — | ✓ | — | ✓ |
| `raw/quarantine` | `root:rawprocessing` | — | ✓ | — | ✓ |
| `raw/archive` | `root:operator` | — | — | — | ✓ |
| `csv/outgoing` | `root:csvoutgoing` | — | ✓ | ✓ | ✓ |
| `csv/processing` | `root:csvprocessing` | — | — | ✓ | ✓ |
| `csv/quarantine` | `root:csvprocessing` | — | — | ✓ | ✓ |
| `csv/archive` | `root:operator` | — | — | — | ✓ |

### Read the columns

- **`raw-publisher`** belongs to one group. It can drop a file into `incoming`
  and nothing else — it cannot observe what happens next, and it cannot
  withdraw what it published. Publication is one-way by construction.
- **`processor`** (the Java stage) can take raw from `incoming`, move it to
  `processing` or `quarantine`, and write sanitized CSV to `outgoing`. It
  **cannot archive** — declaring a batch complete is not its decision.
- **`loader`** never sees `raw/` **at all**. This is the privacy boundary
  expressed in kernel permissions: the component that talks to PostgreSQL is
  structurally incapable of touching a PAN or a CPF.
- **`operator`** is the only role that can archive, and the only one that can
  see every zone.

That third bullet is the answer to *"how do you know the loader can't leak a
card number?"* — it isn't a code review, it's `chown`.

### The `operator` role is not read-only

Worth stating plainly, because it is easy to assume otherwise: `operator` has
group **write** on every zone (`2770`). It is the *widest* role, not the
narrowest.

A later read-only observer (the detector) will authenticate as
`operator` because it is the only role that can see all eight zones.
Read-only behaviour is then a property of that observer's adapter —
`listdir`, `stat`, and read-mode `open` — **not** of the operating
system. `operator` itself has write on every zone because archive
needs it.

If that guarantee ever needs to be OS-enforced, the change is a fifth
role with read-only group membership — not a tightening of `operator`.

---

## Host keys regenerate on every container start

`ssh-keygen -A` runs in the entrypoint, and `/etc/ssh` is **not** on the
`sftp_data` volume. So every recreated container presents new host keys.

`make deploy` handles this: `legacy/runner/bootstrap_runtime.py` captures the
current key into `.runtime/known_hosts` and reports `verified SFTP host key
captured`. Clients use `RejectPolicy` against that file — an unknown key is a
hard failure, never a prompt.

The practical consequence: **after `make clean CONFIRM=clean-runtime`, always
`make deploy` before running anything that talks to SFTP.** A stale
`.runtime/known_hosts` produces an authentication failure that looks like a
credential problem and is not.

---

## Why `local/`, and where the other half lives

`infra/local/` is honest scoping, not an unfinished hierarchy. There is no
`infra/prod/` and there is not meant to be: deployment target selection is
explicitly out of scope per
[`plans/modern.md`](../plans/modern.md) (CI and deployment remain out of
scope), and no CI or infrastructure-as-code exists. Nothing is missing.

The runtime substrate is, however, **split across three places**, and it is
worth knowing all three before you go looking:

| Component | Lives in | Why there |
|---|---|---|
| SFTP server | `infra/local/sftp/` | Pure infrastructure, no application code |
| PostgreSQL roles and grants | `legacy/postgres/init/` | One-shot bootstrap, mounted as `docker-entrypoint-initdb.d` |
| PostgreSQL schema | `legacy/postgres/migrations/` | Checksum-tracked, applied by `migrate.py` |
| Wiring: ports, volumes, healthchecks, pinned images | `compose.yaml` | The single entrypoint that composes them |

### Two different PostgreSQL mechanisms — do not confuse them

| | `init/*.sh` | `migrations/*.sql` |
|---|---|---|
| Runs | **Once**, on first database creation only | Every `make deploy`, via `migrate.py` |
| Trigger | Docker `docker-entrypoint-initdb.d` | Explicit, ordered by version |
| Tracked? | **No** — nothing records that they ran | **Yes** — `control.schema_migrations` stores name + SHA-256 |
| Re-runnable? | No; destroy the volume to re-run | Yes; checksums are verified, drift is refused |

Only the eleven `.sql` migrations appear in `control.schema_migrations`
(`001`, `003`–`011` under `migrations/`, plus `002_type01_procedures.sql`
under `procedures/`). The two
shell scripts create the application role and its grants — work that must exist
*before* any schema does, which is why it cannot be a tracked migration.

**A numbering trap worth knowing.** The two sequences are independent and their
numbers overlap:

```text
init/         000_create_app_role.sh   003_grants.sh
migrations/   001_…sql  003_multitype_control_plane.sql  …  010_…sql  011_type06_merchant_chargeback.sql
procedures/   002_type01_procedures.sql
```

There are two different "003". On first container start Docker runs the mounted
files in filename order — `000.sh`, `001.sql`, `002.sql`, `003_grants.sh` — and
`migrate.py` then applies and records `001`–`011` itself. When someone says
"migration 003", ask which sequence they mean.

---

## What must not change

- **The digest pin.** Replacing it with a tag makes every ledger entry
  unreproducible.
- **Any zone's group ownership.** The matrix above *is* the least-privilege
  design; widening one row silently removes a boundary the tests assume.
- **The `2770` mode.** Drop the setgid bit and cross-role handoffs break in a
  way that looks like a permissions bug in application code.
- **`ForceCommand` or `ChrootDirectory`.** They are the difference between an
  SFTP drop box and a shell host.

Adding a **new zone** means: create it in `entrypoint.sh`, give it a group, add
that group to exactly the roles that need it, set `2770`, and update the table
above. Adding a **new role** means a new user, a new group membership list, and
a new column here.
