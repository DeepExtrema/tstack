---
name: comb
description: Design, plan and architecture review written for the system owner, not the coder. Use whenever a plan, spec, upgrade or refactor needs the owner's decisions, when a review would otherwise produce prose walls plus multiple-choice questions, or when the owner says "comb", "/comb", "walk me through the decisions", or that the output is overwhelming. Triage decisions by reversal cost, escalate at most 3 per phase, render one self-contained decision card per turn in the terminal, make the owner commit before the agent's pick is shown, and list every other decision as an agent's call with its undo.
license: MIT
---

# comb

The reader owns the system. The agent writes the code. Everything below follows from that.

## Five facts about the reader

1. Reads and decides **one** thing per sitting. A second question in the same turn is not read.
2. Will not scroll back for context. If it is not inside the card, it does not exist.
3. Does not know the codebase line by line and is not going to. `file:line`, function names, snippets and library names carry no information for them.
4. Looks at the diagram first, then reads prose only if the diagram failed. Prose is the fallback, not the artifact.
5. Works in the terminal. A file path to open in a browser costs ten minutes and the energy the decision needed.

## Triage: who decides what

Run this before writing anything. For every open decision in the plan:

| Test | If yes | If no |
|---|---|---|
| Can the agent write the reverse of this choice? (ken0nek test) | **Agent's call.** Decide it, log the undo. | Go to the next row. |
| Can it be made reversible cheaply (feature flag, dual-write, both variants behind config)? | Do that. It becomes an agent's call. | Go to the next row. |
| Does it change what the owner sees in Obsidian or in an agent's answer, or cross the human-interlock or ground-truth band? | **Owner's decision.** Make a card. | Agent's call; log it. |

Hard caps: **3 cards per phase**, **1 card per turn**. If more than 3 survive triage, cards go in order of blast radius; the rest wait for the next phase and are named in one line in the ledger.

Never escalate a choice between two implementations of the same behaviour (library, threshold, storage format with no visible effect). Never escalate anything whose answer is in the owner's stated preferences or earlier decisions.

## The card

One per turn. Nothing else in that turn except a one-line status above it. Rendered in markdown that the terminal shows well: short lines, one fenced block for the map, no nested lists, **20 lines maximum** between title and question.

Blocks that other skills or rules require (a plan-guard verdict, a review checklist) go into the plan file, never into the turn. The turn carries at most their one-line verdict, as the status line.

```
**Decision N of M · <phase name>**
<one sentence: what is being decided, in owner language>

why now: <line 1: what in the current system forces this>
         <line 2: what happens if nobody decides>

map:
<fenced block, ≤ 8 lines: only the nodes and edges this decision changes,
 each tagged with its trust band; mermaid `flowchart LR` if the terminal
 renders it, otherwise hand-drawn arrows>

A  <what you would see in Obsidian / in an agent's answer if A>
B  <same for B>
(C only if a real third option exists)

if wrong:  A → <stake> · undo: <how, one clause>
           B → <stake> · undo: <how, one clause>

Your pick + one line why.
```

Card rules:
- No recommendation, no "(recommended)", no ordering that hints. Options are listed in the order they appeared in the plan.
- "why now" states facts about the current system, never "as discussed above".
- Options describe observable behaviour. "Every entity note gets a History section" is an option. "Closed edges move to a second list parsed by the cache" is not.
- The map is a slice, never the whole graph. If the slice needs more than 8 lines the decision is not scoped tightly enough; split it.
- "if wrong" is one clause per option. If an option has no real downside, say "none; friction only".
- Numbers only when they decide something (3,155 notes rewritten is a number that decides; 0.45 threshold is not).

## Commit, then reveal

After the owner answers:

1. Record their pick and reason verbatim.
2. Show the agent's pick and the single strongest counter-argument to the owner's pick, 3 lines maximum. Anything the agent decides on top of the owner's pick is an agent's call: it goes in the ledger, not here.
3. If the owner's pick and the agent's pick differ, ask once whether they want to switch, and stop the turn there. Then close the decision either way. If the picks match, the next card follows in the same turn, under the reveal.
4. Track agreement across the phase. If the owner agrees with the agent on every card, say so at the end of the phase: it means the cards were unreadable or the triage escalated trivia. Tighten both.

Never show the agent's pick before the owner has answered. If the owner asks for it first, give it, mark the decision as agent-led in the record.

## Agent's calls ledger

At the end of each phase, after the last card, one table of everything the agent decided alone:

```
| ~ | decision | chosen | undo |
```

One line per row, same language rules as cards. Show at most 5 rows; if there are more, show the 5 with the largest blast radius and say "+N more; say `ledger` to see them". The owner vetoes by number. Vetoed rows become cards next phase.

If `visual-spec` is loaded, these rows go into its end-of-turn change delta as `~` entries instead of a separate table.

## Rendering: terminal first

- Everything above renders in the terminal. Do not produce an HTML or markdown file in place of a card.
- When a view needs the browser (a full map, a before/after diff), write the file **and open it in the same step**: `xdg-open` on Linux, `open` on macOS, `start` on Windows. The owner never receives a path as an instruction.
- If opening fails or no shell is available, print the exact command to paste, one line, nothing else about it.
- Plans and records are written to files for the agent's continuity. The owner is never asked to read them; the card carries what they need.

## Language

Allowed vocabulary is what the owner uses: note, entity, edge, relation, vault, graph, agent, proposal, Librarian, index, search, merge, retire, owner, trust band names.

Banned in anything the owner reads: `path:line`, function and class names, code snippets, library and package names (unless the decision is which library), internal identifiers, acronyms not already in the owner's vocabulary. Translate each into what it does or what the owner would observe. If a translation is impossible, the decision is an agent's call.

Hedging adverbs that carry no information are deleted. A hedge that carries real uncertainty stays.

## Expand on demand

The owner can ask, per card:
- `expand` → prose for this card only, headed, no longer than it needs.
- `why` → the agent's reasoning for its own pick.
- `code` → the code-level view, with paths and snippets. Only here.
- `map` → the full map opened in the browser.

Nothing above is offered unprompted.

## Record

Each decided card is appended to the plan's `## Decisions` section (create it if absent):

```
- <date> · <decision> · chosen: <A/B> · by: owner|agent · door: one-way|two-way · undo: <how> · why: <owner's line>
```

If the vault is writable, the same line is also written to a decisions note in the vault so the graph can index it. If the vault write is refused, say so in one line and continue; never bypass the refusal.

## Output hygiene (every turn, not only cards)

- First line is the thing to look at or do. No preamble, no "I'll now…".
- Restate position every turn: "Decision 2 of 3 · provenance". The owner does not hold it between messages.
- One question per turn, including interrogation questions during brainstorming. Context inside the question.
- Finish the current thread before mentioning a second issue. Second issues go at the end as one line.
- Lists cap at 5 visible items; the rest exist and are shown on request.
- No closers.

Pre-send check on a card: fewer than 20 lines between title and question; no recommendation; no banned vocabulary; exactly one question; the first line and the last line alone tell the owner what is being decided and what to do.

## With visual-spec

`comb` sits between L0 and L1. The card's map slice uses L0's node names and bands. L1 and L2 are generated only for decisions that were actually made, after they are made. The end-of-turn delta table stays visual-spec's; agent's calls merge into it as `~` rows.

## Persistence

On for the rest of the session once invoked. Off only when the owner says `stop comb`. Confirm in one line.

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

A  Proposals note lives in the agent-writable folder. A tick is a tick;
   the rule says agents don't tick, the journal undoes it if one does.
B  Proposals note lives outside that folder. The server refuses agent
   writes there, so only a tick made in Obsidian counts.

if wrong:  A → an agent approves its own merge; you find out after · undo: journal
           B → every approval needs Obsidian open; nothing breaks · undo: move the note

Your pick + one line why.
```