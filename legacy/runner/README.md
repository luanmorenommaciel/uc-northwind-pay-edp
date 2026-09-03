# The legacy runner

**7,159 lines across 16 files** — the largest single area of the estate and the
hardest part of the migration. It owns sensing, claiming, locking, dispatch,
crash recovery, and evidence. It owns **no** parsing and no business logic.

## The directory listing will mislead you

Two files carry a type number in their name:

```text
run_type01.py   121 lines   self-described backward-compatible entrypoint
run_type02.py    35 lines   ditto
```

**Both are dead.** Neither is called by the Makefile, and two tests assert the
facade does *not* invoke them:

```python
tests/unit/test_make_facade.py:158        self.assertNotIn("run_type01.py", scenario.stdout)
tests/unit/test_worker_acceptance.py:108  self.assertNotIn("run_type01.py", combined)
```

They stay because `legacy/` is a frozen oracle and deleting them would be a
change to frozen truth for cosmetic gain.

**All six types live in `workflow_registry.py`.** The directory lists two type
numbers; the registry holds six.

---

## The files

| File | Lines | Owns |
|---|---:|---|
| `workflow_registry.py` | 2,329 | The six type adapters and the **only** type dispatch |
| `worker.py` | 1,640 | The autonomous poller: sense, claim, lock, recover |
| `workflow.py` | 1,218 | The shared lifecycle engine every batch runs through |
| `recovery_journal.py` | 663 | Crash-safe terminal metadata |
| `lifecycle.py` | 462 | Zone inspection and terminal-state verification |
| `sftp_client.py` | 166 | The SFTP transport (has `put`, `rename`, `remove`) |
| `config.py` | 130 | Runtime configuration |
| `evidence.py` | 81 | Evidence packet writing |
| `run_type.py` | 79 | **The one public CLI** |
| `bootstrap_runtime.py` | 71 | Captures the SFTP host key into `.runtime/known_hosts` |
| `runtime_status.py` | 68 | Runtime health |
| `publish_raw_cli.py` | 57 | Publisher CLI wrapper |
| `clean_runtime.py` | 34 | Runtime teardown |

Plus the two dead shims and `requirements.txt`.

---

## `workflow_registry.py` — six types, one file

```text
class WorkflowAdapter(ABC)        10 abstract methods + 6 overridable members
class Type01WorkflowAdapter       211 lines
class Type02WorkflowAdapter       350 lines
class Type03WorkflowAdapter       368 lines
class Type04WorkflowAdapter       371 lines
class Type05WorkflowAdapter       350 lines
class Type06WorkflowAdapter       ~355 lines   (Night 5 kit)

WORKFLOWS: Mapping[str, WorkflowAdapter] = MappingProxyType({...})
def workflow_for_type(type_number) -> WorkflowAdapter
```

The runner is the component whose *whole job* is to be type-agnostic, so unlike
`processor/` (one package per type) or `postgres/` (one loader per type), it
keeps its per-type code as six subclasses behind one interface.

`workflow_for_type` is the **single dispatch point in the entire orchestration
layer**:

```python
def workflow_for_type(type_number: str) -> WorkflowAdapter:
    """Resolve one implemented workflow or fail before external mutation."""
    try:
        return WORKFLOWS[type_number]
    except KeyError as exc:
        raise ValueError(f"Unsupported workflow type: {type_number}") from exc
```

Note the docstring: an unknown type is rejected **before SFTP is touched**.

### The ten abstract methods — the cost of a new type

| Method | Answers |
|---|---|
| `prepare` | How is this batch staged before commit? |
| `commit` | How is it made durable? |
| `recover` | How is an interrupted run resumed? |
| `prepared_observation` | What was observed after preparation? |
| `load_observation` | What was observed after the database load? |
| `compare_sanitized` | Does the sanitized CSV match the oracle? |
| `compare_post_db` | Does the post-load state match the oracle? |
| `compare_rejection` | Does a refusal match the approved refusal? |
| `rejection_diagnostic` | What privacy-safe diagnostic does a refusal carry? |
| `diagnostic_controls` | Which controls are independently recomputed? |

Plus six overridable evidence members: `java_evidence`,
`raw_publication_evidence`, `raw_intake_evidence`, `postgres_load_evidence`,
`final_status_evidence`, and the `oracle_expected_label` property.

**That list is the checklist for an incoming type kit.** The estimate was
~370 lines here and a registry entry, with *zero* changes to the worker,
the engine, or the recovery journal. The sixth type (Night 5) landed at
~355 lines and confirmed it.

**Type 01 defines exactly 11 members** — the ten abstract methods plus
`java_evidence` — and accepts the base class's default evidence writers.
Types 02–06 define 16–17: the same eleven, plus overrides of
`raw_publication_evidence`, `raw_intake_evidence`, `postgres_load_evidence`,
and `final_status_evidence`, plus a private `_observation` helper (and, for
Type 05, `_rejection_control_fields`).

So the *required* surface is ten methods for every type. The extra six are
customization the base class already permits — which was the useful number
when estimating a sixth type: **ten mandatory, six optional.**

---

## `run_type.py` — the one public CLI

```bash
legacy/runner/run_type.py --type NN (--scenario NAME | --file PATH)
```

Seventy-nine lines, and the body is two:

```python
adapter = workflow_for_type(args.type_number)
return run_cli_selection(adapter, scenario=..., raw_file=..., ...)
```

It resolves the type and hands off. `workflow.py` never learns which type it is
running. `--type` choices come from `WORKFLOWS` itself, so the CLI cannot drift
from the registry.

It also prepends five module directories to `sys.path` — `runner`, `publisher`,
`intake`, `postgres`, and `validation/oracle` — which is how a single process
drives components that are otherwise independent.

---

## `worker.py` — the autonomous poller

Discovers manifest-ready batches and dispatches them without a human. What
makes it more than a loop:

- **Terminal statuses** are exactly `succeeded`, `quarantined`,
  `oracle_mismatch`. Nothing else ends a batch.
- **Candidate zones** are `processing`, `incoming`, and the local `cache`, in
  that order — a batch already claimed is resumed before a new one is taken.
- **A single-instance lock** (`WorkerAlreadyRunningError`) prevents two workers
  claiming the same batch.
- **Hard bounds everywhere**: 64 MB raw, 64 KB manifest, 512 B checksum,
  4,096 directory entries, 100 batches per cycle, poll interval clamped to
  0.1–3,600 s. A hostile or corrupt directory cannot exhaust the runner.
- **Typed refusals**: `WorkerSourceRejected` and `WorkerCacheConflict` are
  distinct from a processing failure, so an unusable source is never reported
  as a defect in the batch.

---

## `workflow.py` + `recovery_journal.py` + `lifecycle.py` — crash safety

This trio is why the estate survives being killed mid-batch, and it is the part
a rewrite most often gets wrong.

**`lifecycle.py`** inspects both zone families (`incoming`/`processing`/
`quarantine`/`archive` for raw, `outgoing`/`processing`/`quarantine`/`archive`
for CSV) and verifies terminal state. Quarantine reasons are bounded to 2 KB
and must match `[A-Z][A-Z0-9_]{2,63}` — a refusal reason can never become an
exfiltration channel.

**`recovery_journal.py`** exists because the raw intake cache deliberately holds
exactly three transport artifacts, so terminal metadata cannot live there. The
journal is a **private, identity-bound** directory holding only immutable source
identity and a bounded safe reason. It is written as canonical JSON, `fsync`s
its directory, verifies file ownership and permissions before reading, and
repairs an interrupted publication on restart.

**`workflow.py`** is the shared engine: `run_pipeline`, `run_java`, the
rejection paths (`_finish_rejection`, `finish_oracle_mismatch`), and
`_resume_terminal_recovery`. Every batch of every type goes through it.

---

## What must not change

`legacy/` is a frozen oracle. In particular:

- **`workflow_for_type` stays the only dispatch.** Adding a second place where
  a type number selects behaviour breaks the property that makes the runner
  reusable.
- **The dead shims stay.** They are documented above; removing them is a change
  to frozen truth for no functional gain.
- **The bounds stay.** They are the difference between a poller and a denial of
  service against your own runtime.

## Local environment

`legacy/runner/.venv/` is **126 MB inside this directory**. It is gitignored
and referenced by the Makefile and every `PYTHONPATH`, so it cannot move — but
it will wreck any naive recursive line count. Use `git ls-files legacy/runner/`.
