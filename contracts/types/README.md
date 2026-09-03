# Type contracts — anatomy, conventions, and how to add one

This folder is the **source of correctness** for the base. DataGen, Java,
PostgreSQL, and the independent oracles all read from here; none of them may
define correctness themselves. When two implementations disagree, this folder
decides which one is wrong.

The base is the **five** types `01`–`05`, which the week works Nights 1–4.
Type `06` is the sixth registry entry: it arrived on Night 5 (2026-08-28)
as the factory's unseen kit, not as an empty folder, and is not part of
the base sign-off in [`../README.md`](../README.md).

The cross-type transport envelopes live one level up in
[`../common/`](../common/README.md). This document covers the per-type
contracts.

---

## The registry

[`registry.yaml`](registry.yaml) is the index. One entry per approved type:
number, status, folder, slug, business name, `file_type_code`, extension,
layout style, purpose, and what the type is meant to exercise.

A type that is not in the registry does not exist. Nothing dispatches on a file
extension — `.dat` is used by Types `01` and `04`, `.csv` by Types `05` and
`06`, and `.csv` by every sanitized output in the system.

---

## Anatomy of a type — four files, four questions

Every type folder answers exactly four questions, one file each. Keeping them
separate is deliberate: it is what lets a reviewer check money rules without
reading transport rules, and privacy rules without reading either.

| File | The question it answers | What lives there |
|---|---|---|
| `layout.yaml` | **How do I read the bytes?** | Encoding, line endings, record grammar, field positions, money encoding, cross-record rules, `canonical_rejection_codes` |
| `csv.yaml` | **What do I emit?** | The sanitized column list, types, patterns, database target, natural key |
| `privacy.yaml` | **What must never leave?** | Restricted fields, their approved transformation, prohibited destinations, whole-output scan rule |
| `reconciliation.yaml` | **How do I know it added up?** | Control definitions, procedure order, report relation and columns, tolerances, success criteria |

Plus `README.md` — prose for a human: why this layout exists, what it exercises
that the other types do not, and its processing route.

### Two rules that are easy to miss

- **`canonical_rejection_codes` in `layout.yaml` is binding on every
  implementation.** An independent parser still owes the contract's stable code
  vocabulary. Inventing your own turns every rejection into a spurious
  golden-match difference.
- **`tolerances` are all zero, everywhere.** There is no configurable slack on
  a financial comparison, and none should ever be added. A tolerance is how an
  unexplained cent becomes an accepted cent.

---

## `main/` — the fixtures, which *are* the oracle

Each type's `main/` folder holds one input file per scenario plus the approved
outputs for that scenario. These files are what "correct" means in practice.

### The naming convention

```
<scenario>.<ext>                                  the input
expected-<scenario>-sanitized.csv                 approved rows      (accepted)
expected-<scenario>-reconciliation.yaml           approved totals    (accepted)
expected-malformed-rejection.yaml                 approved refusal   (rejected)
expected-df-source-00N-finding.yaml               approved refusal   (rejected)
```

**The default scenario is anonymous.** `valid-minimal` is the baseline, and its
two expected artifacts drop the scenario name:

| Scenario | Input | Expected outputs |
|---|---|---|
| `valid-minimal` | `valid-minimal.csv` | `expected-sanitized.csv`, `expected-reconciliation.yaml` |
| `valid-boundary` | `valid-boundary.csv` | `expected-valid-boundary-sanitized.csv`, `expected-valid-boundary-reconciliation.yaml` |

Type `06` is the exception in *location*: its `main/` holds only the
expected outputs (`expected-reconciliation.yaml`,
`expected-valid-boundary-reconciliation.yaml`,
`expected-legacy-miss-reconciliation.yaml`, `expected-malformed-rejection.yaml`);
the inputs and their `.sha256` sidecars live in
[`../../spec/type-06-merchant-chargeback/samples/`](../../spec/type-06-merchant-chargeback/samples/),
because the kit docked through `spec/`. There is no `expected-sanitized.csv`
for Type `06`; the reconciliation file is its oracle.

Reading the folder alone will not tell you that. It is recorded here because
the names are load-bearing — Java resolves fixtures by path through
`-Dcontract.fixture.root`, and DataGen, the oracles, the modern pipeline, and
the acceptance suites all key off the same strings. **Do not rename them.**

### The scenario vocabulary

Every type carries the same four roles, plus one edge case of its own:

| Scenario | Role |
|---|---|
| `valid-minimal` | The baseline happy path — the smallest complete batch |
| `valid-boundary` | Extreme but legal values: maximum amounts, leap-year dates |
| `malformed` | A transport or grammar violation — must be **refused** |
| `DF-SOURCE-00N` | The **injected source defect** — one cent, refused, attributed (`01`–`05` only; there is no `DF-SOURCE-006`) |
| *(type-specific)* | `negative-overpunch` `01` · `escaped-content` `02` · `multi-lot` `03` · `all-returned-zero-net` `04` · `rounding-half-up` `05` · `legacy-miss` `06` |

The `DF-SOURCE-*` batch is the most important fixture in the repository. The
source declares a total its own detail rows contradict. Both implementations
must independently compute the true value, **refuse the batch**, preserve the
wrong declaration exactly as published, and let unrelated batches continue.

Type `06` inverts the roles. Its `legacy-miss` batch carries **no** source
lie: the source is right and the contract says `1.01`; it is the live Java
plant that rounds the cent differently. The honest classification is
`CONFIRMED_LEGACY_DEFECT`, and frozen `legacy/` is not patched to go green.

---

## Who reads what

The **base** consumers are the first four rows. Modern (`modern/`) reads
the same files for Types `01` and `06` today; it is not required for a
batch to be correct.

| Consumer | When | Reads | Never reads |
|---|---|---|---|
| DataGen (`gen/`) | Base | `layout.yaml`, `main/` inputs | Expected outputs |
| Legacy Java | Base | `layout.yaml`, `privacy.yaml`, `main/` fixtures | Modern anything |
| Legacy PostgreSQL | Base | `reconciliation.yaml` | — |
| Oracles (`validation/oracle/`) | Base | `main/` expected outputs | Implementation code |
| Modern (`modern/`) | Nights 2–5 | All four YAMLs, `main/` inputs and expected outputs | **Java, legacy CSV, legacy PostgreSQL** |

The bold exclusion is the one that matters. The modern plant reads the
*contract*, never the Java. Reading the Java would be copying
the answer and calling it a proof — and any defect in the old implementation
would be reproduced faithfully and then declared "parity".

---

## Adding a new type

1. **Reserve the identity** — add a `registry.yaml` entry with number, slug,
   `file_type_code`, extension, and what the type is meant to exercise. Pick a
   layout style that stresses something the existing six do not.
2. **Write the four YAMLs** — layout, csv, privacy, reconciliation. Give the
   type its own `canonical_rejection_codes`.
3. **Write `README.md`** — why this layout exists, detection and transport, the
   processing route.
4. **Author `main/`** — the five scenario inputs and every approved output.
   *This is the oracle; without it nothing downstream can be adjudicated.*
5. **Extend `../common/` semantic notes** if the type needs a cross-field rule
   JSON Schema cannot express.

Only then may an implementation be built. The rule the whole system rests on:

> **No oracle, no build.** A spec that does not carry its expected outputs
> cannot be adjudicated, so the factory refuses it before doing any work.

---

## What must never change

- An expected value, fixture, or oracle — **never** edited to turn a red gate
  green. Green must come from the referee.
- A fixture filename — the names are resolved by path across four languages.
- A tolerance — they are zero and stay zero.
- A `canonical_rejection_code` already in use — the vocabulary is append-only.

Contract changes are versioned through `contract_version` and `layout_version`,
never by editing an approved artifact in place.
