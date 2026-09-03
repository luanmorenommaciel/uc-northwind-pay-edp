# 09 · Pass 5 — Task-Spec (Type 01 lakehouse)

- Slide: Execute 09 (Hands-On **slice c · leaf** · chip **09**) after Task-Spec Show + [`../../ebooks/brf-task-spec.md`](../../ebooks/brf-task-spec.md)
- Slice: **C · Leaf**
- Who: instructor authors the first lakehouse leaf in public, then every seat
- Next: [`10-landing.md`](10-landing.md) on Execute 10–12

Skip this beat if lakehouse Consensus is unsigned (Execute 09 stays dark). No eval, no build. `signed_off` starts **false**. Types `02`–`05` are not leaves tonight.

## Prompt (verbatim)

```text
You are Pass 5 Tasking on NorthWind Pay. Constructor seat.
Author Type 01 remainder + lakehouse leaves under docs/tasks/.
One leaf, one eval. signed_off starts false.

Required leaves (Type 01 only — skip a leaf if that artifact already exists and matches the ADR):
- Emit: schema / writer / handler as needed so modern/landing/ Parquet exists for valid-minimal, and df-source-001 emits zero Parquet (keep 173.44)
- dlt register-only (no re-parse, no money, no privacy)
- Bronze, Silver, Gold — one leaf per layer, each with a grain eval
- Golden-match attach: both questions; DF-SOURCE-001 = CONFIRMED_SOURCE_DEFECT; do not rewrite validation/golden-match/golden_match.py

Each leaf must forbid writes to legacy/, contracts/, gen/, infra/.
Do not author Types 02–05.
Do not author Dagster.
```

```bash
mkdir -p docs/tasks
cvg tasking --draft --json
```

If `cvg` wrote under `cvg/docs/`, move the leaves into `docs/tasks/`. If `cvg` errors, the agent still writes the leaves — do not debug the CLI.

## Proof

Leaves exist under `docs/tasks/` for emit (if needed), register, B/S/G, match. Each has a runnable eval. `signed_off` is false until Execute 10–12. No Type `05` package.

## If fail

No eval → tear it up. Empty type-02 folder → delete it. Do not Loop factory. Board D runs **these** leaves locally — that is the seed, not Thursday.
