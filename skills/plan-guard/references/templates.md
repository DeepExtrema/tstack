# Templates

Section 1–3 are plan-guard's own templates (synthesized; sources in `rules.md`). Section 4 is verbatim vendor text; pick only what the task needs. Stacking every snippet recreates the instruction-bloat problem.

## 1. Plan-guard block (prepend to every plan file)

```markdown
## Plan-guard
Goal: <one sentence, user-visible outcome>
Done when: <observable evidence: screenshot, receipt, command and its output, value read back>
Budget: <time box> | <money cap> | <max new files / lines>
NOT doing: <explicit list; name the drift attractors that apply>
First slice: <the thin end-to-end milestone that reaches "done when" before anything else is built out>
Stop rules: 2 same-premise failures -> write the premise and test it; 3 attempts -> BLOCKED; any scope change -> ask the human
Confirm before: <irreversible actions only: submit, pay, send, delete, force-push, deploy>
Decided by human: <scope decisions and dates>
```

## 2. Plan skeleton

Sources: HumanLayer `create_plan.md` headings (Desired End State, What We're NOT Doing, Automated/Manual Verification); Superpowers `writing-plans` ("the set of decisions the implementer cannot make alone"); Horthy's design-discussion/outline/plan split.

```markdown
# <Task> plan

## Plan-guard
<block from section 1>

## Current state
<facts about the code as it exists; file:line pointers; no recommendations>

## Desired end state
<what is observably true when done; how it is verified>

## What we're NOT doing
<explicit exclusions with the reason each was cut; no TODO for cut items>

## Decisions
<the decisions the implementer cannot make alone; each marked "human" or "agent call">

## Slices (vertical, in order)
### Slice 1: <reaches the finish line thinly>
- Changes: <files>
- Proof: <command and expected output, or the real-artifact check>
- Confirm before: <irreversible step, if any>
### Slice 2 ...

## Open questions
<must be empty before execution starts>
```

## 3. Delegation brief

Sources: OpenAI Codex best practices (Goal / Context / Constraints / Done when); Cherny (task, guardrails, exit criteria); HumanLayer (NOT doing); Anthropic Sonnet 5.5 (stop rule); pstack (attack-the-premise, prove-it-works, never-block); Qu et al. (scope of consent).

```markdown
GOAL (one sentence, user-visible outcome):
  <...>

DONE WHEN (observable evidence you must produce):
  <...>

CONTEXT (pointers, not pasted history):
  <files to read; existing code to reuse; where data lives>

CONSTRAINTS:
  - Budget: <time box, $ cap, max new files/lines>
  - Edit only: <paths>
  - Irreversible actions (<list>) require my explicit confirmation.

NOT DOING (out of scope; do not build, mention in the report instead):
  - No new services, daemons, system users, signing, hashing, manifests, or security mechanisms.
  - No refactors, abstractions, or features beyond the goal.
  - <task-specific exclusions>

SCOPE CHANGES:
  If the goal cannot be met inside this brief, stop and report SCOPE_CHANGE_REQUESTED with one sentence: what and why.

FAILURE RULE:
  If two fixes resting on the same assumption fail, stop, write the assumption down, and test it before trying anything else. After 3 failed attempts, report BLOCKED with the premise you tested.

FINISH:
  When DONE WHEN is met and checked on the real artifact, stop and report DONE with the evidence. No extra review rounds, hardening, tests, or docs unless asked.
```

Delegate report format: `DONE` + evidence (command and output, screenshot path, value read back) | `BLOCKED` + the premise tested and the observation | `SCOPE_CHANGE_REQUESTED` + one sentence.

## 4. Handoff (new session or model-to-model)

Sources: Horthy progress.md fields; Pocock handoff rules; Huntley (reload the spec every loop).

```markdown
# Handoff: <purpose of the next session in one line>
Goal (verbatim from the plan-guard block): <...>
Done when: <...>
Approach chosen: <...>
Done so far: <pointers to commits/files, not narrative>
Current failure: <exact error, exact file:line>
Next single step: <one item>
Constraints still live: <pruned list; each traces to the goal or a demonstrated incident>
Dropped since last handoff: <constraints removed and why>
Suggested skills: <...>
```

Rules: pointers over copies; redact secrets; store disposable handoffs outside the repo; a human edits any model-written handoff before it is used; the "constraints still live" list may shrink but may not grow without a named incident.

## 5. Verbatim vendor snippets

Anthropic, Prompting best practices, "Overeagerness" (written for Opus 4.5/4.6):
```text
Avoid over-engineering. Only make changes that are directly requested or clearly
necessary. Keep solutions simple and focused:

- Scope: Don't add features, refactor code, or make "improvements" beyond what was
asked. A bug fix doesn't need surrounding code cleaned up. A simple feature doesn't need
extra configurability.

- Documentation: Don't add docstrings, comments, or type annotations to code you didn't
change. Only add comments where the logic isn't self-evident.

- Defensive coding: Don't add error handling, fallbacks, or validation for scenarios
that can't happen. Trust internal code and framework guarantees. Only validate at system
boundaries (user input, external APIs).

- Abstractions: Don't create helpers, utilities, or abstractions for one-time
operations. Don't design for hypothetical future requirements. The right amount of
complexity is the minimum needed for the current task.
```

Anthropic, Prompting Claude Opus 5, "Task scope and over-verification":
```text
Deliver what was asked, at the scope intended. Make routine judgment calls yourself, and check in only when different readings of the request would lead to materially different work. If the request seems mistaken or a better approach exists, say so in a sentence and continue with the task as asked rather than quietly narrowing, widening, or transforming it. Finish the whole task, and stop short of actions that are clearly beyond what was asked.
```

Anthropic, Prompting Claude Opus 5, "Controlling subagent spawning":
```text
Delegate to a subagent only for large tasks that are genuinely independent and parallelizable, such as a wide multi-file investigation. Do not delegate work you can finish yourself in a handful of tool calls, and do not use subagents to verify or double-check your own work. If one subagent can complete the task, use one rather than several, and keep spawn counts low.
```

Anthropic, Prompting Claude Sonnet 5.5, "Steer initiative and scope" (second paragraph alone limits additions; measured ~1/3 session-cost cut at `max` with the review-restraint version):
```text
When the work the user asked for is done and checked, stop and report. Don't add features, tests, files, docs or refactors that weren't asked for. If you think one would help, mention it at the end instead of doing it.
```
```text
When the work the user asked for is done and its checks pass, stop and report. Don't start extra rounds of review or hardening on your own, and don't launch reviewer sub-agents unless the user asked for a review. If you think a deeper review is worth doing, say so at the end.
```
```text
When the user asks for ideas, options or a plan, give them that and stop. Don't start building or changing anything until they say to go ahead.
```

Anthropic, Prompting best practices, safety boundary:
```text
Consider the reversibility and potential impact of your actions. You are encouraged to take local, reversible actions like editing files or running tests, but for actions that are hard to reverse, affect shared systems, or could be destructive, ask the user before proceeding.
```

Anthropic, Prompting best practices, commitment:
```text
When you're deciding how to approach a problem, choose an approach and commit to it. Avoid revisiting decisions unless you encounter new information that directly contradicts your reasoning. If you're weighing two approaches, pick one and see it through. You can always course-correct later if the chosen approach fails.
```

OpenAI Codex prompting guide, plan discipline:
```text
- Skip using the planning tool for straightforward tasks (roughly the easiest 25%).
- Do not make single-step plans.
- Plan closure: Before finishing, reconcile every previously stated intention/TODO/plan. Mark each as Done, Blocked (with a one‑sentence reason and a targeted question), or Cancelled (with a reason). Do not end with in_progress/pending items.
- Promise discipline: Avoid committing to tests/broad refactors unless you will do them now. Otherwise, label them explicitly as optional "Next steps" and exclude them from the committed plan.
```
```text
Finish the website or app to completion, within the scope of what's possible without adding entire adjacent features or services. It should be in a working state for a user to run and test.
```

OpenAI GPT-5 prompting guide (archived), bounded context gathering:
```text
Depth:
- Trace only symbols you'll modify or whose contracts you rely on; avoid transitive expansion unless necessary.
```

OpenAI AGENTS.md example of a durable rule:
```text
Ask for confirmation before adding new production dependencies.
```

Claude Code best practices, reviewer scoping:
```text
Use a subagent to review the rate limiter diff against PLAN.md. Check that every requirement is implemented, the listed edge cases have tests, and nothing outside the task's scope changed. Report gaps, not style preferences.
```

Qu et al., consent boundary (benchmark template, adapt the content):
```text
Scope of consent:
Authorized: <A>
OUT OF SCOPE: <NOT_A>
```

Arike et al., strong goal elicitation (adapt the goal):
```text
Remember: your one and only goal is to <goal>.
```

HumanLayer research_codebase, documentarian boundary:
```text
- DO NOT suggest improvements or changes unless the user explicitly asks for them
- DO NOT perform root cause analysis unless the user explicitly asks for them
- DO NOT propose future enhancements unless the user explicitly asks for them
- DO NOT critique the implementation or identify problems
- DO NOT recommend refactoring, optimization, or architectural changes
- ONLY describe what exists, where it exists, how it works, and how components interact
```

pstack prompt fragments:
```text
/poteto-mode read this thread. restate the underlying issue in your own words, in plain english. don't change any code yet.
```
```text
i said the goal is to repro. i did not ask for a fix yet.
```
```text
/poteto-mode turn this design into a plan. small verifiable PRs, each with its own proof.
```
```text
/poteto-mode im going to bed. migrate every caller to the new parser in a fresh worktree off <base>.
done means zero old callers, all parser fixtures pass, old api deleted.
keep a decision log. don't ask me before committing.
/loop until done. if you're truly stuck after a few hours, stop and write up why.
```
