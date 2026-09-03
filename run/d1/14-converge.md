# 14 · Converge — name it, then install

- Slide: DIG · Show · Converge · the spine, then Hands-On Execute 14–16
- Slice: **F · Spine**
- Who: every seat, through **their** agent, then you drive the install
- Next: [`15-capture.md`](15-capture.md)

Blank slate. They have never used these kits. **Ask first. Install second.** Tonight is Pass **0** and Pass **1** only.

`cvg` **adjudicates**. It does not interview the owner and it does not write the tech-spec. The agent drafts; the CLI gates.

---

## Prompt (verbatim) — what the kits are

```text
You are sitting Day 1 of NorthWind Pay. You have not written product code.
Read README.md and docs/README.md. You may also read ebooks/brf-converge.md if it is on disk.

Answer, in this order, from the repo — not from memory:

1. What is Converge? What does the cvg CLI do, and what must the agent still do?
2. What is Task-Spec? When does it attach (which pass)?
3. What is Seamwise? When does it attach (which pass)?
4. What is Brief-Spec for?
5. What do we run tonight (Pass 0 and Pass 1), and what do we not run (Pass 2–8)?
6. How do you Capture a BRD tonight — who drafts, who gates, which folder is inbound vs judge?
7. How do you write Intent tonight — what must the tech-spec answer, and what must it not pick?

Do not change any file.
Do not write modern/.
Do not run Pass 2–8.
Do not ask OntoLayer these questions. The graph is Postgres, not the spine.
```

### Proof

| Ask | A healthy answer |
|---|---|
| Converge | The spine. Nine passes. Coordinates. Never writes product code. `cvg` gates artifacts. |
| Task-Spec | The leaves. One leaf, one eval. Attaches at **Tasking (Pass 5)**. Not tonight. |
| Seamwise | The lanes. Seam → swimlane → leg. Attaches at **Decompose (Pass 3)**. Not tonight. |
| Brief-Spec | The reading interface. Names the hour (explore, decide, implement, review). |
| Tonight | **0 Capture** (BRD from the brain) and **1 Intent** (tech-spec, no stack). Stop. |
| How Capture | Agent drafts from Second Brain + `spec/` into `docs/brd-…`. `cvg capture --draft` gates. `spec/` is inbound. `contracts/` is the judge. |
| How Intent | Agent drafts `docs/tech-spec-…` that answers the brief. `cvg intent --draft` gates. No lakehouse. No ADRs. |

If they invent “Converge writes Java” or “Task-Spec is tonight” — correct from the table. Do not debug the model.

---

## Then install

Install from [luanmorenommaciel/converge](https://github.com/luanmorenommaciel/converge) so `cvg` is on the path. BYO if they already have it.

```bash
cvg version
cvg agent-context --json | head
```

### Proof

`cvg version` prints. The command tree includes `capture` and `intent`.

## If fail

Follow your screen. Do not stall 80 people on a plugin or an engine-version mismatch. They can still **write** the BRD and the tech-spec by hand; the gate waits. Do not start Pass 2.
