---
name: dark-factory-triage
description: Diagnose and repair the four failures that stop the NorthWind Pay modern plant — PublicationError on replay, a doubled lakehouse with Gold MISMATCHED, a golden-match money difference, and a dark Dagster. Use when run_type01_gold.py or plant_steps.py fails, when Gold shows the wrong amount or MISMATCHED, when golden-match reports a difference, or during Night 5 (run/d5) when a demo step breaks.
---

# Dark Factory triage

Four failures stop this plant. Three are mechanical and you fix them. One is the
point of the exercise and you must **not** fix it.

Before anything: `legacy/`, `contracts/`, `gen/` and `infra/` are frozen. If a
repair requires editing those, the repair is wrong.

## 1 · `PublicationError: a different Parquet publication already exists`

**Cause.** The wrong interpreter. `modern/landing/**` was written with
**pyarrow 25** (`modern/.venv`, the only plant env `modern/scripts/bootstrap.sh`
creates besides `modern/orchestration/.venv`). Any other interpreter — an
old `modern/lakehouse/.venv` or `modern/ingestion/.venv` left from Nights
3–4, or the system Python — carries pyarrow 22 and encodes the same rows
into different bytes, so the determinism guard refuses.

**Confirm.**
```bash
for v in modern/.venv modern/lakehouse/.venv modern/ingestion/.venv; do
  [ -x "$v/bin/python" ] && echo "$v $($v/bin/python -c 'import pyarrow;print(pyarrow.__version__)')"
done
# only modern/.venv must exist; if it is missing, run modern/scripts/bootstrap.sh
```

**Fix.** Use `modern/.venv/bin/python`. Never "fix" this by deleting the landing
Parquet or by relaxing `publish()` — the guard is the Stage 4 determinism gate.

## 2 · Gold shows a doubled amount, or `MISMATCHED`

**Cause.** `landing_files()` picked up more than one Parquet for the batch, so
dlt registered it twice. The usual source is a leaked staging directory
(`modern/landing/.NW_*.parquet.XXXX/`) left by an interrupted or refused publish.

**Confirm.**
```bash
find modern/landing -name '*.parquet'          # expect exactly one per batch
ls -a modern/landing | grep '^\.NW'            # expect nothing
```

**Fix.** Delete the leaked staging directory, then rebuild:
```bash
rm -rf modern/landing/.NW_*.parquet.*
modern/.venv/bin/python modern/scripts/run_type01_gold.py
```
Gold must return to `173.45 MATCHED` for `B202607230000001`. Both the leak and
the glob are guarded now; if a leak reappears, that guard regressed.

## 3 · Golden-match reports a money difference — **do not fix this**

This is the plant telling the truth. Ask the two questions separately and never
net them:

1. Does **modern** match the contract?
2. Does **legacy** match the contract?

| modern | legacy | code | what you do |
|---|---|---|---|
| ✗ | ✓ | `MODERN_DEFECT` | fix the new plant, re-run |
| ✓ | ✗ | `CONFIRMED_LEGACY_DEFECT` | write it down, **stall the type** |
| ✓ | ✓ vs each other, both ✗ vs the declaration | `CONFIRMED_SOURCE_DEFECT` | keep the wrong number |

Then write the packet under `evidence/` (`mkdir -p evidence/factory` on a
fresh clone — the folder is gitignored) and stop. Never edit `legacy/`, never
rewrite `contracts/**/expected-*`, never add tolerance to
`validation/golden-match/golden_match.py`. A stalled type with one honest code is
a success state; a green run bought by moving the oracle is not.

Reproduce the canonical case:
```bash
modern/.venv/bin/python modern/scripts/factory_e2e.py --type 06
# stage 3 STALL (the room builds the package) · stage 6 CONFIRMED_LEGACY_DEFECT
```

## 4 · Dagster is dark

Dagster lives in its own environment so it can never perturb the pyarrow 25 that
wrote landing. It is **lineage, not a parser** (ADR 0012) — every asset shells
out to `modern/scripts/plant_steps.py`.

```bash
cd modern/orchestration && .venv/bin/dagster asset materialize --select '*' -m definitions
cd modern/orchestration && .venv/bin/dagster dev -m definitions      # UI
```
Missing environment? `python3 -m venv modern/orchestration/.venv && \
modern/orchestration/.venv/bin/pip install -r modern/orchestration/requirements.txt`

If Dagster cannot come up, say so out loud and skip the gold-hash record. Do not
move parsing into an asset to make the graph look busier.

## Prove the whole thing before an audience

```bash
modern/scripts/night_e2e.sh
```
Eight steps, exit 0. Type 01 ACCEPTED, type 06 STALLED with one code. If it exits
non-zero, the failing step names itself — start at the matching section above.
