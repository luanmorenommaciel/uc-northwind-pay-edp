# Typed Legacy Processor (Java)

This Java 21 service is the raw-to-sanitized trust boundary. It downloads an
integrity-checked source bundle, dispatches by the manifest's exact type
identity, validates the selected contract, and publishes a canonical CSV,
checksum, and sanitized manifest. The sanitized manifest is renamed last, so
downstream consumers never treat a partial bundle as ready.

## Registered processors

| Type | Source contract | Sanitization |
|---|---|---|
| `01` | Card settlement | PAN tokenization and masking |
| `02` | Instant-payment events | Independently keyed document tokens |
| `03` | Payment-slip settlement | Separate payment-reference, party, and account HMAC domains |
| `04` | TED transfer settlement | Dedicated payer/beneficiary account HMAC domain and tax-ID masking |
| `05` | Merchant fee assessment | CNPJ masking, safe Unicode description passthrough, and exact `HALF_UP` fee calculation |
| `06` | Merchant chargeback (Night 5 kit) | CNPJ masking, whole-output CNPJ scan, and a **planted `HALF_EVEN`** chargeback rounding where the contract says `HALF_UP` — the `CONFIRMED_LEGACY_DEFECT` the factory catches. Frozen; do not fix |

The file extension never selects a parser. `ProcessorDispatcher` requires the
manifest number, code, contract version, and layout version to agree with one
registered processor. An optional `--type` argument is an assertion, not an
override.

The shared command-line launcher is
`com.northwindpay.legacy.core.ProcessorMain`; it registers all six processors
and therefore does not belong to any individual type package. The executable
JAR keeps the existing `--batch-id` and optional `--type` interface.

## Evidence projection

Java returns only the fields needed by the selected result contract, and the
Python workflow applies a second explicit adapter allowlist before evidence or
terminal-recovery journaling. “Privacy-safe” does not mean “aggregate-only” for
every type: Type `01` may retain its contract-approved safe transaction
reference and derived amount/count context. PAN, CPF, raw rows, and
unallowlisted fields remain forbidden. Types `02`–`06` retain their documented
aggregate-only rejection projections.

## Type 03 validation boundary

`Type03Processor` applies the approved order to the whole batch:

1. Source size and strict US-ASCII.
2. CRLF framing, final CRLF, blank-line rejection, and 240-byte records.
3. `H (L (A B)+ T)+ Z` grammar.
4. Static literals, strict dates, and reserved filler.
5. Lexical and exact numeric rules.
6. CPF/CNPJ check digits.
7. Safe identifiers, segment pairing, uniqueness, and business dates.
8. Lot controls, file counts, face/discount/fee controls, then file net.
9. Canonical CSV rendering and a whole-output restricted-value scan.
10. CSV/checksum publication followed by the readiness manifest.

All monetary values use `BigDecimal`; binary floating point is absent. A failed
stage returns only a stable code, physical record number when permitted, and
aggregate controls. Raw records, names, documents, accounts, masks, and tokens
cannot be attached to Type 03 result evidence.

## Type 04 validation boundary

`Type04Processor` validates the heterogeneous TED layout as a sequence of
global phases:

1. Source size and strict US-ASCII.
2. Exact CRLF framing, final CRLF, and blank-line rejection.
3. Discriminator and exact variant lengths (`H=56`, `D=162`, `R=91`,
   `T=82` bytes).
4. Conditional `H (D | D R)+ T` grammar selected by each transfer status.
5. Strict dates, local times, literals, and visible right-tilde padding.
6. Lexical and exact numeric rules, followed by CPF/CNPJ check digits.
7. Safe identifiers and text, return linkage, movement uniqueness, and
   timestamp ordering.
8. Transfer/return counts, gross, returned, and net controls in declared
   order.
9. Canonical CSV rendering, account tokenization, tax-ID masking, and a
   whole-output restricted-value scan.
10. CSV/checksum publication followed by the readiness manifest.

Transfer and return timestamps are interpreted with the IANA
`America/Sao_Paulo` rules. Nonexistent local times are rejected, overlaps use
the earlier valid offset, and CSV timestamps always contain seconds and an
explicit numeric offset. Returns inherit their immediately preceding transfer
context and carry a negative amount. All arithmetic remains `BigDecimal`.

Type 04 failures expose only the stable code, optional physical record number,
and declared/computed aggregate controls. Movement IDs, account tokens, tax-ID
masks, names, reasons, and raw records are excluded from result evidence.

## Type 05 validation boundary

`Type05Processor` implements the approved locale-aware CSV contract as closed,
global phases:

1. Source size, strict UTF-8 without BOM, and pre-normalized NFC.
2. Exact LF framing, one final LF, nonblank rows, and 512-byte physical-record
   bounds.
3. Exact header, then a single-pass quote-aware semicolon lexer.
4. Mandatory quoted description, unquoted remaining fields, and exactly ten
   fields.
5. Canonical decimal-comma lexemes, exact ranges, and CNPJ Mod-11 digits.
6. Safe identifiers and descriptions, including code-point length, control,
   bidi, spreadsheet-prefix, long-digit-run, and raw-CNPJ rejection.
7. Filename/row batch identity, strict business dates, and assessment-ID
   uniqueness.
8. Per-row `gross × rate ÷ 100`, rounded once to scale two with
   `BigDecimal` `HALF_UP`.
9. Source count, gross, assessed-fee, and calculated-fee controls in declared
   order.
10. Canonical comma CSV rendering, CNPJ masking, whole-output raw-CNPJ
    scanning, then CSV/checksum publication followed by the readiness
    manifest.

The single-row monetary ceiling is applied only to raw detail fields. Aggregate
controls may legitimately exceed it when multiple maximum-value rows are
summed. A valid assessed fee of `0.00` is accepted only when the independent
positive calculation also rounds to `0.00`.

Type 05 adds no secret. Its success and rejection results contain only
controlled filenames, hashes, optional physical record number, and aggregate
count/gross/assessed/calculated controls. Raw CNPJs, masks, descriptions, and
row bodies cannot be attached to diagnostics.

## Secret domains

Type 03 fails closed unless all three settings are nonblank and mutually
distinct:

- `NWP_PAYMENT_REFERENCE_KEY`
- `NWP_PARTY_TOKEN_KEY`
- `NWP_ACCOUNT_TOKEN_KEY`

Each must also differ from `NWP_TOKENIZATION_KEY` and
`NWP_DOCUMENT_TOKEN_KEY` when those earlier-type keys are configured. Secrets
are never serialized, logged, or included in `Configuration.toString()`.

Type 04 separately requires `NWP_TED_ACCOUNT_TOKEN_KEY`. It must be nonblank
and distinct from the generic key and every configured Type 02/03 key. The
canonical HMAC input is `ispb:branch:account`, and the output is
`tedacct_` followed by the first 24 lowercase hexadecimal digest characters.

The values in `.env.example` are public deterministic fixture keys for the
local synthetic environment only.

## Verification

The root facade builds the pinned Java 21 image and runs all registered
regressions:

```sh
make test-java
```

The current source-converged Java gate runs 80 tests across Types `01`–`06`
(78 on the five-type base plus two for the Night 5 Type `06` kit).
That parser/build gate is distinct from live SFTP/PostgreSQL evidence. Both
passed on 2026-07-24 for the base: the Java gate contributed 78 passing tests to the clean
`make test` portfolio, while the separate synchronous portfolio completed 15
accepted conversions and 10 expected conversion/source quarantines across all
five types. The automatic worker independently completed the same `15/10`
canonical split plus four exact-batch restart probes. Rejection and
oracle-mismatch terminal replays consumed allowlisted Java results from the
private identity-bound journal and did not invoke Java a second time. Type 04
tests cover the five canonical scenarios, every declared rejection phase,
conditional-grammar and linkage precedence, timestamp semantics, diagnostic
privacy, missing or reused keys, manifest dispatch, and zero partial output.

Type 05 tests cover all five canonical outcomes, both positive half-cent ties,
a valid calculated zero fee, embedded quotes and NFC, Unicode/control/bidi and
spreadsheet safety, noncanonical and negative-zero decimals, per-row versus
aggregate width, whole-output privacy forcing, manifest-last publication, zero
partial output, and the declared rejection precedence.

The accepted Type 03 CSV identities are:

| Scenario | SHA-256 |
|---|---|
| `valid-minimal` | `a108607f7d32017a954efce8ee35124d42429bb7a85a38ef58f700087fd4b941` |
| `valid-boundary` | `c5dc9621dee5f713a0634fcfdf69645b4e5d9515a529c0c6823eff6636a9bfcf` |
| `multi-lot` | `31436cd3b718207452154e8a1d3f77e0d705e9721547582da056d1db632ca24f` |

The accepted Type 04 CSV identities are:

| Scenario | SHA-256 |
|---|---|
| `valid-minimal` | `96ac52ddfc186df6b9e0814767ee2176da0740b9944c7dc1d19e82024e875619` |
| `valid-boundary` | `4a125011ce9bfbd0d0f4c2638774f65609a6dbb0b7be639bb21d4fa75fab507b` |
| `all-returned-zero-net` | `1a92c24dac42e3e01cd410be8aa7e3840981491e21fd143a28ae8bb724c8d9ab` |

The accepted Type 05 CSV identities are:

| Scenario | SHA-256 |
|---|---|
| `valid-minimal` | `cc13c6fa4ea028b7b7cbfaaf5b755a09cd8edcc424739515429388bd15978c48` |
| `valid-boundary` | `3652ce3371208e45e1eef0c2f690599429d45a12bcea926af8898405532e480e` |
| `rounding-half-up` | `29440b6691950b4333b2c96187a794e0916bfda07500ad8584ce2c165fc33c85` |

Generate API documentation with:

```sh
docker run --rm \
  -v "$PWD/legacy/processor:/source:ro" \
  maven:3.9.11-eclipse-temurin-21-alpine@sha256:922927df2c662cdd47ddb116443d6bec4696cfae3de1a0ddac8fcc7b87ce61ae \
  sh -lc 'cp -R /source /tmp/processor && cd /tmp/processor && mvn --batch-mode -DskipTests javadoc:javadoc'
```

The documentation command uses a read-only source mount and writes generated
HTML only inside the disposable container.
