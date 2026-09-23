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

A gate is a point past which work does not go until it has been checked. This keeps an error from travelling further down the chain.

- **Contract** - work does not start until you have approved what you will get and how it will be checked.
- **Checker** - code does not go further until it has been checked for breakage, mismatches and consistency.
- **Reviewer** - a large change is not closed without a security review.
- **Tester** - the result is not accepted without tests.
- **Deploy** - is not considered done until the code is rolled out and works.

When a gate can be skipped is decided by the Tech Lead using the conditions in `team/workflow.md` ("When to skip a step").

## Core rules

- **One changes, many check.** One role at a time edits files, the checking roles work in parallel: two editing roles would overwrite each other's work.
- **You talk to the Tech Lead.** They come to you only with a blocker, a step outside the contract or a decision that is yours.
- **The team does not change its own instructions** (`team/`) without your consent.
- **A mission is closed when the contract is closed and the plan is updated.** Otherwise the next chat will not know the work is already done.

## Tech Lead's context

The rules are loaded into the Tech Lead at the start of the session, and by the middle of the context they forget them. If you see them forgetting - have them re-read their role (`team/roles/techlead.md`) and ask them to say what they are doing and where they went wrong. They must work through their own mistakes.
