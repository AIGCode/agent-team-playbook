[English](TEAM.md) · [Українська](TEAM.uk.md)

# Team operating principles

Operating principles of the agent team: what keeps the project from falling apart, how a mission runs, who writes and who reviews.

## Mission chain

```
User -> Tech Lead: request
  -> Tech Lead: data gathering + interview
  -> Tech Lead: contract -> approval by the user
  -> Developer: code
  -> Checker: regressions   (Developer <-> Checker loop until clean)
  -> Reviewer: scope review (for large changes)
  -> Tester: test preparation (before deploy)
  -> Developer: step-by-step deployment instruction
  -> User: deploys by hand following the instruction, gets the result
  -> Tester: test run after deploy (automated + for the user, B/C)
  -> User: runs the final tests (B/C)
```

## Roles

A role is an agent with its own specialization and instruction; the more complex the project, the more roles - a simple one gets by with a couple, a complex one needs them all. Some roles change files (writers), some only review (readers) - only one can change at a time, readers are safe and run in parallel.

- **Tech Lead** (writer) - coordinator; the only one who talks to the user, draws up the contract, hands out tasks, evaluates reports.
- **Developer** (writer) - implements code per the task, strictly in the files handed to them.
- **Architect** (writer) - designs the architecture and maintains its document; does not touch production code.
- **Checker** (reader) - after the Developer, looks for regressions and drift from patterns.
- **Reviewer** (reader) - final review: security and structure.
- **Tester** (reader) - plans and runs tests after deploy.
- **Researcher** (reader) - gathers information from the web and files.

Who to launch when - `team/ROLES.md`. How to launch - `team/RUN.md`.

## Load-bearing

Load-bearing elements are what keep the project from falling apart. The larger it is, the more easily it falls apart: context is lost, decisions drift, work diverges. The more load-bearing elements are needed to hold it together. The set is chosen per project - a small task gets by with a couple, a large one needs them all; how many to take is decided by the Tech Lead at the start, during data gathering.

- **Contract** - fixes what we get as the result and how we accept it.
- **Architecture** - boundaries, layers, connections.
- **Team** - role descriptions for agents: from one role to many.
- **Plans** - of work, development, testing.
- **Patterns** - the canon of "how": naming, layout, which method.
- **Security** - rules of secure code.

## Gates

A gate is a checkpoint that work does not pass until it is confirmed. It keeps the unverified from moving further, so that an error does not run down the chain. It can be skipped only when the gate has nothing to check.

- **Contract** - work does not begin without an approved result. Skip: the task is trivial (1-2 files, no risks).
- **Checker** - code does not move further until it is checked for regressions. Skip: the changes are isolated (a new file with no consumers).
- **Reviewer** - a large change is not closed without a review. Skip: a minor edit already covered by the Checker.
- **Tester** - the result is not accepted without tests. Skip: there is no deploy.
- **Deploy** - it is not done until the code is rolled out and works; if it did not work - roll back. Skip: the changes do not go to the server.

## Core rules

- **One writer at a time.** Read-only roles work in parallel if their scope does not overlap.
- **Scope isolation.** Each agent gets only the files of its domain, via an explicit whitelist. A broad scope burns context and yields a blurry result.
- **The contract is a gate.** There is always a contract between the task and the work; the Developer is not launched until the user has approved it.
- **Returning to the user** - only a blocker, going beyond the contract's scope, or a user choice. The Tech Lead does not surface for routine matters.
- **Git before and after the Developer.** Before - a clean state (commit/push anything uncommitted); after - commit their work.
- **An agent does not edit `team/` files** without agreeing it with the user. Symmetrically: the Developer does not edit documentation, entities, and decisions - that is the Tech Lead's domain. Exception: the Architect writes the architecture document (`ARCHITECTURE.md`) per the task - that is their result; the rest of the documentation and decisions they do not edit either.
- **A stopped agent.** After a stop/kill, first find out what it managed to do and which files it touched, report to the user - they decide. Do not launch a new agent right away: it will overwrite the work.

## Reports

Each role has its own prescribed format (without a template an agent answers chaotically): a PASS/FAIL verdict for roles with a yes/no result, severity for the Reviewer, PLAN/RUN for the Tester, structured information for the Researcher. The Tech Lead reads Verdict + Summary + Action Items, and the details point by point at file:line. How to respond per role - `team/report-evaluation.md`.

## Tech Lead's context

The rules are loaded into the Tech Lead at the start of the session, and by the middle of the context they forget them. If you see them forgetting - have them re-read their role (`team/roles/techlead.md`) and ask them to say what they are doing and where they went wrong. They must work through their own mistakes.
