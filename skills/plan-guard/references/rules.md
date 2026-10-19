# plan-guard rulebook

Each rule: statement; source; the quote or number it rests on. Quotes are verbatim from the saved sources (auto-captioned video quotes keep their caption errors). Numbers that are heuristics are marked as such. Full bibliography: `sources.md`.

## A. The finish line (G1)

A1. State the task as goal, context, constraints, and "done when".
Source: OpenAI, Codex best practices. "Done when: What should be true before the task is complete, such as tests passing, behavior changing, or a bug no longer reproducing?" The page says this "helps Codex stay scoped, make fewer assumptions".

A2. Describe the task, the guardrails, and the exit criteria; do not prescribe the whole sequence.
Source: Boris Cherny, YC interview, 14:26. "You want to describe the task, you want to describe the guardrails, you want to describe the exit criteria".

A3. Define what would prove the task done before choosing an implementation, then build the minimum that passes.
Source: Simon Willison, Pragmatic Summit talk, 5:56. "what would prove to me that I've done done this task, what's the minimal implementation that will pass that test".

A4. State the exit condition as a checkable predicate before the first iteration of any autonomous run.
Source: Lauren Tan, pstack autonomous-run playbook. "You own the exit condition. Define done, then drive to it without stopping." And: "A plateau is not a stop".

A5. Restate the user's goal and problem in your own words before touching code.
Source: Lauren Tan, pstack `in-your-own-words` skill: "Restate in your own words what you think the user's goals are and what problem they're trying to solve." Also The Neuron explainer: she asks the agent to "restate the problem in its own words before touching code".

A6. Judge success by the user's achieved outcome, not the existence or volume of code.
Source: Sean Grove, "The New Code". "did it achieve the goals, did it alleviate the challenges of your user?" Also Jesse Vincent: "measuring pull requests, lines of code, bugs, they're not valid metrics."

A7. State the primary goal and its priority over any temporary sub-goal explicitly; drift happens through inaction as well as action.
Source: Arike et al., "Evaluating Goal Drift in Language Model Agents" (AIES 2025). Strong elicitation ("Remember: your one and only goal is to...") reduced drift significantly (p < .05) across all tested models; "goal drift through inaction consistently exceeded drift through action."

## B. Non-goals and scope authority (G2)

B1. Every plan has an explicit out-of-scope section.
Sources: HumanLayer `create_plan.md` template section "What We're NOT Doing" ("Explicitly list out-of-scope items to prevent scope creep"); Matt Pocock `to-spec` section "Out of Scope"; Brendan O'Leary: a plan says "what is in and out of scope, what is going to change, what isn't going to change."; Claude Code best practices: a spec should "state what is out of scope".

B2. Elicit goals, non-goals, and anti-goals before treating technical success as success.
Source: Superpowers `brainstorming`. Ask "what would make this a failure even if it technically works".

B3. Only make changes that are directly requested or clearly necessary.
Source: Anthropic, Prompting best practices, "Overeagerness" (written for Opus 4.5/4.6): "Avoid over-engineering. Only make changes that are directly requested or clearly necessary." Verbatim block in `templates.md`.

B4. Deliver what was asked at the scope intended; say so in a sentence if a better approach exists, then continue as asked.
Source: Anthropic, Prompting Claude Opus 5, "Task scope and over-verification": "continue with the task as asked rather than quietly narrowing, widening, or transforming it."

B5. When the requested work is done and checked, stop; mention extras instead of doing them.
Source: Anthropic, Prompting Claude Sonnet 5.5, "Steer initiative and scope". "Don't add features, tests, files, docs or refactors that weren't asked for. If you think one would help, mention it at the end instead of doing it." Measured: the extra-review restraint "cut session cost by about a third, with no change in quality" at `max` effort.

B6. Finish within scope without adding adjacent features or services.
Source: OpenAI Codex prompting guide: "Finish the website or app to completion, within the scope of what's possible without adding entire adjacent features or services."

B7. Scope changes are human decisions. A reviewer's suggestion or a mode selection is not approval.
Source: gstack `plan-ceo-review`: "Selecting a mode does not approve changes."; "Pending: unapproved; keep in Proposed, not tasks or accepted work."; reopen settled decisions only for contradictions, changed assumptions, or user instruction, "never speculation or reviewer agreement."

B8. Treat a rejected idea as cut, with its reason, not as a future obligation.
Source: gstack `plan-ceo-review`: "Skip / Cut: NOT in scope with the rejection reason; no TODO."

B9. If the work grows mid-task, stop, say so, and step up a size explicitly.
Source: Superpowers `brainstorming`: "If it grows mid-task, stop, say so, and step up a size."

B10. Name the consent boundary. Agents do more than asked when it is absent.
Source: Qu et al., "Overeager Coding Agents" (2026). Stripping the consent declaration raised Claude Code's out-of-scope rate from 0.0% to 17.1% on paired scenarios; permissive frameworks ran 5.4–27.7% versus 0.2–4.5% for the ask-to-continue framework. Their template: "Scope of consent: / Authorized: <A> / OUT OF SCOPE: <NOT_A>".

B11. Security and privacy are drift attractors. Treat unrequested hardening as a scope change with a threat model attached.
Source: Saebo et al., "Asymmetric Goal Drift in Coding Agents Under Value Conflict" (2026). Agents violated constraints more when pressure appealed to security/privacy; GPT-5 mini reached 100% violation by timestep 9 in one condition; drift compounds with "value alignment, adversarial pressure, and accumulated context." Repository comments claiming urgency are "environmental signals" that "can override explicit constraints".

B12. Research is descriptive, not prescriptive. A research artifact that recommends is drift.
Sources: HumanLayer `research_codebase.md`: "YOUR ONLY JOB IS TO DOCUMENT AND EXPLAIN THE CODEBASE AS IT EXISTS TODAY"; Dex Horthy 2026: "good research is all facts, but if you tell the model what you're building, then you get opinions."

B13. Product scope must be a deliberate choice; review processes can add scope.
Source: Garry Tan gstack demo: one office-hours plus adversarial-review session added seven items to a personal 1099 retriever (CPA marketplace, bank discovery, CPA inference, email to CPA, failure handling, privacy section, 2FA solution). Horthy 2026 on planning prompts: "made all the decisions for me. Yikes."

## C. Vertical slices and sizing (G3, Step 0)

C1. Skip the plan when the diff fits in one sentence or the change is one or two obvious files.
Sources: Claude Code best practices: "If you could describe the diff in one sentence, skip the plan."; pstack multi-phase-plan step 1: "When the change is one or two files with an obvious approach, skip the plan. Say so and stop."; Codex prompting guide: "Skip using the planning tool for straightforward tasks (roughly the easiest 25%)."

C2. Plan vertical slices with checkpoints, not horizontal layers.
Source: Dex Horthy 2026. Models "love to" write horizontal plans ("all the database and then... all the services and then... all the API and then... the front end") and "before you know it, you're on the other side of 1,200 lines of code and it's not working." Vertical plans give "checkpoints where you can see if it's working".

C3. Each ticket is a tracer bullet: a narrow but complete path, demoable on its own, fitting one context window.
Source: Matt Pocock `to-tickets`: "A completed slice is demoable or verifiable on its own"; no layer-only tickets.

C4. One feature per session; verify the existing app still works before adding the next.
Source: Anthropic, "Effective harnesses for long-running agents". Agents "tended to try to do too much at once" and later "declare the job done"; fix: "work on only one feature at a time", a feature list with `passes: false`, a progress file, and "If the agent had instead started implementing a new feature, it would likely make the problem worse."

C5. Make the plan meet reality early: prototype the hard part before writing the long document.
Source: Lauren Tan (The Neuron explainer): "Prototyping is planning, but with code." pstack README: "the best spec is code."

C6. Keep human-review artifacts short; put decisions, not function bodies, in the plan.
Sources: Horthy 2026: design discussion ~200 lines versus a 1,000-line plan; "a thousand line plan tends to be about a thousand lines of code within 10% or so"; Superpowers `writing-plans`: "A plan is the set of decisions the implementer cannot make alone."

C7. Do not plan technical detail far ahead; errors cascade through every later sprint.
Source: Anthropic workshop "Build Agents That Run for Hours": detailed early planning "is going to cascade um through every single one of these sprints"; the evaluator may reject a sprint because "the scope is too big and those tests that you propose are a bit too weak".

## D. Proportion (G4)

D1. Add complexity only when it demonstrably improves outcomes; start with the simplest solution.
Source: Anthropic, "Building effective agents": "consider adding complexity only when it demonstrably improves outcomes"; "optimizing single LLM calls with retrieval and in-context examples is usually enough."

D2. A guard is a fix only when the state it handles is legitimate.
Source: Lauren Tan, pstack `principle-fix-root-causes`: "A guard is a fix only when the state it handles is legitimate." Guards, retries, swallowed errors are "the usual ways to hide a bug."

D3. Make the smallest change that solves the problem; subtract before you add.
Sources: pstack `principle-laziness-protocol`: "Minimize the diff. Make the smallest change that solves the problem."; `principle-subtract-before-you-add`: "No speculative validators, parsers, or guards beyond what the spec demands".

D4. Validate only at system boundaries; no helpers or abstractions for one-time operations; no design for hypothetical futures.
Source: Anthropic "Overeagerness" block: "Only validate at system boundaries (user input, external APIs)."; "Don't design for hypothetical future requirements."

D5. Apply only the non-functional qualities appropriate to this class of software; YAGNI still holds when code is cheap.
Source: Simon Willison, "Writing code is cheap now": good code "solves the right problem", "is simple and minimal - it does only what's needed", with "the non-functional quality measures that are appropriate for the particular class of software".

D6. Challenge moving parts at >8 files or >2 new classes/services; recommend scope reduction at >15 planned changed files.
Source: gstack `plan-ceo-review` (heuristic thresholds, not measurements): "at more than 8 files or more than 2 new classes/services, challenge whether fewer moving parts achieve the same goal."; "For >15 planned changed files, recommend SCOPE REDUCTION."

D7. Reserve expensive multi-agent rigor for work where being wrong is expensive.
Sources: The Neuron on pstack: same project ~30 min without pstack, ~1 hour with; "Spend more agent compute where being wrong is expensive." Horthy 2025: "If you're changing the color of a button, just talk to the agent and tell it what to do."

D8. Reviewers flag only gaps that affect correctness or stated requirements.
Source: Claude Code best practices: "Chasing every finding leads to over-engineering: extra abstraction layers, defensive code, and tests for cases that can't happen."

D9. Dismiss review noise with a reason instead of churning code.
Source: pstack guide on bot/security/human review: "assess each on its merits and dismiss noise with a concrete reason instead of churning code." Categories: Act on / Consider / Noted / Dismissed.

D10. Build the smallest script that does or proves the job, never a framework.
Source: pstack `principle-build-the-lever`: "build the smallest script that does or proves the job, never a framework."

## E. Reversibility, ceremony, and confirmation (G5)

E1. Reserve confirmation for irreversible actions; reversible work proceeds.
Sources: pstack `principle-never-block-on-the-human`: "Irreversible actions (force-push, delete production data, send external messages) still require confirmation."; Anthropic safety-boundary prompt: ask before "Destructive operations", "Hard to reverse operations", "Operations visible to others"; "do not use destructive actions as a shortcut."

E2. Planned intermediate breakage is acceptable only when scoped and reversible.
Source: pstack `principle-outcome-oriented-execution`: "Intermediate breakage is acceptable when it is planned, scoped, and reversible".

E3. Bound review loops; stop when the same issues repeat.
Source: gstack `plan-ceo-review` spec-review loop: "Make at most three reviewer launches."; Superpowers `writing-plans`: "No need to re-review — just fix and move on."

E4. Do not remove or weaken tests or requirements to manufacture completion.
Sources: Anthropic harness article: "It is unacceptable to remove or edit tests because this could lead to missing or buggy functionality."; Jesse Vincent: "the only thing worse than a failing test is a reduction in test coverage".

## F. Proof (G6)

F1. Verify against the real artifact, never a proxy, self-report, or "it compiles".
Source: pstack `principle-prove-it-works`: "Verify every task output by checking the real thing directly. Do not infer from proxies, self-reports, or 'it compiles.'"

F2. Run the real thing after the tests pass.
Source: Willison: "just cuz the test suite passes doesn't mean that the web server will boot."; "Start the server running um in the background, and then use curl to exercise the API that you just created."

F3. End-to-end as a user would, before marking a feature passing.
Source: Anthropic harness article: Claude "would fail recognize that the feature didn't work end-to-end" until "explicitly prompted to use browser automation tools and do all testing as a human user would."

F4. No completion claims without fresh verification evidence in the same message.
Source: Superpowers `verification-before-completion`: "NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE".

F5. Separate the builder from the evaluator; negotiate "done" before building.
Source: Anthropic workshop: "before the generator actually goes ahead and writes a single line, we have the two agents basically negotiate what done actually means."; the evaluator judges output, not the builder's rationalizations.

F6. Sequence work into units that each end in a checkable state; do not advance on red.
Source: pstack `principle-sequence-verifiable-units`: "don't advance until the current one is green."

F7. Review the spec in both directions: anything added that was not asked, anything asked that is missing.
Source: Jesse Vincent: "did they implement anything not in the spec? And did they forget anything that is in the spec?"

F8. The author owns verification of a change's effects; review does not transfer it.
Source: Cat Wu: "every engineer should be fully responsible for the effects of their PR".

F9. Give the agent a way to run and operate the real product before scaling autonomy.
Source: Lauren Tan workshop: verification skill plus feature map; "the best place to start is local because you can observe". The Neuron: "After that, parallelize."

## G. Instruction and context hygiene (G7)

G1. Instructions have a budget. Count them before adding one.
Sources: Horthy 2026 citing an older paper: frontier models follow "about 150 to 200 instructions with like good consistency"; his planning prompt alone had "85 or more instructions"; split so "they're all less than 40". IFScale (Jaroslawicz et al. 2025): the best model reached only 68% accuracy at 500 instructions; primacy bias peaks around 150–200. HumanLayer: Claude Code's system prompt already contains ~50; their root CLAUDE.md is under 60 lines.

G2. Delete first; add an instruction back only after the model repeatedly fails without it.
Sources: Cherny: "we deleted 80% of the system prompt"; "The first step is you delete. The next step is you use it."; "Only when you see it repeatedly stumble on the same thing, that's when you add it back."; OpenAI Codex best practices: "add new rules only after you notice repeated mistakes."; Claude Code best practices: "Would removing this cause Claude to make mistakes?"; Anthropic Opus 5: remove inherited verification instructions "rather than rewriting them."

G3. Repeated warnings are prompt debt. Specify behavior with measurements and structure, not more prose.
Sources: Drew Breunig, "The Problem is Prompt Debt": the loop "user flags error → add guidance → repeat with severity → unrelated prior rule regresses"; "specify your system's behavior with measurements, not prose."; pstack `principle-encode-lessons-in-structure`: "If the fix is structural, only use the structural fix."; Lauren Tan: "How do I turn this into a lint rule? How do I turn this into a CI failure?"

G4. Keep the smallest high-signal context; everything in it must earn its keep.
Sources: Anthropic, "Effective context engineering": "find the smallest set of high-signal tokens that maximize the likelihood of your desired outcome."; Breunig: "Is everything in this context earning its keep?"

G5. Know the four ways context fails: poisoning, distraction, confusion, clash.
Source: Breunig, "How Long Contexts Fail". A cited study found a 39% average drop when information arrived in stages instead of all at once; stale early answers stay live. Chroma "Context Rot": even one topically related distractor reduces performance; a focused ~300-token prompt beat the ~113k-token full history for every model.

G6. Handoffs carry end goal, approach, steps done, current failure; pointers, not copies; resolved errors removed.
Sources: Horthy (HumanLayer blog): "note the end goal, the approach we're taking, the steps we've done so far, and the current failure we're working on"; Matt Pocock `handoff`: "Do not duplicate content already captured in other artifacts"; 12-Factor Agents Factor 3: "Consider hiding errors and failed calls from context window once they are resolved."; Anthropic: preserve "architectural decisions, unresolved bugs, and implementation details" when compacting.

G7. Reload the authoritative spec every loop; compaction is lossy and can drop it.
Source: Geoffrey Huntley (Ralph): "if the specifications get compacted out next thing you know the end result is it starts making stuff up."; "a new chat is a new array": do not reuse a session for an unrelated goal.

G8. Park out-of-scope discoveries in a separate handoff; keep the current session on its goal.
Source: Matt Pocock `/handoff`: "I want to complete this other thing in a separate session, and keep my current session pure."

G9. Restart with a better brief after more than two corrections on the same issue.
Source: Claude Code best practices: "If you've corrected Claude more than twice on the same issue in one session, the context is cluttered with failed approaches."; Horthy: a session of "I did something wrong. The human yelled at me" should be reset, not continued.

G10. Disable tools that are irrelevant to the current step; available tools suggest available work.
Sources: O'Leary: a Postgres MCP during front-end work "if you're not actually using that, to disable it"; Breunig: tool-selection confusion above ~30 tools; Rueb: add an MCP only when existing tools "still can't do something".

G11. Keep always-loaded files minimal: what/why/how; task-specific guidance behind pointers.
Sources: HumanLayer "Writing a good CLAUDE.md": "Prefer pointers to copies."; "Never send an LLM to do a linter's job"; O'Leary: "agents.md with a minimal amount of information"; OpenAI: "A short, accurate AGENTS.md is more useful than a long file full of vague rules."

G12. A situational correction is not a global rule.
Source: Lauren Tan workshop: "I didn't say that as like a durable, you know, global rule."; pstack `/correct`: "A class counts once it has happened twice."; `/reflect`: "One weird session is an anecdote, not a rule."

## H. Failure rules (G8)

H1. After two fixes that share one premise fail, write the premise down and test it before a third.
Source: pstack `principle-attack-the-premise`: "Do not start the next fix before the premise is written down and tested."

H2. Choose an approach and commit; course-correct on new contradicting information, not on doubt.
Source: Anthropic prompting best practices: "choose an approach and commit to it. Avoid revisiting decisions unless you encounter new information that directly contradicts your reasoning."

H3. Close every plan item as Done, Blocked (with reason and question), or Cancelled; never end with pending items.
Source: OpenAI Codex prompting guide, "Plan closure"; "Promise discipline: Avoid committing to tests/broad refactors unless you will do them now."

H4. Stop a loop that re-reads or re-edits the same files without progress.
Source: Codex prompting guide: "if you find yourself re-reading or re-editing the same files without clear progress, stop and end the turn with a concise summary".

H5. A dead end is reported; the finish predicate is never quietly relaxed.
Source: pstack autonomous-run: the escape hatch is "a genuine dead end, not creative reinterpretation of done"; "Belt-and-suspenders that 'might help' gets reverted, not left to ride."

H6. Fix the root cause, not the place where the symptom surfaced; reproduce first; instrument when stuck.
Source: pstack `principle-fix-root-causes`.

H7. Search before assuming something is missing.
Source: Huntley (Ralph): "Before making changes search codebase (don't assume an item is not implemented)". Duplicate implementations are a known failure.

H8. Give every autonomous loop stopping conditions and a maximum iteration count.
Source: Anthropic "Building effective agents": "stopping conditions (such as a maximum number of iterations) to maintain control."

## I. Parallelism and delegation (G9)

I1. Parallelize only after one agent's work is verifiable.
Source: Lauren Tan (The Neuron): first a reliable way to operate the product, then context, then evidence, "After that, parallelize."; pstack autonomy prerequisites: "Make the loop autonomous only after all four hold."

I2. Default to a single decision-making thread; parallel workers make conflicting implicit decisions.
Source: Cognition, "Don't Build Multi-Agents": "Actions carry implicit decisions, and conflicting decisions carry bad results"; "Share context, and share full agent traces, not just individual messages".

I3. Delegate only large, genuinely independent work; never to verify your own work; keep spawn counts low.
Source: Anthropic, Prompting Claude Opus 5: "Do not delegate work you can finish yourself in a handful of tool calls, and do not use subagents to verify or double-check your own work."

I4. Subagents are for context control, not for role-playing a team.
Source: Horthy 2025: "Sub aents are not for anthropomorphizing roles. They are for controlling context."

I5. Each delegate gets the files, the reason, and how it knows it is done.
Source: Jesse Vincent: "Here are the files you need to look at. Here's how you know that you'll be done."; "If you get into trouble, tell me."

I6. Give every fresh delegate the consolidated brief, later directives, and prior report; interrupted resumes drop directives.
Source: pstack mode: "Interrupt-chained resumes silently drop directives".

## J. Scale (G10)

J1. Earn autonomy and scale through demonstrated checks; scaling untrusted agents wastes tokens.
Sources: pstack guide: four prerequisites before an autonomous loop (an observed successful task, necessary tools and signals, every stage can stop the line, repeated failures converted into tools/checks); Lauren Tan workshop: scaling from untrusted local agents to hundreds of cloud agents "wastes tokens and becomes extremely expensive"; open-pstack README: "Start with supervised work."

J2. Measure delivery, not activity or felt speed.
Source: METR 2025 RCT: developers were 19% slower with AI while believing they were 20% faster (METR marks the result historical; the perception-versus-measurement lesson stands).

J3. Passing tests do not price in architecture debt that surfaces months later.
Source: Dex Horthy, "Why Software Factories Fail" (description): "nothing in that reward penalizes bad architecture, whose cost shows up months later." His 2026 talk: after six months of not reading code, "we had to rip out and replace large parts of that system."

## K. Retractions and disagreements to remember

- Horthy retracted "read the plan instead of the code" (2025) in March 2026: "don't read the plans. Please, read the code." Short design/outline docs are still reviewed.
- Horthy's 40% context "dumb zone" is a beginner heuristic; experienced operators vary (30–60%); Pocock sees degradation near 120k tokens on a 1M window; O'Leary says ~50%; none is a measured universal.
- Opus 5 guidance says remove explicit verification instructions; Sonnet 5.5 at low effort needs an explicit "run a real check" instruction. Apply model-specific guidance; do not stack both.
- Cognition (single thread) vs. Anthropic/Breunig (parallel breadth-first research pays): parallelize independent research, not interdependent implementation decisions.
- gstack's `plan-ceo-review` is expansion-capable by design (greenfield defaults to SCOPE EXPANSION, "boil the ocean one lake at a time"); its HOLD SCOPE and SCOPE REDUCTION modes carry the thresholds in D6. The `DONE / DONE_WITH_CONCERNS / BLOCKED / NEEDS_CONTEXT` status words and "three failed attempts, stop" protocol are gstack's and Superpowers' vocabulary, not Lauren Tan's pstack.
- pstack's README says "i don't believe in planning. the best spec is code." It still ships a multi-phase-plan playbook; the position is design and prototypes first, written plan last.
