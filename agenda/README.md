# Agenda — five-day scope

These briefs are the week map. They are **scope**, not hour-by-hour
run-of-show. The night you execute lives in [`run/`](../run/README.md)
(staff + the two designers). Do not invent extra story when the slides
are built.

The public bootcamp page is the autonomy curve. This folder is how that
curve lands on **this** repo.

| Day | Seat | File | Rings | Converge | Gate |
|---|---|---|---|---|---|
| 1 | Archaeologist (SA + AI) | [`d1.md`](d1.md) | Prompt + context | **0–1** Capture → Intent | The system starts to understand the legacy (Second Brain + OntoLayer + tech-spec) |
| 2 | Translator (SWE) | [`d2.md`](d2.md) | Harness (Bind) | Recap 0–1. **2–4**, then **5**. Mesh internals. Factory 6–8 is Day 4 | Design the second plant. Bind is the fence. Consensus is the barrier. Leaves in `docs/tasks/`. No `modern/` required |
| 3 | Constructor (DE + analytics) | [`d3.md`](d3.md) | Harness + loop seed | Recap. **2–4–5** on dlt → Gold. Mesh seed | Type 01 **steel thread**: landing → Gold + golden-match. `02`–`04` parked |
| 4 | Orchestrator | [`d4.md`](d4.md) | Loop + eval | Context · Eval · Loop. Then **6–8** crank. Linear. Type `05` unattended | Remaining SWE+DE + packet; small `HALF_UP` pill |
| 5 | Dark Factory | [`d5.md`](d5.md) | Orchestration | Full 0–8 on sealed Type `06` | Never-seen type onboarded live. Large pill: `CONFIRMED_LEGACY_DEFECT` |

**Story of the week (steel threads, then the factory).** Days 2–3 **explain one seat and run one Type 01 lane** — SWE ingest → landing, then DE landing → Gold. Day 4 teaches **Context · Eval · Loop**, **walks the Type 01 trail**, then generates remaining SWE+DE, cranks Mesh + Pass 6–8 (Linear), then Type `05` unattended. Day 5 is sealed Type `06`. Do not dump Types `02`–`05` on Wednesday.

**The week starts at Day 1.** You arrive as an AI-native engineer from scratch.
You do not inherit a brain, a graph, or last run's ADRs.

| Night | What closes |
|---|---|
| 1 | Plant **MATCHED**. Second Brain fed (whole drop, types `01`–`05`). OntoLayer via MCP. Capture + Intent. Research queries for Day 2. **No product code.** |
| 2 | Recap Pass 0–1. **Bind** fail-closed. Query Second Brain + OntoLayer. ADRs, seams, **Consensus signed**. One Task-Spec leaf. Mesh internals. **No `modern/` required.** Research for Day 3. |
| 3 | Type 01 DE steel thread: landing → Gold + golden-match. Mesh seed. `02`–`04` parked |
| 4 | Context · Eval · Loop. Type 01 trail. Generate remaining SWE+DE. Mesh + Pass 6–8 (Linear). Unattended Type `05` |
| 5 | Sealed Type `06`. Full spine. Classify, do not patch |

Every day uses the same swing: **Stage → Craft → Floor → Dig → Debrief**.
Day 1 Dig is read / brain / graph / spine. Days 2–4 Dig is kits then Hands-On.

Every day closes with three parts: **role skills** (the seat), **deliverables**
(what you hold), and **Research** (what you query for tomorrow). See each
`dN.md` → `## Research`.

The inbound drop is [`spec/`](../spec/README.md). The engagement map is
[`plans/`](../plans/README.md). The operator surface is the root
[`README.md`](../README.md). Type `06` was **not** in `spec/` until Friday
morning (it docked 2026-08-28 and is there now; the week's clocks still
treat it as sealed until Night 5).

The human Second Brain for the week is
[`brain/notebooklm/`](../brain/notebooklm/README.md) — nine packs, types
`01`–`05`. Days 2–4 **query that notebook**. They do not rebuild it. Type
`06` is a new source on Friday, not in the zip.

Public page lists Day 1 Converge as *P1 Intent · P2 Structure*. This week
**keeps Capture + Intent on Day 1** so follow-along can finish Second Brain
and OntoLayer. Day 2 **recaps** 0–1, **Binds** the Agent Harness, then
Structure → Decompose → Consensus → one Task-Spec leaf. First write is
landing Parquet when the mesh later runs. The page gate still holds: by
Tuesday night the legacy is specified, structured, and designed as leaves.

## Decks

| Day | Deck |
|---|---|
| 1 | [`presentation/d1-archaeologist.html`](../presentation/d1-archaeologist.html) — live. 44 slides. Staff: [`run/d1/`](../run/d1/README.md) — 17 beats, six slices A–F + Close 17 |
| 2 | [`presentation/d2-translator.html`](../presentation/d2-translator.html) — live, 34 slides, six blocks. Staff: [`run/d2/`](../run/d2/README.md) — 12 beats, five Hands-On boards |
| 3 | [`presentation/d3-constructor.html`](../presentation/d3-constructor.html) — **live**, 37 slides. Identify by `data-act-name`. Staff: [`run/d3/`](../run/d3/README.md) — 13 beats, four boards |
| 4 | [`presentation/d4-orchestrator.html`](../presentation/d4-orchestrator.html) — live, 28 slides, six blocks. Staff: [`run/d4/`](../run/d4/README.md) — 9 beats. Trail, then factory |
| 5 | Deck live: [`presentation/d5-dark-factory.html`](../presentation/d5-dark-factory.html) — 28 slides, six blocks. Staff live: [`run/d5/`](../run/d5/README.md) — pre-flight `00` + 6 beats. Do not use `wrkp-dark-factory.html` as the HUD |

## What is frozen vs what the week writes

| Already on the tree | Written during the week |
|---|---|
| Legacy plant, five contracts, DataGen, oracles | Second Brain (Day 1, queried all week) + OntoLayer, Converge artifacts, `modern/` for Types `01`–`05` (and `06` on Day 5) |
| Inbound packs `01`–`05` under `spec/` | ADRs, seams, Task-Specs under [`docs/`](../docs/README.md) (Day 2+) |
| `validation/golden-match/golden_match.py` | Modern observations attached to that referee |
| This folder (scope) | Hour-by-hour in [`run/`](../run/README.md); Day 1 PPT is closed |

Do not pre-seed Converge. Do not copy last run's ADRs out of git history.
Do not repair a source declaration. Do not edit frozen `legacy/` to go green.
