#!/usr/bin/env bash
# Rebuild the NorthWind Pay NotebookLM packs from spec/. Run from repo root:
#   bash brain/notebooklm/build.sh
#
# The brain is the whole drop (types 01–05) for the week. Type 06 stays out on purpose (never-seen kit).
# Raw samples and expected/ oracles stay on disk — not in this notebook.
set -euo pipefail
root="$(cd "$(dirname "$0")/../.." && pwd)"
out="$root/brain/notebooklm"
spec="$root/spec"

banner() {
  local path="$1"
  printf '\n\n---\n\n## Source: `%s`\n\n' "$path"
}

append_file() {
  local rel="$1"
  banner "$rel"
  cat "$root/$rel"
}

pack_type_inbound() {
  local slug="$1"
  local title="$2"
  local blurb="$3"
  local dest="$4"
  local dir="spec/${slug}"
  {
    cat <<EOF
# ${title}

${blurb}
The raw samples and expected/ oracles are not in this pack.

EOF
    append_file "${dir}/README.md"
    while IFS= read -r f; do
      append_file "${dir}/inbound/$(basename "$f")"
    done < <(find "$root/${dir}/inbound" -type f | LC_ALL=C sort)
  } > "$dest"
}

{
  cat <<'EOF'
# Pack 01 — The estate (inbound)

Customer drop for the whole engagement. Type packs may contradict it.
Mail is not the contract. Do not invent Java.

EOF
  append_file "spec/estate/README.md"
  append_file "spec/estate/cover.md"
  while IFS= read -r f; do
    append_file "spec/estate/mail/$(basename "$f")"
  done < <(find "$spec/estate/mail" -type f | LC_ALL=C sort)
  while IFS= read -r f; do
    append_file "spec/estate/meetings/$(basename "$f")"
  done < <(find "$spec/estate/meetings" -type f | LC_ALL=C sort)
  while IFS= read -r f; do
    append_file "spec/estate/policies/$(basename "$f")"
  done < <(find "$spec/estate/policies" -type f | LC_ALL=C sort)
} > "$out/01-estate.md"

{
  cat <<'EOF'
# Pack 02 — Five live types (the week)

Inbound READMEs only. Not the samples. Not contracts/. Type `06` is not here.
Type `01` is the steel thread on Day 1. Types `02`–`05` stay in this notebook for the rest of the week.

EOF
  append_file "spec/README.md"
  append_file "spec/type-01-card-settlement/README.md"
  append_file "spec/type-02-instant-payment-events/README.md"
  append_file "spec/type-03-payment-slip-settlement/README.md"
  append_file "spec/type-04-ted-transfer-settlement/README.md"
  append_file "spec/type-05-merchant-fee-assessment/README.md"
} > "$out/02-five-types.md"

pack_type_inbound \
  "type-01-card-settlement" \
  "Pack 03 — Type 01 inbound (card settlement)" \
  "What we mailed for Type \`01\`. Day 1 steel thread. Capture starts here. Do not open Java for the answer." \
  "$out/03-type-01-inbound.md"

pack_type_inbound \
  "type-02-instant-payment-events" \
  "Pack 04 — Type 02 inbound (instant payment / PIX)" \
  "What we mailed for Type \`02\`. Pipes, escapes, offsets. Same shape of lie as Type 01." \
  "$out/04-type-02-inbound.md"

pack_type_inbound \
  "type-03-payment-slip-settlement" \
  "Pack 05 — Type 03 inbound (payment slips)" \
  "What we mailed for Type \`03\`. 240-byte pairs, lots. Same shape of lie as Type 01." \
  "$out/05-type-03-inbound.md"

pack_type_inbound \
  "type-04-ted-transfer-settlement" \
  "Pack 06 — Type 04 inbound (TED)" \
  "What we mailed for Type \`04\`. Mixed widths, inherited returns, two dated procs." \
  "$out/06-type-04-inbound.md"

pack_type_inbound \
  "type-05-merchant-fee-assessment" \
  "Pack 07 — Type 05 inbound (merchant fees)" \
  "What we mailed for Type \`05\`. Semicolon CSV, decimal comma, HALF_UP. Ops mail that says “normal rounding” is not the contract. Day 4 lives here." \
  "$out/07-type-05-inbound.md"

{
  cat <<'EOF'
# Pack 08 — The lie (the whole drop)

This pack is inbound, not the contract. Raw samples are **not** here — NotebookLM cannot read signed overpunch. The numbers below are what the drop already says in prose.

The same shape of lie exists on every live type. Type `01` is the steel thread on Day 1. Types `02`–`05` keep the same rule: keep their number, refuse the batch.

## What the source declares vs what the rows add to

| Type | Sample | Declares | Rows add to | Finding |
|---|---|---|---|---|
| `01` card | `df-source-001` | **173.44** | **173.45** | `SOURCE_CONTROL_TOTAL_MISMATCH` |
| `02` PIX | `df-source-002` | **173.44** | **173.45** | `SOURCE_CONTROL_NET_MISMATCH` |
| `03` slips | `df-source-003` | **198.49** | **198.50** | `SOURCE_CONTROL_NET_MISMATCH` |
| `04` TED | `df-source-004` | **999.99** | **1000.00** | `SOURCE_CONTROL_NET_MISMATCH` |
| `05` fees | `df-source-005` | **0.99** | **1.00** | assessed-fee lie |

Keep their number. Refuse the batch. Do not quietly write the computed total into the trailer.

EOF
  append_file "spec/estate/mail/2026-07-14-the-cent-that-will-not-die.md"
} > "$out/08-the-lie.md"

zip_path="$out/northwind-pay-brain.zip"
rm -f "$zip_path" "$out/northwind-pay-d1-brain.zip" "$out/04-the-lie.md"
(
  cd "$out"
  zip -q -X "northwind-pay-brain.zip" \
    00-how-this-notebook-thinks.md \
    01-estate.md \
    02-five-types.md \
    03-type-01-inbound.md \
    04-type-02-inbound.md \
    05-type-03-inbound.md \
    06-type-04-inbound.md \
    07-type-05-inbound.md \
    08-the-lie.md
)
echo "wrote $out/01-estate.md"
echo "wrote $out/02-five-types.md"
echo "wrote $out/03-type-01-inbound.md"
echo "wrote $out/04-type-02-inbound.md"
echo "wrote $out/05-type-03-inbound.md"
echo "wrote $out/06-type-04-inbound.md"
echo "wrote $out/07-type-05-inbound.md"
echo "wrote $out/08-the-lie.md"
echo "wrote $zip_path"
unzip -l "$zip_path"
