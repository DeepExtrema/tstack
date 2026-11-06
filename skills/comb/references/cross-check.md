# Ledger cross-check

The agent that wrote the plan also graded which decisions are two-way. That grading is the weakest step in comb, so a fresh reviewer checks it before the owner sees the ledger.

Spawn one read-only subagent with a fresh context. Use a different model family from the one running comb when the harness allows; a cheap, fast model is enough. The brief carries:

- **Goal.** Find agent's calls that are really one-way, and cards that leak the agent's pick.
- **Inputs, as pointers.** The plan file (its `## Decisions`, `## Owner preferences` and the one-way list) and the ledger rows with their undo and expiry.
- **Per row, answer:** Does the undo exist? Point at the mechanism or say "unchecked". Does it expire before the owner would notice the decision? Does the row touch anything on the one-way list? Verdict: two-way, one-way or unclear, with one line why.
- **Per sealed card, answer:** Does option length, shape or wording point at the sealed letter?
- **Return:** one table, `| row | verdict | why |`, then any leaked cards. Nothing else.
- **Not doing:** no edits, no new options, no redesign of the plan.

Rows marked one-way or unclear become cards next phase. A leaked card is noted in the phase-end agreement check. The reviewer's one-line verdict goes in the status line above the ledger.
