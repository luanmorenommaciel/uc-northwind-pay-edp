# NorthWind Pay DataGen

`gen/` is the standalone Python simulator for the upstream legacy source
system. It generates contract-controlled raw artifacts. It does not publish to
SFTP, call Java, produce sanitized CSV, or connect to PostgreSQL.

## Current scope

DataGen implements all six legacy layouts: five deterministic scenarios per
type on the five-type base, and four for the Night 5 Type `06` kit (which
has no source-control defect scenario — its miss is in the legacy plant,
not the file):

| Type | Layout | Accepted scenarios | Malformed scenario | Source-control defect |
|---|---|---|---|---|
| `01` | Card Settlement Detail | `valid-minimal`, `valid-boundary`, `negative-overpunch` | `INVALID_OVERPUNCH` | `DF-SOURCE-001` → `SOURCE_CONTROL_TOTAL_MISMATCH` |
| `02` | Instant Payment Events | `valid-minimal`, `valid-boundary`, `escaped-content` | `INVALID_FIELD_COUNT` | `DF-SOURCE-002` → `SOURCE_CONTROL_NET_MISMATCH` |
| `03` | Payment Slip Settlement | `valid-minimal`, `valid-boundary`, `multi-lot` | `SEGMENT_PAIR_MISMATCH` | `DF-SOURCE-003` → `SOURCE_CONTROL_NET_MISMATCH` |
| `04` | TED Transfer Settlement | `valid-minimal`, `valid-boundary`, `all-returned-zero-net` | `INVALID_TRANSPORT` | `DF-SOURCE-004` → `SOURCE_CONTROL_NET_MISMATCH` |
| `05` | Merchant Fee Assessment | `valid-minimal`, `valid-boundary`, `rounding-half-up` | `INVALID_CSV_QUOTING` | `DF-SOURCE-005` → `SOURCE_CONTROL_ASSESSED_FEE_MISMATCH` |
| `06` | Merchant Chargeback | `valid-minimal`, `valid-boundary`, `legacy-miss` | `INVALID_CSV_QUOTING` | — (no `DF-SOURCE-006`; `legacy-miss` is a `CONFIRMED_LEGACY_DEFECT` probe) |

SFTP, Java, and PostgreSQL intentionally remain outside `gen/`; the
repository-level runner connects those independent components.

## How it works

One command produces one immutable batch. The modules form a straight line:

```text
cli.py            parse --type / --scenario / --output / --contracts-root
  └─ generation.py       registry dispatch: type number → generator
       ├─ contract_loader.py   read layout / csv / privacy / reconciliation YAML
       ├─ models.py            typed records, exact minor-unit money, errors
       ├─ generators/type_NN_*.py   build this type's raw bytes for a scenario
       ├─ manifest.py          declared controls → source-manifest.json
       ├─ checksum.py          SHA-256 + GNU-compatible sidecar line
       └─ artifacts.py         write private temp dir → atomic rename
```

| Module | Owns |
|---|---|
| `cli.py` | The stable command line; nothing else parses arguments |
| `generation.py` | Type dispatch — the only place a type number selects code |
| `contract_loader.py` | Reading `contracts/types/`; the sole contract reader |
| `models.py` | Typed records, `GenerationError`/`ContractError`, exact money |
| `generators/type_NN_*.py` | One type's byte-level layout and its scenarios |
| `manifest.py` | The source system's **declared** controls |
| `checksum.py` | Digest and sidecar grammar |
| `artifacts.py` | Atomic, private, never-overwrite bundle publication |
| `paths.py` | Repository-root discovery |

DataGen simulates the **source system**, so it declares controls rather than
verifying them. That is why the `DF-SOURCE-*` scenarios can emit a trailer whose
total contradicts its own detail rows: the simulated source genuinely believes
the wrong number, and no downstream component is told a fault was injected.

Modules live flat on `sys.path` under `PYTHONPATH=gen/src` — `models`, `paths`,
`manifest`, and `generation` are top-level names. Keep that in mind before
adding a module here with a common name, and never put `gen/src` on the path
together with another component's source root.

## Run

Requirements:

- Python 3.12 or newer.
- PyYAML 6.x.

For an isolated development environment:

```bash
python3 -m venv gen/.venv
source gen/.venv/bin/activate
python -m pip install -e 'gen[dev]'
```

From the repository root:

```bash
python3 gen/src/cli.py \
  --type 01 \
  --scenario valid-minimal
```

Set `--type` to `01`, `02`, `03`, `04`, `05`, or `06`, and replace
`valid-minimal` with any scenario supported by that type. Scenario names are
case-sensitive.

After editable installation, `datagen` provides the same CLI. Run it inside the
repository, set `NWP_EDP_ROOT`, or pass both `--contracts-root` and `--output`.

The optional `--output` argument selects another output root. The default is
`gen/output/`.

`valid-minimal` is a fixed canonical recipe, so it intentionally has no seed.
A seed will be introduced only when a future scenario genuinely varies its
synthetic values.

## Output

```text
gen/output/B202607230000001/
├── NW_CARD_SETTLEMENT_20260723_B202607230000001.dat
├── NW_CARD_SETTLEMENT_20260723_B202607230000001.dat.sha256
├── source-manifest.json
└── generation-receipt.json
```

Each scenario has a distinct batch ID, so all 29 implemented scenarios may
coexist under the same output root. Re-running a scenario against that root
fails safely rather than overwriting its immutable batch.

Raw `.dat`, `.txt`, `.rem`, and `.csv` files contain restricted synthetic
source values. The other artifacts contain only safe metadata, controls,
filenames, and hashes.

The output directory is written privately in a temporary sibling directory and
atomically renamed into place. An existing batch directory is never
overwritten.

### Output outlives `make clean`

`make clean CONFIRM=clean-runtime` destroys the Docker volumes, `.runtime/`,
and `evidence/` — but **not** `gen/output/`. Combined with the never-overwrite
rule, that has one consequence worth knowing before a demo or a contract
change:

> After editing a contract or a fixture, delete the affected bundle by hand.
> Otherwise the next run silently reuses the previously generated bytes, and
> DataGen reports `Immutable batch output already exists` rather than
> regenerating.

```bash
rm -rf gen/output/B202607230000401     # one batch
rm -rf gen/output                      # all of them
```

Bundles are deterministic, so for an unchanged contract a retained bundle is
byte-identical to a fresh one. The hazard is only after the contract moves.

## Artifact ownership

DataGen creates:

- Raw source file.
- GNU-compatible SHA-256 sidecar.
- Deterministic source manifest.
- Deterministic local generation receipt.

The repository publisher verifies and transports the raw file, checksum, and
source manifest unchanged. It publishes the source manifest last as the SFTP
readiness marker. The generation receipt remains local evidence and is not sent
to SFTP.

The source manifest describes what the simulated source declares. It does not
disclose local scenario or fault labels. The local receipt records both
computed and declared controls, so both Dark Factory scenarios preserve their
BRL 173.45 versus BRL 173.44 contradiction without telling downstream systems
that a test fault was injected.

## Test

From the repository root:

```bash
PYTHONPATH=gen/src \
  python3 -m unittest discover \
    --start-directory gen/tests \
    --pattern 'test_*.py' \
    --verbose
```

Type `06` is covered by `gen/tests/integration/test_type_06_generation.py`
only; it has no `contract/`, `unit/`, or `security/` test module. That is
the kit's known gap, not a claim that those properties were checked.

The contract tests compare hashes, lengths, and the first differing byte offset
without printing raw records or restricted identifiers.

The shared source interfaces are also checked with strict typing:

```bash
PYTHONPATH=gen/src mypy --python-version 3.12 --strict gen/src
```
