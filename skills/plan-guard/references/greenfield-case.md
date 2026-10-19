# The Greenfield derailment (Sep 8 – Oct 18, 2026)

The case plan-guard was built from. Figures come from the project's own planning brief and the Opus 5.5 assessment written on Oct 18 (`~/nimblemind/greenfield2/plan/background/`), and from the OMP session archive.

## Goal

"Greenfield fills in and submits the Tech Osaka Award 2027 form by Oct 28, logs it in the tracker xlsx, and spends no more than $10 on Fireworks (at most $0.03 per call)."

## What was built

- A root-run, six-stage migration into a multi-user "protected" installation.
- 17,945 lines of installer code in 12 modules; the orchestrator alone 5,632 lines.
- 6 new system accounts (UIDs 959, 1001–1005): attester, sender, custodian, main, PostgreSQL, reviewer signer.
- 13 systemd units; a 3-minute renewal timer; signed plans expiring after 14 minutes.
- ~51 versioned contract types; at least 8 Ed25519 keys; 41 signed JSON files in /etc.
- 46+ sudo prompts (19 on Oct 18 alone); kit versions v74 → v88 in ~22 hours; 73 earlier "274" handoff versions; artifact generations 252 → 274.
- Each kit: 160–210 files and a 35 MB SHA-256 manifest.
- 40 days elapsed; 0 submissions by Greenfield. On Oct 17 the coordinator submitted two applications by hand in 34 minutes at $0.
- Money actually at stake: ~$0.14 of the $10 cap (1.4%).

## What the machinery caught

13 refusals or partial failures in the final campaign. Zero caught a real overspend, double submission, workbook corruption, or credential risk. Every diagnosed failure was self-inflicted: IndexError, UnboundLocalError, KeyError, a path or hash pin mismatch, a signed-journal format problem, a missing import path, an unsupported sealing call. The final failure (Stage 5 SAFE-DOWN) was a design-time bug: role specs signed with 5 fields where 13 were required. A one-second import test would have found it. Its cause was hidden because error text was redacted into hashes by design.

## Structural causes (from the Oct 18 assessment)

1. The goal was replaced by a security project.
2. Irreversibility was manufactured (Stage 3 "point of no return"), then engineered around with signed errata; a one-line fix took 1–2 hours.
3. Hash-pinning everything turned every typo into a release.
4. Production was the integration test.
5. Error detail was hidden by design.
6. Two independent reviewers (functional and security) on every candidate, 5–30 minutes each.
7. Accounting precision far beyond the stakes ($0.14 tracked to 7 decimals; one gate cost ~3 kit versions).
8. Scope accreted around a product that had never submitted; the 12k-line browser journey was never completed and sat downstream of all the installer effort.
9. The workbook custody design broke the owner's own use.
10. Process overhead: ~50 proof scripts per kit; password timeouts; 15 kit versions in 22 hours.

## The prompt chain

About 274 numbered continuation prompts. Exhibit, Oct 13 (handoff 261):

"Continue from verified-operational-handoff261.json. Resolve the replacement-inspection integration gap and missing rejection diagnostics before requesting another live attempt. ... One replacement256 Main POST returned HTTP409. ... Historical I255 remains UNKNOWN. Paid HOLD remains. ... Do not simply delete the guard or exclude every retired operation. ... A replacement must require: the exact historical operation and authentic local-retirement evidence; current case, Source and native-generation bindings; an explicitly authorized replacement operation; durable single-use consumption that prevents concurrent or alternate-key duplicates."

It never mentions the form, the program, or the $10. Each rule is added; none is removed. 80 archived prompts contain "Preserve". Each authorization allowed exactly one attempt. Several prompts were written by a model and forwarded as attachments.

## Timeline

- Sep 8: first commit.
- Sep 28: first complete controlled (practice) run.
- Oct 3: goal grows to "ten concurrently active cases" with 0 real submissions.
- Oct 5–14: ~274 handoffs; one-attempt authorizations.
- Oct 15–18: protected-installer campaign.
- Oct 17: two manual submissions in 34 minutes; owner rules that only Greenfield may submit; the installer work grows out of that ruling ("make it submit" became "make it trustworthy enough to submit unattended").
- Oct 18: reassessment; Greenfield 2 plan.

## The loop, not just the model

1. Model behavior: overeager actions; asymmetric drift toward security; context poisoning across 274 prompts.
2. The process ratchet: constraints only added; model-written briefs forwarded unedited; one-attempt scopes plus dual review made every fix expensive while feeling careful.
3. Goal inflation before proof: 1 → 10 → 100; $10 → $500.

What was missing: a time box, a kill criterion, and the recurring question "is this on the shortest path to one submitted form?" pstack's attack-the-premise would have fired after the second installer failure; there were 13.

## What the Greenfield 2 plan fixed and what it kept

Fixed: no privilege separation; no signing or hashing of errors; plaintext errors; ~4,000-line budget; "does Tech Osaka need this on Day 3?" test; stop after 3 failed attempts.

Kept (each a plan-guard FAIL): horizontal order (submission F13 depends on F00–F08); three parallel lanes from day 1; 100 workers and a $500 cap planned before the first success; confirmation removed from the one irreversible step (submit); references to the wrong pstack (no-session/pstack, a gstack fork, not Lauren Tan's).

The vertical reorder: exit the protected install; one script fills the Tech Osaka form and stops before submit, proven by screenshot; draft and review answers for that one form; the human clicks submit; only then the database, scheduler, and lanes.
