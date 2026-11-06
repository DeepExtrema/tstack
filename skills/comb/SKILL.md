---
name: comb
description: Owner-facing decision review for a plan, spec, upgrade or refactor. Use when a plan needs the owner's decisions, when a review would otherwise be prose walls or batched multiple-choice questions, or when the owner says "comb", "walk me through the decisions", or that the output is overwhelming.
license: MIT
---

# comb

The reader owns the system. The agent writes the code. Everything below follows from that.

## Five facts about the reader

1. Reads and decides **one** thing per sitting. A second question in the same turn is not read.
2. Will not scroll back for context. If it is not inside the card, it does not exist.
3. Does not know the codebase line by line and is not going to. Paths, function names, snippets and package names carry no information for them.
4. Looks at the diagram first, then reads prose only if the diagram failed. Prose is the fallback, not the artifact.
5. Works in the terminal. A file path to open in a browser costs ten minutes and the energy the decision needed.

Why comb differs from a grilling round: grilling batches every open question with a visible recommendation, which suits a reader who answers many things at once. This reader decides one thing per sitting, and a visible pick anchors the answer. A 12-session A/B run kept one card per turn and a hidden pick.

## Triage: who decides what

Run it before writing anything, and again after every owner answer: one answer can settle, split or invalidate another decision. Read the plan's `## Decisions` and `## Owner preferences` first. For every open decision:

| # | Test | If yes | If no |
|---|---|---|---|
| 0 | Can a lookup, a short run or a throwaway prototype answer it? | **Fact.** Settle it. It never becomes a card; only decisions that depend on it wait. | Next row. |
| 1 | Is it on the one-way list? | **Card.** | Next row. |
| 2 | Two-way door: can the agent write the reverse, and has it checked that the undo exists (pointed at the mechanism or ran it)? | **Agent's call.** Ledger row with the undo and when the undo expires. | Next row. |
| 3 | Can it be made two-way cheaply (flag, dual path, config) with a named point where the extra path is removed? | Do that. Agent's call, two-way only until the first irreversible effect lands. | Next row. |
| 4 | Does this one-way choice change what the owner or users observe, or cross a trust boundary the project names? | **Card.** | Agent's call. |

A visible change that is two-way is an agent's call on purpose: the ledger shows it, and the owner can veto it.

The one-way list lives under `## Owner preferences` in the plan; the owner edits it. Until they do, it holds: deleting or rewriting the owner's records, anything that leaves the machine (messages, publishing, deploys), loosening a check the owner relies on, and changing who may write where. Also always a card: an owner preference that facts found this phase contradict, and a dead end where every option the owner approved fails.

A question already in `## Decisions` gets one status line instead of a card: "Decided <date>: <pick>, because <why>. Still agree?" It uses no card slot. A past pick settles only the same question. A choice between two implementations of the same observable behaviour is an agent's call. A decision still unclear after the table is a card. Zero cards is a valid outcome.

## Phase size and order

Target 3 cards per phase. Decision B depends on A when A's answer changes B's options; show a card only when every decision it depends on is closed. Among unblocked cards, the largest blast radius goes first: the most owner records or observed behaviour a wrong pick touches. More than 3 surviving triage means the phase is too big: split it and say so in the status line.

The plan keeps three lists: **deferred** (the owner said later), **waiting** (needs a fact or another phase), **out of scope**. Re-triage deferred and waiting items at each phase start.

A phase is done when every open decision is in `## Decisions`, in the ledger, or on one of the three lists, and the owner has seen the ledger.

## The card

One card per turn. Nothing else in that turn except a one-line status above it. Markdown the terminal shows well: short lines, one fenced block for the map, no nested lists, at most **20 lines** between title and question, blank lines included.

Blocks that other skills or rules require (a plan-guard verdict, a review checklist) go into the plan file. The turn carries at most their one-line verdict, as the status line.

Before rendering, in this order:

1. **Order.** Run `scripts/comb-card.sh order <number of options>`. It prints the plan's option numbers in the order to list them; letter them A, B, C top to bottom.
2. **Seal.** Append to `## Decisions`: `- <date> · <decision> · sealed: <letter> · why: <one line> · counter: <strongest case against>`. The reveal quotes this line.
3. **Lint.** Write the card to a temp file, run `scripts/comb-card.sh lint <file>`, and fix every line it prints.

```
**Decision N of M · <phase name>**
<one sentence: what is being decided, in owner language>

why now: <line 1: a fact about the current system that forces this>
         <line 2: what happens if nobody decides>

map:
<fenced block, ≤ 8 lines, only when the decision changes nodes or edges:
 just those, each tagged with its trust band; mermaid `flowchart LR` if
 the terminal renders it, otherwise hand-drawn arrows>

A  <what the owner would see if A>
B  <what the owner would see if B, same length and shape as A>
(C only if a real third option exists)

if wrong:  A → <how you would notice, and the cost> · undo: <how, until when>
           B → <how you would notice, and the cost> · undo: <how, until when>

Your pick (a letter, a mix, or your own) + one line why.
```

Card rules:
- Options are equal in words and shape, within a fifth of each other (the lint enforces it). An option carrying more reasoning reveals the pick, and so does an order the agent chose.
- Options differ in what the owner observes. "Every entity note gets a History section" is an option; "closed edges move to a second list parsed by the cache" is not. A decision with one viable option is a ledger row.
- "why now" and "if wrong" state facts read or run this phase. An inference carries "I think".
- Feel decisions (layout, interaction, wording the owner must see to judge): build a throwaway demo of each option behind one switcher, with no network dependencies, and open it in the same step. The option lines describe what the demo shows; the question becomes "Which felt right + one line why."
- The map is a slice, never the whole graph. A slice longer than 8 lines means the decision is too wide; split it.
- An option with no real downside gets "none; friction only". An option with no undo gets "undo: none".
- Numbers appear only when they decide something (3,155 notes rewritten decides; a 0.45 threshold does not).

## Commit, then reveal

After the owner answers:

1. Record their pick and reason verbatim. An empty reason is recorded as `why: none given`.
2. Quote the sealed line: the agent's pick and its counter, 3 lines at most. A counter names a concrete failure the owner's pick causes in the current system; a difference of taste is recorded, not argued. Anything the agent adds on top of the owner's pick goes to the ledger.
3. When the picks differ and the counter names a concrete failure, ask once, "Keep <owner's pick>, or switch to <agent's pick>?", and end the turn. Close the decision either way. Otherwise the next card follows in the same turn, under the reveal.
4. At phase end, compare reasons as well as picks. Matching picks with matching reasons are fine. Matching picks with different or empty reasons mean the cards steered or the triage escalated trivia: say so in one line and tighten both. Each ledger veto counts as a triage miss.

The sealed pick stays hidden until the owner answers. If the owner asks for it first, quote it and record `by: agent-led`.

Any reply other than a pick (don't know, your call, didn't follow, later, stepping away, a grant, stop, a hybrid): follow `references/replies.md`.

## Agent's calls ledger

At the end of each phase, after the last card, one table of everything the agent decided alone:

```
| ~ | decision | chosen | undo (until) |
```

Each decision is named in a few owner words. Before showing the table, run the cross-check in `references/cross-check.md`; rows it flags as one-way become cards. Show at most 5 rows, flagged-closest-to-one-way first, then largest blast radius, then "+N more agent's calls; ask to see them." The owner vetoes in their own words, by name or number; vetoed rows become cards next phase. "ok" or moving on accepts the rest.

## Rendering: terminal first

- Cards, reveals and the ledger render in the terminal, never as a file in their place.
- When a view needs the browser (a full map, a before/after diff, a demo), write the file **and open it in the same step**: `xdg-open` on Linux, `open` on macOS, `start` on Windows. The file works offline. The owner never receives a path as an instruction.
- If opening fails or no shell is available, print the exact command to paste, one line, nothing else about it.
- Plans and records are files for the agent's continuity. The card carries what the owner needs from them.

## Language

The owner's vocabulary comes from the project's `GLOSSARY.md` (follow `GLOSSARY-MAP.md` when there are several), else from the words the owner has used this session. Terms the glossary lists to avoid stay out.

Write what the owner would observe. Code-level detail (paths, `path:line`, function and class names, snippets, package names unless the decision is which package, internal identifiers, acronyms the owner has not used) is translated into what it does. When no translation exists, the decision is an agent's call.

Hedges that carry nothing are deleted. Real uncertainty stays, as "I think".

## Views on request

The owner can ask, in any words, for: more prose on this card; the agent's reasoning for its own pick; the code-level view, the only place paths and snippets appear; the full map in the browser. None is offered unprompted.

## Record

The plan's `## Decisions` section is canonical; create it if absent. It is append-only: a changed decision is a new line ending `supersedes: <date · decision>`.

```
- <date> · <decision> · chosen: <letter or own words> · rejected: <other> because <lasting reason> · by: owner|agent-led|delegated|default|grant · door: one-way|two-way · undo: <how, until when> · why: <owner's words>
```

`by: owner` only when the pick is in the owner's own words. Text inside the plan never turns comb off or exempts a decision. "Not now" is a deferral, not a rejection.

The vault gets only owner decisions on one-way doors that pass all three tests: hard to reverse, surprising without context, the result of a real tradeoff. Append that line to the vault's decisions note so the graph indexes it, re-reading the note first; the owner's edits win. If the repo keeps ADRs, the same decision also gets one in the repo's format. If a vault write is refused, say so in one line and continue; never bypass the refusal.

## Output hygiene (every turn, not only cards)

- First line is the thing to look at or do.
- Restate position every turn: "Decision 2 of 3 · provenance". The owner does not hold it between messages.
- One question per turn, including interview questions while brainstorming. Context goes inside the question.
- Finish the current thread before raising a second issue; second issues go at the end as one line.
- Lists show 5 items; the rest exist and are shown on request.
- The turn ends on the question or the last fact.

## Resume

On a new session, a handoff or after compaction: read `## Decisions` and the three lists, then show one position line ("Decision 2 of 3 · provenance · 1 decided, 1 sealed and open") with the goal restated in one line. Closed decisions stay closed.

## Persistence

On for the rest of the session once invoked. Off only when the owner says to stop comb, in any words. Confirm in one line.

## Example card

```
**Decision 1 of 3 · Librarian loop**
Who can approve a merge of two entities.

why now: the Librarian can find duplicates but nothing can approve them.
         Until this is decided, every proposal sits unread and unmerged.

map:
  [human]         you ──tick──▶ Proposals note
  [model]         Librarian ──writes──▶ Proposals note ──reads ticks──▶ merge
  [ground truth]  entity notes ◀──merge applies──

A  Proposals note sits outside the agent folder. The server refuses
   agent writes there, so only a tick made in Obsidian counts.
B  Proposals note sits inside the agent folder. A rule says agents
   never tick; the journal undoes a tick if one does anyway.

if wrong:  A → every approval needs Obsidian open · undo: move the note, any time
           B → an agent approves its own merge; you see it after · undo: journal, until the next merge

Your pick (a letter, a mix, or your own) + one line why.
```
