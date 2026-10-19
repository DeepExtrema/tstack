---
description: plan-guard gate on plan files
condition:
  - "**/PLAN*.md"
  - "**/plan/**/*.md"
  - "**/*-plan.md"
  - "**/*_plan.md"
interruptMode: always
---
You are writing a plan file. Before it is written, run the `skill://plan-guard` gates (Step 0 size check, Step 1 restatement, G1–G10) and put the resulting `## Plan-guard` block at the top of the file: Goal, Done when, Budget, NOT doing, First slice, Stop rules, Confirm before, Decided by human. Include the PASS/REVISE verdict in your reply. If the gate was already run this session for this plan, say so and continue.
