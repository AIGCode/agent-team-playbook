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
```

## Output format

Every role must have its own prescribed response format - without a template the agent answers chaotically. Below is the base format for roles with a yes/no result (Developer, Checker, Architect). The reviewing roles and the researcher have their own formats, see their roles: Reviewer - severity (HIGH/MEDIUM/LOW), Tester - PLAN/RUN, Researcher - structured information without a verdict.

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
