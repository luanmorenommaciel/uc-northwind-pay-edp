# Shared transport contracts

These schemas define the boundary between independently implemented legacy
components. Producers must emit them exactly; consumers must validate both the
schema and the semantic links to transported bytes.

- `source-manifest.schema.json`: raw source readiness and closed, type-specific declared controls.
- `generation-receipt.schema.json`: closed, type-dispatched local DataGen evidence; never published.
- `sanitized-manifest.schema.json`: sanitized CSV readiness, lineage, and closed type-specific stage controls.
- `checksum-sidecar.md`: exact checksum sidecar grammar.

All JSON artifacts use UTF-8, sorted keys, two-space indentation, and one final
LF. Manifests are readiness markers and are renamed from `.part` last.

Consumers first validate the common envelope, then dispatch from the exact
`file_type.number` or `contract.type_number` branch. They must also cross-check
the manifest type, filename, header code, layout version, date, and batch ID.
The file extension alone never selects a parser. Types `01` through `06` have
closed branches (`06` carries `MER_CHGBK06`); cross-pairing one type's identity, filenames, controls, or
lineage with another type is invalid.

JSON Schema closes the artifact shape and type-specific filename grammar.
Equality links that JSON Schema cannot express—such as the same batch ID and
date appearing in the envelope, filename, and raw header—are mandatory semantic
validation performed before publication, intake, conversion, or loading.
Sanitized-manifest validation also enforces each type's declared row and byte
bounds. Semantic checks that JSON Schema cannot express remain mandatory:
Type `02` requires `returned_count <= row_count`; Type `03` requires adjacent
source-record numbers, exact physical-count/byte-size agreement, lot count not
greater than logical count, and source/stage control equality; Type `04`
requires `return_count <= transfer_count`, `row_count = transfer_count +
return_count`, exact filename/header/trailer identity, and signed-control
equality; Type `05` requires row count and source/stage controls to agree,
source filename date and batch to match every row, and assessed fee to equal
the independently calculated `HALF_UP` fee; Type `06` requires each
chargeback amount to equal `original × rate ÷ 100` rounded `HALF_UP` at
scale 2 per row, and the batch control to equal the sum of those rounded
rows, both at tolerance `0.00`.
