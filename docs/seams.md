# Seams — Type 01 ingest → landing, then dlt → Gold

Pass 3 Decompose. Seamwise names: **seam**, **swimlane**, **leg**.
One owner per handoff. Papers live in `docs/`, not `cvg/docs/`.

The seam is a **handoff**, not a language. **Java vs Python is not a
seam.** Both plants read the same SFTP raw bytes; they do not own each
other. **Bronze / Silver / Gold are legs, not new estates.**

## Steel thread

**Night 2 (signed):** Type 01 ingest → landing. Do not recut.

**Night 3 (tonight):** Type 01 **dlt → Gold**. This is the only lane
for new leaves tonight (Pass 5). Types `02`–`05` and orchestrate wait
for Thursday.

*(Historical — written Night 3, 2026-08-26. Seam 3 was unparked on Night
4; Type 06 got its own cut in [`seams-type-06.md`](seams-type-06.md) on
Night 5. The text below is left as signed.)*

Landing facts already closed (ADRs 0001–0005): first write is
`modern/landing/` Parquet, not SFTP; five-file package; Decimal;
privacy dies at the parser; source lie keeps 173.44 and emits zero
Parquet. Lakehouse facts tonight: ADRs 0007–0011.

## Vocabulary

| Name | Meaning here |
|---|---|
| **Seam** | The cut: what is consumed, what is produced, who may write |
| **Swimlane** | Exactly one owning seat. Coordinates the write surface. Others read through the contract |
| **Leg** | Ordered, observable capability on that lane. Proof is a terminal, not a promise |

Two owners on one seam, or a seam with no owner, is refused.

## Seam list

### 1. Ingest → landing

| | |
|---|---|
| **Seam** | Type 01 raw intake → sanitized landing |
| **Swimlane** | Translator (SWE) — Night 2 |
| **When** | Night 2. **Signed.** Product write after ingest Consensus |
| **Consumes** | Same SFTP `raw/incoming` bytes, checksum, manifest last. `contracts/types/01-card-settlement/` |
| **Produces** | Accepted: atomic Parquet + readiness manifest in `modern/landing/`. Refused / source lie: **zero Parquet**, stable finding |
| **Write surface** | Type 01 five-file package (`model → parser → schema → writer → handler`) and `modern/landing/` |
| **Must not write** | `legacy/`, `contracts/`, `gen/`, `infra/`, SFTP `csv/outgoing`, lakehouse, Gold |
| **Reads through contract** | Legacy CSV, Postgres paid grain, Java — observation only. Never inputs |

**Legs** (ordered):

1. **Sense** — identity, checksum, manifest-last, replay. Same raw the live line already reads.
2. **Claim** — Type 01 parse, Decimal money, privacy at the parser, independent controls.
3. **Emit** — landing Parquet for `valid-minimal` (net 173.45, MATCHED shape); quarantine with zero Parquet for `df-source-001` (keep 173.44) and malformed.

Night 2’s parser leaf attaches here. Night 3 may finish emit (schema /
writer / handler) so landing exists; it does not recut this seam.

### 2. dlt → Gold

| | |
|---|---|
| **Seam** | Immutable landing → governed Gold |
| **Swimlane** | Constructor (DE + analytics) — Night 3 |
| **When** | **Tonight.** Unparked as ADRs 0007–0011 |
| **Consumes** | `modern/landing/` Parquet already published. Does **not** re-parse raw |
| **Produces** | Bronze → Silver → Gold; golden-match attached to contract and to legacy observation |
| **Write surface** | dlt register-only, local DuckLake / DuckDB, dbt Bronze / Silver / Gold, `evidence/modern/` |
| **Must not write** | Raw files, the Type 01 parser grammar, frozen plant (`legacy/` `contracts/` `gen/` `infra/`), SFTP, Dagster, FastAPI, Types `02`–`05` |

**Legs** (ordered, observable):

1. **Register** — dlt registers `modern/landing/` Parquet into local
   DuckDB. No re-parse. No money. No privacy. Zero-Parquet batches
   stay absent (ADR 0007, 0008).
2. **Medallion** — Bronze (source-aligned, grain `batch_id` +
   `source_record_number`) → Silver (same grain, conserved money) →
   Gold (paid grain `batch_id` + `currency`). Parser already did
   privacy + Decimal; dbt does not retokenize (ADR 0009, 0010).
3. **Match** — attach `validation/golden-match/golden_match.py`. Two
   questions never netted. `valid-minimal` both yes.
   `DF-SOURCE-001` = `CONFIRMED_SOURCE_DEFECT`, keep **173.44**, no
   Gold. Malformed classified. No tolerance. Do not rewrite the
   referee (ADR 0011).

Constructor owns this write surface. Translator does not write Gold.

### 3. Orchestrate + serve

| | |
|---|---|
| **Seam** | Gold + Type 01 landing → unattended run and read-only serve |
| **Swimlane** | Orchestrator — Night 4 |
| **When** | Day 4. Parked in ADR 0006 |
| **Consumes** | Approved Gold; Type 05 contract when that night opens. Not restricted raw |
| **Produces** | Dagster lineage / replay; Type 05 unattended including `HALF_UP`; read-only serve of approved Gold only |
| **Write surface** | Dagster, serving — **unparked on Day 4** |
| **Must not write** | Parser, landing contract, frozen `legacy/`, unresolved Gold |

**Legs** (named, not run tonight): orchestrate replay → Type 05 pill → serve approved Gold. FastAPI/MCP and CI stay parked (default CI = no).

## Refused cuts

- Java vs Python
- CSV-as-input to modern
- SFTP as modern destination
- Type 06 (not in this drop — cut separately on Night 5, see [`seams-type-06.md`](seams-type-06.md))
- A lakehouse named as a **new estate** (it is seam 2 legs)
- Recutting seam 1 to smuggle Gold

## Handoff rule

Each seam has one owner. Translator does not write Gold. Constructor
does not rewrite landing grammar. Orchestrator does not parse Type 01.
Pass 5 writes **Type 01 remainder + lakehouse leaves on seam 2** after
`docs/consensus-lakehouse.md`. No lakehouse sign → no Gold (09–12
dark). Ingest sign in `docs/consensus.md` stays canonical.
