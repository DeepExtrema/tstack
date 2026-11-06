# tstack

Skills that keep coding agents on the plan. Built after a $10 form-filling bot turned into a six-week, 18k-line root installer with six Linux users, signed documents, 46 sudo prompts, 274 continuation prompts, and zero real submissions.

Three core skills:

| Skill | When it runs | What it produces |
|---|---|---|
| `plan-guard` | Before any plan, brief, delegation, handoff, or 3+-step todo; when scope, infrastructure, security, or scale is proposed; after two failed fixes on one premise | A PASS/REVISE verdict across ten gates and a `## Plan-guard` block the plan carries (goal, done-when, budget, NOT doing, first slice, stop rules, confirm-before) |
| `drift-audit` | A project is already running and you want to know whether it derailed | An ON-TRACK / DRIFTING / DERAILED verdict with evidence, the shortest path back to one real artifact, a cut list, and a plan revision |
| `comb` | A plan, spec, upgrade or refactor needs the owner's decisions; a review would otherwise be prose walls plus multiple-choice questions; the owner says "comb" or that the output is overwhelming | Facts settled by lookup or run, the rest triaged by reversal cost against an owner-kept one-way list; about 3 owner cards per phase in dependency order, one self-contained card per turn in the terminal; the agent's pick sealed in the record before the card and revealed only after the owner commits; every other decision listed as an agent's call with its undo and expiry, cross-checked by a second model |

`plan-guard` and `drift-audit` are grounded in `skills/plan-guard/references/rules.md`: 70 rules, each with its source and a verbatim quote or number, drawn from Anthropic's and OpenAI's prompting guides, four research papers (Overeager Coding Agents, Asymmetric Goal Drift, Evaluating Goal Drift, IFScale), Lauren Tan's pstack principles, Matt Pocock's skills, Superpowers, gstack, HumanLayer, and the talks by Dex Horthy, Boris Cherny, Simon Willison, Jesse Vincent, Geoffrey Huntley and others. Retractions and disagreements between sources are recorded there too. `comb` borrows one rule each from i-have-adhd (first line is the action, restate state every turn, lists cap at 5), Superpowers brainstorming (options steer; three-pile sort), ken0nek decide-and-log (reversal cost decides who decides), show-me / visual-explainer (smallest view that makes the point) and gstack plan-eng-review (stakes if wrong, one-way door), and drops every "recommended" default.

`comb` 0.3.0 takes the following from a full read of both stacks. From Matt Pocock's skills: grilling's "facts are the agent's job" and dependency frontier; the measured result in `teach` that an instruction cannot stop the right answer landing in slot A (33 of 33), so order now comes from a shell shuffle; `pr`'s warning that the agent grading its own change is most suspect when it says "two-way"; `domain-modeling`'s glossary and three-test ADR bar; `to-questionnaire` and `wait-what`. From Lauren Tan's pstack: poteto-mode's rule to settle observable forks by running them, its autonomy grants and answers in the owner's own words; blast-radius's checked facts; show-me-your-work's cross-model review; `check-plan.mjs` as the model for the card lint. Matt's case against hard question caps turned the 3-card cap into a target that splits oversized phases.

The `skills/` folder also carries personal workstation skills (`omarchy`, `diagnose-crash`, and the `omarchy-end4-*`, `quickshell-*`, `tesseract-*`, `feynman-*`, `nimblemind-*` skills). They are machine-specific; ignore them elsewhere.

## Install

### OMP

```sh
git clone https://github.com/DeepExtrema/tstack ~/Work/tstack
omp plugin link ~/Work/tstack
```

Then add the skills you want to `skills.includeSkills` in `~/.omp/agent/config.yml` (at least `plan-guard`, `drift-audit` and `comb`). The `rules/` folder is loaded automatically: `plan-guard.md` is an always-apply reminder; `plan-guard-planfile.md` interrupts writes to `PLAN*.md`; `plan-guard-delegation.md` interrupts the first delegation of a session and checks the brief.

Or from the marketplace: `omp plugin marketplace add DeepExtrema/tstack` then `omp plugin install tstack@tstack`.

### Claude Code

```
/plugin marketplace add DeepExtrema/tstack
/plugin install tstack@tstack
```

Skills are then `/tstack:plan-guard`, `/tstack:drift-audit` and `/tstack:comb`. The OMP-specific rule files are ignored; put the one-line trigger from `rules/plan-guard.md` in your `CLAUDE.md`.

### Codex

```sh
codex plugin marketplace add DeepExtrema/tstack
codex plugin add tstack@tstack
```

Or copy `skills/plan-guard`, `skills/drift-audit` and `skills/comb` into `~/.codex/skills/` and put the trigger line in `AGENTS.md`.

## Use

- Writing a plan: run `plan-guard` first; prepend its block to the plan file. Re-run at phase boundaries, on every reviewer suggestion, and on every resume.
- Delegating: every brief carries Goal, Context, Constraints, NOT doing, Done when, Stop rules, Confirm-before (template in `skills/plan-guard/references/templates.md` §3).
- Suspecting drift: `drift-audit <project root>`. It writes `plan-audit/<date>-drift-audit.md` and `plan-audit/<date>-plan-revision.md` inside the project and does not touch anything else until you say so. Its numbers come from `skills/drift-audit/scripts/drift-metrics.sh`, which is read-only.
- Reviewing a design with the owner: `comb`. One decision card per turn; the owner answers before the sealed agent's pick appears. Ask in plain words for more detail, the agent's reasoning, the code view, the full map, or the rest of the agent's calls; "don't know", "your call", "later" and "stop" are handled too.

## Third-party stacks this does not vendor

Reinstall from their own sources: Lauren Tan's pstack (`/plugin marketplace add cursor/plugins`, `/plugin install pstack@cursor-plugins`), Matt Pocock's skills (`claude plugin install mattpocock-skills@claude-plugins-official`), Superpowers (`/plugin install superpowers@claude-plugins-official`). Note: `no-session/pstack` is a fork of gstack, not Lauren Tan's pstack.

## Layout

```
plugin.json / .claude-plugin / .codex-plugin   manifests
skills/plan-guard/      SKILL.md + references (rules, drift signatures, templates, case, sources)
skills/drift-audit/     SKILL.md + references/report-template.md + scripts/drift-metrics.sh
skills/comb/            SKILL.md (triage, card format, commit-then-reveal, ledger, record) + references/replies.md, references/cross-check.md + scripts/comb-card.sh (option order, card lint)
skills/<personal>/      workstation skills
rules/                  OMP rule files (always-apply trigger, plan-file and delegation interrupts)
```
