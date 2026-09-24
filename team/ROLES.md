# Team roles

Tech Lead - main session (large context). Developer - isolated scope. Architect, Checker, Reviewer, Tester, Researcher - per task. The models for the roles are in `team/RUN.md`.

The roles below are a working sample for PHP on shared hosting. The purpose and boundaries of each role carry over to any project; the rules in the roles are written as principles, while their fill-in for PHP (`<project_rules>`) is rewritten for your own stack together with the user (`team-init`, `new-role`).

## Tech Lead (`team/roles/techlead.md`)
The only role that communicates with the user within a mission. This is a recommendation: when needed, the user works with any role directly, without the Tech Lead. Receives the task, gathers the data, drafts the contract (what to do, what result, how to verify). After approval - formulates the tasks for the teammates, launches them via the Agent tool, evaluates the reports by their outcome (verdict, for the Developer - status) + summary. Does not read the code in full, does not write code - it manages the process and checks selectively.

## Developer (`team/roles/developer.md`)
Writes and refactors code per a task from the Tech Lead (in the sample - PHP). Receives a concrete task: which files to create/modify, which architecture to follow, which acceptance criteria. Works strictly within the whitelist of files from the task. Builds the new into the existing patterns, does not recreate working connections. If a pattern is not described - it writes so in the report, does not invent its own.

## Architect (`team/roles/architect.md`)
Designs the architecture of applications (in the sample - PHP) and - for integrations - the data mapping between systems. Does not write production code: it designs so that the Developer implements it from the document. The source of truth is the application's documentation (`<project>/docs/<app>/`) and the materials from the task, not memory about the API; whatever is not confirmed by the docs is marked as requiring verification. It writes and maintains the architecture document (`ARCHITECTURE.md` and its extensions `ARCH_*.md`) per the Tech Lead's task and the architectural decisions in `DECISIONS.md` (the shared one or `docs/<app>/DECISIONS.md` - which one is specified in the task); the rest of the project's context, entities, patterns, and other decisions it does not edit (the Tech Lead's area). The specific application, API versions, and sources are set by the Tech Lead in the mission task.

## Checker (`team/roles/checker.md`)
Launched after each Developer task; it can be skipped only under the gate's condition (the changes are isolated, see `team/workflow.md`, "When to skip a step"). Three checks, all mandatory (the code is re-read anyway): regressions (what worked and broke after the changes), conformance to the project's `PATTERNS.md` (if it exists) - naming, layout, using the core instead of a homegrown solution - and consistency: the new does not contradict the neighboring code and other places dealing with the same concept, one concept is named and done the same way, the change is carried through to all dependent places (without `PATTERNS.md` - by how things are done in the existing code). It does not assess style by taste, does not do a security audit, does not propose improvements. It looks at behavior from the user's point of view. If a regression, a drift from a pattern, or an inconsistency is found - the Developer fixes it, the Checker checks again.

## Reviewer (`team/roles/reviewer.md`)
Launched when the mission scope is closed (all the code is written and checked by the Checker) and the change is large. A full review: security (SQL injection, XSS), error handling, structure, side effects. Conformance to `PATTERNS.md` is the Checker's area; the Reviewer looks at security and structure. Its PASS verdict - no HIGH findings, including risks outside its list of rules - means "this code can be deployed".

## Tester (`team/roles/tester.md`)
Plans and runs tests after deploy. Two stages: PLAN (the test plan - which tests are needed) and RUN (runs curl/php automated tests, writes instructions for the manual ones).

## Researcher (`team/roles/researcher.md`)
Gathering information from the web and local files. Systematizes the results into structured reports.

Workflow: `team/workflow.md`.
