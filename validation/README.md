# The referees

**The two referees.** Neither implementation may mark its own work. This
folder is deliberately outside both `legacy/` and `modern/` —
a referee that lives in a player's folder is not a referee.

```text
validation/
├── oracle/           the legacy referee — one module per type + tests
└── golden-match/     the modern referee — attached for Types 01 and 06 via modern/validation/
```

---

## `oracle/` — the legacy referee

One oracle per type, each independently recomputing what the contract says the
answer should be, then comparing it with what legacy actually produced. They
read `contracts/types/<slug>/main/` — the approved fixtures — and never read the
Java or the loaders.

Each oracle exposes the same three comparisons, which is what
`legacy/runner/workflow_registry.py` calls through its adapters:

| Function | Compares |
|---|---|
| `compare_sanitized_before_posting` | The sanitized CSV, before anything reaches PostgreSQL |
| `compare_post_db_reconciliation` | The reporting reconciliation, after the procedures ran |
| `compare_rejection` | The terminal refusal of a batch that was correctly refused |

Three outcome labels, and the distinction matters:

- `oracle_matched` — compared against an approved expectation and agreed;
- `internally_reconciled_unscored` — internally consistent, but no approved
  artifact exists to score it against;
- `rejected_unscored` — correctly refused, so there is nothing to score.

An oracle never reports "pass" for something it did not actually compare. That
is the whole reason the middle label exists.

### `canonical.py` — 40 lines that set the rule for the folder

```python
def canonical_money(value: object) -> str | None:
    """Return an exact scale-two money lexeme or reject it.

    Oracles compare observations; they must never repair observations by
    rounding, padding, accepting binary floats, or normalizing negative zero.
    """
```

**This is the governing principle of `validation/`.** A referee that quietly
rounds `173.445` to `173.44` has invented a tolerance, and a tolerance is how an
unexplained cent becomes an accepted cent.

---

## `golden-match/` — the modern referee

`golden_match.py` asks two separate questions of every batch, and keeps them
separate all the way into the evidence packet:

1. **Legacy parity** — did modern reach the same observable outcome as legacy?
2. **Business correctness** — did modern satisfy the approved contract?

A source defect makes those answers differ, which is exactly why they are never
netted out. Every difference is classified as one of six:

| Classification | Explained? |
|---|:-:|
| `CONFIRMED_SOURCE_DEFECT` | ✓ |
| `CONFIRMED_LEGACY_DEFECT` | ✓ |
| `APPROVED_BEHAVIOR_CHANGE` | ✓ |
| `MODERN_DEFECT` | — |
| `CONTRACT_AMBIGUITY` | — |
| `UNRESOLVED` | — |

`Comparison.resolved` requires **no unexplained difference and every check
true**. When serving is built, it must refuse to serve an unresolved batch.
The property is load-bearing at the API boundary, not just in a report.

There is no tolerance member anywhere in this module, and adding one would
defeat its purpose.

### Accepted and rejected batches are compared differently

| | Accepted | Rejected |
|---|---|---|
| Record level | modern Parquet vs `expected-*-sanitized.csv` | *nothing — there are no rows* |
| Aggregate | modern Gold vs contract **and** vs `reporting.*` | — |
| Terminal | — | modern status/code vs **`control.batches`** and vs the contract |
| Controls | — | declared vs independently computed |

Inventing empty rows so a rejected batch can be "compared like a successful one"
would hide the difference that matters, so it is not done.

---

## Two referees, one philosophy

Both referees compare. Neither repairs. A rejected batch is compared on
terminal status and code, never on invented empty rows. Money is an
exact scale-two lexeme or it is refused — no padding, no
`ROUND_HALF_EVEN` renderer.

---

## Verification

| Referee | Tests |
|---|---|
| `oracle/` | `validation/oracle/tests/` — one suite per type, run by `make check` |
| `golden-match/` | `tests/modern/test_type01_golden_match.py` — no `make` target runs it; use `modern/.venv/bin/python -m pytest tests/modern` |

`golden-match` is the modern referee. The module was on the tree before the
modern plant so the week had a comparison contract to attach; the plant
built during the week attaches to it through
`modern/validation/attach_type01.py` and `attach_type06.py`, and the
packets land under `evidence/` (Type `06`: `evidence/factory/type-06.json`,
`CONFIRMED_LEGACY_DEFECT`). Types `02`–`05` are not attached yet. See
[`../plans/modern.md`](../plans/modern.md).

## What must not change

- **Referees never repair.** No rounding, padding, coercion, or tolerance — in
  either half of this folder.
- **The two questions stay separate.** Merging legacy parity with business
  correctness makes a source defect indistinguishable from a modern one.
- **A referee never asserts what it did not observe.** If a channel is skipped,
  say so; do not synthesize it and check it against itself.
- **`resolved` keeps requiring both** no unexplained difference *and* all checks
  true. It gates the serving layer.
