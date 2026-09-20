# How to evaluate agents' reports

## General rules

1. Read the verdict/summary first
2. The details (file:line) - only if you need to make a decision
3. Do not load the whole report if the verdict is PASS

## Developer

| Check | How |
|---|---|
| Task done? | Compare "what to do" with "what was done" |
| In scope? | Did not touch files outside the whitelist |
| Follows the architecture? | Structure as in ARCHITECTURE.md |
| Patterns observed? | PDO prepared statements, htmlspecialchars, error handling |
| Any questions? | Read the "questions for the Tech Lead" section |

**Red flags:**
- "While I was at it, I also fixed..." - went beyond scope
- "It didn't work out, so I did it differently" - a deviation from the architecture
- No report of what did not work - hiding problems

## Architect

| Check | How |
|---|---|
| Task done? | Designed what was asked (architecture / mapping) |
| Source of truth observed? | Fields and API versions taken from the application's documentation, not from memory |
| Implementable in stages? | Each component is a separate task for the Developer, no "everything first" |
| "Requires verification" marks? | Anything not confirmed by the docs is marked, not invented |
| Any questions? | Read the "Questions for the Tech Lead" section |

**Red flags:**
- Values filled in "plausibly" without a "requires verification" mark - designing from memory
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
- Criticality: blocker / can continue / cosmetic?

## Reviewer

| Severity | Action |
|---|---|
| HIGH/CRITICAL | Stop. Task for the Developer to fix |
| MEDIUM | Assess: fix now or after the mission |
| LOW | Note it, fix when convenient |

## Tester

| Verdict | Action |
|---|---|
| PASS (plan) | Approve the plan, launch the run |
| PASS (run) | Automated tests passed, hand the manual steps to the user |
| FAIL | Analyze: a bug in the code or in the test? |

## Researcher

The researcher's result is information, not code. Evaluate by:
- Are all the questions from the task covered?
- Are there sources (links)?
- Are there contradictions between the sources?
