# tstack

Skills that keep coding agents on the plan. Built after a $10 form-filling bot turned into a six-week, 18k-line root installer with six Linux users, signed documents, 46 sudo prompts, 274 continuation prompts, and zero real submissions.

Two core skills:

| Skill | When it runs | What it produces |
|---|---|---|
| `plan-guard` | Before any plan, brief, delegation, handoff, or 3+-step todo; when scope, infrastructure, security, or scale is proposed; after two failed fixes on one premise | A PASS/REVISE verdict across ten gates and a `## Plan-guard` block the plan carries (goal, done-when, budget, NOT doing, first slice, stop rules, confirm-before) |
| `drift-audit` | A project is already running and you want to know whether it derailed | An ON-TRACK / DRIFTING / DERAILED verdict with evidence, the shortest path back to one real artifact, a cut list, and a plan revision |

Both are grounded in `skills/plan-guard/references/rules.md`: 70 rules, each with its source and a verbatim quote or number, drawn from Anthropic's and OpenAI's prompting guides, four research papers (Overeager Coding Agents, Asymmetric Goal Drift, Evaluating Goal Drift, IFScale), Lauren Tan's pstack principles, Matt Pocock's skills, Superpowers, gstack, HumanLayer, and the talks by Dex Horthy, Boris Cherny, Simon Willison, Jesse Vincent, Geoffrey Huntley and others. Retractions and disagreements between sources are recorded there too.

The `skills/` folder also carries personal workstation skills (`omarchy`, `diagnose-crash`, and the `omarchy-end4-*`, `quickshell-*`, `tesseract-*`, `feynman-*`, `nimblemind-*` skills). They are machine-specific; ignore them elsewhere.

## Install

### OMP

```sh
git clone https://github.com/DeepExtrema/tstack ~/Work/tstack
omp plugin link ~/Work/tstack
```

Then add the skills you want to `skills.includeSkills` in `~/.omp/agent/config.yml` (at least `plan-guard` and `drift-audit`). The `rules/` folder is loaded automatically: `plan-guard.md` is an always-apply reminder; `plan-guard-planfile.md` interrupts writes to `PLAN*.md`; `plan-guard-delegation.md` interrupts the first delegation of a session and checks the brief.

Or from the marketplace: `omp plugin marketplace add DeepExtrema/tstack` then `omp plugin install tstack@tstack`.

### Claude Code

```
/plugin marketplace add DeepExtrema/tstack
/plugin install tstack@tstack
```

Skills are then `/tstack:plan-guard` and `/tstack:drift-audit`. The OMP-specific rule files are ignored; put the one-line trigger from `rules/plan-guard.md` in your `CLAUDE.md`.

### Codex

```sh
codex plugin marketplace add DeepExtrema/tstack
codex plugin add tstack@tstack
```

Or copy `skills/plan-guard` and `skills/drift-audit` into `~/.codex/skills/` and put the trigger line in `AGENTS.md`.

## Use

- Writing a plan: run `plan-guard` first; prepend its block to the plan file. Re-run at phase boundaries, on every reviewer suggestion, and on every resume.
- Delegating: every brief carries Goal, Context, Constraints, NOT doing, Done when, Stop rules, Confirm-before (template in `skills/plan-guard/references/templates.md` §3).
- Suspecting drift: `drift-audit <project root>`. It writes `plan-audit/<date>-drift-audit.md` and `plan-audit/<date>-plan-revision.md` inside the project and does not touch anything else until you say so. Its numbers come from `skills/drift-audit/scripts/drift-metrics.sh`, which is read-only.

## Third-party stacks this does not vendor

Reinstall from their own sources: Lauren Tan's pstack (`/plugin marketplace add cursor/plugins`, `/plugin install pstack@cursor-plugins`), Matt Pocock's skills (`claude plugin install mattpocock-skills@claude-plugins-official`), Superpowers (`/plugin install superpowers@claude-plugins-official`). Note: `no-session/pstack` is a fork of gstack, not Lauren Tan's pstack.

## Layout

```
plugin.json / .claude-plugin / .codex-plugin   manifests
skills/plan-guard/      SKILL.md + references (rules, drift signatures, templates, case, sources)
skills/drift-audit/     SKILL.md + references/report-template.md + scripts/drift-metrics.sh
skills/<personal>/      workstation skills
rules/                  OMP rule files (always-apply trigger, plan-file and delegation interrupts)
```
