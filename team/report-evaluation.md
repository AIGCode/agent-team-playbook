# How to evaluate agents' reports

## General rules

1. Read the outcome/summary first: for most roles the outcome is a verdict, for the Developer - a status (DONE / PARTIAL / BLOCKED) and a criteria table
2. The details (file:line) - only if you need to make a decision
3. Do not load the whole report if the verdict is PASS

## Developer

| Check | How |
|---|---|
| Status? | DONE - on to the Checker; PARTIAL / BLOCKED - read the Issues and questions, decide: finish it, rephrase the task, or take it to the user |
| Acceptance criteria closed? | The table "acceptance criterion - met - how verified": every criterion from the task is in the table, and for the met ones it says how it was verified |
| Task done? | Compare "what to do" with "what was done" |
| In scope? | Did not touch files outside the whitelist |
| Follows the architecture? | Structure as in ARCHITECTURE.md (if present) |
| Patterns observed? | Check against the project's `PATTERNS.md` (in the sample - PDO prepared statements, htmlspecialchars, error handling) |
| Any questions? | Read the "questions for the Tech Lead" section |

**Red flags:**
- "While I was at it, I also fixed..." - went beyond scope
- "It didn't work out, so I did it differently" - a deviation from the architecture
- No report of what did not work - hiding problems
- Status DONE, but the table has a criterion without "how verified" or lacks it altogether - completion is not confirmed

## Architect

| Check | How |
|---|---|
| Task done? | Designed what was asked (architecture / mapping) |
| Source of truth observed? | Fields and API versions taken from the application's documentation, not from memory |
| Implementable in stages? | Each component is a separate task for the Developer, no "everything first" |
| "Needs verification" marks? | Anything not confirmed by the docs is marked, not invented |
| Any questions? | Read the "Questions for the Tech Lead" section |

**Red flags:**
- Values filled in "plausibly" without a "needs verification" mark - designing from memory
- Paper architecture - pretty, but does not break down into tasks for the Developer

## Checker

| Verdict | Action |
|---|---|
| PASS | Continue |
| NEEDS_REVIEW | Read the details, assess the risk |
| FAIL | Stop. Task for the Developer to fix |

**What to check in the details:**
- What functionality is broken?
- Is it a regression from our code or a false positive?
- Inconsistency: what exactly does the new diverge from (both places given)? Is it a divergence from what already exists, and not a wish to "make it better"?
- Criticality: blocker / can continue / cosmetic?

## Reviewer

| Verdict / severity | Action |
|---|---|
| FAIL (there is a HIGH, including risks outside the list) | Stop. Task for the Developer to fix |
| PASS, there is a MEDIUM | Assess: fix now or after the mission |
| PASS, there is a LOW | Note it, fix when convenient |

Rules table: an "OK" without a comment on how it was checked counts as unchecked - send it back to the Reviewer.

## Tester

| Verdict | Action |
|---|---|
| PASS (plan) | Every acceptance criterion of the contract is covered by a test or marked "not tested, because..." - approve the plan, launch the run |
| PASS (run) | Automated tests A passed and cover the contract's criteria (the rest moved to B/C) - hand the manual steps to the user |
| FAIL | Analyze: a bug in the code, in the test, or a criterion not covered? |

## Researcher

The researcher's result is information, not code. First read the outcome at the top of the report (what is covered, what was not found, sources), the full material is in the files, as needed. Evaluate by:
- Are all the questions from the task covered?
- Are there sources (links)?
- Are there contradictions between the sources?
