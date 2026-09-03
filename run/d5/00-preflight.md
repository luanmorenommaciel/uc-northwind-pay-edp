# 00 · Pre-flight — prove the spine before the room arrives

- Slide: Factory run (Dig · **Show** · before Execute 05)
- Slice: **staff only** — not a Hands-On board
- Who: instructor, alone, before the doors open
- Next: [`01-recap-type01.md`](01-recap-type01.md)

One command runs the Dark Factory stages for one type and prints **every gate**. It builds
nothing and edits nothing. It executes what exists, reports what does not, and stalls the type at
the first gate that refuses. Classification names are imported from
[`validation/golden-match/golden_match.py`](../../validation/golden-match/golden_match.py) — the referee is never rewritten.

### One command, the whole plant

```text
modern/scripts/night_e2e.sh
```

Eight steps, narrated, exit `0` when the Night is ready:

| # | Step | Proof it prints |
|---|---|---|
| 1 | legacy ground truth | `MATCHED 173.45` from `evidence/B202607230000001/` |
| 2 | emit → landing Parquet | sha `a3256309309d…` · first write is landing |
| 3 | dlt register | one `load_id` · register only |
| 4 | dbt build | `PASS=27 WARN=0 ERROR=0` on `tag:type_01` |
| 5 | **the data, in DuckDB** | landing/bronze/silver row counts + the Gold row |
| 6 | **Dagster lineage** | 6 assets materialised · gold hash recorded |
| 7 | factory gates · type 01 | seven gates PASS → **ACCEPTED** |
| 8 | factory gates · type 06 | stalls at Build → **CONFIRMED_LEGACY_DEFECT** |

Just the gates, without the rebuild:

```text
modern/.venv/bin/python modern/scripts/factory_e2e.py --type 01
modern/.venv/bin/python modern/scripts/factory_e2e.py --type 06
```

Dagster on its own, including the UI the room can click through:

```text
cd modern/orchestration && .venv/bin/dagster asset materialize --select '*' -m definitions
cd modern/orchestration && .venv/bin/dagster dev -m definitions
```

Use **`modern/.venv`** — it has pyarrow 25, the version that wrote landing. `modern/lakehouse/.venv`
is stale local state carrying pyarrow 22 and will raise `PublicationError`. Nothing is wrong with the
pins: `modern/scripts/bootstrap.sh` builds both environments from `requirements.txt` and yields
pyarrow **25.0.0** every time.

### If a step is missing

`night_e2e.sh` preflights before it does anything and names the cause once:

```text
modern/scripts/bootstrap.sh      # builds modern/.venv and the Dagster env
```

Bootstrap does **not** create `evidence/`, `modern/landing/` or the lakehouse. Those are gitignored
artifacts of actually running the nights — a fresh clone can never present the Night without first
producing them. Rehearsed on 2026-08-28 in the `wrktr-e2e` worktree: a clean checkout preflights
and stops in one screen, and bootstrap brings both environments up from the pins.

## Stages and gates

| Stage | Gate | Type 01 | Type 06 |
|---|---|---|---|
| 0 Intake | does the kit ship an oracle? **no eval, no task** | PASS | PASS |
| 1 Ground truth | legacy ran and the observation is captured | PASS | PASS |
| 2 Plan | three seams, one owner per handoff | PASS | PASS |
| 3 Build | five-file package present | PASS | **STALL** on the Night's opening tree — the room builds it. PASS once `06-merchant-chargeback/` exists (it does on `main` now) |
| 4 Publish | landing Parquet matches its recorded SHA-256 | PASS | skip until emit ran; PASS after |
| 5 Lakehouse | dlt register-only → Bronze/Silver/Gold | PASS · 173.45 MATCHED | skip until `run_type06_gold.py` ran; PASS · 1.01 after |
| 6 Golden-match | two questions, never netted, one code | PASS | **STALL** — `CONFIRMED_LEGACY_DEFECT` |

Exit `0` = accepted. Exit `1` = stalled. A stall is a **success state**: the gate held and the
difference has a name.

## What pre-flight must show

- Type 01 reaches stage 6 and prints **ACCEPTED**. If it does not, Floor board **D** is at risk —
  read [`04-pipeline-smoke.md`](04-pipeline-smoke.md).
- Type 06 stalls. On the Night's opening tree it stalls at stage 3 (no modern package — correct,
  that is tonight's work). On `main` after Night 5, where the package exists, it runs through to
  stage 6 and stalls there. Either way question 2 answers **NO**: legacy disagrees with the
  contract. That is the Night's payload and it is real before anyone types.

## Do not

- Do not run `--scenario legacy-miss`. Batch `B202607230000504` has **never** been through legacy;
  it stalls at stage 1 by design. Keep it virgin for the loop.
- Do not `ls spec/type-06-merchant-chargeback/samples/` on the projector. One filename spoils the Night.
- Do not commit `evidence/`. Do not patch `legacy/` to make stage 6 go green.
- Do not install Dagster into `modern/.venv`. It lives in `modern/orchestration/.venv` so it can never
  move the pyarrow that wrote landing. If a step breaks, the `dark-factory-triage` skill names all four failures.
