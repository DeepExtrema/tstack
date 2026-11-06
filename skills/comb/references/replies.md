# Replies other than a pick

Match the owner's words to the closest case. Each case ends with what goes into `## Decisions` or onto a list in the plan.

- **Don't know.** If a fact would settle it, it was a triage row 0 miss: find the fact, then show the card again. If the knowledge sits with someone else, tell the owner that `to-questionnaire` turns the question into a document for that person (the owner runs it; comb never invokes it), and move the card to **deferred** with who it waits on. If the choice can be made two-way (triage row 3), do that and record `by: delegated`.
- **Your call.** Quote the sealed line, record `by: delegated`, and state in one line the assumption the pick rests on. This covers this card only, unless the owner widens it ("the rest too"). Cards on the one-way list are never delegated silently: they go to **deferred** with the sealed pick noted as the default.
- **Didn't follow** ("wait what", "?", "I'm lost"). Render the same card again inside the same 20-line cap, adding the missing premise and plainer words, not more prose. Count it as a readability failure in the phase-end check.
- **Later.** Move the card to **deferred** with what it waits on. The position line shows the count.
- **Stepping away, or no answer while work continues.** The sealed pick is the planning default only. Agent's calls that do not depend on the open card proceed. Nothing that depends on the open card is executed. On return, show at most 5 one-line parked items, then the open card.
- **Grant** ("decide it all", "full autonomy until X"). Decisions inside the grant become agent's calls, recorded `by: grant` and reported without a question. A decision outside the grant's scope, or on the one-way list, gets its sealed pick applied only when it is two-way; otherwise it goes to **deferred**. Each report says, in plain words, what the owner could say to change it. Asking to see the plan is not a grant.
- **Stop or wrap up.** Accept the current state. Unshown cards go to **deferred**. Show the ledger, then stop.
- **Hybrid** ("A, but with B's ..."). Record it as the owner's own pick, check the undo again for the combined choice, and log anything new it implies as an agent's call.
- **Direct order** ("do B"). Record `by: owner`. No card, no reveal.
