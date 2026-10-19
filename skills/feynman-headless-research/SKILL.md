---
name: feynman-headless-research
description: "Launch the real Feynman research CLI from OMP, enforce Sol 6.1-only research models, handle native plan approval, and verify report and actual child-model provenance."
---

# Scope
Use when the user requests an actual Feynman literature review or deep research run. A renamed OMP scout is not Feynman. Research only unless implementation is explicitly requested.

# Known installation
Verified local installation: `/home/extremis/.local/bin/feynman` is the canonical wrapper for `@companion-ai/feynman@0.5.2` under `/home/extremis/.local/opt/feynman/` (Node 24.18.0). Config is `/home/extremis/.feynman/agent/`. Recheck `--help`, `status`, and authenticated `model list`; do not assume version or availability remains unchanged. Do not reinstall or upgrade a working installation without need.

**Credential reach inside a Paperclip runner (confirmed 2026-10-17).** `omp models` / `feynman status` reporting "No models available" is *not* a provider outage and not a hidden-secret problem. The runner replaces `HOME` with a sandbox under `/tmp/paperclip-ai-*/`, which contains a freshly generated stub `.feynman/agent/` whose `auth.json` and `models-store.json` are both 2 bytes (`{}`). The real config and credentials live at `/home/extremis/.feynman/agent/`. Launch with `HOME=/home/extremis` (plus `PATH=/home/extremis/.local/bin:$PATH`, which the runner also omits) and reach is restored: 9 authenticated models, 1 provider. Do **not** "fix" this by copying `auth.json` into the sandbox home — that copies live credentials into a directory Paperclip deletes, and it violates the credential rule below. Point the tool at the real config instead; never read the credential file to do it.

The wrapper sets `FEYNMAN_TELEMETRY=off`, `DO_NOT_TRACK=1`, and defaults `PUPPETEER_EXECUTABLE_PATH` to `/usr/bin/chromium` without overriding an explicit browser path. Use the wrapper for every launch. Native `model login openai-codex` offers browser or device-code login. Use supervised PTY for authentication, show the user its sign-in instructions, and wait for their authorization. Never read, copy, or share Prime/Codex credential files. `status` and `model list` suffice to verify auth.

# User model policy
Research agents must use **`openai-codex/gpt-6.1-sol` only; never Astra, Terra or Luna**, including reviewers, inherited models, and fallback paths. This policy does not authorize modifying the main OMP coordinator's model (which runs Astra by design).

Terra is forbidden: it fails the latest-release rule and has **never executed on this machine** (zero resolved-model loads in OMP session journals as of 2026-10-17). Luna is not permitted in the research branch under the current qualification; if a narrow Luna slot is ever qualified, it must be added deliberately to both this file and `agent/settings.json`, never reached by inheritance.

Verified mapping (TAI-8, 2026-10-17): **every** role is `openai-codex/gpt-6.1-sol` — lead, writer, researcher, reviewer, verifier, oracle/advisor, evidence-auditor, scout, delegate and worker. Sol 6.1 is confirmed present in the authenticated catalog and confirmed to have executed: 357 resolved-model loads with `resolvedModelIsFallback: false`. Confirm current supported IDs.

In Feynman's `agent/settings.json`, use native `subagents.defaultModel`, `subagents.agentOverrides.<role>.model`, and `subagents.modelScope` with `enforce:true`, `strict:true`, and an allowlist of exactly `["openai-codex/gpt-6.1-sol"]`. Set **every** role explicitly: all bundled agent definitions ship with `model:` unset, so any role you leave out falls through `defaultModel` to the parent session model — that is the path by which Astra reaches the research branch. Never use `inherit` in the allowlist because it could permit a forbidden parent model. Strict mode matters: without it inherited out-of-scope models can merely warn.

Two gotchas confirmed by test:
- Top-level `defaultModel` is resolved **against** top-level `defaultProvider`, so it must be the **bare** id (`gpt-6.1-sol`). Writing `openai-codex/gpt-6.1-sol` there yields `openai-codex/openai-codex/gpt-6.1-sol` and `Model valid: no`. `subagents.*` model fields do take the fully-qualified form.
- Allowlist patterns are globs (`*` → `.*`). Use exact ids; a pattern like `openai-codex/gpt-6*` would also admit `gpt-6-astra`.

Native scope is trusted configuration, not a hostile-code sandbox; project scope can replace user scope. Use an isolated research workspace and prohibit settings changes and alternative agent CLIs in the brief. The external-runner agents (`claude-code`, `codex-exec`, `cursor-agent` and their `-writer` variants) are intentionally left unpinned: they drive other vendors' CLIs rather than Pi models, and the brief must prohibit them rather than mislabel them as Sol.

Also set top-level `enabledModels` to the allowed list — `["openai-codex/gpt-6.1-sol"]`: pi-web-access summary/query helpers honor it. In `agent/web-search.json`, pin `openaiSearchProviders:["openai-codex"]`, `openaiSearchModel:"gpt-6.1-sol"`, `summaryModel:"openai-codex/gpt-6.1-sol"`, `workflow:"none"`, and `allowBrowserCookies:false`. Preserve unrelated existing config. Fixing only `settings.json` and leaving `web-search.json` on Terra/Luna re-establishes the forbidden mapping through search and summarisation; both files must move together. The full model catalog may still display Astra; visibility is not authorization. Verify the installed `pi-subagents/src/runs/shared/model-scope.js` policy function rejects explicit and inherited Astra **without making an Astra API call**.

# Execute the genuine workflow
Write a bounded brief in a dedicated research workspace: questions, relevant user context without private data, primary-source standards, evidence classes, expected artifacts, model restriction, max research children, and no installations/submissions/cloud compute. OMP 18.3 has no `hub` tool: for finite runs use `functions.bash` with `async:true` and await the background result; for genuinely long-lived processes use `functions.bash` with a unique `name` and inspect `proc://<id>` for output and status. Never prescribe `hub start` or `hub logs`.

Verified planning invocation (through the canonical wrapper):
`/home/extremis/.local/bin/feynman --mode json --model openai-codex/gpt-6.1-sol --thinking high --session-dir <workspace>/sessions --new-session -- deepresearch "Read brief.txt and execute the research assignment under its model and scope constraints."`

Do not combine the initial workflow with legacy `--prompt`: that can bypass workflow expansion. Current deepresearch writes a native plan under `outputs/.plans/` then stops for explicit confirmation. Review the actual plan. Within already authorized scope, the coordinator can approve it; ask the user only for genuinely new material decisions. Resume the **same exact session** with `/home/extremis/.local/bin/feynman --mode json --model <allowed-model> --session <jsonl> --prompt "Yes. Main approves the reviewed plan within the authorized scope. Proceed through research, verification, review, and final artifacts..."`.

The native workflow creates plan, draft, cited, final and provenance files; request an evidence JSON and plain-text report as additional deliverables if useful. Avoid depending on legacy `--output-dir`; inspect actual workspace artifacts. Child roles can be inspected through native `subagent action:list/models`. Bound concurrency in the assignment. Do not abandon the workflow at a phase boundary.

# Verification and reporting
Process readiness/exit alone does not prove research completion. Check:
1. First session user message contains expanded deepresearch instructions, not only the raw question.
2. Actual report/provenance/evidence files exist; evidence JSON parses and required fields are present.
3. Citation/review findings were addressed or clearly retained as limitations. Source-reported benchmarks are not independent reproduction, and proposed integrations are not deployed features.
4. Native `bg_wait` tool-result details contain completed child receipts and `sessionFile` paths. Read only those run-owned journals to extract assistant-message provider/model fields, without printing hidden reasoning/signatures or whole transcripts. Verify lead plus every child uses permitted models. Configured/requested models alone are insufficient proof.
5. Preserve an explicit model-audit JSON if model restrictions are a user acceptance criterion.

Prefer bounded JSON extraction over raw JSON streaming logs: they duplicate events and contain enormous encrypted reasoning payloads. Await supervised process exit rather than sleep/polling loops. No benchmark, formatter or project tests are needed for a read-only research run.

# Preview and export
`feynman status` and `feynman doctor` check for Pandoc and browser executables, but do not themselves render content. Feynman 0.5.2's bundled preview skill advertises `/preview`, `/preview --file`, `/preview-browser`, and `/preview-pdf` **only when those commands are visible in the active session**; the bundled core/optional package list does not install a preview extension. Do not assume `/preview` or PDF export is available, or install a LaTeX stack to test browser preview.

Supported local fallback: `pandoc input.md --standalone -o output.html`, then inspect that HTML in an isolated browser tab (`browser.open` with `file://` and `allow_file_access:true`), verify rendered content, and close the tab. Feynman's separate documented `--export <session.jsonl> [out.html]` delegates to Pi's HTML session exporter: it exports a **session transcript**, not Markdown/PDF. In a scratch test, Pandoc 3.10.2 converted a Markdown heading/table/math and Chromium rendered it; `/home/extremis/.local/bin/feynman --export scratch.jsonl session-preview.html` rendered a harmless synthetic session in Chromium. Both require an actual rendered-content check; dependency readiness is not enough. Browser path is supplied by the wrapper; no extra Feynman settings were necessary.

Historical exemplar: `/home/extremis/research/agent-reliability-20260923/` contains brief, native artifacts, structured evidence, and model audit for a real Terra lead, three Luna researchers and two Sol verification/review children. **Its model mapping is superseded and now forbidden** — read it only as a shape reference for artifacts and audit structure, never as a model precedent. This is historical launch evidence, not permission to reuse its conclusions without checking relevance or freshness.
