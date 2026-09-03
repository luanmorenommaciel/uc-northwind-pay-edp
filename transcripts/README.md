# Transcripts — live Nights

Closed captions from the projector room. They are **what was said**, not
the week map and not the staff clock.

| Need | Open |
|---|---|
| What the Night was *for* | [`agenda/`](../agenda/README.md) |
| What the three of you execute | [`run/`](../run/README.md) |
| What the room saw | [`presentation/`](../presentation/README.md) |
| Converge papers | [`docs/`](../docs/README.md) |

**One Night** each day. No morning / afternoon split. The `.vtt` is the
live language (this drop is pt-BR). Briefs in the repo stay English.

Do not treat a caption as a gate. If a transcript and [`agenda/dN.md`](../agenda/d1.md)
disagree, the brief wins. Do not paste these files into NotebookLM.

## Naming

```text
tr-dN-<seat>.cc.vtt
```

| File | Night | Seat |
|---|---|---|
| [`tr-d1-archaeologist.cc.vtt`](tr-d1-archaeologist.cc.vtt) | 1 | Archaeologist (SA + AI) — **on disk** |
| [`tr-d2-translator.cc.vtt`](tr-d2-translator.cc.vtt) | 2 | Translator (SWE) — **on disk** |
| [`tr-d3-constructor.cc.vtt`](tr-d3-constructor.cc.vtt) | 3 | Constructor (DE + analytics) — **on disk** |
| [`tr-d4-orchestrator.cc.vtt`](tr-d4-orchestrator.cc.vtt) | 4 | Orchestrator — **on disk**, not yet committed |
| [`tr-d5-dark-factory.cc.vtt`](tr-d5-dark-factory.cc.vtt) | 5 | Dark Factory — **on disk**, not yet committed |

`.cc.vtt` = WebVTT closed captions. All five Nights are captioned; the
last two are untracked in git until someone adds them.

---

## Main points of each Night

The week is one steel thread that **widens**: Type `01` card settlement,
trailer lie **173.44** vs rows **173.45**, keep the declaration, refuse
the batch. Days 2–3 run **Type 01 only** (SWE landing, then DE Gold).
Day 4 walks the Type 01 trail, then generates remaining SWE+DE and cranks the loop. Autonomy goes up.
HITL goes down. Type `06` stays sealed until Friday, then docks and stalls
`CONFIRMED_LEGACY_DEFECT`.

### Night 1 — Archaeologist · understand

**Rings:** prompt + context. **Converge:** Pass **0–1** only. **No product code.**

You arrive AI-native, brownfield. You do not inherit a brain, a graph,
or last run’s ADRs.

1. **Use-case.** Money arrives as overnight files. Two plants, same raw
   bytes. Legacy first write = CSV on SFTP. Modern first write (later) =
   Parquet in `modern/landing/`.
2. **Seat.** House stack: Oh My Pi → OpenRouter → a workspace → DeepSeek.
   Grade gates, not the vendor.
3. **Plant is a fact.** `make deploy` then `make run TYPE=01 SCENARIO=valid-minimal`.
   MATCHED, net `173.45`. `evidence/` in the **terminal**.
4. **Second Brain.** Nine packs, types `01`–`05`, NotebookLM. Type `01`
   is the week’s first steel thread. Days 2–4 **query** this notebook.
5. **OntoLayer.** Same question **without** (`make ontology-ask-sql`) then
   **with** (`make ontology-ask` / MCP).
6. **Converge 0–1.** Capture writes `docs/brd-type-01-card-settlement.md`.
   Intent writes `docs/tech-spec-type-01-card-settlement.md`. Stop.
   No ADRs, no seams, no Consensus, no `modern/`.

Staff: [`run/d1/`](../run/d1/README.md). Deck live: [`d1-archaeologist.html`](../presentation/d1-archaeologist.html).

### Night 2 — Translator · translate

**Rings:** harness (Bind). **Converge:** Recap 0–1. Run **2–4**, then **5**.
Mesh internals. Factory 6–8 is Day 4.

Yesterday you created the seat, the brain, the graph, and the brief.
Tonight you recap, bind the machine, query, sign, and hold **one** leaf.

1. **Recap.** MATCHED still. Restate the BRD and the tech-spec.
2. **java2py.** Second plant, not a Java port. First write is Parquet, not SFTP.
3. **Bind the Agent Harness.** Frozen: `legacy/`, `contracts/`, `gen/`,
   `infra/`. Touch `legacy/processor/` → fail closed, or **stop**.
4. **Query.** Second Brain + OntoLayer until 2–4 has evidence.
5. **Consensus is the barrier.** ADRs 0001–0005 close landing; **0006 parks**
   the lakehouse. Seams named. Owner **signs** ingest → landing. No sign → no leaf.
6. **Task-Spec.** One Type 01 **parser** leaf, one eval, `signed_off` false.
   Mesh is Show. **No `modern/` required Tuesday.** Park `02`–`05`.

Staff: [`run/d2/`](../run/d2/README.md) — 12 beats, five boards.
Deck live: [`d2-translator.html`](../presentation/d2-translator.html).
Kit pauses: [`ebook-seamwise.pdf`](../ebooks/ebook-seamwise.pdf), [`brf-task-spec.md`](../ebooks/brf-task-spec.md).

### Night 3 — Constructor · Gold

**Rings:** harness + loop seed. **Converge:** Recap. **2–4–5** on **dlt → Gold**.
Mesh is **seed**. Factory 6–8 is Thursday.

Landing Parquet exists **only if** Tuesday’s emit ran — otherwise emit is
the first incident, not a re-parse. Tonight is the **Type 01 DE steel thread**.

1. Recap papers + disk. 0006 parked. One parser leaf. Keep **173.44**.
2. Query the same nine-pack brain + OntoLayer (paid grain). Abstain on dlt/dbt
   if not in the notebook — stack lives in `docs/` / `plans/modern.md`.
3. Unpark 0006. Cut seam 2 legs (register → medallion → match). Sign
   **`docs/consensus-lakehouse.md`**. Do not recut ingest Consensus.
4. Type 01 lakehouse leaves only. Eval = Gold + classification, not “dbt ran.”
5. Execute: landing → dlt **registers** (no re-parse) → Bronze → Silver → Gold
   → golden-match. `valid-minimal` both questions yes. `DF-SOURCE-001` =
   `CONFIRMED_SOURCE_DEFECT`. Zero unexplained. Do not rewrite the referee.
6. Types `02`–`05` stay parked. No Dagster. No Linear tonight.

Staff: [`run/d3/`](../run/d3/README.md) — 13 beats, four boards.
Deck live: [`d3-constructor.html`](../presentation/d3-constructor.html).

### Night 4 — Orchestrator · leave

**Rings:** loop + eval. **Converge:** Context · Eval · Loop, then Pass **6–8**.
**Linear** is the board. Type `05` unattended. Mesh is **not** inside Task-Spec.

1. Recap: Type 01 Gold **or named gap**. Keep **173.44**. Do not recut signs.
2. **Trail:** requisites → problem → decisions → SWE → DE/AE → tonight.
   Cite a file per chapter. Do not re-ask where paid lives.
3. **Context · Eval · Loop** (Stage talk): four rooms; `golden_match.py`;
   packet under `evidence/`. No packet → no settle.
4. Remaining types on the **same two lanes**. Task-Spec generates remaining
   SWE+DE. Empty packages forbidden. Host: pin Task-Spec 3.8.x, `cvg init`,
   this plant’s seams (`ingest-landing`, `dlt-gold`, `orchestrate-serve`).
5. Mesh + Pass 6–8 **crank Type 01 first**. Watch the eval. Linear moves with the packet.
6. Type `05` unattended. `DF-SOURCE-005` = `CONFIRMED_SOURCE_DEFECT`. Small pill:
   `rounding-half-up` is `HALF_UP`. `HALF_EVEN` → `MODERN_DEFECT`. Do not change
   `expected/`. Do not break Java.
7. Type `06` still absent.

Staff: [`run/d4/`](../run/d4/README.md) — 9 beats, four boards. Trail first.
Deck live: [`d4-orchestrator.html`](../presentation/d4-orchestrator.html).

### Night 5 — Dark Factory · classify

**Rings:** orchestration. **Converge:** full **0–8** on a sealed Type `06`.

1. Never-seen kit. Not in the Day 1 zip. Not in `spec/` until tonight.
   Then add a **new** brain pack — do not invent it on Days 2–4.
2. Same spine, same barrier, same Bind. OntoLayer may answer the new
   schema; it does not skip Consensus.
3. Build the same shape: five-file → landing → dlt → Gold → golden-match.
4. When the cent disagrees: classify. Honest name may be
   `CONFIRMED_LEGACY_DEFECT` — the **main plant**, not the file.
5. Stall the type. Write the evidence. **Do not** edit frozen `legacy/`
   to go green.

Staff: [`run/d5/`](../run/d5/README.md) — pre-flight + 6 beats.
Deck live: [`d5-dark-factory.html`](../presentation/d5-dark-factory.html).

The workshop deck [`wrkp-dark-factory.html`](../presentation/wrkp-dark-factory.html)
is not this Night’s HUD.

---

## How to use a caption

- Search a number (`173.45`, `173.44`) or a pass name to jump the tape.
- Pair with the matching `run/dN/` beat if you are reconstructing a Night.
- Night 3 recap may use [`tr-d2-translator.cc.vtt`](tr-d2-translator.cc.vtt)
  plus [`docs/`](../docs/README.md) — not as a gate.
- Do not upload into the Second Brain. Do not treat speech as `contracts/`.
