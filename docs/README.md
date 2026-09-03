# Docs — Converge paper trail

This folder is where Converge **writes**. It is not inbound
([`spec/`](../spec/README.md)), not the judge ([`contracts/`](../contracts/README.md)),
and not the method manuals ([`presentation/`](../presentation/README.md)).

This repo’s Converge home for the **room** is **`docs/`**, not `cvg/docs/`.
If `cvg` emits under `cvg/docs/` or `cvg/swimlanes/`, copy the artifact
into the path below. `cvg init` (Thursday, or host) creates `cvg/` for
the referee — it does **not** replace this folder. Do not copy another
project’s lane names (`assurance` / `foundation` / `models`). This plant’s
seams are **ingest → landing**, **dlt → Gold**, **orchestrate + serve**.

Do not upload these files into NotebookLM. The brain is inbound only
([`brain/notebooklm/`](../brain/notebooklm/README.md)).

---

## Story of the week (what papers close)

| Night | Seat | What this folder holds | Product (not this folder) |
|---|---|---|---|
| **1** | Archaeologist | BRD + tech-spec (Pass 0–1) | none |
| **2** | Translator (SWE) | Landing ADRs 0001–0005, **0006 parked**, `seams.md`, ingest **sign**, one parser leaf | parser may exist under `modern/ingestion/`; Parquet **not** required Tuesday |
| **3** | Constructor (DE + analytics) | Unpark 0006 → ADRs 0007+; seam 2 legs; **`consensus-lakehouse.md`**; Type 01 lakehouse leaves | Type 01 **landing → Gold + golden-match**. Mesh **seed**. Types `02`–`05` **not** tasked |
| **4** | Orchestrator | Remaining SWE + DE leaves (`02`–`04`, Type `05`, orchestrate). Unpark 0006 rows 8–9 as **0012–0013** (0006 stays the park record) | Trail first, then loop cranks with a **packet**. Linear is the board. Type `05` unattended |
| **5** | Dark Factory | Type `06` papers (`brd` / tech-spec / ADR 0014–0015 / `seams-type-06.md` / `consensus-type-06.md`) | Recap Type 01 from disk · Linear queue · look up 02–05 · smoke · **Type `06` 0–8** · flywheel. Classify. Do not patch `legacy/` |

**Two nights, two seats, one type** (Tue–Wed). Thursday **walks that trail**, then **generates** the rest and cranks it.
Do not dump Types `02`–`05` on Wednesday.

Clocks: [`run/d2/`](../run/d2/README.md) · [`run/d3/`](../run/d3/README.md) · [`run/d4/`](../run/d4/README.md) · [`run/d5/`](../run/d5/README.md).
Scope: [`agenda/d3.md`](../agenda/d3.md) · [`agenda/d4.md`](../agenda/d4.md) · [`agenda/d5.md`](../agenda/d5.md).

---

## On disk now (after Night 5)

All five Nights have written here. Type 01 Gold **source and papers
are on this checkout**; so are the Type `06` papers and the Night 4
leaves. Landing Parquet, DuckDB, and `evidence/modern/` are gitignored —
open them in the **terminal**.

```text
docs/
  README.md                              this map
  brd-type-01-card-settlement.md         Pass 0 Capture     Day 1
  tech-spec-type-01-card-settlement.md    Pass 1 Intent      Day 1
  CONTEXT.md                             glossary           Day 2
  adrs/0001-first-write-is-landing-parquet.md
  adrs/0002-type-01-five-file-package.md
  adrs/0003-decimal-never-float.md
  adrs/0004-privacy-dies-at-the-parser.md
  adrs/0005-source-lie-kept-zero-parquet.md
  adrs/0006-later-nights-parked.md        rows 3–7 unparked as 0007–0011; 8–9 as 0012–0013
  adrs/0007-dlt-registers-landing-only.md
  adrs/0008-ducklake-duckdb-is-local.md
  adrs/0009-medallion-grains-and-keys.md
  adrs/0010-rule-split-parser-vs-dbt.md
  adrs/0011-golden-match-keys-two-questions.md
  adrs/0012-dagster-is-lineage-not-parser.md
  adrs/0013-fastapi-readonly-approved-gold.md
  seams.md                               seam 1 signed; seam 2 legs tasked; 8–9 unparked
  consensus.md                           ingest → landing **signed** 2026-08-25
  consensus-lakehouse.md                 dlt → Gold **signed** 2026-08-26
  tasks/T-20260825-type-01-landing-parser.md
  tasks/T-20260826-type-01-landing-emit.md
  tasks/T-20260826-type-01-dlt-register.md
  tasks/T-20260826-type-01-bronze.md
  tasks/T-20260826-type-01-silver.md
  tasks/T-20260826-type-01-gold.md
  tasks/T-20260826-type-01-golden-match.md
  tasks/T-20260827-type-02-ingest.md
  tasks/T-20260827-type-02-lakehouse.md
  tasks/T-20260827-type-03-ingest.md
  tasks/T-20260827-type-03-lakehouse.md
  tasks/T-20260827-type-04-ingest.md
  tasks/T-20260827-type-04-lakehouse.md
  tasks/T-20260827-type-05-ingest.md
  tasks/T-20260827-type-05-lakehouse.md
  tasks/T-20260827-orchestrate-type-01.md
  brd-type-06-merchant-chargeback.md      Pass 0 Capture     Day 5
  tech-spec-type-06-merchant-chargeback.md Pass 1 Intent     Day 5
  adrs/0014-type-06-five-file-half-up.md
  adrs/0015-type-06-gold-grain-and-classification.md
  seams-type-06.md                       Type 06 on the same three cuts
  consensus-type-06.md                   Type 06 **signed** 2026-08-28
  tasks/T-20260828-type-06-ingest.md
  tasks/T-20260828-type-06-lakehouse.md
```

Product these papers authorized (source tracked in `modern/`; runtime gitignored — look up in the terminal):

- `modern/ingestion/src/northwind_pay/types/0{1..6}-*/` six five-file packages (Night 2 leaf, Night 4 generate, Night 5 kit)
- `modern/lakehouse/dlt/registration.py` · `modern/dbt/` Bronze/Silver/Gold for Type `01` **and** Type `06` · `modern/orchestration/definitions.py` Dagster (ADR 0012)
- `modern/validation/attach_type01.py`, `attach_type06.py` — golden-match attached
- `modern/landing/B202607230000001/` Parquet + manifest · `modern/lakehouse/ducklake/northwind_modern.duckdb`
- `evidence/modern/B202607230000001/golden-match.json` both questions yes
- `evidence/modern/B202607230000004/golden-match.json` `CONFIRMED_SOURCE_DEFECT` · 173.44 kept · no Parquet
- `evidence/factory/type-06.json` stage 6 **stalled** · `CONFIRMED_LEGACY_DEFECT` · `legacy/` untouched

Not built: Types `02`–`05` **lakehouse** leaves (`attach_type0N.py`, `run_type0N_gold.py`, dbt models). Their Task-Specs are on disk and signed in `cvg/tasks/`; the artifacts are not. Both `_state.yaml` files still project every leaf as `ready` — see [`tasks/_linear-board.md`](tasks/_linear-board.md).

Keep **173.44**. Ingest sign stays canonical. Thursday **walked this folder as the trail** (requisites → problem → decisions → SWE → DE/AE → tonight), then remaining types. It did not recut Tuesday’s papers. It did not re-ask where paid lives.

Night 5 recap read the Thursday inventory in [`agenda/d5.md`](../agenda/d5.md). Type `06` papers landed after that night’s drop (BRD, tech-spec, ADR 0014–0015, `seams-type-06.md`, `consensus-type-06.md`, two leaves). Clock: [`run/d5/`](../run/d5/README.md).

---

## Pass → file

| Pass | Name | File | Night |
|---|---|---|---|
| 0 | Capture | [`brd-type-01-card-settlement.md`](brd-type-01-card-settlement.md) | Day 1 wrote it. Later nights **look** ([`run/d2/02-prompt-papers.md`](../run/d2/02-prompt-papers.md), [`run/d3/01-prompt-recap.md`](../run/d3/01-prompt-recap.md), [`run/d4/01-prompt-recap.md`](../run/d4/01-prompt-recap.md)) |
| 1 | Intent | [`tech-spec-type-01-card-settlement.md`](tech-spec-type-01-card-settlement.md) | Same |
| 2 | Structure | `adrs/` + `CONTEXT.md` | Day 2 landing 0001–0005 + park 0006 ([`run/d2/08-structure.md`](../run/d2/08-structure.md)). Day 3: SA mermaids ([`run/d3/04-prompt-sa-plan.md`](../run/d3/04-prompt-sa-plan.md)), then unpark rows 3–7 as 0007+ ([`run/d3/06-structure.md`](../run/d3/06-structure.md)). Do not recut 0001–0005 |
| 3 | Decompose | [`seams.md`](seams.md) | Day 2 named three seams; tasked seam 1 ([`run/d2/09-decompose.md`](../run/d2/09-decompose.md)). Day 3 writes **seam 2 legs** (register → medallion → match) ([`run/d3/07-decompose.md`](../run/d3/07-decompose.md)). Day 4 cuts remaining type lanes + orchestrate |
| 4 | Consensus | [`consensus.md`](consensus.md) · [`consensus-lakehouse.md`](consensus-lakehouse.md) · [`consensus-type-06.md`](consensus-type-06.md) | Day 2 ingest sign **canonical**. Day 3 lakehouse sign **canonical** (2026-08-26). Day 5 Type 06 sign **canonical** (2026-08-28). Do not recut ingest or lakehouse |
| 5 | Tasking | `tasks/` | Day 2: one parser leaf ([`run/d2/11-taskspec.md`](../run/d2/11-taskspec.md)). Day 3: Type 01 remainder + lakehouse leaves ([`run/d3/09-taskspec.md`](../run/d3/09-taskspec.md)). Day 4: remaining SWE + DE (`02`–`04`, Type `05`, orchestrate) |
| 6 | Register | opt-in / `cvg/` | Day 3 Mesh is **seed**. Factory Register is Day 4 ([`run/d4/04-generate-queue.md`](../run/d4/04-generate-queue.md)) |
| 7 | Bind | harness, not a doc | Shown Day 2 fail-closed; **still on** Days 3–4 |
| 8 | Loop | product, not this folder | Type 01 Gold is Day 3 product. Factory 6–8 + Linear + packet = Day 4 ([`run/d4/05-mesh-crank.md`](../run/d4/05-mesh-crank.md)) |

`cvg` may error (Task-Spec 3.9 vs Converge 3.8). The **agent still writes
here**. Do not debug the CLI in front of the room. A dated signature in
`consensus.md` / `consensus-lakehouse.md` still counts.

---

## ADR index (Day 2)

| ADR | Status | Closes |
|---|---|---|
| [`0001-first-write-is-landing-parquet.md`](adrs/0001-first-write-is-landing-parquet.md) | Closed | First write is `modern/landing/` Parquet, not SFTP |
| [`0002-type-01-five-file-package.md`](adrs/0002-type-01-five-file-package.md) | Closed | `model → parser → schema → writer → handler` |
| [`0003-decimal-never-float.md`](adrs/0003-decimal-never-float.md) | Closed | Exact Decimal |
| [`0004-privacy-dies-at-the-parser.md`](adrs/0004-privacy-dies-at-the-parser.md) | Closed | PAN token + last4, CPF mask — before Gold |
| [`0005-source-lie-kept-zero-parquet.md`](adrs/0005-source-lie-kept-zero-parquet.md) | Closed | Keep **173.44**. Refuse. Zero Parquet |
| [`0006-later-nights-parked.md`](adrs/0006-later-nights-parked.md) | **Parked** | Rows **3–7** Day 3 (dlt, DuckLake, B/S/G grains, rule split, match keys). Rows **8–9** Day 4 (Dagster, serve). Row 10 CI = no |

0006 stays as the park record. Day 3 adds **new** ADRs; it does not rewrite 0001–0005.
Day 4 adds [`0012-dagster-is-lineage-not-parser.md`](adrs/0012-dagster-is-lineage-not-parser.md) (row 8) and [`0013-fastapi-readonly-approved-gold.md`](adrs/0013-fastapi-readonly-approved-gold.md) (row 9). It does not rewrite 0006.
Day 5 adds [`0014-type-06-five-file-half-up.md`](adrs/0014-type-06-five-file-half-up.md) and [`0015-type-06-gold-grain-and-classification.md`](adrs/0015-type-06-gold-grain-and-classification.md). It does not recut ingest or lakehouse Consensus.

---

## Method manuals (not this folder)

| Manual | What it is |
|---|---|
| [`ebooks/ebook-converge.pdf`](../ebooks/ebook-converge.pdf) · [`brf-converge.md`](../ebooks/brf-converge.md) | Converge spine — nine passes, one human barrier |
| [`presentation/asd-agentic-loop.html`](../presentation/asd-agentic-loop.html) | ASD — the Agentic Loop |
| [`presentation/boot-uc-northwind-pay-edp-oss.html`](../presentation/boot-uc-northwind-pay-edp-oss.html) | Bootcamp reference |
| [`ebooks/ebook-seamwise.pdf`](../ebooks/ebook-seamwise.pdf) · [`brf-seamwise.md`](../ebooks/brf-seamwise.md) | SeamWise kit — Leave · SeamWise on Nights 2–4, return to the numbered beat |
| [`presentation/d3-constructor.html`](../presentation/d3-constructor.html) | Night 3 HUD — not a paper |
| [`ebooks/brf-task-spec.md`](../ebooks/brf-task-spec.md) | Task-Spec kit (PDF built locally, gitignored). Mesh is **not** inside it |

The kit HTML decks left `presentation/` on Night 4; [`ebooks/`](../ebooks/README.md) is their home now.

Plans steer the plant: [`plans/`](../plans/README.md). This folder is
the week’s **signed papers**.

---

## What this folder is not

- Not contracts, fixtures, or expected outputs.
- Not a second copy of [`plans/legacy.md`](../plans/legacy.md) or [`plans/modern.md`](../plans/modern.md).
- Not the HTML manuals or Night decks.
- Not `modern/`. Landing Parquet and Gold are **product** after the relevant sign.
- Not `cvg/swimlanes/`. That tree is the referee workspace (`cvg init` ran on Night 4), projected from [`seams.md`](seams.md). `cvg/tasks/` holds signed **copies** of sixteen leaves; the canonical eighteen (incl. Type `06`) are in `tasks/` here.
- Not the Second Brain. Do not paste BRD, ADRs, or Consensus into NotebookLM.

Do not copy last run’s ADRs out of git history. Do not repair **173.44**.
If you replay a Night in a worktree, the "do not pre-seed" rules of that
night still apply inside the worktree; on `main` the papers are already here.
