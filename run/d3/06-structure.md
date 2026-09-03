# 06 · Pass 2 — Structure (unpark 0006)

- Slide: Execute 05–08 (Hands-On **slice b · barrier**) — tile 06
- Slice: **B · Barrier**
- Who: instructor drafts the first lakehouse ADR in public, then every seat
- Next: [`07-decompose.md`](07-decompose.md)

SeamWise kit already ran. Do not reopen the SeamWise kit (`ebooks/ebook-seamwise.pdf`) for this beat.

What is true, never how. **Unpark** rows 3–7 in [`docs/adrs/0006-later-nights-parked.md`](../../docs/adrs/0006-later-nights-parked.md). Leave 0006 as the park record. Do not recut ADRs 0001–0005.

## Prompt (verbatim)

```text
You are Pass 2 Structure on NorthWind Pay. Human-led. Constructor seat.

Read docs/README.md, docs/adrs/0006-later-nights-parked.md, docs/seams.md, and plans/modern.md (Milestones 2–3).
You may query the Second Brain and OntoLayer for grains and keys.
Write new ADRs under docs/adrs/ as NNNN-short-name.md (0007+).
Update docs/CONTEXT.md if a lakehouse term is new.
This repo’s Converge home is docs/, not cvg/docs/.

Tonight’s lakehouse ADRs must cover 0006 rows 3–7:
- dlt registers landing only. It does not re-parse. It does not own money or privacy.
- DuckLake / DuckDB is local. Not a cloud warehouse copy.
- Bronze = source-aligned. Silver = conformed grain. Gold = may later be served.
- Rule split: parser already did privacy + Decimal; dbt does not retokenize.
- Golden-match keys: batch + currency at paid grain; two questions never netted.

Do not pick Dagster or FastAPI.
Do not recut 0001–0005.
Do not import Java.
Do not write modern/ product code yet.
```

```bash
mkdir -p docs/adrs
cvg structure --draft --json
```

If `cvg` wrote under `cvg/docs/`, move the ADRs into `docs/adrs/`. If `cvg` errors (engine mismatch), the agent still writes those files — do not debug the CLI.

## Proof

New ADRs exist for rows 3–7. 0006 still says those rows were parked. Room can restate grains with the files closed. No “how we implement dbt” in an ADR.

## If fail

A Dagster/FastAPI ADR → tear it out. Park it for Thursday. Do not proceed to Decompose on mush. Stack choice dressed as grain → park it.
