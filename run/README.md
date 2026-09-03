# Run — staff follow-along

This folder is for **you and the two designers**. It is the night you
actually run: beats, commands, who speaks, what “done” is, what to do
when a table dies.

It is not the student brief. It is not the deck.

| Folder | Job |
|---|---|
| [`agenda/`](../agenda/README.md) | Scope. What the night closes. Not the clock. |
| [`presentation/`](../presentation/README.md) | What the room sees. |
| **This folder** | What the three of you execute, in order. |

One folder per night. One file per beat, numbered. **One Night** — no
morning / afternoon split. Converge papers: [`docs/`](../docs/README.md).

**Week story:** Nights 2–3 are **Type 01 steel threads** (SWE ingest → landing, then DE landing → Gold). Night 4 teaches **Context · Eval · Loop**, **walks the Type 01 trail**, then generates remaining SWE+DE and cranks them (Mesh + Pass 6–8, Linear), then Type `05` unattended. Night 5 is sealed Type `06` — it ran on 2026-08-28 and stalled `CONFIRMED_LEGACY_DEFECT`. All five Nights have run; each `dN/` clock still reads as **that** Night's tree (see the root [`README.md`](../README.md) on re-running from a worktree).

Night 1 HTML is live — [`d1-archaeologist.html`](../presentation/d1-archaeologist.html) · [`d1/`](d1/README.md).
Night 2 HTML is live — [`d2-translator.html`](../presentation/d2-translator.html) · [`d2/`](d2/README.md). Identify by `data-act-name`.
Night 3 HTML is live — [`d3-constructor.html`](../presentation/d3-constructor.html) · [`d3/`](d3/README.md) (13 beats, four boards). Type 01 Gold steel thread. Identify by `data-act-name`. J5 abstains, then they render the SA mermaids in [`plans/modern.md`](../plans/modern.md).
Night 4 HTML is live — [`d4-orchestrator.html`](../presentation/d4-orchestrator.html) (28 slides) · [`d4/`](d4/README.md) (9 beats, four boards). Trail first, then remaining lanes + Type `05`. Identify by `data-act-name`.
Night 5 staff is live — [`d5/`](d5/README.md) (pre-flight `00` + 6 beats). Pre-flight, recap Type 01 from disk, Linear, look up 02–05, smoke with DuckDB/dbt/Dagster, Type `06` factory, flywheel. Identify by `data-act-name`. Deck: [`presentation/d5-dark-factory.html`](../presentation/d5-dark-factory.html) (28 slides).

Kits (park the Night HUD, teach, **return**): [`ebooks/ebook-seamwise.pdf`](../ebooks/ebook-seamwise.pdf), [`ebooks/brf-task-spec.md`](../ebooks/brf-task-spec.md) — see [`ebooks/`](../ebooks/README.md).

---

## E2E as run (Night 3)

Do **not** walk 07–11 on `main` — those beats write `docs/` and `modern/`. Use a worktree after the clock is committed. Compose `northwind-pay-legacy` (port 2222) is one plant; do not share it with another checkout.

| Beat | Expect |
|---|---|
| 01 | Ingest signed. 0006 parked. One parser leaf. **No** `modern/landing/` unless emit already ran |
| 02–03 | Nine-pack notebook. Paid grain `batch_id + currency`. Abstain on dlt/dbt if not in the brain |
| 04 | Three mermaids from [`plans/modern.md`](../plans/modern.md). Not an ADR. Dagster on the flowchart = Thursday |
| 05–08 | Lakehouse ADRs + seam 2 legs + `docs/consensus-lakehouse.md`. Do not recut ingest `consensus.md` |
| 09–12 | **Dark** if 08 unsigned. Else Type 01 only: emit → dlt register → B/S/G → golden-match |
| 13 | Lineage · Type 05 subject line · Milestone 4. No Dagster on disk |

`cvg` may error (Task-Spec 3.9 vs 3.8). Agent still writes `docs/`. Do not author Types `02`–`05` on Night 3. Thursday **does** `cvg init` + pin 3.8.x. `make deploy` recreates SFTP (`--force-recreate`) so a stale `sftpusers` container cannot fail the boot — stop Compose on `main` first **or remap ports / `COMPOSE_PROJECT_NAME` on a worktree**. Evidence is gitignored — open it in the **terminal**. Hyphenated `01-card-settlement/` is not an importable package; do not shadow pip `dlt`. See [`d3/README.md`](d3/README.md) Staff traps.

---

## E2E as run (Night 4)

Do **not** generate `02`–`05` on `main` if Type 01 Gold is missing — those beats write `docs/` and `modern/`. Use a worktree. Gold missing → walk 01–02 only.

| Beat | Expect |
|---|---|
| 01 | Type 01 Gold **or named gap**. One look. Keep 173.44 |
| 02 | Six trail chapters cited in order. Right/wrong card started. **Not** paid-grain `catalog_ask` |
| 03–04 | **Dark** if Gold missing. Remaining work on SWE vs DE vs tonight. Leaves with evals. Linear queue |
| 05–06 | **Type 01** leaf cranked. **Packet** on disk. Hash if Gold exists |
| 07–08 | `DF-SOURCE-005` = `CONFIRMED_SOURCE_DEFECT`. `HALF_UP`. Never rewrite `expected/` |
| 09 | Factory / flywheel. Type `06` not searched |

Host: pin Task-Spec 3.8.x, `cvg init`, project `ingest-landing` / `dlt-gold` / `orchestrate-serve`. Linear is the board, not the judge. Mesh is **not** inside Task-Spec.

```text
run/
  README.md
  d1/          live — six slices A–F + Close 17. Deck 44 slides.
    README.md  slice index
    01–04      Slice A · Seat
    05–09      Slice B · Plant (boot before any status/run)
    10–11      Slice C · Read
    12         Slice D · Second Brain (nine packs, whole drop)
    13         Slice E · OntoLayer
    14–16      Slice F · Converge Capture → Intent · no Pass 2
    17         Close · Research, then walk
  d2/          live — 12 beats, same mold as d1 (prompts + proofs)
    README.md  slices A–E + Close
    01–02      A · Recap (status, papers)
    03–04      B · Harness (prompt, fail closed)
    05–06      C · Query (brain, graph)
    07–10      D · Pass 2–4 (kits, ADRs, seams, sign)
    11         E · Task-Spec
    12         Close · Research
  d3/          live — 13 beats, four boards + Close. Type 01 Gold.
    README.md  Recap + slices A–D + Close
    01         Recap · papers + disk (no HO badge)
    02–04      A · Query (brain, graph, SA mermaids from plans/modern.md)
    05–08      B · Barrier (kits, unpark, seam 2, lakehouse sign)
    09         C · Task-Spec Type 01 remainder + lakehouse leaves
    10–12      D · Gold (landing, dlt+B/S/G, golden-match)
    13         Close · Research
  d4/          live — 9 beats, four boards + Close. Trail, then factory.
    README.md  Recap + slices A–D + Close
    01         Recap · Gold or named gap (no HO badge)
    02         A · Trail (requisites → problem → decisions → SWE → DE/AE → tonight)
    03–04      B · Lanes (place remaining + generate/queue)
    05–06      C · Loop (Type 01 crank + packet)
    07–08      D · Type 05 unattended + HALF_UP
    09         Close · Research
  d5/          live — pre-flight + 6 beats. Thursday disk, then Type 06 factory.
    README.md  Recap 01 · Linear · look-up 02–05 · smoke · Type 06 · flywheel
    00         Pre-flight (host: venvs, DuckDB, dbt, Dagster, the sealed kit)
    01         A · Recap Type 01 (Gold + packet; skip Dagster)
    02         B · Linear register (file is the queue)
    03         C · Look up 02–05 (leaves + Type 05 legacy packets)
    04         D · Pipeline smoke (Type 01 from landing)
    05         E · Type 06 Converge 0–8
    06         Close · Flywheel
```


## How to write a beat file

```text
# NN · name
- Slide:
- Who:
- Next: NN+1-….md

## Do / Prompt (verbatim)
## Proof
## If fail
```

Homework for the room is not a beat.

If `agenda/dN.md` and `run/dN/` disagree, **agenda wins on scope**.
Fix the run file. Do not invent a sixth type or a Pass the brief did
not authorize.
