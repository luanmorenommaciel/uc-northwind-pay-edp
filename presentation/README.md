# Presentation

What the room **sees**. Self-contained HTML. Open in a browser, `F11`.
No build step, no server — the only external fetch is Google Fonts.

This folder is not the week map ([`agenda/`](../agenda/README.md)), not
the staff clock ([`run/`](../run/README.md)), not the Converge papers
([`docs/`](../docs/README.md)), and not the engagement spec
([`plans/`](../plans/README.md)). Images live in [`../assets/`](../assets/).

Two shapes live here:

| Shape | How it plays | Files |
|---|---|---|
| **Follow-along deck** | Snap slides, HUD, Hands-On boards. One Night. | `d1-archaeologist.html`, `d2-translator.html`, `d3-constructor.html`, `d4-orchestrator.html`, `d5-dark-factory.html` |
| **Method / reference** | Manual or workshop. Teach the kit, not the clock. | `asd-…`, `boot-…`, `wrkp-…`, `yt-…` — the three method kits (Converge, SeamWise, Task-Spec) moved to [`ebooks/`](../ebooks/README.md) |

If a night’s HTML and [`run/dN/`](../run/) disagree, **agenda wins on
scope**; **run wins on the clock**. Identify Night 2–4 slides by
**`data-act-name`**, not a HUD integer. Type `06` was not in `spec/` until
Friday (it docked 2026-08-28).

**All five Nights ran:** Night 1 (44 slides), Night 2 (34), Night 3 (37 ·
[`run/d3/`](../run/d3/README.md)), Night 4 ([`d4-orchestrator.html`](d4-orchestrator.html) · [`run/d4/`](../run/d4/README.md)
— 28 slides, 9 beats, trail then factory), Night 5 ([`d5-dark-factory.html`](d5-dark-factory.html) · brief [`agenda/d5.md`](../agenda/d5.md) · staff [`run/d5/`](../run/d5/README.md) — 28 slides, pre-flight `00` + 6 demo beats). Identify by `data-act-name`. Do not clone `wrkp-dark-factory.html` as the HUD.

---

## What’s in this folder

| File | Kind | What it is | When you open it |
|---|---|---|---|
| [`d1-archaeologist.html`](d1-archaeologist.html) | Night 1 deck | Onboard + Archaeologist. **44 slides**, six blocks, HUD `01`–`44`. Pass **0–1** only. **Live.** | Night 1. Staff: [`run/d1/`](../run/d1/README.md) |
| [`d2-translator.html`](d2-translator.html) | Night 2 deck | Translator · java2py. **34 slides**, six blocks, five Hands-On boards (slices a–e). Identify by `data-act-name`. **Live.** | Night 2. Staff: [`run/d2/`](../run/d2/README.md) |
| [`d3-constructor.html`](d3-constructor.html) | Night 3 deck | Constructor · DE + analytics. **37 slides**, six blocks, four Hands-On boards (A–D). Identify by `data-act-name`. **Live.** Lockstep with `run/d3/`. | Night 3. Staff: [`run/d3/`](../run/d3/README.md) |
| [`d4-orchestrator.html`](d4-orchestrator.html) | Night 4 deck | Orchestrator. **28 slides**, six blocks. Identify by `data-act-name`. Lockstep with `run/d4/`. | Night 4. Staff: [`run/d4/`](../run/d4/README.md) |
| [`d5-dark-factory.html`](d5-dark-factory.html) | Night 5 deck | Dark Factory. **28 slides**, six blocks, boards A–E + Flywheel. Identify by `data-act-name`. Lockstep with `run/d5/`. Brief [`agenda/d5.md`](../agenda/d5.md). **Live.** | Night 5. Staff: [`run/d5/`](../run/d5/README.md). Do not clone `wrkp-dark-factory.html` |
| [`../ebooks/ebook-seamwise.pdf`](../ebooks/ebook-seamwise.pdf) | Method kit | SeamWise internals. **Leave · SeamWise** parks here (Nights 2–4), then **returns** to the numbered beat. Was `seamwise.html` here until `f06e5c5` | Pass 3 kit. Not the Night clock |
| [`../ebooks/brf-task-spec.md`](../ebooks/brf-task-spec.md) | Method kit | Task-Spec internals. Dig **Show**, then return (Night 2: Execute 11 · Night 3: 09 · Night 4: 03–04). Was `task-spec.html` here; the rendered PDF is gitignored | Pass 5 kit. Mesh is **not** inside it |
| [`../ebooks/ebook-converge.pdf`](../ebooks/ebook-converge.pdf) | Method manual | Converge spine — nine passes, two phases, one human barrier. Was `cvg-aut-systems-spine-steps.html` here | When the room needs the kit, not the Night. Papers: [`docs/`](../docs/README.md) |
| [`asd-agentic-loop.html`](asd-agentic-loop.html) | Method manual | ASD — the Agentic Loop. Scroll document, **12 sections** (not a HUD deck) | Doctrine |
| [`boot-uc-northwind-pay-edp-oss.html`](boot-uc-northwind-pay-edp-oss.html) | Method manual | Bootcamp reference — case framing, Shapiro ladder, the week arc. **19 slides** | Framing. Not the follow-along |
| [`wrkp-dark-factory.html`](wrkp-dark-factory.html) | Workshop | Dark Factory Operation. **83 slides**. Broader workshop, not Night 5’s sealed Type `06` | Context / seed |
| [`yt-agentic-engineering.html`](yt-agentic-engineering.html) | Talk | *Engenharia Agêntica* (pt-BR). **44 slides** | Outreach. Do not drive a Night from it |

One Night — no morning / afternoon split.

**Week story on these HUDs:** Night 1 understands (0–1). Nights 2–3 are
**Type 01 steel threads** (SWE ingest → landing, then DE landing → Gold).
Night 4 clock teaches **Context · Eval · Loop**, **walks the Type 01 trail**,
then generates remaining SWE+DE and cranks (Mesh + Pass 6–8, Linear), then Type `05` unattended. 28 slides, live.

---

## Night 1 · Archaeologist

[`d1-archaeologist.html`](d1-archaeologist.html) — **44 slides, six blocks**.
HUD pill is the block name. HUD `01`–`44`.

| Block | Slides | Mode |
|---|---|---|
| Opening | 1 | title |
| Stage | 7 | presentation, keyboards down |
| Craft | 6 | teaching + Hands-On A (01–04) |
| Floor | 9 | teaching, Hands-On B (05–09), MATCHED look-up |
| Dig | 14 | roles, estate, Show then Hands-On C–F (10–16) |
| Debrief | 7 | Research (17), Next, silent Tomorrow |

Six Hands-On boards only (slices A–F). Brain: unzip
[`brain/notebooklm/northwind-pay-brain.zip`](../brain/notebooklm/northwind-pay-brain.zip)
and upload the **nine** `.md` files. Days 2–4 **query** that notebook. Type `06`
is deliberately not in it.

Staff: [`run/d1/README.md`](../run/d1/README.md).

## Night 2 · Translator

[`d2-translator.html`](d2-translator.html) — **34 slides, six blocks**.
Identify by `data-act-name`.

| Block | Mode |
|---|---|
| Opening | title |
| Stage | Recap Shows, Execute 01–02, then lecture (SWE, java2py, ingest) |
| Craft | Harness Shows, Execute 03–04 |
| Floor | Query Shows, Execute 05–06 |
| Dig | Converge Show, Leave · SeamWise (`ebooks/ebook-seamwise.pdf`), Execute 07–10, Task-Spec Show (`ebooks/brf-task-spec.md`), Execute 11, Task-Mesh Show |
| Debrief | In hand, Research 12, Next, silent Tomorrow |

Five Hands-On boards (slices a–e). Research is Close, not a sixth board.
`java2py` is a nickname for the second plant, not a Java port.
Staff: [`run/d2/README.md`](../run/d2/README.md).

## Night 3 · Constructor

[`d3-constructor.html`](d3-constructor.html) — **37 slides, six blocks**, four Hands-On
boards (A–D). Identify by `data-act-name`. Extra Stage talk slides (Lakehouse,
Agentic field) are talk only — they have **no** `run/d3/` file. **SA plan · mermaids**
is Stage Show; the room **types** it as `run/d3/04` on Execute 02–04 after J5 abstains.

| Block | Mode |
|---|---|
| Opening | title · Constructor |
| Stage | Recap, DE+analytics role, foundations, pipeline, engines, **SA plan mermaids**, medallion, agentic modeling |
| Craft | Bind still on (Show). Kits. **No** fail-closed board |
| Floor | Second Brain + OntoLayer Shows, **Execute 02–04** |
| Dig | Converge Show, Leave · SeamWise, **Execute 05–08**, Task-Spec Show, **Execute 09**, **Execute 10–12**, Task-Mesh seed, Thursday queue |
| Debrief | In hand, Research (`run/d3/13`), Next, silent Tomorrow |

Type 01 **steel thread** tonight: leftover emit if no Parquet, then dlt
register → Bronze → Silver → Gold → golden-match. Types `02`–`05` wait for
Thursday. Unsigned lakehouse sign → skip Execute 09 and Execute 10–12.

Staff: [`run/d3/README.md`](../run/d3/README.md).

## Night 4 · Orchestrator

[`d4-orchestrator.html`](d4-orchestrator.html) — **in this folder.** Identify by `data-act-name`. PPT brief: [`agenda/d4.md`](../agenda/d4.md).
Staff: [`run/d4/README.md`](../run/d4/README.md) — 9 beats, four Hands-On boards A–D.
Clone Night 3 chrome. Identify by `data-act-name`. If agenda and `run/d4/` disagree on Hands-On ranges, **run wins on the clock**.

Public eight (same shape as Night 2): Recap · Orchestrator role · Context Engineering · Eval Engineering · Telemetry (packet) · Agent Harness (Loop+Eval) · Loop / Mesh · Converge 6–8 + Linear.

Stage teaches **Context · Eval · Loop first**. Floor **walks the trail**. Then remaining lanes, Type 01 crank, Type `05` unattended + `HALF_UP`. Task-Mesh is **beside** Task-Spec. Recap Gold from disk; gap → dark 03–08.

| Block | Mode |
|---|---|
| Opening | title · Orchestrator |
| Stage | Recap Gold / papers, then Context · Eval · packet · rings |
| Craft | Bind still on. Host pin Task-Spec 3.8.x + `cvg init`. Kits. |
| Floor | Trail Show, **Execute 02** |
| Dig | Leave · SeamWise, **Execute 03–04**, Task-Spec Show, Mesh+Linear Show, **Execute 05–06**, **Execute 07–08** |
| Debrief | In hand, Research (`run/d4/09`), Next, silent Tomorrow |

---

## Method manuals vs week papers

Leave the Night HUD to teach a kit; **return** to the numbered beat. Do not
paste Pass 3 or Pass 5 execute from inside the kit.

| Need | Open |
|---|---|
| What is Converge / ASD / the boot arc | [`ebooks/ebook-converge.pdf`](../ebooks/ebook-converge.pdf); this folder (`asd-…`, `boot-…`) |
| SeamWise internals | [`ebooks/ebook-seamwise.pdf`](../ebooks/ebook-seamwise.pdf) |
| Task-Spec internals | [`ebooks/brf-task-spec.md`](../ebooks/brf-task-spec.md) |
| BRD, tech-spec, ADRs, seams, the sign, Task-Specs | [`docs/`](../docs/README.md) |
| Independence, type map, golden-match | [`plans/modern.md`](../plans/modern.md) |

`wrkp-dark-factory.html` is the long workshop. `yt-agentic-engineering.html`
is the Portuguese talk. Neither replaces Night 5.

---

## Driving a follow-along deck

| Key | Does |
|---|---|
| `→` `↓` `Space` `PageDown` | next slide |
| `←` `↑` `PageUp` | previous |
| `Home` / `End` | first / last |

Dots on the right edge are clickable. The bar across the top is scroll
progress. Slides snap, so a trackpad flick moves exactly one.

`asd-agentic-loop.html` is a **scroll page** (anchor nav, Print / save as
PDF). `boot-…` is a **print-page** deck (fixed 1000×1414), not the HUD
snap deck; the Converge print deck that used to sit beside it is now
[`ebooks/ebook-converge.pdf`](../ebooks/ebook-converge.pdf).

---

## House rules for editing

- **One file per deck.** Styles, markup and script live together — no imports.
- **Every number is traceable.** Amounts, byte offsets and verdicts come from
  `contracts/`, `spec/` or `evidence/`. If it is on a slide, it is in the repo.
- **Hands-On is one mold.** Clone Day 1 Execute 01–04: chip, `run/dN/` path,
  `.req` beat tiles, look-up / do not. Show slides teach; they do not invent a
  local “beat 01”. Point at `run/dN/NN`. Night 1: six boards. Night 2: five.
  Night 3: four. Night 4: four. Research is Close, not a Hands-On badge.
- **Each Show slide shows its information differently.** Flow, annotated artifact,
  diff, matrix, gauges — repeating a mechanism is a smell. The Hands-On boards
  are the exception: they must look the same.
- **Namespace new components.** Two decks merged into this one already collided
  on `.mac`; the second set became `.cmac`. Check before adding a class.
- **Cut HTML blocks by their own closing tag,** not the next `</div>`. Getting
  this wrong once pushed 5 slides outside `.deck` and the counter read `02`.

The Day 1 deck uses 35 files from [`../assets/`](../assets/).
