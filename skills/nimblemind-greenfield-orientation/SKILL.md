---
name: nimblemind-greenfield-orientation
description: "Locate authoritative Nimblemind greenfield workflow code and acceptance evidence before inspecting, resuming, or integrating its runner with OMP or another coordinator."
---

# Nimblemind greenfield orientation

Use when inspecting the existing application runner, comparing its capabilities, or considering an OMP/Prime/OpenCode integration. This is an orientation procedure, not permission to run applications or change the system.

## Find the authoritative working tree

1. Start at `~/Documents/Default Project/nimblemind-greenfield/`.
2. Read `AGENTS.md` and `docs/development/OVERNIGHT-20260911.md`, especially its current-authority pointer. Do not assume the root README or `docs/CAPABILITIES.json` describes the latest implementation.
3. As inspected on 2026-09-23, that pointer led to `.local/mission-worktrees/demo/docs/development/E2E-MISSION-20260911.md`. Re-read the handoff on every visit; follow newer pointers if present.
4. Read the handoff's referenced acceptance and preservation records. Distinguish accepted source, subsequent unaccepted working changes, deployed bytes, and live-qualified behavior. Do not reset, deploy, or clean the worktree during orientation.
5. Some imported documents contain `/home/extrema` paths; the inspected machine used `/home/extremis`. Resolve existing files rather than blindly executing historical commands or rewriting paths globally.

## Preserve the execution boundaries

- OpenCode development dispatch (`scripts/dev_dispatch.mjs`, `.opencode/agents/`) is not the application scheduler.
- The demo worktree contains the PostgreSQL-authoritative case/effect journal, application service, and bounded deterministic `Director`. Chat history and coordinator todos are not application state.
- The root LangGraph wrapper was a narrow authenticated node/checkpoint mechanism, not evidence of a complete autonomous application DAG.
- Review `src/nimblemind/{director,application,runtime_model,dev_sessions}.py` only as needed for the requested capability. Inspect current code and use available language-server tools for symbol navigation.

## Inspect an integration before designing another

Read `docs/development/CLIENTS-SCOPED-ACCEPTANCE.md` and the relevant `src/nimblemind/client_api.py`, `client_cli.py`, or `client_mcp.py`.

The inspected client boundary exposed case-scoped `status`, `actions`, `start`, `pause`, `resume`, and `cancel`. Writes used expected versions and stable command keys. It did not expose owner authorization, budget expansion, submission authority, or arbitrary routing. Unknown write outcomes were not permission to retry with a new key.

MCP/CLI implementation is not deployment: verify the current records for mounting, private TLS configuration, host registration, lifecycle ownership, and accepted source before connecting a coordinator. Do not bypass protected owner controls or access the database directly to simulate missing client capabilities.

## Classify evidence honestly

Consult `docs/development/SEQUENTIAL-WORKFLOW-ACCEPTANCE.md`. Its recorded 1/5/50-case results used real controlled browser interactions but synthetic producer/reviewer calls; they were not real application submissions. Treat those as historical reported evidence unless a new authorized verification is actually performed.

For every capability distinguish: implemented, controlled-tested, accepted, deployed, live-qualified, or blocked. Review later preservation records before relying on an earlier pass. A stopped development worker does not prove an application worker stopped; retained unknown outcomes, claims, reservations, and holds must not be cleared by inference.

Architecture guidance: a conversational coordinator may plan, inspect, and request scoped controls. The runner owns legal transitions, durable progress, and external-effect reconciliation. Keep workflow improvement separate from an active production batch; do not silently change its rules while troubleshooting.
