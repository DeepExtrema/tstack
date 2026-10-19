---
name: plan-guard
description: Gate against goal drift and over-engineering; run before writing, approving, delegating, or resuming any plan, brief, feature list, handoff, or 3+-step todo, when new infrastructure, security, services, abstraction, or scale is proposed, and after two failed fixes on one premise. Produces a PASS/REVISE verdict and the plan-guard block the plan must carry.
---

# plan-guard

Why this exists: a $10 form-filling bot became a 6-week, 18k-line root installer with 6 Linux users, signed documents, 46 sudo prompts, 274 continuation prompts that only ever added "preserve / do not weaken" rules, and 0 real submissions. Every rule below traces to a source in `references/rules.md`; the case is in `references/greenfield-case.md`.

## When to run

- Before writing or approving a plan, PLAN.md, feature list, roadmap, or a todo list with 3+ steps.
- Before every delegation brief (task tool, Codex, subagent, overnight run).
- When resuming from a handoff, "continue from", checkpoint, or model-written brief.
- When anyone (agent, reviewer, subagent) proposes new infrastructure, security, services, users, signing, abstraction, scale, or "while we're here" work.
- After two fixes that rest on the same assumption have failed.

## Step 0: size it

If the whole change can be described in one sentence and touches one or two files with an obvious approach, do not plan. Say so and do the change. (Claude Code best practices; pstack multi-phase step 1; Codex: skip planning for the easiest ~25%.)

## Step 1: restate before anything else

Write, in your own words: the user's goal, the problem it solves, and the observable finish line. If the finish line is not observable (a screenshot, a receipt, a passing command, a value read back), ask one question now. This is one of the few places asking is correct.

## Step 2: the gates

Run every gate. Each has a FAIL condition. One FAIL means the verdict is REVISE.

G1 Finish line. The plan states one user-visible outcome in one sentence, a "done when" with evidence, and budgets (time box, money cap, max new files/lines). FAIL: done-when names an intermediate (installed, migrated, hardened, qualified) instead of the outcome.

G2 Non-goals. The plan has a "NOT doing" list. It names the drift attractors that apply: security/privacy hardening, privilege separation, signing/hashing/manifests, custody/authority/audit documents, new services/daemons/users, frameworks and abstractions, "comprehensive" coverage, accounting precision beyond the stakes, adjacent features, scale targets. FAIL: no list, or an attractor is in scope without a human decision recorded.

G3 First slice is vertical. The first milestone reaches the finish line end to end, thinly, before any layer is built out. FAIL: the first real artifact appears after more than ~20% of the plan, or the phases are "all data layer, then all services, then all UI".

G4 Proportion. Every guard, mechanism, review step, or abstraction names the concrete loss it prevents and its size. A guard is a fix only when the state it handles is legitimate. FAIL: a mechanism defends a speculative threat, or complexity exceeds the budget (challenge at >8 files or >2 new services; reduce scope at >15 files).

G5 Reversibility and ceremony. No manufactured points of no return, no hash-pinning or signing of ordinary artifacts, plaintext errors. Human confirmation is reserved for irreversible actions (submit, pay, send, delete, force-push, deploy). FAIL: reversible steps need approval, or an irreversible step has none.

G6 Proof per unit. Each unit ends with a check on the real artifact (run the feature, read the value, exercise the running app), not "tests pass" or a self-report. For long runs, a separate evaluator negotiates "done" before the builder starts. FAIL: any unit whose completion is asserted rather than observed.

G7 Instruction and context hygiene. The brief carries only constraints that trace to the goal or a demonstrated incident; inherited "preserve/do not" lines are pruned, not accumulated. No model-written brief is passed on unedited. A handoff states: goal verbatim, done-when, approach, done so far, current failure, next single step, live constraints. FAIL: the constraint count grows across handoffs, or the brief never mentions the finish line.

G8 Failure rules. The plan states: after two fixes on one premise fail, write the premise down and test it before a third; after three attempts, report BLOCKED; a time box with a kill criterion; any scope change is a human decision, not a reviewer suggestion. FAIL: any of the four missing.

G9 Parallelism after trust. No parallel lanes, swarms, or multi-model panels before one agent has produced one verified vertical slice. FAIL: lanes on day 1.

G10 Scale after success. No scale targets (N workers, N concurrent cases, budget raised) before the first real success. FAIL: a scale number precedes the first artifact.

## Step 3: verdict

Output exactly:

```
PLAN-GUARD: PASS | REVISE | SKIP (one-sentence change)
G1 finish line .... PASS|FAIL: <required edit>
... G10
Scope decisions needed from the human: <list or none>
```

On REVISE, rewrite the plan and re-run the gates once. Then prepend this block to the plan file so every later session reads it:

```
## Plan-guard
Goal: <one sentence>
Done when: <observable evidence>
Budget: <time box> | <money cap> | <max files/lines>
NOT doing: <list>
First slice: <the thin end-to-end milestone>
Stop rules: 2 same-premise failures -> test the premise; 3 attempts -> BLOCKED; scope change -> ask
Confirm before: <irreversible actions only>
```

## Step 4: during execution

At each phase boundary, before adding any mechanism, on every reviewer suggestion, and on every resume, answer in one line each:

1. Is this step on the shortest path to the finish line?
2. Did the goal, done-when, or NOT-doing list change? If so, who decided?
3. Have two fixes failed on one premise? Then stop and test it.
4. Is this a scope change? Then ask, do not build. Park it in a separate handoff.
5. Is "done" being claimed from a proxy? Then run the real check.

When corrected more than twice on the same issue, or when the context is dominated by failed attempts, start a fresh session from the plan-guard block, not from the conversation.

## Delegation briefs

Every brief carries: Goal, Context (pointers, not history), Constraints, NOT doing, Done when, Stop rules, Confirm-before list. Template and verbatim vendor snippets: `references/templates.md`. Report format from delegates: DONE with evidence | BLOCKED with the premise tested | SCOPE_CHANGE_REQUESTED with one sentence.

## References

- `references/rules.md`: every rule above with its source, quote, and number.
- `references/drift-signatures.md`: what drift looks like in a plan, a brief, a transcript, and a repo.
- `references/templates.md`: plan block, delegation brief, handoff, verbatim Anthropic/OpenAI scope snippets.
- `references/greenfield-case.md`: the derailment this skill was built from.
- `references/sources.md`: bibliography.
