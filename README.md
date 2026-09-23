[English](README.md) · [Українська](README.uk.md)

# team-playbook - how to use

> Usually you take a task to a chat: you describe the problem and get an answer. A single chat handles a large task poorly. It loses the thread, forgets what was agreed, and does not check itself. Along with the chat, the material you worked with is lost too: findings, decisions, drafts. That is why a project is set up first, where everything the work involves is stored. Any new chat will read it and continue from the same place. Once there is a project, a team can be connected to it: one chat runs the work and talks to you, the others do the work and check it. Below is how to start: how to turn your task into a project, connect the team, and give a new chat its role so that it understands what is needed from it.

> The role prompts and task complexity are designed for models in the Opus 4.8 class and above. On weaker models quality is not guaranteed.

## Three words

- **Role** - an instruction file: who the chat will be in this work.
- **Tech Lead** - the role of the chat that runs the work and talks to you.
- **Skill** - a ready-made Claude Code procedure that you run by name.

## Installation

Put the `team-playbook/` folder in `~/.claude/team-playbook/`. This is the framework - a source folder, not a project: the skills take the team and the templates from it for every new project. You can also put it elsewhere - then `team-init` (it takes the team and the templates from the framework) will ask for the path to it. Copy the skills from `skills/` into `~/.claude/skills/`, one folder per skill.

## Getting started

**There is no project yet.**
1. Basic research: gather the initial information on the task.
2. `project-init`: set up the project.
3. `team-init`: deploy the team.
4. `new-role`: if your stack is not PHP - rewrite the roles for the project's stack.

**There is a project.**
1. Open a new chat, hand it the project's `AGENTS.md`: "We are working in this project".
2. Hand it the role file: "This is your role, tell me how you understood it".
3. If this is the Tech Lead role (`team/roles/techlead.md`), they report how they understood the role and run the work per the workflow. If it is another role, this is short work within the project without a Tech Lead.

## Lifecycle

```
New project
  -> skill project-init: create the project, ask "team now or later?"
  -> skill team-init: deploy team/ into the project, fill in the placeholders;
     if the stack is not PHP - call new-role for each role with stack-specific parts
     (Developer, Architect, Reviewer, Tester, the Tech Lead's references, the Checker's steps and examples;
     the Researcher does not depend on the stack)
  -> new chat: the user assigns the Tech Lead role
     (see "Getting started")
  -> if the project needs an architecture (there is an application or a system
     of several components) - the first mission of a new application
     is architectural, with its own contract:
     the Architect writes ARCHITECTURE.md, the user accepts the document,
     the mission is closed; all subsequent contracts rely on it
  -> work: the Tech Lead runs missions
     (contract -> Developer -> Checker -> Reviewer -> Tester: preparation
     -> deploy -> Tester: run)
  -> mission closure: the contract is closed (status: closed), the project's plan and decisions
     are updated, the work is committed
```

If the team was deferred - deploy it later with the `team-init` skill.

## What's inside

- `team/` - the team framework: roles (`roles/`), the mission chain (`workflow.md`), launching agents (`RUN.md`), templates (contract, task, deploy, security - `security-template.md` and the PHP example `security-example.md`), report evaluation. The placeholders (`<project>`, `<app>`, `<SERVER_ROOT>`, `<model>`, `[brief project description]`, "Local environment" for the Developer and the Tester) are filled in for the specific project; if the project's stack is not PHP, filling them in is not enough - the roles are also rewritten for the stack (see "For your own project").
- `skills/` - three skills:
  - `project-init` - create and organize a new project (file structure).
  - `team-init` - deploy the team into a project from the framework.
  - `new-role` - create a new team role or rewrite an existing one for your stack.
- `TEAM.md` - the team's operating principles (read before the first mission).

## For your own project

**What carries over and what is adapted.** The principles carry over: the mission chain, the contract as a gate, gates with skip conditions, one writer at a time, scope isolation, report formats, load-bearing elements, and templates. They do not depend on the stack and work in any project. What is tied to the stack is adapted: the roles' stack rules, the references tables, checklists, the test strategy. The roles in `team/roles/` are a working sample for PHP on shared hosting, not a ready-made team for any project: filling in the placeholders is not enough if the stack is different. The roles are rewritten for your stack with the `new-role` skill - the role's purpose, its boundaries, and the report format stay, the antipatterns stay in meaning (the stack specifics in them are replaced), the PHP rules and examples are replaced with the rules of your stack.

## What to read next

1. `README.md` (this file) - what lives where.
2. `TEAM.md` - the principles: the chain, roles, gates, rules.
3. `team/roles/` - the roles, a working sample for PHP (developer, checker, reviewer, tester, researcher, architect, techlead); they are rewritten for your stack with the `new-role` skill.
4. `team/workflow.md` and `team/RUN.md` - the mechanics of a mission and of launching.

From there, go deeper via the links.

---

> **Disclaimer.** The examples and templates in this set are illustrative - they are not real configurations or ready-made "100%" solutions. You are responsible for the security, data, and money of your own applications, and you assemble the necessary amount of rules yourself. Check everything for your own project: a mistake can cost you data, money, or your job.
