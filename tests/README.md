# Verification map

The index of every proof on the **base**. Tests live with the thing
they prove, not only under `tests/`.

| Location | Proves |
|---|---|
| `tests/end-to-end/` | Live SFTP, Java, PostgreSQL, evidence — the five base types (`make test-e2e` refuses `TYPE=06`) |
| `tests/contracts/` | Cross-component contract oracles, one per type |
| `tests/unit/` | Loaders, workflows, worker, recovery, Make facade |
| `tests/postgres/` | Real `COPY`, procedures, rollback |
| `tests/security/` | Adversarial worker and transport probes |
| `legacy/processor/src/test/` | Java parser and privacy, per type |
| `gen/tests/` | DataGen bytes, encoding, privacy, per type |
| `validation/oracle/tests/` | Independent correctness oracles, one suite per type, `01`–`06` |
| `tests/modern/` | Modern emit for Types `01` and `06`, and the Type `01` golden-match — run with `modern/.venv/bin/python -m pytest tests/modern` after `modern/scripts/bootstrap.sh`; **no `make` target** covers them |

Lakehouse (dlt/dbt) proof is the dbt test suite under `modern/dbt/tests/`
and the golden-match packet under `evidence/`, not a pytest file.

## Coverage by type

| Surface | 01 | 02 | 03 | 04 | 05 | 06 |
|---|:-:|:-:|:-:|:-:|:-:|:-:|
| Contract bytes and layout — `gen/tests/contract/` | ✓ | ✓ | ✓ | ✓ | ✓ | — |
| Generator encoding — `gen/tests/unit/` | ✓ | ✓ | ✓ | ✓ | ✓ | — |
| Generator privacy — `gen/tests/security/` | ✓ | ✓ | ✓ | ✓ | ✓ | — |
| Generator integration — `gen/tests/integration/test_type_NN_generation.py` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Java conversion and privacy — `legacy/processor/src/test/` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Cross-component contract — `tests/contracts/` | ✓ | ✓ | ✓ | ✓ | ✓ | — |
| Independent oracle — `validation/oracle/tests/` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Loader boundary — `tests/unit/test_typeNN_loader.py` | ✓ | ✓ | ✓ | ✓ | ✓ | — |
| Typed workflow — `tests/unit/test_typeNN_workflow.py` | ✓ | ✓ | ✓ | ✓ | ✓ | — |
| Transactional rollback — `tests/postgres/` | ✓ | ✓ | ✓ | ✓ | ✓ | — |
| Live acceptance — `tests/end-to-end/run_typeNN_suite.py` | ✓ | ✓ | ✓ | ✓ | ✓ | — |
| Modern emit — `tests/modern/test_typeNN_emit.py` | ✓ | — | — | — | — | ✓ |
| Golden-match — `tests/modern/test_type01_golden_match.py` | ✓ | — | — | — | — | — |

Types `01` and `02` keep bespoke live suites. Types `03`–`05` use
`typed_acceptance.py`. All five base types run under `make test-e2e TYPE=all`.

Type `06` is the Night 5 kit and is thin on purpose: a Java test class
(`Type06ProcessorTest.java`, 73 lines against an 1,125-line processor),
the oracle, the generator integration test, and the modern emit test. It
has no loader/workflow unit tests, no `tests/contracts/` oracle, no
rollback suite, and no live acceptance suite — `make run TYPE=06` works,
`make test-e2e TYPE=06` is refused. Those gaps are the type's open leaves,
not an oversight to paper over.

Type `01` is the exception in names: generic PostgreSQL tables, no
`type01` migration, DataGen `type_01` vs runtime `type01`. That is a
real estate, not two implementations.

## Running them

```bash
make check                  # source, build, Java, and the fast suites
make test-postgres          # rollback-only, against a live database
make test-type01            # the full Type 01 proof on a fresh runtime
make test-e2e TYPE=all      # live acceptance, the five base types (01–05)
make test-worker-e2e        # the autonomous worker on a clean runtime
make test                   # check + test-postgres + worker acceptance
```

Live suites do not erase runtime state. Canonical batch IDs are
immutable. Clean or isolate before repeating a live suite:
`make clean CONFIRM=clean-runtime`, then `make deploy`.

## What must not change

- **A gate that cannot fail is worse than no gate.** Prove it red
  before accepting it green.
- **Fixture names.** They are resolved by path across four languages.
