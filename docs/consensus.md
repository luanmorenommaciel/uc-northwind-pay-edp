# Consensus — Type 01 ingest → landing

Pass 4. The barrier. Papers live in `docs/`, not `cvg/docs/`.
Keep **173.44**. Do not patch the trailer.

**Signed.** This plan is the right thing to build. The machine may
take Pass 5 (one Type 01 ingest → landing leaf). The eval is the
judge of done. Keep **173.44**.

- Date: 2026-08-25
- Author of ADRs / seams: Grok seat (Night 2 Translator)
- Signed by: **Luan Moreno, Agentic Lead**
- Verdict: **canonical**
- Steel thread: Type 01 ingest → landing (ADR 0001–0005, `docs/seams.md` seam 1)
- Fictional brief owner (Helena Dias, Partner Integration) remains in
  the BRD; this barrier is signed by the Agentic Lead.

## What `cvg` actually ran

Night prompt says `cvg consensus --sign --json`. That verb is **not**
on `cvg` 0.2.0. Pass 4 on the referee is:

- `cvg doctor` — can we dispatch a cross-family adversary?
- `cvg review --adversary codex|kimi` — attack swimlanes
- `cvg review --check` — `CHECK_CONSENSUS`
- `cvg review --resolve … --fix|--accept --owner` — human dispositions

Default `taskspec` on PATH is **3.9.0**. Converge 0.2 requires **3.8.x**.
Without a pin, every `cvg` command dies `ENGINE_UNAVAILABLE`.

With `CVG_TASKSPEC_BIN` → `taskspec` 3.8.0 backup:

| Command | Token | Meaning |
|---|---|---|
| `cvg version` | ok | `cvg 0.2.0 (task-spec 3.8.0)` |
| `cvg doctor` | `DOCTOR=OK` | Codex + Kimi ready (cross-family). Claude present (same family as a typical author; weaker fallback) |
| `cvg doctor host` | `DOCTOR_HOST=OK` | git, bash 4+, python3, shellcheck, sha256 |
| `cvg doctor evidence` | `DOCTOR_EVIDENCE=ERROR` | no `cvg/` workspace; `cvg init` never run |
| `cvg next` | `NEXT_PASS=USAGE_ERROR` | same: no Converge workspace |
| `cvg capture --draft` on BRD | `CHECK_BRD=DRAFT_OK` | structure OK; **sign-off pending** — not canonical |
| `cvg intent --draft` on tech-spec | `CHECK_TECH_SPEC=DRAFT_OK` | structure OK; **sign-off pending** — not canonical |
| `cvg structure --dir docs/adrs` | `CHECK_ADR=FAIL` | missing `0000-context.md`; ADRs lack YAML `status:` frontmatter |
| `cvg review --check` | `CHECK_CONSENSUS=USAGE_ERROR` | no `cvg/swimlanes/<seam>/` tree (`docs/seams.md` is not that layout) |

`CHECK_CONSENSUS` is **not green**. Cross-family dispatch was **not**
run: there is no swimlane tree to attack.

## Contradiction walked (mail vs inbound vs judge vs MATCHED)

- Mail (Marina, 2026-07-14): trailer **173.44**; she will not send a
  corrected file. Ops noun “settlement total.”
- Inbound pack: `df-source-001` declared 173.44, computed 173.45.
- Judge (`contracts/`): `SOURCE_CONTROL_TOTAL_MISMATCH`; DF-SOURCE-001
  field is `net_amount_brl` (layout bytes 16–30).
- Live plant MATCHED is **`valid-minimal`**, net **173.45**, delta
  **0.00** — a different batch. MATCHED does not license rewriting the
  lie.

**Keep 173.44. Refuse. Zero Parquet.** (ADR 0005)

## Objections (default-to-refuted)

Same-family attack on `docs/adrs/` + `docs/seams.md` + tech-spec.
Not a substitute for `cvg review --adversary codex|kimi`.

| ID | Objection | Disposition |
|---|---|---|
| C-1 | Author and reviewer are the same seat. Converge requires a **different family**. | **ACCEPTED** — owner: Luan Moreno. Reason: `DOCTOR=OK` can dispatch Codex/Kimi once a swimlane tree exists; bootcamp paper is `docs/seams.md`, not `cvg/swimlanes/`. Does not block this sign. |
| C-2 | Trailer 173.44 vs rows 173.45 looks like a bug to “fix.” | **FIXED** in ADR 0005 / R-1. Keep 173.44. Finding `SOURCE_CONTROL_TOTAL_MISMATCH`. Zero Parquet. |
| C-3 | Marina “settlement total” vs layout “net amount.” | **ACCEPTED** — owner: Marina Alves. Judge remains `contracts/`. Does not block Type 01 landing. |
| C-4 | `cvg` says Pass 2 must not consume an unsigned tech-spec; we already wrote ADRs. | **ACCEPTED** — owner: Luan Moreno. Night 2 **looks** at Day 1 drafts (docs/README). This sign is the barrier. |
| C-5 | Landing Parquet vs Java CSV — two first writes could be mixed. | **FIXED** in ADR 0001 and seam 1: modern destination is `modern/landing/`, never SFTP `csv/outgoing`. |
| C-6 | Privacy “dies at the parser” but tokens must match the contract fixture, not Java. | **ACCEPTED** — owner: Priya Shah. Judge is `privacy.yaml`. Do not import Java. |
| C-7 | Paid lives on Postgres reporting; ingest→landing does not write it. Downstream might treat staging as paid. | **FIXED** in `docs/CONTEXT.md` and seam 2: paid = `reporting.card_settlement_reconciliation`, grain `batch_id`+`currency`; staging is not paid; dlt does not re-parse. |
| C-8 | Five-file package could smuggle a lakehouse. | **FIXED** in ADR 0006: dlt/DuckDB/dbt/Dagster parked. Seam 1 write surface is the Type 01 package + landing only. |

No objection remains unresolved. None of them is a license to code.

## Open questions (do not block the sign; they block the **machine** gate)

1. Pin `taskspec` 3.8.x for this repo (`CVG_TASKSPEC_BIN` or PATH). Owner: host.
2. `cvg init` so `cvg next` / evidence doctor have a workspace. Papers still live in `docs/`. Owner: host.
3. Optional: project `docs/seams.md` into `cvg/swimlanes/<seam>/` if we want `CHECK_CONSENSUS=OK`. Not required for the bootcamp proof. Owner: Luan Moreno.
4. ADR meta: add `0000-context.md` and YAML `status:` if we want `CHECK_ADR` green. Owner: Translator seat.
5. Frozen-path Bind: `legacy/processor/PWNED.txt` was writable earlier. A polite ADR is not a fence. Owner: host.

## Sign-off

I sign that this plan is the right thing to build, and I hand it to
the machine. I do not sign that the code will be correct — that is
the eval.

| Field | Value |
|---|---|
| Signed by | **Luan Moreno, Agentic Lead** |
| Date | **2026-08-25** |
| Verdict | **canonical** |
| FIXED | C-2, C-5, C-7, C-8 |
| ACCEPTED | C-1, C-3, C-4, C-6 (named owners above) |
| Keep | **173.44** |

Pass 5 may write **one** Type 01 ingest → landing leaf in `docs/tasks/`,
`signed_off` false until that leaf’s own gate. No parser in `modern/`
until that leaf is executed. Do not edit frozen `legacy/`, `contracts/`,
`gen/`, or `infra/`.

## Referee vs this sign

Bootcamp proof (`run/d2/10-consensus.md`): dated signature here
**counts**. The room can point at the sign.

Converge referee `CHECK_CONSENSUS` is still not green (no `cvg/`
workspace, no swimlane tree, ADR meta). That is host/tooling, not a
refusal of this plan. Optional follow-up: pin Task-Spec 3.8.x, `cvg
init`, project seams. Not required to open Pass 5 on this night.

## Status after the sign (not part of the signed text)

- 2026-08-27 (Night 4): `cvg init` ran; `cvg/swimlanes/` holds the three
  lanes; signed copies of the leaves sit in `cvg/tasks/`.
- 2026-08-27: Type 01 landing parser leaf settled (`T-20260825-type-01-landing-parser`).
  Types `02`–`05` ingest packages authored; their leaves remain `signed_off: false`.
- 2026-08-28 (Night 5): Type 06 got its own sign, [`consensus-type-06.md`](consensus-type-06.md).
  This ingest sign was not recut.
