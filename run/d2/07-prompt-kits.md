# 07 · Prompt — Converge 2–4 + Seamwise

- Slide: Execute 07–10 (Hands-On **slice d · barrier** · chip **07–10**) — tile 07
- Slice: **D · 2–4**
- Who: every seat, through **their** agent
- Next: [`08-structure.md`](08-structure.md) on the **same board**

Show Converge + Seamwise first. Then **Leave · Seamwise** — park, open [`../../ebooks/ebook-seamwise.pdf`](../../ebooks/ebook-seamwise.pdf), explain internals, return. Then this board: tile 07 names the kits from the repo (**do not start Pass 2 yet**), then 08–10. `cvg` gates; the agent drafts. Do not paste 07–10 from inside the kit.

## Prompt (verbatim)

```text
Read docs/README.md. You may read ebooks/brf-converge.md.
Do not change any file.

Answer from the repo:
1. What is Converge? What does cvg do, and what must the agent still do?
2. What is Seamwise? At which pass does it attach tonight?
3. What is the one lane we cut (ingest → landing)? What waits until Day 3 and Day 4?
4. Where do papers live (BRD, tech-spec, adrs/, seams, consensus, tasks/)?
5. What do we run tonight (Pass 2–4, then Task-Spec)? What do we not run (Pass 6–8 factory)?

Do not write product code.
Do not start Pass 2 yet.
Do not ask OntoLayer these questions.
```

## Proof

| Ask | A healthy answer |
|---|---|
| Converge | Spine. Coordinates. Never writes product code. `cvg` gates |
| Seamwise | Lanes. Attaches at **Decompose (Pass 3)** |
| Lane | ingest → landing. dlt → Gold is Day 3. Dagster is Day 4 |
| Papers | [`docs/`](../../docs/README.md) — not `cvg/docs/` |
| Tonight | **2–4**, then **5**. Not factory Loop |

## If fail

Correct from the table. Do not install a second Converge.
