# NorthWind Pay Second Brain — NotebookLM pack

Human brain for the **whole drop** (types `01`–`05`), not only Day 1. The rest of the week queries this notebook. Type `06` is deliberately **not** in it: it docked on Friday (2026-08-28) and stays out so a re-run of Night 5 still meets it as a never-seen kit. Not the agent’s memory. `spec/` stays on disk.

Handout: [`northwind-pay-brain.zip`](northwind-pay-brain.zip)

| Pack | What |
|---|---|
| `00-how-this-notebook-thinks.md` | Inbound only. Cite or abstain. |
| `01-estate.md` | Mail, meetings, policies, cover. |
| `02-five-types.md` | Types `01`–`05` READMEs. Type `06` not here. |
| `03-type-01-inbound.md` | Card settlement — Day 1 steel thread. |
| `04-type-02-inbound.md` | PIX / instant payment. |
| `05-type-03-inbound.md` | Payment slips. |
| `06-type-04-inbound.md` | TED. |
| `07-type-05-inbound.md` | Merchant fees — HALF_UP. Day 4 lives here. |
| `08-the-lie.md` | Same shape of lie on every live type. |

Staff: Day 1 upload [`../../run/d1/12-notebooklm.md`](../../run/d1/12-notebooklm.md) · Day 2 query [`../../run/d2/05-query-brain.md`](../../run/d2/05-query-brain.md) · Day 3 query [`../../run/d3/02-query-brain.md`](../../run/d3/02-query-brain.md) · Day 3 SA mermaids [`../../run/d3/04-prompt-sa-plan.md`](../../run/d3/04-prompt-sa-plan.md) · Day 3 research [`../../run/d3/13-research.md`](../../run/d3/13-research.md) · Day 4 trail [`../../run/d4/02-walk-trail.md`](../../run/d4/02-walk-trail.md) · Day 4 research [`../../run/d4/09-research.md`](../../run/d4/09-research.md)

**Days 2–4 do not add a tenth source.** The room **queries** this notebook. Specs, OntoLayer, and `docs/` answer “what we build.” Java, contracts, the tech-spec, ADRs, dlt/dbt/DuckLake decisions, and `modern/` stay out. If a stack fact is not in these nine files, the notebook must **abstain**.

### Night 2 ask → pack

| Night 2 ask | Pack that can cite | Not this notebook |
|---|---|---|
| J1 privacy / PAN / CPF | `01` meeting + policy; `03` layout | Java tokenizer |
| J2 signed overpunch, Marina’s lie | `03` (`00000001234E` → `123.45`); `08` | a `.dat` |
| J3 refuse vs crash; do not patch the trailer | `00`, `08`, Marina’s mail | a “fix” |
| J4 sanitize (tokenize, last4) | `01` privacy; `03` field notes | `legacy/processor/src` |
| J5 is the Java parser here? | `00` says no | uploading Java to “help” |
| Research: first modern artifact | `01` architecture: parser → **sanitized Parquet**; must not call Java | `plans/modern.md` (repo, Research Q3) |

### Night 3 ask → pack (Constructor · Type 01 Gold)

| Night 3 ask | Pack that can cite | Not this notebook (repo) |
|---|---|---|
| J1 does the lakehouse re-parse, or only register landing? | `01` architecture: parser → Parquet → Bronze/Silver/Gold. **Abstain on “dlt”** if the word is missing | `docs/adrs/0006`, `run/d3/02` |
| J2 privacy at parse or in Gold? | `01` privacy boundary; `03` | a dbt model |
| J3 Bronze / Silver / Gold | `01` architecture sketch (mail, **not a grain**) | lakehouse ADRs (tonight’s Pass 2) |
| J4 must Gold “fix” 173.44? | `08` + Marina: keep the declaration, refuse | a repaired trailer |
| J5 DuckDB / dlt / dbt decision? | **Abstain.** Not in inbound | `plans/modern.md`, `docs/adrs/` |
| Research: lineage; parsing not in the orchestrator | `01` architecture (parser stays the second reader of raw bytes); `02` Days 3–4 build the vertical | `plans/modern.md` Milestone 4 (Dagster) |
| Research: Type 05 subject line only | `07` (`normal-rounding` / HALF_UP). Do not implement | Type 05 leaves (Thursday) |

### Night 4 ask → pack (Orchestrator · remaining types + Type 05)

| Night 4 ask | Pack that can cite | Not this notebook |
|---|---|---|
| Type `02`–`04` inbound (when generating remaining SWE+DE) | `04`, `05`, `06` | empty type packages |
| Type `05` HALF_UP / `normal-rounding` / `df-source-005` | `07` | Python default; `expected/` rewrite |
| Same shape of lie on every live type | `08` | a unique Type 05 story |
| Research: factory / flywheel | `02` (Type `06` arrives day five as the unseen kit) | `plans/dark-factory.md` details; Type `06` files |

### Night 5 (Friday) — new inbound, not this zip

Type `06` was sealed until Friday morning and docked under
`spec/type-06-merchant-chargeback/` on 2026-08-28. `build.sh` still packs
`01`–`05` only and the notebook stays at nine packs on purpose. If a room
wants Type `06` queryable **after** its Consensus is signed, add a tenth
pack in a separate notebook — do not upload it into the Day 1 notebook.

Rebuild packs from `spec/` whenever inbound changes:

```bash
bash brain/notebooklm/build.sh
```

NotebookLM does not ingest the zip. Unzip, upload the nine `.md` files.
Do not add `legacy/`, `contracts/`, a `.dat`, the Day 1 tech-spec, ADRs, or `modern/`.
