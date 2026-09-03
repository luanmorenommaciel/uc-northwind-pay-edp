# The Dark Factory — stages, gates, and the doctrine behind them

**Partly on this tree since Night 5 (2026-08-28).** This began as the
seed of the later idea — lights-out build, stages, gates, the unattended
loop. There is still no `factory/` folder; the detector is
`modern/scripts/factory_e2e.py` (seven stages: intake, ground truth, plan,
build, publish, lakehouse, golden-match), driven by
`.claude/skills/dark-factory-triage/`. It ran once on Type `06` and
stalled. Read the rest as the broader picture the plant grew into, and
the flywheel note at the end as what actually happened.

Companion documents:

| Document | Answers |
|---|---|
| [`legacy.md`](legacy.md) | What the frozen oracle is and how it was proven |
| [`modern.md`](modern.md) | What the independent second implementation must be |
| [`agenda/d5.md`](../agenda/d5.md) | Night-five scope. Type `06` is not in the Day 1 Second Brain zip. Papers: [`docs/`](../docs/README.md) |

---

## 1. What "Dark Factory" means

The industry term is *lights-out manufacturing*: a plant that runs with the
lights off because no human is on the floor. Applied here:

> **A queue goes in. Validated, evidence-backed software comes out. No human is
> in the execution path — only at the approval gate.**

Two distinct things share the name in our material, and conflating them
confuses an audience:

| | The **build factory** | The **detector** |
|---|---|---|
| Where | KurvPay chapter 07; this week, later | `modern/scripts/factory_e2e.py` — Night 5, not on the base |
| Job | Manufactures a typed pipeline for a file type | Observes finished runs and attributes defects |
| Direction | Produces code | Judges output |

This document is about the **build factory**. The detector is one of the
instruments the factory's proof stage uses.

---

## 2. The given — what arrives with the request

The factory does **not** build the legacy system. Legacy arrives *with* the
request, already working, and is the **ground truth**. At Kurv this was 32
T-SQL types that already ran in production; here it is the same shape.

A new-type request carries three things:

1. **The documentation** — layout, field positions, money rules, privacy rules,
   reconciliation definition, canonical rejection codes.
2. **The sample file** — real bytes, plus its checksum and source manifest.
3. **The working legacy path** — SFTP → Java → SFTP → PostgreSQL.

### The legacy path in detail

```
raw file
  → SFTP raw/incoming            (manifest written LAST = readiness signal)
  → worker senses + claims the batch
  → Java processor               pulls raw bytes, parses, validates declared
                                 controls against independently computed ones
  → SFTP csv/outgoing            sanitized CSV written back (no PAN, no CPF)
  → loader                       pulls CSV, COPY into staging.*
  → stored procedures            apply to legacy.*, refresh
                                 reporting.*_reconciliation — one transaction
  → evidence packet              immutable, privacy-safe, per batch
  → raw archived or quarantined
```

Two terminal outcomes, both correct:

- **Accepted** → sanitized CSV, staged rows, applied rows, `MATCHED`
  reconciliation, raw archived.
- **Quarantined** → *no* CSV, *zero* rows, a stable rejection code, raw moved to
  quarantine, and **unrelated batches keep running**.

The factory never calls this path, never imports from it, and never modifies
it. It only *observes* it.

---

## 3. The four truth roles — the doctrine everything rests on

Most migration failures come from collapsing these four into one word,
"source of truth". Keep them apart in code, in evidence, and in conversation:

| Role | In this repo | What it answers |
|---|---|---|
| **System of record** | `source-manifest.json` — the source's own declaration | "What did the sender claim?" |
| **Source of observation** | Legacy evidence, PostgreSQL control plane, SFTP zones | "What actually happened?" |
| **Source of correctness** | `contracts/types/**` — layouts and expected outputs | "What *should* happen?" |
| **Executable Git contract** | The committed, hash-bound tree | "Which exact version made this claim?" |

The consequence that matters:

> **Legacy is the referee, not the teacher.** The new implementation reads the
> *contract*, never the Java. Reading the Java would be copying the answer and
> calling it a proof — and any defect in the old code would be faithfully
> reproduced and then declared "parity".

---

## 4. The seven stages

Each stage ends in a gate. A failed gate **stalls that type** with the stage and
reason recorded. It never silently advances with a half-built layer — which is
what makes an unattended run safe.

### Stage 0 — Intake

Read the request: spec document, sample file, legacy kit.

**Gate: does the request ship an oracle?**
The spec must carry its expected outputs — sanitized rows, reconciliation
totals, rejection codes. No expected outputs means nothing can adjudicate the
result, so the factory refuses **before doing any work**.

> *No eval, no task.*

This is the cheapest gate in the system and the one that saves the most: it
fails in seconds instead of after a build nobody can validate.

### Stage 1 — Ground truth

Deploy a **fresh** runtime, run the legacy path end to end for the new type,
capture the observations: evidence packets, `reporting.*` rows, control-plane
state, SFTP zone topology.

**Gate: legacy green and its observations captured and hashed.**

Freshness is *asserted*, never assumed — the volume is verified empty and
migrations are seen applying from scratch. A run on a dirty runtime proves
nothing, and the residue of a previous run looks exactly like success.

### Stage 2 — Plan

Create the worktree and branch. Read the contract and the captured
observations. Write the plan and the decision records.

**Gate: every handoff has one owner, one input contract, one accepted output.**

Ownership ambiguity is where financial bugs hide. If two components can both
decide how money is typed, they will eventually disagree.

### Stage 3 — Build

Implement the five-layer package **from the contract only**:

```
model.py    typed records, exact Decimal money
parser.py   transport, positions, grammar, encoding, dates, signs
schema.py   validation, privacy transformation, independent controls
writer.py   deterministic Parquet plus metadata
handler.py  composes the four for one batch
```

**Gate: reproduces the contract's approved sanitized output byte-for-byte.**

Not "parses without error". Not "coverage ≥ 80%". *Produces the approved
bytes.* This is the single highest-value test in the system — it is the only
check that has caught defects which were well-formed, deterministic, stable,
and wrong.

### Stage 4 — Publish

Write canonical Parquet plus a readiness manifest, atomically, manifest last.

**Gate: re-running produces an identical SHA-256.**

Statistics and dictionary encoding are disabled so the file is a pure function
of the rows and the schema. The file hash therefore *is* the determinism check
— no extra machinery needed.

### Stage 5 — Lakehouse

dlt **registers** the landing Parquet (it never parses or reshapes). dbt builds
Bronze → Silver → Gold at documented grains.

**Gate: `dbt build` green, including privacy assertions and the
no-unexplained-financial-delta test.**

Gold's grain deliberately equals the legacy reporting grain, so the comparison
in the next stage is like-for-like rather than an aggregate reshaped to fit.

### Stage 6 — Golden-match

Compare on two axes at two levels:

|  | Against contract truth | Against legacy observation |
|---|---|---|
| **Record level** | expected sanitized rows | legacy sanitized CSV |
| **Aggregate level** | expected reconciliation | `reporting.*_reconciliation` |

Rejected batches are compared on **terminal behavior** — status, stable code,
zero output, zero mutation, peer continuation — never on rows. Inventing empty
rows so a rejection can be "compared like a success" hides the very difference
that matters.

Every difference is classified as exactly one of:

`CONFIRMED_SOURCE_DEFECT` · `CONFIRMED_LEGACY_DEFECT` · `MODERN_DEFECT` ·
`APPROVED_BEHAVIOR_CHANGE` · `CONTRACT_AMBIGUITY` · `UNRESOLVED`

**Gate: zero unexplained differences.**

There is no tolerance setting anywhere in this stage. A configurable tolerance
is how an unexplained cent becomes an accepted cent.

### Stage 7 — Ship and learn

Publish the immutable, privacy-safe evidence packet. Open the PR carrying the
evidence, the journal, and the decision records. Harvest lessons. Promote a
recurring one to a skill or a guard.

**Gate: a human approves the merge.** The only human touch in the whole line.

A lesson earns promotion when all three hold: it **recurs** across types, it is
**expensive when wrong**, and it is **mechanizable**. Anything needing
case-by-case judgment stays a lesson.

---

## 5. The gates — four kinds, one human

| Kind | When | Waivable? |
|---|---|---|
| **Stage gates** | Between every stage | No |
| **Source gate** | Contract, unit, security suites + strict typing | No |
| **Correctness gates** | Privacy scan, golden-match, determinism, isolation | **Never** |
| **Approval gate** | The PR merge | Yes — the one human decision |

Waiving the human gate does not weaken the correctness gates. Under unattended
operation they still fire and still stall the type.

**Never waived, ever:** no-oracle refusal · privacy violation · unexplained
financial difference · frozen-input mutation.

---

## 6. The loop — how it runs unattended

An agent cannot loop on its own; it only acts when invoked. The loop supplies
what's missing:

| Part | What it is |
|---|---|
| **Goal state** | A queue — one row per item with a status |
| **Per-tick action** | What to do for exactly one item, idempotent |
| **Pre-flight gate** | Must pass before tick 1 — credentials, inputs, runtime |
| **Stall policy** | One item's failure stalls **that item**, never the batch |
| **Clock** | Re-fires the next tick; terminates when the queue drains |

Five invariants:

1. **Idempotent ticks** — a half-done item is `in-progress`; the next tick
   continues it, never double-processes.
2. **Stall, never halt** — the batch is as fragile as its pre-flight gate, not
   as its worst item.
3. **Verify before irreversible** — trust-but-verify each item before any
   deploy or merge.
4. **Pre-flight gates loud** — fail before tick 1 rather than waste a batch
   that cannot finish.
5. **The durable record is the goal-state file**, not the chat.

Operator cadence is the **morning review**: the loop runs overnight, stalling
anything it cannot finish; the human reviews and clears the approval gate in
the morning. A stall is not urgent until then.

---

## 7. The injected defect — why the whole thing exists

Every type carries a canonical `DF-SOURCE-*` batch in which the **source
declares a total its own detail rows contradict** — one cent.

What must happen, and what the demo shows:

1. Java independently computes the true total and **refuses** the batch.
2. **Zero** rows reach staging or the business tables. Not rolled back — never
   written.
3. No sanitized CSV is produced.
4. The modern implementation, independently, computes the same true total and
   refuses the same way.
5. Neither system **corrects** the source's number. Both preserve the wrong
   declaration exactly as published.
6. Golden-match classifies it `CONFIRMED_SOURCE_DEFECT` — explained, not
   unexplained.
7. Peer batches processed after it succeed and reconcile.

> **A wrong money number passes unnoticed. That is exactly why the golden-match
> exists. Eval engineering is not optional in a financial system.**

### Small red pill — Type `05`, this week

Type `05` already carries a **small** pill. It is not a planted Java
bug and not a second source lie. It is `rounding-half-up`: assessed
`0.04` on `3.50` under **`HALF_UP`**.

Python's default is `HALF_EVEN`. Ops language says "normal rounding."
An agent or a human that trusts either of those will get a different
cent and still look structurally green. Golden-match against
`expected/` is what names it: `MODERN_DEFECT` if the new plant
rounded the wrong way.

That is the preview. Something you already trusted — the language, the
email, "how we always round" — can be wrong. The contract is right.
Java on this type is specified `HALF_UP`; we do **not** break the
frozen plant to stage this lesson.

### The red pill — Day 5, Type `06`

Days 1–4 prove the **source** can lie (Day 1 sees Type `01` 173.44 vs
173.45; Day 4 is the Type `05` `HALF_UP` pill). Java already refuses
those five `DF-SOURCE-*` batches. The room has seen that movie. The
week notebook ([`brain/notebooklm/`](../brain/notebooklm/README.md))
covers types `01`–`05` only — Type `06` is a new drop, not in the zip.

Day 5 is a different pill. A **new type** arrives — sealed, not in
`spec/` until that Night. Full Converge 0–8 writes under
[`docs/`](../docs/README.md). The factory builds it. Golden-match finds
a one-cent (or one-cent-equivalent) miss where the **legacy plant** —
Java, procedures, or the report — disagrees with the contract and
with an independent computation.

| | Source lie (`01`–`05`) | Type `05` small pill | Day 5 (Type `06`) |
|---|---|---|---|
| Who is wrong | The source declaration | The trusted default (`HALF_EVEN` / "normal") | The **legacy plant** |
| Classification | `CONFIRMED_SOURCE_DEFECT` | `MODERN_DEFECT` if the new plant copies the default | `CONFIRMED_LEGACY_DEFECT` |
| What Java does | Already refuses | Specified `HALF_UP` — do not break it | May accept or report MATCHED |
| Repair | Never | Never. Do not change `expected/` | Never. Do not edit frozen `legacy/` |

The flywheel's job is to **find and classify** that numeric difference,
write the evidence, and stall the type. It does not patch Java, rewrite
a procedure, or "fix" the cent in place. The highlight for the room:
an agent can catch the system you already trusted, not only a dirty
file from upstream.

Type `06` stayed sealed until that day. The miss was authored and
classified on Night 5; the classification above was the contract for
that kit and the entry below is the receipt.

**Flywheel, 2026-08-28 (this checkout).** Queue in, classified evidence
out. Type 06 modern Gold is HALF_UP **1.01** `MATCHED` against the
contract. Legacy applied **1.00** with `rounding_mode=HALF_EVEN` and
reported `MATCHED` against itself. One code:
`CONFIRMED_LEGACY_DEFECT`. Packet:
`evidence/factory/type-06.json`. The type is stalled. The flywheel
must not patch Java, net the two questions, or settle without that
packet.

---

## 8. Mapping to the KurvPay `/tsys:onboard` line

For audiences who see both, the correspondence is close:

| `/tsys:onboard` | Here |
|---|---|
| 1 `scaffold` | Stage 2–3 — worktree + five-layer package |
| 2 `kb-agent` | Stage 0 — the contract, pre-frozen rather than generated |
| 3 `models` | Stage 3 — with a stricter gate (byte-for-byte, not "parses") |
| 4 `tests` | Stage 3 source gate — value agreement rather than a coverage % |
| 5 `preflight` | Stage 3 source gate |
| 6 `lambda` | *No equivalent* — local only, deployment out of scope |
| 7 `lakeflow` | Stage 5 — and we carry Silver/Gold, not Bronze-only |
| 8 `e2e` | Stage 6 — two references instead of one |
| 09 deploy | Stage 7 — the one human gate |

Shared doctrine, arrived at independently:

- *"the golden is evidence, not truth — the raw bytes plus the proc are truth"*
  ↔ the four truth roles
- *"editing the parser until the diff vanishes is the most dangerous move in the
  program"* ↔ **never edit an expected value, fixture, or oracle to turn a gate
  green**

---

## 9. What the factory must never do

These are standing boundaries. They bind every phase, every type, and every
future slice — not just the first one. (Consolidated here from the retired
starting brief.)

**Never touch frozen truth**
- Modify a frozen input — `legacy/`, `contracts/`, `gen/`, `infra/`, applied
  migrations — to make a gate pass.
- Modify source declarations, raw SFTP bytes, legacy Java results, PostgreSQL
  observations, canonical fixtures, or expected outcomes.
- Edit an expected value, fixture, or oracle to turn red into green.

**Never blur the truth roles**
- Keep system of record, source of observation, source of correctness, and
  executable Git contract separate in code *and* in evidence.
- Treat a model's judgment as a proposal, never as correctness evidence.

**Never emit what privacy forbids**
- Emit a restricted value: PAN, CPF, CNPJ, account number, holder name,
  prohibited description, raw row, or unrestricted exception text.

**Never act where it may only observe**
- Quarantine is a legacy runtime action. The detector observes and verifies
  that result; it does not move files or repair data.
- Take no remediation, contract change, external message, or deployment
  without a separately designed approval gate.

**Never weaken the proof**
- Bind every finding to exact batch, type, raw hash, manifest hash, contract
  identity, observation references, and detector version.
- Use a fresh isolated runtime for every authoritative live run; never clean
  state implicitly.
- Claim production or CI readiness from local proof.

---

## 10. The teaching sequence

The order that makes the machine legible to a room:

1. **The legacy works** — and it is the referee, not the teacher.
2. **The problem** — translation can be structurally correct and financially
   wrong. Plausible-but-wrong money is the whole risk.
3. **Types 01–05 end to end** — the machine running, gates visible.
4. **A new request arrives** — spec, sample file, working legacy kit.
5. **Invoke the factory** — one command; hands off the keyboard.
6. **Watch the stages and gates pass** — narrate altitude, not code.
7. **Golden-match against ground truth** — 100%, then the injected cent.
8. **Ship and learn** — PR, evidence, lesson, promoted skill.

The line that carries the whole talk:

> *"Green is not the goal. **Green for the right reason** is."*
