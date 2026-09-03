---
id: T-20260827-orchestrate-type-01
title: Dagster lineage on closed Type 01 — parsing does not move into the orchestrator
status: ready
format_version: 3
profile: standard
effort: S
budget_iterations: 10
agent: any
parent: docs/seams.md
depends_on:
  - T-20260826-type-01-golden-match
supersedes: (none)
touches_paths: []
creates_paths:
  - modern/orchestration/definitions.py
source_note: "ADR 0012 unparks 0006 row 8; seams.md seam 3; skip Gold hash if Dagster is not up"
created: 2026-08-27T12:00:00Z
tags: [orchestrate, dagster, type-01, lineage]
owner: Luan Moreno
priority: P1
severity: financial-critical
due_date: (none)
precondition: "Type 01 Gold closed; ADR 0012 accepted; do not stand up Dagster to look busy"
blocked_reason: (none)
security_class: restricted_synthetic_pii
source_action_item: (none)
tracker_ref: (none)
execution_backend: any
signed_off: false
signed_off_by: (none)
signed_off_at: (none)
accepted: false
accepted_by: (none)
accepted_at: (none)
evidence_refs: []
---

# Dagster lineage on closed Type 01 — parsing does not move into the orchestrator

> **Why:** Seam 3 is lineage and serve, not a second parser. Type 01
> Gold already exists. Skip the hash compare if Dagster is not up.

## Goal

Declare Dagster assets that replay closed Type 01 emit → register →
Bronze → Silver → Gold → golden-match from immutable landing. Parsing
does not move into the orchestrator. Do not write frozen trees. Do not
create an empty orchestrate package to look busy. `signed_off` starts
false.

## Behavior

- **B-1** — Dagster is lineage (ADR 0012). It may partition by
  `batch_id`, retry, and backfill from `modern/landing/`.
- **B-2** — It must not read raw `.dat`, tokenize, decode overpunch,
  or own money.
- **B-3** — If Dagster is not installed / not up, skip the Gold-hash
  compare and pass. Do not stand up Dagster to look busy.
- **B-4** — If Dagster is up, replayed Gold for `B202607230000001`
  matches the existing Type 01 packet (applied_net `173.45`,
  `MATCHED`). Lie batch stays absent.

## Success Criteria

```bash
ROOT="$(git rev-parse --show-toplevel)"
SPEC="$ROOT/docs/tasks/T-20260827-orchestrate-type-01.md"
ADR="$ROOT/docs/adrs/0012-dagster-is-lineage-not-parser.md"
DEFS="$ROOT/modern/orchestration/definitions.py"
PACKET="$ROOT/evidence/modern/B202607230000001/golden-match.json"

eval_1() {
  grep -q 'lineage' "$SPEC" || return 1
  grep -q 'not a parser' "$ADR" || grep -q 'not a parser' "$SPEC" || return 1
  grep -q 'skip' "$SPEC" || return 1
  grep -q 'signed_off: false' "$SPEC" || return 1
  grep -q 'Parsing does not move into the orchestrator' "$ADR" || return 1
  awk '
    BEGIN { sec="" }
    /^---$/ { n++; next }
    n==1 && $0 ~ /^(touches_paths|creates_paths):/ { sec=$1; next }
    n==1 && sec != "" && $0 ~ /^[^[:space:]-]/ { sec="" }
    n==1 && sec != "" && $0 ~ /^[[:space:]]*-[[:space:]]*(legacy|contracts|gen|infra)\// { bad=1 }
    END { exit bad ? 1 : 0 }
  ' "$SPEC" || return 1
}

eval_2() {
  if [[ ! -f "$DEFS" ]]; then
    grep -q 'signed_off: false' "$SPEC" || return 1
    grep -q 'Skip the Gold-hash' "$SPEC" || grep -q 'skip the Gold-hash' "$SPEC" || return 1
    python3 -c 'import dagster' 2>/dev/null && {
      # Dagster library present but no definitions — still skip hash; do not fail unsigned
      return 0
    }
    return 0
  fi
  grep -q 'landing' "$DEFS" || return 1
  ! grep -qE '\\.dat|decode_overpunch|tokenize' "$DEFS" || return 1
  test -f "$PACKET" || return 1
}
```

## Validation Card

```yaml
success_criteria:
  - id: eval_1
    description: ADR 0012 lineage-not-parser; freeze fence; unsigned
    runnable: bash
    check_type: deterministic
    verifies: [B-1, B-2]
    terminal: true
    expected_duration_sec: 5
  - id: eval_2
    description: Skip Gold hash if Dagster is not up; definitions must not parse raw
    runnable: bash
    check_type: deterministic
    verifies: [B-2, B-3, B-4]
    terminal: true
    expected_duration_sec: 5
```

## Exit Check

```bash
eval_1 && eval_2
```

## Anti-Patterns

- **Don't parse Type 01 in Dagster.** Translator owns grammar.
- **Don't stand up Dagster to look busy.** Skip the hash.
- **Don't serve unresolved Gold** (ADR 0013). That is not this leaf's write.

## Do-Not-Touch

- `legacy/`
- `contracts/`
- `gen/`
- `infra/`
- `validation/golden-match/golden_match.py`
- `modern/ingestion/src/northwind_pay/types/01-card-settlement/parser.py`
