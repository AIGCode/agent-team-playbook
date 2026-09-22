# Workflow: Mission

## Chain

```text
User → Tech Lead: request
  ↓
Tech Lead: data gathering + interview
  ↓
Tech Lead: reads `<project>/docs/<app>/ARCHITECTURE.md`, locates the files, drafts the contract
  ↓
Tech Lead → User: approves the contract
  ↓
Tech Lead → Developer: coding task
  ↓
Tech Lead → Checker: regression check
  ↓ (if regressions)
Tech Lead → Developer: fix → Checker: re-check
  ↓ (loop until there are no regressions)
Tech Lead → Reviewer: scope review (for large changes)
  ↓ (if issues)
Tech Lead → Developer: fix
  ↓ (if the mission changes files on the server)
Tech Lead → Tester: test preparation (before deploy, no Bash)
  ↓
Tech Lead → Developer: step-by-step deployment instruction (template team/deploy-template.md)
  ↓
Tech Lead → User: result + deployment instruction (what to verify and deploy by hand)
  ↓ (after the user has deployed)
Tech Lead → Tester: test run on production (automated + instructions for the manual ones, B/C)
  ↓
Tech Lead → User: test results + manual steps (B/C)
```

## Rules

- One writer (Developer) at a time. Read-only roles (Checker, Reviewer, Tester) run in parallel if their scopes do not overlap
- The Tech Lead does not go back to the user for routine decisions. Return to the user on: a blocker, going beyond the contract scope, a user's choice
- The Tech Lead does not edit team/ files (roles, workflow, templates) without the user's agreement
- Git commit + push before and after the Developer. Before launching the Developer: check git status, commit and push any uncommitted changes (a clean state). After the Developer finishes: commit and push their work
- A mission is a container of work; the contract inside it is drafted when a result is being made from it (plain research - no contract). Plans are flexible: a large plan - many missions, a small one - a single mission; the size is set by the Tech Lead (see TEAM.md "Load-bearing")
- The project's patterns (`PATTERNS.md`, if it exists) - the canon of "how": the Developer checks against it before coding, the Checker verifies conformance

## Artifacts

Missions are numbered sequentially. A number + a short description.

```text
team/missions/
  001_short-name/
    contract.md              Contract (goal, scope, verification)
    DEPLOY.md                Deploy instructions for the user (if the mission is deployed)
    research/                Research within the mission (if any)
    tasks/
      developer.md           Task for the Developer
      checker.md             Task for the Checker
      tester.md              Task for the Tester
    reports/
      developer.md           Developer's report
      checker.md             Checker's report
      reviewer.md            Reviewer's report
      tester-plan.md         Test plan (Tester PLAN)
      tester-run.md          Test results (Tester RUN)
  002_short-name/
    ...
```

## When to skip a step

| Step | Can be skipped if |
|---|---|
| Contract | The task is trivial (1-2 files, no risks) |
| Checker | The changes are isolated (a new file, no consumers) |
| Reviewer | A small edit already covered by the Checker |
| Tester | No deploy, preparation only |
| DEPLOY.md | The changes do not go to the server (local analysis only / a one-off CLI artifact not copied to production) |
