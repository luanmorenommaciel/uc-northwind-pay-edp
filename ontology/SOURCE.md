# Source pin

This folder is a **slim crawl**, not a port of the OntoLayer product.

| | |
|---|---|
| Upstream | `/Users/luanmoreno/GitHub/ontolayer` (sibling repo) |
| Commit | `189b245efe3301c09727529eca47d8094b313d72` (`189b245 feat: graph view, postgres env stack, and product backlog`) |
| Connector kept | `src/connectors/postgres.py` — tables, columns, FKs, views, COMMENT ON |
| Added here | `ProcedureEntity` + `_extract_routines()` against `pg_proc` / `pg_get_functiondef` / `pg_depend` |

## Keep

- Entity models + `EntityStore` (tables, columns, relationships, views)
- Postgres connector fetch of information_schema + pg_description
- pydantic settings pattern (rewritten plant-only)

## Drop (do not copy)

`connectors/fabric.py`, `duckdb.py`, `fabric_client.py`, `datagen/`, `agent/`, `query/`, `search/`, `embeddings.py`, `enrichment*.py`, `providers/`, `semantic/`, `cluster_builder.py`, `summary_builder.py`, `manifests/`, `schema_drift.py`, `sync_manager.py`, `auth.py`, `web/`, `server/`, `envs/`, `presentation/`, OpenSearch, LLM, sampling.

Document projection (`documents.py`, `document_builder.py`) is dropped: this cut stops at `EntityStore` and writes `output/graph.json`.

MCP here is a thin stdio server over that JSON (`catalog_search`, `catalog_get`, `catalog_ask`). It is not OntoLayer's planned `ontolayer-mcp` (no LangGraph `nl_query.run`, no OpenSearch).

## Plant defaults

- Schema filter: `control,staging,legacy,reporting`. Never `public`.
- DSN: admin role from plant `.env` (`POSTGRES_ADMIN_*` @ `127.0.0.1:54329` / `northwind_legacy`).
- Session: `readonly=True`. Crawl does not write `legacy/`, `contracts/`, `gen/`, or `infra/`.
