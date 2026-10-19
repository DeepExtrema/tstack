---
name: drift-audit
description: Audit a project that is already underway for goal drift and over-engineering; use when asked whether a project has derailed, is over-engineered, has lost its original goal, or needs its plan fixed, and whenever a project has run more than twice its estimate without the deliverable. Produces an evidence-backed ON-TRACK / DRIFTING / DERAILED verdict, the shortest path back, and a plan revision.
---

# drift-audit

Companion to `plan-guard`. plan-guard gates a plan before work; drift-audit measures a project that is already running against the goal it started with, then fixes the plan. Rules and sources: `skill://plan-guard/references/rules.md`; signatures: `skill://plan-guard/references/drift-signatures.md`; the case this was built from: `skill://plan-guard/references/greenfield-case.md`.

Read-only toward the project. The audit writes one report file and one proposed plan; it edits the project's own plan only on the owner's explicit go.

## Inputs to collect

1. Project root(s). Ask for the path if not given; also take any state dirs outside the repo (`~/.local/share/...`, `/etc/...`, `/opt/...`) the project writes to.
2. The stated goal. Look in this order and quote verbatim: a `## Plan-guard` block; PLAN/README/SPEC/BRIEF/ROADMAP; the first prompts of the project in the session archive (OMP: `archive.sessions(project=...)`, `archive.search(...)` in eval); the owner. If no written one-sentence goal exists anywhere, ask the owner for it before continuing. That is one of the few places asking is correct.
3. The original estimate and budget, if any were stated.
4. `skill://drift-audit/scripts/drift-metrics.sh <root> [extra dirs]` (path relative to this skill directory): deterministic numbers (LOC, attractor share, churn, constraint language, privilege markers). Re-run on subdirectories when generated artifacts (runs, snapshots, fixtures) inflate totals; say so.

## Procedure

### Step 1: restate the goal and the finish line

Write: goal (one sentence, user-visible), done-when (observable evidence), original estimate, budget. If any of these is missing from the project's own documents, that is finding F0.

### Step 2: delivery versus activity

Answer with numbers, not impressions (METR: felt speed is not delivery):
- Has the finish-line artifact ever been produced? When? How many times?
- Days elapsed versus estimate. Commits, LOC, versions, prompts/handoffs produced in that time.
- Where does the first real artifact sit in the dependency graph: how many features, stages, or services must complete before it?

### Step 3: drift signature scan

Go through `drift-signatures.md` section by section (plan, handoff, session, repo). For each signature found, record: the signature, the evidence (file:line, number, quote), and which gate it maps to (G1–G10). Pay particular attention to:
- Attractor share: LOC and files in security/privilege/signing/custody/audit/accounting paths versus LOC on the path to the artifact.
- Constraint ratchet: count "preserve / do not / must / never / authorized / exact reviewed" lines across the chronological handoffs; a rising count with no deletions is a finding.
- Manufactured irreversibility: points of no return, hash pins, signed artifacts, redacted errors.
- Scale and goal inflation: did the target number (users, cases, workers, budget) grow before the first success? Quote the date it grew.
- Parallelism before trust: lanes, swarms, multi-model panels started before one verified vertical slice.
- Approval inversion: confirmations demanded on reversible steps; none on irreversible ones.

### Step 4: guard efficacy

List every guard, refusal, gate, reviewer, or check that fired. For each: did it catch a real loss (overspend, data loss, duplicate irreversible action, credential leak) or a self-inflicted defect (typo, pin mismatch, format, import path)? Report the ratio. A guard that has never caught a real loss and costs a round trip is a candidate for removal (pstack fix-root-causes: a guard is a fix only when the state it handles is legitimate).

### Step 5: premise check

List the fixes that failed in sequence. Group them by the assumption they share. For any premise with two or more failed fixes, state the premise in one sentence and whether anyone tested it directly (pstack attack-the-premise). Untested premises are findings.

### Step 6: verdict

- ON-TRACK: artifact produced on schedule, or the first vertical slice is next and no signature maps to more than two gates.
- DRIFTING: no artifact yet and three or more gates have evidence, or the attractor share exceeds the share of code on the artifact path, or the constraint count is rising.
- DERAILED: elapsed time is more than twice the estimate with no artifact, or the goal has been replaced (the done-when in current documents names an intermediate, not the outcome), or guards have caught zero real losses across five or more firings.

### Step 7: shortest path back and plan revision

1. Write the shortest path to one real artifact from the current state, as a vertical slice: what to run first, what to skip, what to cut. Prefer deleting over compensating (laziness protocol; subtract before you add).
2. List what to cut, with the loss each item was supposed to prevent and why that loss is not material at the current stakes.
3. Run `skill://plan-guard` gates on the revised plan and include the verdict block.
4. List the scope decisions only the owner can make (cuts, irreversibility, budget, confirmation points).
5. Write the report to `<root>/plan-audit/<YYYY-MM-DD>-drift-audit.md` using `references/report-template.md`. Write the revised plan to `<root>/plan-audit/<YYYY-MM-DD>-plan-revision.md`. Do not modify the project's existing plan, code, or state. Then ask the owner whether to apply the `## Plan-guard` block and the revision to the live plan file.

## Reply format

Verdict line first, then the evidence table (signature, evidence, gate), then the shortest path as a numbered list, then the scope decisions, then the two file paths. Claims from the metrics script are measured; claims from reading are cited by file:line; anything else is marked [INFERENCE].
