# Drift signatures

Observable signs that a plan, a brief, a running session, or a repository has left the shortest path to the finish line. Each signature names where it was seen (Greenfield = the case in `greenfield-case.md`; others cite the source in `rules.md`).

## In a plan or brief

- The "done when" names an intermediate: installed, migrated, qualified, hardened, Stage N committed. (Greenfield: "Stage 6, then a capacity grant signed by a separate reviewer UID, then an offline SQL init, then an owner-supplied case scope" before any application could run.)
- No out-of-scope section, or it is empty. (HumanLayer, Pocock, O'Leary all require one.)
- Phases are horizontal: all database, then all services, then all API, then all UI; the first runnable checkpoint is near the end. (Horthy: "1,200 lines of code and it's not working".)
- The first real artifact depends on five or more features. (Greenfield 2 plan: Tech Osaka submission F13 depends on F00–F08.)
- Security, privilege separation, signing, custody, audit, or accounting mechanisms appear without a named loss and its size. (Greenfield: ~70% of 17.9k installer lines defended "a compromised UID 1000 on a single-owner laptop", rated speculative; $0.14 of exposure tracked to 7 decimals.)
- Points of no return are designed in. (Greenfield Stage 3 "Point of no return"; every later bug needed a signed erratum.)
- Everything is hash-pinned or signed, so a typo is a release. (Greenfield: two of the last five failures were pin/path mismatches.)
- Errors are redacted by design. (Greenfield `_safe_refusal` hashed error text; diagnosing one failure meant brute-forcing 1.5M candidate strings.)
- Approval gates on reversible steps; none on the irreversible one. (Greenfield: 46+ sudo prompts for engineering steps; the new plan removed confirmation on the submit click.)
- Parallel lanes or swarms from day 1. (Greenfield 2: three Codex lanes plus an integrator before any slice was verified.)
- Scale numbers precede the first success. (Greenfield: 1 application became "ten concurrent" on Oct 3 with 0 submissions; the new plan targets 100 workers and raises the cap from $10 to $500.)
- Review on every candidate regardless of size. (Greenfield: two independent reviewers, functional and security, per one-line fix, 5–30 minutes each.)
- "Comprehensive", "complete coverage", "all edge cases", "boil the ocean" language in a plan for a small deliverable. (gstack's expansion modes; Pocock's to-spec asks for an "extremely extensive" story list.)
- Plan length approaches implementation length. (Horthy: a 1,000-line plan is ~1,000 lines of code within 10%.)
- Plan contains "TBD", "handle edge cases", "add appropriate validation". (Superpowers writing-plans.)
- Unresolved design questions in the final plan. (HumanLayer: "Do NOT write the plan with unresolved questions".)
- A research document recommends what to build. (HumanLayer research_codebase; Horthy: research with the ticket visible produces opinions.)

## In a handoff or continuation prompt

- The prompt does not mention the user-visible goal or the finish line at all. (Greenfield handoff 261: entirely about operations, generations, retirements, bindings; never mentions the form, the program, or the $10.)
- The count of "preserve", "do not weaken", "exact reviewed", "must require" lines rises across handoffs and never falls. (Greenfield: 80 archived prompts containing "Preserve"; 274 numbered handoff files; constraints only accumulated.)
- Each authorization allows exactly ONE attempt, so every failure needs a new review-and-approve round. (Greenfield Oct 5–14.)
- The brief was written by a model and forwarded unedited. (Greenfield: continuation prompts arrived as attachments and scripts from a Codex outputs folder.)
- The handoff copies history instead of pointing at artifacts. (Pocock: "do not duplicate content already captured in other artifacts".)
- Resolved failures remain prominent and keep steering the next plan. (12-Factor Agents Factor 3.)
- A hybrid goal appears ("balance X and Y") where the user stated one exclusive goal. (Arike et al.: misaligned self-reports were "almost always a hybrid goal".)
- The temporary sub-goal persists after its completion condition was met. (Arike et al.: drift through inaction.)

## In a running session

- Version numbers race while the artifact does not move. (Greenfield: kit v74 → v88 in ~22 hours; 15 production kit versions; 0 submissions.)
- Bugs surface one per privileged run because production is the first integration test. (Greenfield: KeyError, missing fcntl constant, missing sys.path, wrong path, missing spec fields, each found only after the previous was fixed.)
- Two or more fixes resting on the same assumption have failed and a third is being written. (pstack attack-the-premise; Greenfield had 13 consecutive refusals with the premise "we need a protected install" never tested.)
- The same issue has been corrected more than twice. (Claude Code best practices: restart.)
- The agent re-reads or re-edits the same files without progress. (Codex prompting guide.)
- Repeated "no, that's wrong" corrections accumulate in one session. (Horthy: reset instead.)
- A reviewer's suggestion becomes a task without a human decision. (gstack: "never speculation or reviewer agreement".)
- Repository comments claiming urgency ("compliance requires", "security team mandates") are treated as authority. (Saebo et al.: environmental pressure.)
- The agent proposes security hardening nobody asked for. (Saebo et al.: asymmetric drift toward security/privacy.)
- "Done" is claimed from tests passing, a build, or a self-report, without running the real thing. (Willison; Anthropic harness; Superpowers.)
- A test, a test file, or a requirement is removed to turn a run green. (Vincent; Anthropic harness.)
- The agent asks whether to continue on reversible work, or proceeds without asking on an irreversible action. (pstack never-block-on-the-human.)
- Tool loadout grows: a database MCP during front-end work; dozens of tools enabled. (O'Leary; Breunig >30 tools.)
- Felt productivity is high; measured delivery is zero. (METR: 19% slower, believed 20% faster.)

## In a repository

- Guards and mechanisms that never caught a real incident. (Greenfield: 13 refusals, 0 caught an overspend, double submission, workbook corruption, or credential risk.)
- Duplicate implementations because a search miss was taken as absence. (Huntley.)
- One giant PR replaces a sequence of small verifiable ones. (Mistele: the unreviewable 40,000-line PR; Lauren Tan: atomic PRs.)
- Nobody has read the generated code for months; the team cannot navigate it when production fails. (Horthy, "Why Software Factories Fail".)
- The owner's own workflow is broken by the "safety" design. (Greenfield: the tracker moved to a location the desktop user could not read.)
- The riskiest, least-proven component sits downstream of all the effort. (Greenfield: 12k lines of browser automation never completed a submission while all effort went into the installer upstream of it.)

## Vocabulary for naming what you see

- Overeager / out-of-scope actions: doing more than authorized (Qu et al.).
- Goal drift: deviation from the assigned objective over time (Arike et al.).
- Asymmetric goal drift: drift that favors security/privacy under pressure (Saebo et al.).
- Context poisoning / distraction / confusion / clash (Breunig).
- Context rot: reliability falls as input grows (Chroma).
- Instruction budget / prompt debt (Horthy, IFScale, Breunig).
- Horizontal vs vertical plans (Horthy).
- Outsourcing the thinking (Horthy, via Jake from Netflix).
