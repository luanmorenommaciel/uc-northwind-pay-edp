# Converge Workspace

This directory is the project-local Converge control plane. Product code stays
in the repository's normal application directories; the artifacts here record
why work exists, what was authorized, how it ran, and what proved it complete.

## Lifecycle

`brain → docs → swimlanes → tasks → execution → receipts`

| Path | Contract | On this tree |
|---|---|---|
| `brain/` | Raw inputs and append-only discovery material | Empty scaffold (`.gitkeep`). The week's brain is `brain/notebooklm/` at the repo root |
| `docs/` | Reviewed product and technical decisions | Empty scaffold. The papers live in the repo-root `docs/` (BRD, tech-spec, ADRs `0001`–`0015`, seams, three Consensus signs) |
| `swimlanes/` | Decomposition, lanes, and consensus evidence | Three lanes: `ingest-landing/`, `dlt-gold/`, `orchestrate-serve/` |
| `tasks/` | Task-Specs and their lifecycle projection | 16 HMAC-signed copies (`signed_off_sig`) of the Nights 2–4 leaves. **Canonical** Task-Specs are `docs/tasks/` (18, including the two Type `06` leaves that were never copied here) |
| `execution/` | Runtime contracts bound to signed Task-Spec hashes | One folder per signed leaf (15) |
| `receipts/` | Write-once settlement evidence | Empty; the week's packets went to the gitignored `evidence/` |

There is no `sketch/` or `loop/` directory; `cvg init` (Night 4, 2026-08-27)
did not create them and nothing writes there.

Task-Spec frontmatter is canonical. `tasks/_state.yaml` is a derived,
rebuildable projection — the copies here and in `docs/tasks/` were last
regenerated on 2026-08-31 and do not reflect what Nights 4–5 built; rebuild
before trusting them. External trackers are optional projections, never the
authoring source.
