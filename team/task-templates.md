# Templates

The Tech Lead reads this file before delegating. Two templates: the task for an agent and the output format.

## Task for an agent

```markdown
# Task: [name]

## What to do
[One sentence: what to implement/check/refactor]

## Context
Read: [paths to documentation, architecture, code]

Brief description:
- [What this block should do / what to check]

## Files to work with
| File | Action |
|------|----------|
| [path] | Create / Modify / Read (read-only) |

## Constraints
- Do not touch: [files/modules outside the scope]

## Acceptance criteria
- [ ] [Scenario works]
- [ ] [Edge case handled]

## Result format
Report to `team/missions/<NNN>_<name>/reports/<role>.md` per the output format below.
When done, send the Tech Lead via SendMessage (to: "team-lead") the report's outcome + Summary + the path to the report - plain text does not reach the Tech Lead.
```

## Output format

Every role must have its own prescribed response format - without a template the agent answers chaotically. Below is the base format for roles with a yes/no result (Checker, Architect). The other roles have their own format, see their roles, but all of them have an outcome at the top - the Tech Lead reads it first: Developer - `Status: DONE / PARTIAL / BLOCKED` and a table "acceptance criterion - met - how verified"; Reviewer - `## Verdict` (PASS = no HIGH, including risks outside the list) + violations by severity (HIGH/MEDIUM/LOW) + `## Summary`; Tester - `## Verdict` in PLAN and in RUN (PASS only if the tests cover the contract's acceptance criteria); Researcher - an outcome at the top (what is covered, what was not found, sources), without a verdict.

```text
## Verdict
PASS | FAIL | NEEDS_REVIEW

## Issues
- [HIGH] file:line - description
- [MEDIUM] file:line - description

## Action Items
- [ ] What needs to be done

## Summary
Up to 100 words.
```
