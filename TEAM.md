[English](TEAM.md) · [Українська](TEAM.uk.md)

# Team operating principles

Operating principles of the agent team: what keeps the project from falling apart, how a mission runs, who writes and who reviews.

## Mission chain

```
User -> Tech Lead: request
  -> Tech Lead: data gathering + interview
  -> Tech Lead: contract -> approval by the user
  -> Developer: code
  -> Checker: regressions and consistency   (Developer <-> Checker loop until clean)
  -> Reviewer: scope review (for large changes)
  -> Tester: test preparation (before deploy)
  -> Developer: step-by-step deployment instruction
  -> User: deploys by hand following the instruction, gets the result
  -> Tester: test run after deploy (automated + for the user, B/C)
  -> User: runs the final tests (B/C)
```

## Roles

A role is an agent with its own specialization and instruction; the more complex the project, the more roles (a simple one gets by with a couple, a complex one needs them all). Some roles change files (writers), some only review (readers) - only one can change at a time, readers are safe and run in parallel. The exception is the Tester on production: their requests reach the live site, so during that time they work alone.

The roles in `team/roles/` are a working sample for PHP on shared hosting. The principles below carry over to any project as is, and the roles' stack rules are rewritten for your own stack with the `new-role` skill.

- **Tech Lead** (writer) - coordinator; in a mission, the only one who talks to the user (this is a recommendation: when needed, the user works with any role directly, without the Tech Lead), draws up the contract, hands out tasks, evaluates reports.
- **Developer** (writer) - implements code per the task, strictly in the files handed to them.
- **Architect** (writer) - designs the architecture and maintains its document; does not touch production code.
- **Checker** (reader) - after the Developer, looks for regressions, drift from patterns, and inconsistencies (consistency): the new does not diverge from what already exists.
- **Reviewer** (reader) - final review: security and structure.
- **Tester** (reader) - plans and runs tests after deploy; on production, does only checks without consequences themselves and does not run in parallel with others.
- **Researcher** (reader) - gathers information from the web and files.

Who to launch when - `team/ROLES.md`. How to launch - `team/RUN.md`.

## Load-bearing

Load-bearing elements are what keep the project from falling apart. The larger it is, the more easily it falls apart: context is lost, decisions drift, work diverges. The more load-bearing elements are needed to hold it together. The set is chosen per project - a small task gets by with a couple, a large one needs them all; how many to take is decided by the Tech Lead at the start, during data gathering.

- **Contract** - fixes what we get as the result and how we accept it.
- **Architecture** - boundaries, layers, connections.
- **Team** - role descriptions for agents: from one role to many.
- **Plans** - of work, development, testing.
- **Patterns** - the canon of "how": naming, layout, which method. A simple project gets by with a single `PATTERNS.md`, a complex one needs sets by role or by layer (`patterns/<name>.patterns.md`); what to set up is decided by the Tech Lead.
- **Security** - rules of secure code.

## Gates

A gate is a checkpoint that work does not pass until it is confirmed. It keeps the unverified from moving further, so that an error does not run down the chain. It can be skipped only when the gate has nothing to check.

- **Contract** - work does not begin without an approved result. Skip: the task is trivial (1-2 files, no risks).
- **Checker** - code does not move further until it is checked for regressions and consistency. Skip: the changes are isolated - a new file with no consumers that does not introduce its own variant of what the project already has (a second helper, a different name for the same concept). Why the caveat: such a file has nothing to break, but it can introduce an inconsistency with the existing code.
- **Reviewer** - a large change is not closed without a review. Skip: a minor edit already covered by the Checker. Large means a change where an error can turn into a leak, a breach, or a production breakdown. Signs, for example (not only these): a new entry point (endpoint, webhook, script), authorization and secrets, files or data from an external user, money and payments, a change to many files at once. If there is at least one sign - the Reviewer is needed.
- **Tester** - the result is not accepted without tests. Skip: there is no deploy.
- **Deploy** - it is not done until the code is rolled out and works; if it did not work - roll back. Skip: the changes do not go to the server.

## Core rules

- **One writer at a time.** Read-only roles work in parallel if their scope does not overlap. The exception is the Tester on production: while they run tests on the live site, other agents are not launched, so that their work does not get mixed up with the Tester's checks.
- **An architecture is needed but does not exist - the first mission is architectural.** Architecture is a load-bearing element that the Tech Lead picks for the project (see "Load-bearing"). The contract relies on `ARCHITECTURE.md` if the project needs an architecture (there is an application or a system of several components); if it does not exist or is outdated, the Tech Lead first runs a separate architectural mission with its own contract: the result - `ARCHITECTURE.md`, the verification - the user reads and accepts the document. Then the task for the Architect, the user's acceptance of the document, the mission's closure. Only after that - the contract for the original task, which relies on the finished architecture. The "always a contract" rule is not broken by this: the architectural mission has a contract too; it is drawn up without `ARCHITECTURE.md` (it does not exist yet) - from the task, the existing code, and the documentation. If the project does not need an architecture, the contract relies on the affected files and the existing code.
- **Scope isolation.** Each agent gets only the files of its domain, via an explicit whitelist. A broad scope burns context and yields a blurry result.
- **The contract is a gate.** There is always a contract between the task and the work, except for trivial tasks (the skip condition is in "Gates"); the Developer is not launched until the user has approved it.
- **Returning to the user** - only a blocker, going beyond the contract's scope, or a user choice. The Tech Lead does not surface for routine matters.
- **Git before and after the Developer.** Before - a clean state (commit/push anything uncommitted); after - commit their work.
- **An agent does not edit `team/` files** without agreeing it with the user. Symmetrically: the Developer does not edit documentation, entities, and decisions - that is the Tech Lead's domain. Exception: the Architect writes the architecture document (`ARCHITECTURE.md` and its extensions `ARCH_*.md`) per the task - that is their result - and maintains the architectural decisions in `DECISIONS.md` (the shared one or `docs/<app>/DECISIONS.md` - which one is specified in the task); the rest of the documentation (`CONTEXT.md`, `PATTERNS.md`, and others) they do not edit either.
- **A stopped agent.** After a stop/kill, first find out what it managed to do and which files it touched, report to the user - they decide. Do not launch a new agent right away: it will overwrite the work.
- **Mission closure.** A mission is closed when the Tech Lead has marked the contract closed (`status: closed`, `closed_at`), updated the project's plan and decisions, and committed the work. Without this step, the next session does not know that the mission is already finished.

## Reports

Each role has its own prescribed format (without a template an agent answers chaotically), and each report has an outcome that the Tech Lead reads first: the Checker and the Architect - a PASS / FAIL / NEEDS_REVIEW verdict; the Reviewer - a verdict (PASS = no HIGH, including risks outside the list) and violations by severity; the Tester - a verdict in PLAN and in RUN (PASS only if the tests cover the contract's acceptance criteria); the Developer - a DONE / PARTIAL / BLOCKED status and a table "acceptance criterion - met - how verified", not a self-assessed PASS; the Researcher - a short outcome at the top (what is covered, what was not found), the full material - in files. The Tech Lead reads the outcome + Summary + Action Items, and the details point by point at file:line. How to respond per role - `team/report-evaluation.md`.

## Tech Lead's context

The rules are loaded into the Tech Lead at the start of the session, and by the middle of the context they forget them. If you see them forgetting - have them re-read their role (`team/roles/techlead.md`) and ask them to say what they are doing and where they went wrong. They must work through their own mistakes.
