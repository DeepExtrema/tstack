---
name: tesseract-omp-integration
description: "Connect, repair, or diagnose the local Tesseract Obsidian vault through OMP MCP; use for Tesseract setup, broken launchers, indexing, or memory-stack integration."
---

# Tesseract–OMP integration

## Local components

- Repository: `/home/extremis/dev/tesseract-mcp`
- Vault: `/home/extremis/Documents/tesseract-vault` (also linked as `/home/extremis/tesseract-vault`)
- Preferred OMP config: `~/.omp/agent/mcp.json`
- Preferred transport: native MCP `stdio`, not the legacy Prime HTTP bridge.

## Diagnose before changing anything

1. Read `~/.omp/agent/config.yml` and `~/.omp/agent/mcp.json` if present.
2. Inspect `.venv/pyvenv.cfg`, `.venv/bin/tesseract-mcp`, and interpreter symlinks.
3. Check whether the generated entry-point shebang and launcher paths use the current home `/home/extremis`, not stale `/home/extrema`.
4. Test the server through MCP, not merely by importing its package:
   `scripts/probe_server.py --exe <server-executable> --vault /home/extremis/Documents/tesseract-vault --timeout 60`.
5. A passing probe must initialize MCP and receive a `search_brain` response.

The probe can report "server exe not found" even when the launcher file exists: a missing interpreter named in its shebang also causes `subprocess.Popen` to raise `FileNotFoundError`. Inspect the shebang before diagnosing a missing installation.

## Repair policy

If the virtual environment references a missing interpreter or old home path, rebuild it against the installed uv Python rather than patching individual symlinks/shebangs. Reinstall the repository editable package, then run the MCP probe.

Use an OMP-native definition equivalent to:

```json
{
  "$schema": "https://raw.githubusercontent.com/can1357/oh-my-pi/main/packages/coding-agent/src/config/mcp-schema.json",
  "mcpServers": {
    "tesseract": {
      "type": "stdio",
      "command": "/home/extremis/dev/tesseract-mcp/.venv/bin/tesseract-mcp",
      "env": {
        "TESSERACT_VAULT_PATH": "/home/extremis/Documents/tesseract-vault"
      },
      "timeout": 120000
    }
  }
}
```

Then reload and test the server in OMP. Call `onboard` before normal use and exercise a known `search_brain` query.

Named OMP profiles have separate user-level MCP configuration at `~/.omp/profiles/<name>/agent/mcp.json`; a profile does not inherit the default profile's native MCP registration. Project and foreign-tool configuration sources are not profile-isolated. Inspect the active profile before concluding that a missing default config means no registration exists anywhere.

## Data and maintenance boundaries

- Vault Markdown is authoritative; `~/.tesseract-mcp/` contains rebuildable caches.
- Agents write freely only below `Claude/`; outside that tree requires explicit path confirmation. Read the live vault constitution for more-specific standing permissions.
- Concepts and decisions are append-oriented; search before creating near-duplicates.
- Run Librarian/index/organization operations in dry-run mode first after migration or long downtime. Do not infer that dry-run means no model/network calls: verify the relevant implementation before running it under provider restrictions.
- Do not bulk-copy conversational memory into Tesseract. Use it for curated concepts, decisions, sessions, and research; use an active OMP memory backend for episodic recall when one is intentionally enabled.
- Tesseract knowledge is not authoritative runner state or an executable skill deployment. Proposed architecture changes are not authorization to publish, sync, or schedule maintenance.
- The specialized `create_knowledge_record` tool has a stricter contract than general `Claude/` writes: read `docs/knowledge-records.md`; exact path/content authorization is required. Committed reference publication likewise requires its preview/apply consent flow in `docs/reference-publication.md`.

## Local recovery and LiveSync prerequisites

The user authorized a same-disk versioned safety net on 2026-09-24. `~/.local/bin/backup-tesseract-vault` archives the physical vault into `~/Backups/tesseract-vault/`; the persistent user `tesseract-vault-backup.timer` runs daily and retains the latest 14 successful archives. The service uses a single-writer lock, private permissions, integrity checks and atomic publication; failures do not prune good backups. Run it manually with `systemctl --user start tesseract-vault-backup.service`.

Restore into a separate empty directory, never over the live vault: `tar --use-compress-program=zstd -xf <chosen-archive.tar.zst> -C <empty-scratch-directory> -- tesseract-vault/Claude/README.md`. A real isolated restore of that file matched the live constitution byte-for-byte. Root Snapper snapshots exclude `/home`; this archive protects against accidental changes but does not survive failure of the system SSD. Obtain separate authorization/destination for off-machine backup.

Do not infer working LiveSync from architecture notes. On 2026-09-24 the plugin was installed but disabled, with `isConfigured=false`, no endpoint/credentials and no saved remote configuration; the older task list still marked Oracle deployment and setup-URI generation unfinished. Reconnection requires a real existing setup, entered privately through Obsidian, and a backup before any replication. Do not invent a destination or use destructive rebuild/sync actions to make the status look healthy.

## Maintenance model routing

Before enabling unattended indexing or consolidation, inspect `src/tesseract_mcp/extractor.py` and verify the actual child command/model. As inspected on 2026-09-24, `CliExtractor` defaults to the `codex` backend and invokes bare `codex exec`. Its `--model` argument is added only for the `claude` backend; `TESSERACT_EXTRACT_MODEL` and `TESSERACT_CONSOLIDATE_MODEL` therefore do not pin Codex. Feynman's model allowlist does not constrain this independent CLI process.

The user's research-agent policy is Luna/Terra/Sol only, never Astra. Do not assume that a caretaker or helper inherits a compliant model from OMP or Feynman. Establish a supported explicit routing boundary and inspect actual receipts before authorizing unattended model-backed maintenance. Do not change the main coordinator model or silently alter global Codex configuration to achieve this.

## Known legacy configuration

The Prime HTTP endpoint at `http://127.0.0.1:8787/mcp`, `~/.prime/agent/mcp/tesseract-serve.sh`, and OpenCode `opencode.jsonc` may exist but are not the preferred OMP path. OMP imports `opencode.json`, not `opencode.jsonc`, and external provider discovery may be disabled.
