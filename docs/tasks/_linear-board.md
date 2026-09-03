# Night 4–5 queue — the board

Linear is the **board**, not the judge. A card moves only when a packet
exists under `evidence/` (terminal, not Git). Chat is not a settle.

**Tonight do not open GitKraken / Linear in the browser.** The signed-in
Linear MCP is down. This file **is** the queue. If Linear comes back
later, copy these rows; do not recut the night for it.

Seams on this plant: **ingest-landing**, **dlt-gold**,
**orchestrate-serve**. Not `assurance` / `foundation` / `models`.

`signed_off` starts **false**. Do not crank unsigned leaves.

| Card | Lane | Eval (exact) | Status tonight |
|---|---|---|---|
| T-20260825-type-01-landing-parser | ingest-landing | live `B202607230000001` MATCHED 173.45 + `evidence/modern/B202607230000001/golden-match.json` both questions true | **settled** · packet `evidence/loop/T-20260825-type-01-landing-parser.json` · `signed_off: true` · eval exit 0 · Dagster hash skipped |
| T-20260827-type-02-ingest | ingest-landing | `docs/tasks/T-20260827-type-02-ingest.md` `eval_1 && eval_2` | queued · `signed_off: false` |
| T-20260827-type-02-lakehouse | dlt-gold | `docs/tasks/T-20260827-type-02-lakehouse.md` `eval_1 && eval_2` · `DF-SOURCE-002` = `CONFIRMED_SOURCE_DEFECT` | queued |
| T-20260827-type-03-ingest | ingest-landing | `docs/tasks/T-20260827-type-03-ingest.md` `eval_1 && eval_2` | queued |
| T-20260827-type-03-lakehouse | dlt-gold | `docs/tasks/T-20260827-type-03-lakehouse.md` `eval_1 && eval_2` · `DF-SOURCE-003` = `CONFIRMED_SOURCE_DEFECT` | queued |
| T-20260827-type-04-ingest | ingest-landing | `docs/tasks/T-20260827-type-04-ingest.md` `eval_1 && eval_2` | queued |
| T-20260827-type-04-lakehouse | dlt-gold | `docs/tasks/T-20260827-type-04-lakehouse.md` `eval_1 && eval_2` · `DF-SOURCE-004` = `CONFIRMED_SOURCE_DEFECT` | queued |
| T-20260827-type-05-ingest | ingest-landing | `docs/tasks/T-20260827-type-05-ingest.md` `eval_1 && eval_2` · `HALF_UP` · `DF-SOURCE-005` zero Parquet | queued |
| T-20260827-type-05-lakehouse | dlt-gold | `docs/tasks/T-20260827-type-05-lakehouse.md` `eval_1 && eval_2` · `DF-SOURCE-005` = `CONFIRMED_SOURCE_DEFECT` · `rounding-half-up` = `HALF_UP` · `HALF_EVEN` = `MODERN_DEFECT` | queued |
| T-20260827-orchestrate-type-01 | orchestrate-serve | `docs/tasks/T-20260827-orchestrate-type-01.md` `eval_1 && eval_2` · same Gold hash if Dagster exists · **skip hash if Dagster is not up** | queued · do not stand up Dagster to look busy |
| T-20260828-type-06-ingest | ingest-landing | `docs/tasks/T-20260828-type-06-ingest.md` `eval_1 && eval_2 && eval_3` · HALF_UP **1.01** · malformed zero Parquet | **built** · five-file present · `signed_off: true` |
| T-20260828-type-06-lakehouse | dlt-gold | `docs/tasks/T-20260828-type-06-lakehouse.md` · two questions · `CONFIRMED_LEGACY_DEFECT` | **stalled** · packet `evidence/factory/type-06.json` · modern **1.01** · legacy **1.00** · do not patch |

Do not settle from chat. Type `06` moves when `evidence/` holds the packet. Do not create empty type folders. Do not dump Types `02`–`05`.

**Board vs disk (2026-09-03).** The "Status tonight" column is what the
board said when each card last moved. On disk now: the four `02`–`05`
**ingest** packages exist under `modern/ingestion/src/northwind_pay/types/`
(five files each, authored Night 4) and `modern/orchestration/definitions.py`
exists, but their frontmatter still reads `signed_off: false` /
`status: ready` — the code was written ahead of the sign, so those cards
stay **queued** until an owner signs and a packet lands. The `02`–`05`
**lakehouse** leaves have no code. `evidence/` is gitignored, so on a fresh
clone none of the packets named above are present; the settled and stalled
rows are claims about the night's terminal, not about git.
