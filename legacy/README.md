# The legacy estate

**32,588 lines, 75 files, four languages.** This is the system that works, and
it is the **frozen oracle**: nothing in here may be modified to make a gate
pass. When legacy and modern disagree, this folder is evidence — never a
variable.

For scale: `contracts/` is ~2,850 lines of YAML and the entire modern
platform is 7,700. Legacy is 4.2× the size of its replacement, and that
ratio is the business case. (Counts as of 2026-09-03, after the Night 5
Type `06` kit was added to both plants.)

| Component | Lines | Files | Language | Role |
|---|---:|---:|---|---|
| [`processor/`](processor/README.md) | 14,395 | 35 | Java 21 | Parse, validate, sanitize |
| [`postgres/`](postgres/README.md) | 10,571 | 22 | PL/pgSQL + Python | Load, apply, reconcile |
| [`runner/`](runner/README.md) | 7,159 | 16 | Python | Orchestrate everything |
| [`intake/`](intake/README.md) | 238 | 1 | Python | Own the raw zone transitions |
| [`publisher/`](publisher/README.md) | 225 | 1 | Python | Publish to raw SFTP |

---

## One batch, end to end

```text
gen/output/B2026…                     DataGen writes an immutable bundle
     │
     │  publisher/  ── authenticates as `raw-publisher`
     ▼
raw/incoming/                          manifest written LAST = the ready signal
     │
     │  intake/     ── authenticates as `processor`
     ▼
raw/processing/                        claimed; no one else may take it
     │
     │  processor/  ── Java, in a container
     ▼
csv/outgoing/                          sanitized CSV; no PAN, no clear CPF
     │
     │  postgres/   ── authenticates as `loader`, never sees raw/
     ▼
staging → legacy → reporting           COPY, governed procedure, reconciliation
     │
     ▼
raw/archive/ + csv/archive/            only `operator` can archive
```

Two terminal outcomes, and only two: **archived** or **quarantined**. A
quarantined batch never blocks an unrelated one.

The whole route is driven by [`runner/`](runner/README.md), which owns sensing,
claiming, locking, crash recovery, and evidence.

---

## Why four languages is the point, not an accident

This is a realistic legacy estate, so it has the properties that make estates
hard to replace:

- **A JVM you cannot inspect from Python** — the sanitized CSV is the only
  interface. Modern must reimplement the grammar from the *contract*, not from
  the Java.
- **Business logic inside the database** — stored procedures, not application
  code. Rewriting the app does not move the logic.
- **Filesystem-level trust boundaries** — SFTP zones with Unix group ownership.
  The privacy guarantee is `chown`, not a code review. See
  [`../infra/README.md`](../infra/README.md).
- **An orchestrator with crash semantics** — a recovery journal, terminal-state
  ordering, and restart repair. The hard part of the migration is here.

---

## Per-type symmetry

Every type has exactly one Java processor, one loader, one workflow adapter,
and one oracle. There is no partially implemented type on the five-type
base. Type `06` (Night 5) has the same four pieces but is thin on tests —
see below.

| Type | Java main | Java test | Loader | Migration |
|---|---:|---:|---:|---|
| `01` | 695 | 433 | 760 | `001` + `002` |
| `02` | 1,032 | 539 | 887 | `004` |
| `03` | 1,680 | 911 | 977 | `005` |
| `04` | 1,552 | 1,098 | 1,015 | `006` |
| `05` | 1,118 | 997 | 965 | `007`–`010` |
| `06` | 1,125 | 73 | 959 | `011` |

Roughly one Java test line per 1.5 source lines on the base, and the ratio
*rises* with grammar nastiness — Type 05 is 0.89. Type 05's four
migrations are follow-up corrections to control width and the HALF_UP
constraint, not asymmetry. Type `06` is the outlier at 0.06: it was
authored as the Night 5 kit with a **planted** `HALF_EVEN` miss
(`Type06Processor.java`), and its thin test class is part of why the
factory, not the plant's own suite, is what catches the cent.

**Type 01 has no `type01` migration.** Its tables are in `001` under generic
names, and its procedures are version `002` inside `procedures/`. See
[`postgres/README.md`](postgres/README.md#four-things-about-this-folder-that-are-not-obvious).

---

## Reading this folder without being misled

**`legacy/runner/.venv/` is 126 MB inside the source tree.** It is gitignored,
but it means a naive `find legacy/ -name '*.py' | xargs wc -l` reports 428,628
lines instead of 6,793. Use `git ls-files legacy/` to see the real estate.

**The only per-type filenames in `runner/` are the two dead ones.**
`run_type01.py` and `run_type02.py` are self-described backward-compatible
entrypoints, superseded by `run_type.py --type NN`, not called by the Makefile,
and there are two tests asserting the facade does *not* invoke them. All six
types live inside `workflow_registry.py`. Scanning filenames gives exactly the
wrong impression twice over.

**`procedures/` holding one file is historical**, and that file is misnamed —
six of its eight functions are the shared control plane used by all six types.

---

## What must not change

Everything. `legacy/` is a frozen oracle:

- **Never** edit an expected value, fixture, or behaviour to turn a gate green.
- **Never** modify an applied migration — `control.schema_migrations` stores a
  SHA-256 and `migrate.py` refuses drift.
- **Never** rename a file that is recorded in the migration ledger or resolved
  by path from another language.

The dead compatibility shims stay for the same reason: removing them would be a
change to frozen truth for cosmetic gain. They are documented above instead.

If a gate cannot pass without changing something in here, that is a **hard
stop**, not a task.
