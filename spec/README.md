# Spec — inbound customer drop

This folder is how the **customer arrives**. Until the document factory
exists, we mimic a real engagement drop: Share Folder, not a repo tour.

The picture is KurvPay EDP, distilled. There a type did not arrive as
four YAMLs. It arrived as a vendor PDF, a SQL Server table dump, two
dates of an insert proc, a sample that did not quite match the proc,
and a meeting note that contradicted all three. The work was
**unpack, question, decide, then translate**.

The week works Types `01`–`05`. Those packs are written **in advance**
so day one is a customer drop, not a hunt through `contracts/`. Type
`01` is the steel thread on Day 1. Types `02`–`05` stay in the drop so
later nights can ask them. Type `06` is authored here as
`type-06-merchant-chargeback/` and is dropped on day five as the
factory's unseen kit — the flywheel — and the **red pill**: the agent
may find a numeric difference that is wrong in the **legacy plant**,
not only in the source file. Classify it. Do not patch `legacy/` to
make it green.

Day 1 feeds **inbound prose** from this folder into the Second Brain
([`brain/notebooklm/`](../brain/notebooklm/README.md) — nine packs).
Mail, meetings, policies, layouts, procs. Raw `samples/` and
`expected/` stay on disk — NotebookLM cannot read signed overpunch.
`cover.md` is mail. It is not `contracts/`.

> **No oracle, no build.** A pack that cannot be adjudicated is refused
> before any modern code exists.

## The experience this drop is for

The week is not "open `contracts/` and write a parser." The week is:

1. Receive a messy customer bundle (this folder).
2. **Day 1** — feed inbound to the Second Brain, ask OntoLayer, run
   Converge **0 Capture** and **1 Intent**. No parser. No `modern/`.
3. Hold the meetings the documents imply. Find what is true, what is
   stale, and who lied.
4. **Day 2** — Bind, Structure (ADRs), Decompose (Seamwise), Consensus,
   one Task-Spec leaf. First write is landing Parquet **when the mesh
   later runs**.
5. Days 3–4 build the vertical. Day 5 is a **new** pack (`06`), not this
   zip.

Data analysts, software engineers, and platform people are in the same
room. The drop has to give each of them something to do: a layout to
read, a control to recompute, a contradiction to escalate, a privacy
rule to enforce.

Daily briefs live in [`agenda/`](../agenda/README.md). Staff clock is
[`run/d1/`](../run/d1/README.md). This page is the **inbound**, not the
timetable. The type split is closed: `01`–`05` all week, `06` only when
the factory runs.

## Two layers, like Kurv

Kurv had `notes/` (the engagement) and `specs/{type}/` (each file).
We keep that split.

```text
spec/
├── README.md                 this contract
├── estate/                   one drop for the whole customer
│   ├── cover.md              who they are, what they want, what done means
│   ├── meetings/             kick-off, tech syncs, async handoffs
│   ├── mail/                 threads that "just forward the folder"
│   └── policies/             privacy, rounding, "do not fix the source"
└── type-NN-<slug>/           one inbound pack per file type
    ├── inbound/              what they mailed — messy on purpose
    ├── samples/              raw bytes + checksums
    └── expected/             the oracle (sanitized, recon, refusals)
```

`estate/` is shared. A type pack never repeats the kick-off.

## What `estate/` contains

Fictional NorthWind Pay / partner voices. Not Kurv names, not TSYS
layouts, not real PCI.

| Artifact | Job in the room |
|---|---|
| Kick-off note | Scope, stack, who owns SFTP, who owns privacy |
| File-decomposition sync | "Java stays. You rebuild beside it." |
| Async handoff | "Folder is in the share. Walk through next week." |
| One angry / tired thread | A control that has been wrong for months |
| Privacy policy | What must never leave, in customer language |
| Rounding note | `HALF_UP` stated in one place, implied elsewhere |

Every note follows a short template (attendees, decisions, actions,
open questions, implicit signals). That is how Kurv notes were
usable a month later.

## What each type pack contains

Mirror a Kurv `specs/{type}/` drop. Filenames may look like a customer
exported them, not like we designed a repo.

| They mail | Looks like | Why it is there |
|---|---|---|
| Vendor-ish layout | PDF or long markdown, field positions, "see page 14" | Translation starts here |
| Table definitions | `.txt` / `.sql` dump | Analysts and warehouse people land here first |
| Insert / apply proc | One or two dated copies | The legacy "how we post" — not Java, not to be ported |
| Email / Slack export | A walk-through, an argument about a noun | The week has something to unpack |
| Meeting excerpt | Type-specific walk-through | Open questions with owners |
| Raw samples | Happy, boundary, type edge, malformed, source lie | Real bytes |
| Expected sanitized + recon | For accepted samples | The oracle |
| Expected refusals | Malformed + source lie, stable code | The other half of the oracle |

They never mail the modern parser. If they did, the referee would
score a copy.

The five scenario **roles** stay. Customer names may differ. We map;
we do not drop a role.

## How the week uses the methods

The drop is the input to the method stack. It is not a substitute
for it.

| Method | What it does with the drop |
|---|---|
| **Second Brain** | Day 1 compiles inbound (not samples) into NotebookLM. Days 2–4 query it. Type `06` is deliberately not in the zip — `build.sh` packs `01`–`05` only |
| **Brief-Spec** | Each day has a type: unpack is exploration, a contradiction is review, a parser is implementation |
| **Converge** | **Day 1:** Pass 0–1 compile the folder into a BRD / tech-spec. **Day 2:** Pass 2 writes ADRs; Pass 4 attacks contradictions **before** code |
| **Seamwise** | Attaches at Pass 3 (Day 2). Seams from the drop: raw → sanitize → stage → apply → report. One owner per handoff |
| **Task-Spec** | Only after Consensus (Day 2, Pass 5). Each leaf has evals against `expected/`. No eval, no task |
| **Dark Factory** | [`plans/dark-factory.md`](../plans/dark-factory.md) — Type `06` docked here on Night 5 as a new drop; the factory ran it and stalled `CONFIRMED_LEGACY_DEFECT` |

The room should spend real time in "meetings" that the notes set up:
walk the unused columns, pick a vocabulary, refuse a sample that has
no oracle. That is the ultimate experience — not slides about it.

## This folder vs the brain vs `contracts/`

| | `spec/` | Second Brain | `contracts/types/` |
|---|---|---|---|
| Role | How the request **arrives** (messy) | Queryable memory of inbound prose | Source of correctness once **installed** (clean) |
| What goes in | estate + per-type inbound, samples, expected | Nine packs from estate + inbound. **No** `.dat`, **no** `expected/`, **no** Type `06` | Signed layouts and oracles |
| Audience | The week, the factory | Humans, all week | DataGen, Java, oracles |
| Contradictions | Allowed in inbound prose | Cite the page, or abstain | **Never.** Contracts stay executable truth |

`cover.md` is inbound. Do not treat it as the judge.

The factory reads the pack as if the customer sent it. After
understanding, the signed contract in `contracts/` is still what
Java and the oracles obey. We do not "fix" `contracts/` because a
meeting used the wrong noun.

## On this tree today

| Piece | Status |
|---|---|
| This page | The drop contract. Nights 1–4 = Types `01`–`05`. Night 5 = Type `06`. |
| Second Brain | Compiled from this folder: [`brain/notebooklm/`](../brain/notebooklm/README.md). Nine packs. |
| [`estate/`](estate/README.md) | Compiled. Cover, five meetings, two mails, two policies. |
| [`type-01-…`](type-01-card-settlement/README.md) | Compiled. inbound / samples / expected |
| [`type-02-…`](type-02-instant-payment-events/README.md) | Compiled |
| [`type-03-…`](type-03-payment-slip-settlement/README.md) | Compiled |
| [`type-04-…`](type-04-ted-transfer-settlement/README.md) | Compiled |
| [`type-05-…`](type-05-merchant-fee-assessment/README.md) | Compiled. Same shape as the others. |
| [`type-06-…`](type-06-merchant-chargeback/README.md) | **Docked Night 5 (2026-08-28).** inbound / samples (+ `.sha256`) / expected. Was sealed until then; still absent from the brain zip. |

## Gate before a pack is written

A type pack is ready only when:

1. Accepted samples have expected sanitized rows **and** recon.
2. Malformed and the source lie have expected refusals and a stable code.
3. Privacy is stated in customer language **and** matches `contracts/`
   once installed.
4. Tolerances are zero in the oracle half.
5. Nothing requires editing `legacy/`, `gen/`, or `infra/` to become true.

Fail any one and we do not write that type.

## What is written in advance

1. `estate/` — cover, five notes, two mails, two policies.
2. Types `01`–`05` — inbound / samples / expected. Five equal drops.
3. Type `06` — written and docked on Night 5 (2026-08-28). It was sealed
   until then; it is the drop a fresh Night 5 rediscovers, so keep it out
   of the Day 1 brain.

The room starts on a drop, not on a pointer. Rebuild the brain whenever
inbound changes: `bash brain/notebooklm/build.sh`. The factory learns on
a type it has not already unpacked (`06` on Friday).
