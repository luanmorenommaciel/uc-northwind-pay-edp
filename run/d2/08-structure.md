# 08 · Pass 2 — Structure

- Slide: Execute 07–10 (Hands-On **slice d · barrier**) — tile 08
- Slice: **D · 2–4**
- Who: instructor drafts the first ADR in public, then every seat
- Next: [`09-decompose.md`](09-decompose.md)

Seamwise kit already ran. Do not reopen the SeamWise kit (`ebooks/ebook-seamwise.pdf`) for this beat.

What is true, never how. Close or **park** the ten questions in `plans/modern.md`. Tonight must close landing facts.

## Prompt (verbatim)

```text
You are Pass 2 Structure on NorthWind Pay. Human-led. No product code.

Read docs/README.md and docs/tech-spec-type-01-card-settlement.md.
You may query the Second Brain and OntoLayer for facts.
Write ADRs under docs/adrs/ as NNNN-short-name.md.
Write domain terms to docs/CONTEXT.md.
This repo’s Converge home is docs/, not cvg/docs/.

Tonight’s landing ADRs must cover:
- First write is modern/landing/ Parquet, not SFTP
- Type 01 five-file package is the unit
- Decimal, never float
- Privacy dies at the parser
- Source lie keeps 173.44; refuse; zero Parquet

Do not pick a lakehouse.
Do not write modern/ code.
Do not import Java.
```

```bash
mkdir -p docs/adrs
cvg structure --draft --json
```

If `cvg` wrote under `cvg/docs/`, move the ADRs and `CONTEXT.md` into `docs/`. If `cvg` errors (engine mismatch), the agent still writes those files — do not debug the CLI.

## Proof

Files exist under `docs/adrs/` and `docs/CONTEXT.md`. The room can restate them with the files closed. No “how we implement the parser” in an ADR.

## If fail

A stack choice dressed as an ADR → tear it out. Park it. Do not proceed to Decompose on mush.
