# Consensus — Type 01 dlt → Gold (lakehouse)

Pass 4 addendum. **Does not overwrite** [`docs/consensus.md`](consensus.md)
(ingest → landing stays canonical). Papers live in `docs/`, not
`cvg/docs/`. Keep **173.44**. Do not patch the trailer.

**Signed.** This lakehouse plan is the right thing to build. The
machine may take Pass 5 (Type 01 remainder + lakehouse leaves). The
eval is the judge of done. Keep **173.44**.

- Date: 2026-08-26
- Author of ADRs 0007–0011 / seam 2 legs: Grok seat (Night 3 Constructor)
- Signed by: **Luan Moreno, Agentic Lead**
- Verdict: **canonical** (lakehouse facts only)
- Steel thread: Type 01 dlt → Gold (ADR 0007–0011, `docs/seams.md` seam 2)
- Fictional brief owner (Helena Dias, Partner Integration) remains in
  the BRD; this barrier is signed by the Agentic Lead.

Ingest sign (`docs/consensus.md`, 2026-08-25) is **unchanged**.

## What `cvg` actually ran

Night prompt says `cvg consensus --sign --json`. Night 2 already
recorded: default `taskspec` on PATH is **3.9.0**; Converge 0.2
requires **3.8.x**; without a pin every `cvg` command dies
`ENGINE_UNAVAILABLE`. There is still no `cvg/` workspace (`cvg init`
is Thursday / host).

A dated signature in this file **counts** (`run/d3/08-consensus.md`).
Do not debug the CLI in front of the room.

## Contradiction walked (dlt-as-parser vs register-only; Gold vs Postgres)

- Mail (2026-06-09): parser → sanitized Parquet → Bronze / Silver /
  Gold. Nouns, not a grain.
- ADR 0006 parked dlt / DuckLake / grains / rule split / match keys.
- Wrong Constructor move A: dlt re-parses `.dat` or HMAC-tokenizes.
  That recuts seam 1.
- Wrong Constructor move B: dbt reads `reporting.card_settlement_reconciliation`
  to compute Gold. That copies the first plant.
- Right move: dlt registers landing (ADR 0007). DuckDB is local
  (ADR 0008). Gold grain equals paid grain and is computed from
  landing (ADR 0009). Parser already owns privacy + Decimal
  (ADR 0010). Referee is attached, not rewritten (ADR 0011).

**Keep 173.44. Refuse. Zero Parquet. No Gold on the lie.** (ADR 0005
still binds.)

## Objections (default-to-refuted)

Same-family attack on ADRs 0007–0011 + seam 2. Not a substitute for
`cvg review --adversary`.

| ID | Objection | Disposition |
|---|---|---|
| L-1 | Author and reviewer are the same seat. Converge wants a different family. | **ACCEPTED** — owner: Luan Moreno. Reason: same Night 2 exception; no `cvg/` workspace. Does not block this sign. Cross-family review is Thursday host work. |
| L-2 | dlt could parse raw and “help” Gold. | **FIXED** in ADR 0007 / seam 2 leg 1. Register landing only. |
| L-3 | Gold could copy Postgres paid to go green. | **FIXED** in ADR 0008 and 0009. Postgres is observation. Gold rebuilds from landing. |
| L-4 | Trailer 173.44 vs rows 173.45 looks like a Gold repair. | **FIXED** in ADR 0005 (still) and 0011. Keep 173.44. `CONFIRMED_SOURCE_DEFECT`. No Gold. |
| L-5 | Bronze / Silver / Gold might be new estates. | **FIXED** in `docs/seams.md`. They are **legs** on seam 2. |
| L-6 | dbt should retokenize so privacy is “defense in depth.” | **FIXED** in ADR 0010. dbt may **assert** no clear PAN; it must not tokenize. |
| L-7 | Rewrite `golden_match.py` with a one-cent tolerance. | **FIXED** in ADR 0011. Referee is the base. |
| L-8 | Stand up Dagster / FastAPI / Types `02`–`05` tonight. | **ACCEPTED** — owner: Helena Dias. Parked ADR 0006 rows 8–9 and Types `02`–`05`. Thursday. |
| L-9 | `cvg` ENGINE_UNAVAILABLE / no swimlane tree. | **ACCEPTED** — owner: host. Dated signature here is the bootcamp proof. |

No objection remains unresolved. None of them is a license to recut
ingest Consensus.

## Open questions (do not block this sign; they block Thursday’s machine)

1. Pin `taskspec` 3.8.x / `cvg init`. Owner: host.
2. Dagster as lineage (Milestone 4). Parsing does not move into the
   orchestrator. Owner: Orchestrator, Day 4.
3. Remaining SWE + DE leaves for Types `02`–`04` and Type `05`. Owner:
   Thursday generate.

## Sign-off

I sign that this **lakehouse** plan is the right thing to build, and I
hand it to the machine. I do not sign that the code will be correct —
that is the eval. I do not recut Tuesday’s ingest sign.

| Field | Value |
|---|---|
| Signed by | **Luan Moreno, Agentic Lead** |
| Date | **2026-08-26** |
| Verdict | **canonical** (lakehouse) |
| FIXED | L-2, L-3, L-4, L-5, L-6, L-7 |
| ACCEPTED | L-1, L-8, L-9 |
| Keep | **173.44** |
| Ingest sign | unchanged (`docs/consensus.md`) |

Pass 5 may write Type 01 remainder + lakehouse leaves in `docs/tasks/`,
`signed_off` false until Execute Gold. Do not edit frozen `legacy/`,
`contracts/`, `gen/`, or `infra/`. Do not author Types `02`–`05`. Do
not author Dagster.

## Status after the sign (not part of the signed text)

- 2026-08-26/27: Type 01 dlt → Bronze → Silver → Gold → golden-match
  authored and run; `modern/dbt/` and `modern/lakehouse/dlt/` exist.
- 2026-08-27 (Night 4): Dagster lineage authored as
  `modern/orchestration/definitions.py` (ADR 0012), seam 3 unparked.
  `02`–`05` lakehouse leaves written in `docs/tasks/`, no code, unsigned.
- 2026-08-28 (Night 5): Type 06 rode the same legs and stalled at
  golden-match — `CONFIRMED_LEGACY_DEFECT` ([`consensus-type-06.md`](consensus-type-06.md)).
  This sign was not recut.
