# Publisher — the entry to the estate

One file, 225 lines, and it owns a single boundary:

> *Validate DataGen bundles and publish them to raw SFTP manifest-last.*

Nothing else in the repository may write to `raw/incoming`.

## The two rules

**1. Validate before publishing.** The bundle's raw file, SHA-256 sidecar, and
`source-manifest.json` are checked against each other and against the JSON
Schema before a single byte crosses to SFTP. A malformed bundle is refused
here, not discovered three components later.

**2. The manifest goes last.** This is the readiness contract for the entire
estate:

```text
raw/incoming/B2026…/
  1. NW_….dat            the raw source file
  2. NW_….dat.sha256     the checksum sidecar
  3. source-manifest.json   ← written LAST
```

`intake/` and `worker.py` treat the presence of `source-manifest.json` as
"this batch is complete and may be claimed". Publishing it first — or
concurrently — would let a consumer claim a half-written batch. **The ordering
is the synchronization primitive.** There is no lock and none is needed.

## Least privilege

The publisher authenticates as the **`raw-publisher`** SFTP role, which belongs
to exactly one group and can write to exactly one zone. It therefore:

- cannot observe what happens to a batch after publication;
- cannot withdraw or amend what it published;
- cannot see `raw/processing`, `raw/quarantine`, `raw/archive`, or any CSV zone.

**Publication is one-way by construction**, enforced by Unix group ownership
rather than by application logic. See
[`../../infra/README.md`](../../infra/README.md) for the full role and zone
matrix.

## Where it is invoked

```bash
make publish-raw            # via legacy/runner/publish_raw_cli.py
```

`legacy/runner/run_type.py` also puts this directory on `sys.path`, so a full
typed workflow publishes through the same code rather than a second path.

## What must not change

- **The manifest-last ordering.** Every downstream readiness check depends on
  it.
- **The `raw-publisher` role.** Widening it removes the one-way property.
- **Validation before transport.** Publishing an unvalidated bundle moves the
  failure into a component that cannot attribute it.
