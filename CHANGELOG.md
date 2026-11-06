# Changelog

## 0.3.0 (2026-11-04)

- comb: a new first triage row settles anything a lookup, short run or prototype can answer, so facts are never carded. An owner-kept one-way list is checked before reversibility. Undos must be checked and carry an expiry.
- comb: the agent's pick is sealed into `## Decisions` before the card, and the reveal quotes it. Option order comes from `scripts/comb-card.sh order`, options are equal in length, and `scripts/comb-card.sh lint` checks every card.
- comb: re-triage after every answer. Cards go in dependency order. 3 cards per phase is a target; more means split the phase. Zero cards is valid, phase completion is defined, and there are deferred, waiting and out-of-scope lists.
- comb: replies other than a pick (don't know, your call, didn't follow, later, stepping away, grant, stop, hybrid) are handled in `references/replies.md`. Requests are taken in plain words instead of tokens.
- comb: a cross-model ledger check (`references/cross-check.md`) runs before the owner sees agent's calls. The phase-end agreement check compares reasons, not only picks.
- comb: the record is append-only with `rejected:` and `supersedes:`. A past decision is re-shown instead of re-asked. The vault gets only owner one-way decisions that pass the three ADR tests.
- comb: vocabulary comes from the project's `GLOSSARY.md`, live demos are used for feel decisions, and the `visual-spec` branch (no such skill is installed) is removed. The description is cut to its triggers.

## 0.2.0 (2026-11-03)

- comb: owner-facing design review. Reversal-cost triage, ≤3 owner cards per phase, one card per turn in the terminal, commit-then-reveal, agent's-calls ledger with undo, `expand`/`why`/`code`/`map` on demand.
- comb: other skills' verdict blocks go to the plan file, not the card turn; a pick the agent disagrees with ends the turn on the switch question; agent add-ons to the owner's pick go to the ledger. Found by an A/B run of 12 sessions on the Tesseract plan.

## 0.1.0 (2026-10-19)

- plan-guard: ten-gate plan review with sourced rulebook, drift signatures, templates, Greenfield case.
- drift-audit: ON-TRACK / DRIFTING / DERAILED audit of running projects with read-only metrics script and report template.
- OMP rules: always-apply trigger, PLAN*.md write interrupt, delegation-brief interrupt.
- Personal workstation skills carried along.
