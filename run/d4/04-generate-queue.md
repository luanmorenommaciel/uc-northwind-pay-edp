# 04 · Generate remaining + queue

- Slide: Execute 03–04 (Hands-On **slice b · lanes**) — **type tile 04 after** the Task-Spec Show ([`../../ebooks/brf-task-spec.md`](../../ebooks/brf-task-spec.md)), which is the next HUD after this board
- Slice: **B · Lanes**
- Who: instructor authors the first remaining leaf in public, then every seat
- Next: Task-Mesh · Linear Show, then [`05-mesh-crank.md`](05-mesh-crank.md) on Execute 05–06

Task-Spec kit already ran. Mesh is **not** inside this kit. One leaf, one eval. `signed_off` starts **false**. Empty type packages forbidden. Linear is the **board**, not the judge.

Host, if not done on Craft: pin Task-Spec **3.8.x**. `cvg init`. Project **this** plant’s seams only.

## Prompt (verbatim)

```text
You are Pass 5 Tasking then Pass 6 Register on NorthWind Pay. Orchestrator seat.
The two lanes from the trail still hold. Author remaining SWE + DE leaves under docs/tasks/.
One leaf, one eval. signed_off starts false.

Required (skip a leaf if that artifact already exists and matches the ADR):
- Types 02, 03, 04: ingest (five-file / landing) as SWE leaves; lakehouse (dlt → B/S/G → golden-match) as DE leaves
- Type 05: ingest + lakehouse leaves. Evals must cover DF-SOURCE-005 (CONFIRMED_SOURCE_DEFECT) and rounding-half-up (HALF_UP; HALF_EVEN is MODERN_DEFECT)
- Orchestrate: Dagster lineage on closed Type 01 — parsing does not move into the orchestrator

Each leaf must forbid writes to legacy/, contracts/, gen/, infra/.
Each eval is a runnable command, not “the agent said it worked.”
Do not author Type 06.
Do not create empty type folders.

Then Pass 6:
1. Confirm cvg/ exists (cvg init) or say the agent will keep writing docs/.
2. Project this plant’s seams only: ingest-landing, dlt-gold, orchestrate-serve.
3. Put the queue on Linear (or a visible board if Linear is down). One card per leaf.
   Linear moves when an eval settles — not when chat says done.
Do not crank yet.
```

```bash
mkdir -p docs/tasks
cvg tasking --draft --json
```

If `cvg` wrote under `cvg/docs/`, move the leaves into `docs/tasks/`. If `cvg` errors, the agent still writes the leaves.

## Proof

Leaves exist for remaining SWE+DE with evals. Queue is visible. Seams are **this** plant’s names. `signed_off` is false. Type `06` absent. No empty Type `05` package.

## If fail

No eval → tear it up. Empty type-02 folder → delete it. Foreign lane names → delete and re-project. No evals → **dark 05–08**. Do not crank unsigned leaves.
