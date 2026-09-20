[English](TEAM.md) · [Українська](TEAM.uk.md)

# Team operating principles

How the agent team works on a project. The mechanics in detail live in `team/` (`workflow.md`, `RUN.md`, roles).

## Mission chain

```
User -> Tech Lead: task
  -> Tech Lead: contract -> approval by the user
  -> Developer: code
  -> Checker: regressions   (Developer <-> Checker loop until clean)
  -> Reviewer: scope review (for large changes)
  -> Tester: PLAN (before deploy) ... RUN (after deploy)
  -> User: result + DEPLOY.md
```

## Roles

- **Writers:** Tech Lead (coordinator, the only one who talks to the user), Developer (code), Architect (project docs).
- **Read-only:** Checker (regressions), Reviewer (review and security), Tester (tests), Researcher (information gathering).

Who to launch when - `team/ROLES.md`. How to launch - `team/RUN.md`.

## Gates (what can be skipped)

- Contract - the task is trivial (1-2 files, no risks).
- Checker - the changes are isolated (a new file with no consumers).
- Reviewer - a minor edit already covered by the Checker.
- Tester - there is no deploy.
- DEPLOY.md - the changes do not go to the server.

## Core rules

- **One writer at a time.** Read-only roles work in parallel as long as their scope does not overlap.
- **Scope isolation.** Each agent gets only the files of its domain, via an explicit whitelist. A broad scope burns context and yields a blurry result.
- **The contract is a gate.** There is always a contract between the task and the work; the Developer is not launched until the user has approved it.
- **Returning to the user** - only for a blocker, going beyond the contract's scope, or a user choice. The Tech Lead does not surface for routine matters.
- **Git before and after the Developer.** Before - a clean state (commit/push anything uncommitted); after - commit their work.
- **An agent does not edit `team/` files** without agreeing it with the user. Symmetrically: the Architect/Developer do not edit documentation, entities, and decisions - that is the Tech Lead's domain.
- **A stopped agent.** After a stop/kill, first find out what it managed to do and which files it touched, and report to the user - they decide. Do not launch a new agent right away: it will overwrite the work.

## Reports

Each role has its own prescribed format (without a template an agent answers chaotically): a PASS/FAIL verdict for roles with a yes/no result, severity for the Reviewer, PLAN/RUN for the Tester, structured information for the Researcher. The Tech Lead reads Verdict + Summary + Action Items, and the details point by point at file:line. How to respond per role - `team/report-evaluation.md`.

## Tech Lead's context

The rules are loaded into the Tech Lead at the start of the session, and by the middle of the context they forget them. If you see them forgetting - have them re-read their role (`team/roles/techlead.md`) and ask them to say what they are doing and where they went wrong. They must work through their own mistakes.
