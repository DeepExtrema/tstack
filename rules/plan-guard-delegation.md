---
description: plan-guard gate on delegation briefs
scope: "tool:task"
condition: "(?s)."
interruptMode: always
agents:
  - main
---
You are spawning a delegate. Every brief must carry: Goal (one sentence, user-visible), Done when (observable evidence), Context as pointers, Constraints (budget, edit paths, confirm-before list), NOT doing (name the drift attractors: security/hardening, new services or users, signing/hashing, abstractions, adjacent features, scale), Stop rules (2 same-premise failures -> test the premise; 3 attempts -> BLOCKED; scope change -> SCOPE_CHANGE_REQUESTED), and the finish instruction "when done and checked on the real artifact, stop and report DONE with evidence; no extra review, hardening, tests, or docs unless asked". Template: `skill://plan-guard/references/templates.md` section 3. If the brief already has these, proceed.
