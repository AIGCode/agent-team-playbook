[English](README.md) · [Українська](README.uk.md) · [Deutsch](README.de.md)

# team-playbook - how to use

> Everything a chat has worked out stays in its session: close the chat and the data is lost. A project keeps it separately from sessions, and any new chat continues from the same place.
>
> The bigger the project, the faster it falls apart: context gets lost, decisions drift, material scatters across chats. The framework holds the project together: all the context lives in the project's files, and the work grows with it - from a single chat to a team of roles.

This is what team-playbook is for. It grew out of my own practice of working with AI on many applications. Install it and start your first project - everything is below, step by step.

## Installation

Put the `team-playbook/` folder in `~/.claude/team-playbook/`. This is the framework - a source folder, not a project: the skills take the team and the templates from it for every new project. You can also put it elsewhere - then `team-init` (it takes the team and the templates from the framework) will ask for the path to it. Copy the skills from `skills/` into `~/.claude/skills/`, one folder per skill.

> The role prompts and task complexity are designed for models in the Opus 4.8 class and above. On weaker models quality is not guaranteed. The framework is written for Claude Code. If you work with another tool or model, ask it to find the Claude Code dependencies in the framework and adapt them to itself.

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
Task
  -> research: gather what is known
  -> project: materials and decisions are kept in one place
  -> team: joins when the task has grown
  -> architecture: if there is something to hold together
  -> missions in a loop:
       contract -> work -> check -> acceptance -> closing
       (the project's plan and decisions are updated after each one)
  -> project done
```

If the team was deferred - deploy it later with the `team-init` skill.

## What's inside

- `team/` - the team framework: roles (`roles/`), the mission chain (`workflow.md`), launching agents (`RUN.md`), templates (contract, task, deploy, security - `security-template.md` and the PHP example `security-example.md`), report evaluation. The placeholders (`<project>`, `<app>`, `<SERVER_ROOT>`, `[brief project description]`, "Local environment" for the Developer and the Tester) are filled in for the specific project; if the project's stack is not PHP, filling them in is not enough - the roles are also rewritten for the stack (see `TEAM.md`, "Roles").
- `skills/` - three skills:
  - `project-init` - create and organize a new project (file structure).
  - `team-init` - deploy the team into a project from the framework.
  - `new-role` - create a new team role or rewrite an existing one for your stack.
- `TEAM.md` - the team's operating principles (read before the first mission).

## What to read next

1. `README.md` (this file) - what lives where.
2. `TEAM.md` - the principles: the chain, roles, gates, rules.
3. `team/roles/` - the roles, a working sample for PHP (developer, checker, reviewer, tester, researcher, architect, techlead); they are rewritten for your stack with the `new-role` skill.
4. `team/workflow.md` and `team/RUN.md` - the mechanics of a mission and of launching.

From there, follow the links inside these files: where a topic is covered in more detail in another document, there is a link to it.

---

> **Disclaimer.** The examples and templates in this set are illustrative - they are not real configurations or ready-made "100%" solutions. You are responsible for the security, data, and money of your own applications, and you assemble the necessary amount of rules yourself. Check everything for your own project: a mistake can cost you data, money, or your job.
