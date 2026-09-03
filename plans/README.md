# Plans — the engagement map

These three documents are the guiding process for the whole week. They
are not optional reading and they are not last-run souvenirs. One
describes the use case that already runs. One is the contract for the
second implementation. One is the later factory idea — a seed, not a
plant that already runs.

They are **not** the night's clock. Scope is [`agenda/`](../agenda/README.md).
Staff: [`run/d1/`](../run/d1/README.md) · [`run/d2/`](../run/d2/README.md) ·
[`run/d3/`](../run/d3/README.md) · [`run/d4/`](../run/d4/README.md) · [`run/d5/`](../run/d5/README.md). Decks: all five Nights' HTML live. Papers:
[`docs/`](../docs/README.md). **One Night** each day — no morning / afternoon
split.

**Week story:** Days 2–3 are **Type 01 steel threads** (SWE ingest → landing,
then DE landing → Gold). Day 4 teaches **Context · Eval · Loop**, **walks the Type 01 trail**, then **generates remaining swimlanes / SWE+DE
leaves** and cranks them (Mesh + Pass 6–8, Linear). Day 5 is sealed Type `06`.
All five Nights have run (2026-08-24 → 2026-08-28); Day 5 stalled Type `06`
as `CONFIRMED_LEGACY_DEFECT`.

| Plan | What it is | When you open it |
|---|---|---|
| [`legacy.md`](legacy.md) | The completed local baseline: architecture, operating model, 25-batch catalog, and the 2026-07-24 proof ledger | Before anyone touches a later fabric. This is what must stay true. Day 1 boots it until Type `01` **MATCHED**. |
| [`modern.md`](modern.md) | The specification the second implementation must satisfy: independence rules, type map, golden-match, milestones, definition of done | Day 2 Structure (close or park). Day 3 unparks lakehouse facts and closes Type `01` Gold. Day 4 **Context · Eval · Loop**, trail, then remaining types. **Not** a license to write `modern/` on Day 1. |
| [`dark-factory.md`](dark-factory.md) | The later idea: lights-out build, stages, gates, unattended loop | When the room needs the broader picture. Enhance it as the week writes the factory. Day 5 ran it on sealed Type `06`. |

The detector is `modern/scripts/factory_e2e.py`, not a `factory/` folder.

## How the two plans work together

```text
contracts/  ── source of correctness for both sides
    │
    ├── legacy.md         frozen path that already runs
    │                       DataGen → SFTP → Java 21 → PostgreSQL → oracle
    │
    ├── modern.md         path the week constructs
    │                       same raw SFTP → Python → modern/landing/
    │                       → dlt → DuckLake/DuckDB → dbt → golden-match
    │
    └── dark-factory.md   later idea — enhance as the factory is built
```

Legacy is the **observed reference system**. Modern is an **independent
second implementation**. Neither may edit `contracts/`, `legacy/`,
`gen/`, or `infra/` to make a later gate pass.

## What is frozen, what is built

| Frozen on this tree | Built during the week |
|---|---|
| Five signed type contracts (`01`–`05`) | Type `01` `modern/` on Days 2–3 (parser, then landing → Gold). Types `02`–`05` on Day 4 |
| DataGen, SFTP, Java 21, PostgreSQL | Golden-match wiring against live modern observations |
| Independent oracles under `validation/oracle/` | One vertical at a time, `01` first (Wed), remainder generated Thu |
| Inbound packs for `01`–`05` under [`spec/`](../spec/README.md) | Day 1: brain + graph + Capture → Intent. Day 2: Bind, landing ADRs, ingest sign, parser leaf. Day 3: lakehouse ADRs, `consensus-lakehouse.md`, Type 01 Gold leaves |
| Human Second Brain ([`brain/notebooklm/`](../brain/notebooklm/README.md), nine packs) | Queried Days 2–4. **No tenth source.** Type `06` is a new source on Friday, not in the zip |
| OntoLayer over live Postgres | Without (`make ontology-ask-sql`) then with (`make ontology-ask` / MCP) |
| `validation/golden-match/golden_match.py` | Tests, Make targets, `evidence/modern/` |
| This folder | Factory later. Day five: Type `06` unseen + **red pill** — a numeric miss attributed to the legacy plant (`CONFIRMED_LEGACY_DEFECT`), found not repaired |

## How to use them in the room

Clock: [`agenda/`](../agenda/README.md). Day 1 staff: [`run/d1/`](../run/d1/README.md).
Day 2 staff: [`run/d2/`](../run/d2/README.md). Day 3 staff: [`run/d3/`](../run/d3/README.md).
Day 4 staff: [`run/d4/`](../run/d4/README.md). Papers: [`docs/`](../docs/README.md).

1. **Arrive (Day 1).** Boot the use case with `make deploy` and one
   `make run TYPE=01 SCENARIO=valid-minimal`. Confirm the packet in
   [`legacy.md`](legacy.md#batch-evidence) and the Type `01` row in the
   [25-batch catalog](legacy.md#canonical-25-batch-catalog). Net `173.45`,
   **MATCHED**. `evidence/` is gitignored — open it in the terminal.
2. **Understand (Day 1).** Feed [`spec/`](../spec/README.md) to the
   Second Brain ([`brain/notebooklm/`](../brain/notebooklm/README.md) —
   nine packs, types `01`–`05`). Ask OntoLayer without, then with. Run
   Converge **0 Capture** and **1 Intent**. **No product code. No ADRs.
   No `modern/`.**
3. **Design (Day 2).** Recap Pass 0–1 in [`docs/`](../docs/README.md).
   **Bind** the Agent Harness (fail closed on frozen folders). Query the
   Second Brain for Java *concepts* — do not rebuild it. Open
   [`modern.md`](modern.md). Close or park the ten questions as ADRs under
   `docs/adrs/`. Consensus is the barrier (`docs/consensus.md`). One
   Task-Spec leaf in `docs/tasks/`. First write is landing Parquet **when
   the mesh later runs** — not required Tuesday. The ten questions are
   not closed on Day 1.
4. **Steel threads (Days 2–3).** Type `01` only. Tuesday: SWE ingest →
   landing. Wednesday: DE landing → Gold + golden-match. Park `02`–`04`.
5. **Factory night (Day 4).** Context Layer · eval · loop packet. **Walk the
   Type 01 trail** (requisites → problem → decisions → SWE → DE/AE → tonight).
   Then generate remaining swimlanes, legs, and SWE+DE leaves. Crank in Mesh +
   Pass 6–8 (Linear is the board, not the judge). Task-Mesh is **beside**
   Task-Spec, not inside it. Type `05` unattended. Type `06` stays sealed until
   day five. Staff: [`run/d4/`](../run/d4/README.md).
6. **Adjudicate.** Golden-match asks two questions and never nets them:
   did modern match legacy, and did modern match the contract?
7. **Do not repair a source lie.** Every `DF-SOURCE-*` batch is a
   one-cent (or one-cent-equivalent) declaration the source got wrong.
   Compute the truth, keep the declaration, refuse the batch.
8. **Type `05` small red pill (Day 4).** `HALF_UP` vs "normal" /
   `HALF_EVEN`. Day 5 is the large pill: Type `06` may indict the
   legacy plant.

## Operator entry

The day-to-day commands live in the root [`README.md`](../README.md).
The plans do not replace that page. They explain *why* those commands
exist and what a green result is allowed to mean. They do not replace
[`agenda/`](../agenda/README.md) on *when* a night closes.
