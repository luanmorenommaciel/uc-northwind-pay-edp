# 06 - Merchant Chargeback Adjustment

Status: `approved-for-implementation` — the Night 5 factory kit (docked 2026-08-28). Not part of the five-type base sign-off.

Synthetic chargeback adjustments. Independent calculation is
`original × rate ÷ 100` rounded **HALF_UP** to scale 2.

`valid-minimal` row `67,00` at `1,500` percent is exactly `1.005` before
scale-2 rounding: contract **1.01**. The live Java plant MATCHES the batch
at a different cent. That disagreement is a **legacy-plant** defect, not a
source lie: classify it `CONFIRMED_LEGACY_DEFECT`, stall the type, and do
not patch frozen `legacy/`.

Where the files are: the four YAMLs and the expected outputs are in this
folder; the inputs (`valid-minimal.csv`, `valid-boundary.csv`,
`malformed.csv`, `legacy-miss.csv`) and their `.sha256` sidecars are in
[`spec/type-06-merchant-chargeback/samples/`](../../../spec/type-06-merchant-chargeback/samples/).
There is no `DF-SOURCE-006` scenario and no `expected-sanitized.csv`.
Modern package: `modern/ingestion/src/northwind_pay/types/06-merchant-chargeback/`;
Consensus: [`docs/consensus-type-06.md`](../../../docs/consensus-type-06.md);
factory evidence: `evidence/factory/type-06.json`.

## Detection

- Filename: `^NW_MERCHANT_CHARGEBACK_[0-9]{8}_B[0-9]{15}\.csv$`
- Header type code: `MER_CHGBK06`
- Encoding: UTF-8 NFC, semicolon, quoted description

## Canonical outcomes

| Scenario | Batch | Expected (contract) |
|---|---|---|
| `valid-minimal` | `B202607230000501` | MATCHED chargeback **1.01** |
| `valid-boundary` | `B200002290000502` | accepted |
| `malformed` | `B202607230000503` | `INVALID_CSV_QUOTING` |
| `legacy-miss` | `B202607230000504` | contract MATCHED **1.01** (same HALF_UP steel thread) |
