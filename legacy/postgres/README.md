# Legacy PostgreSQL

This folder owns the sanitized-file loading boundary, governed business
procedures, operational legacy tables, and reconciliation reporting.

## Loader map

| File | Responsibility |
|---|---|
| `loader_common.py` | Shared batch controls, terminal finalization, rejection recording, and CSV quarantine helpers |
| `type01_diagnostics.py` | Type 01 privacy-safe, read-only control recomputation |
| `type01_loader.py` | Type 01 card-settlement validation, `COPY`, procedures, and reconciliation |
| `type02_loader.py` | Type 02 instant-payment-event loading |
| `type03_loader.py` | Type 03 payment-slip-settlement loading |
| `type04_loader.py` | Type 04 TED-transfer-settlement loading |
| `type05_loader.py` | Type 05 merchant-fee-assessment loading |
| `type06_loader.py` | Type 06 merchant-chargeback loading |

The common module does not own a business layout. Each numbered loader owns
the parsing and PostgreSQL behavior for exactly one file type.

## Batch path

```text
/csv/outgoing/<batch>
  -> /csv/processing/<batch>
  -> validate sanitized manifest, checksum, lineage, and CSV
  -> COPY into the type staging table
  -> execute governed legacy procedure
  -> refresh reporting reconciliation
  -> commit only when the controls match
  -> /csv/archive/<batch>
```

An invalid sanitized batch is isolated under `/csv/quarantine/<batch>`.
Unrelated batches remain eligible for processing.

## Database structure

- `migrations/` contains immutable, checksummed schema evolution.
- `procedures/` contains the governed PL/pgSQL entrypoints.
- `init/` creates the least-privilege application role for a fresh database.
- `migrate.py` applies migrations and rejects checksum drift.

Four schemas: `control` (batch state and lineage), `staging` (raw `COPY`
target), `legacy` (operational tables), `reporting` (reconciliation).

Use `make migrate` to apply schema changes and `make test-postgres` to exercise
the real `COPY`, procedure, permission, rollback, and reconciliation boundary.

---

## Four things about this folder that are not obvious

### 1. `migrations/` and `procedures/` are **one** numbered sequence

`migrate.py` globs both directories, sorts by the three-digit version, and
refuses duplicate versions:

```python
MIGRATION_NAME = re.compile(r"^(?P<version>[0-9]{3})_[a-z0-9_]+\.sql$")
MIGRATION_DIRECTORIES = ("migrations", "procedures")
```

So there are eleven migrations, `001`–`011`, and `002` simply lives elsewhere:

```text
001  migrations/001_schemas_and_tables.sql
002  procedures/002_type01_procedures.sql      ← the apparent gap
003  migrations/003_multitype_control_plane.sql
004…011  migrations/
```

`migrations/` looks like it is missing `002` because it is. Nothing is absent
from the database.

### 2. Type 01 has no `type01` migration, because it predates the concept

`001_schemas_and_tables.sql` creates the four schemas and then, under generic
names, nothing but Type 01 tables — `staging.card_settlement`,
`legacy.card_settlement`, `reporting.card_settlement_reconciliation` — plus:

```sql
CREATE TABLE control.batches (
    file_type text NOT NULL CHECK (file_type = '01'),
```

At version `001` the database was **physically incapable** of holding another
type. `003_multitype_control_plane.sql` is the moment that changed:

```sql
-- Expand the Type 01 control plane without changing its existing API.
ALTER TABLE control.batches DROP CONSTRAINT batches_file_type_check;
ALTER TABLE control.batches ADD CONSTRAINT batches_file_type_check
    CHECK (file_type IN ('01','02','03','04','05'));
```

`011_type06_merchant_chargeback.sql` (Night 5) widens that same CHECK to
include `'06'` and adds the Type `06` tables — the one migration that is
not part of the 2026-07-24 five-type proof.

Everything before `003` is generically named because it was universal by
accident. Everything after is `NNN_typeNN_*`. The naming asymmetry is the
fossil record, not sloppiness.

### 3. `002` is misnamed — it is the shared control plane

`procedures/` holds one file because Type 01 was built when DDL and behaviour
were separate concerns. From Type 02 onward, each type ships one self-contained
migration carrying both its tables and its two functions.

But `002_type01_procedures.sql` defines **eight** functions, and six of them
belong to every type:

```
control.register_batch           ┐
control.register_file            │
control.register_load            │  the control plane —
control.register_reject          │  called by all six loaders
control.mark_batch_committed     │  via loader_common.py
control.mark_batch_succeeded     ┘
legacy.apply_card_settlement_batch               ┐ genuinely
reporting.refresh_card_settlement_reconciliation ┘ Type 01
```

`loader_common.py` — imported by every numbered loader — calls
`control.register_batch` and `control.mark_batch_succeeded`. Type 05's loader
depends on a file named `002_type01_procedures.sql`.

It should have been `002_control_plane_and_type01.sql`. It is not renamed
because the recorded name and its SHA-256 live in `control.schema_migrations`,
and renaming would break checksum verification on every existing database.

### 4. Two different "003" — always ask which sequence

`init/*.sh` and `migrations/*.sql` are independent mechanisms whose numbers
overlap:

| | `init/*.sh` | `migrations/*.sql` |
|---|---|---|
| Runs | **Once**, on first database creation only | Every `make deploy`, via `migrate.py` |
| Trigger | Docker `docker-entrypoint-initdb.d` | Explicit, ordered by version |
| Tracked? | **No** — nothing records that they ran | **Yes** — `control.schema_migrations` |
| Re-runnable? | No; destroy the volume | Yes; checksums verified, drift refused |

```text
init/         000_create_app_role.sh   003_grants.sh
migrations/   001_…  003_multitype_control_plane.sql  …  010_…  011_type06_merchant_chargeback.sql
procedures/   002_type01_procedures.sql
```

`compose.yaml` mounts **four** files into `docker-entrypoint-initdb.d`:
`000_create_app_role.sh`, `001_schemas_and_tables.sql`,
`002_type01_procedures.sql`, `003_grants.sh`. Docker runs them in filename
order, which is why `003_grants.sh` can `GRANT EXECUTE ON
control.register_batch` — `002` has already created it.

On a fresh volume, `001` and `002` therefore run twice: once by Docker, once by
`migrate.py`. That is harmless (`CREATE TABLE IF NOT EXISTS`, `CREATE OR
REPLACE FUNCTION`) and `migrate.py` records them either way. The mount list is
a bootstrap ordering dependency, not a duplicate.
