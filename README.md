[English](README.md) · [Українська](README.uk.md)

# team-playbook - how to use

A portable framework for a team of AI agents plus skills for working on projects. From here the team deploys into any project.

> The role prompts and task complexity are designed for models in the Opus 4.8 class and above. On weaker models quality is not guaranteed.

## What's inside

- `team/` - the team framework: roles (`roles/`), the mission chain (`workflow.md`), launching agents (`RUN.md`), templates (contract, task, deploy), report evaluation. The placeholders (`<project>`, `<app>`, `<SERVER_ROOT>`) are filled in for the specific project.
- `skills/` - three skills:
  - `project-init` - create and organize a new project (file structure).
  - `team-init` - deploy the team into a project from the framework.
  - `new-role` - create a new team role.
- `TEAM.md` - the team's operating principles (read before the first mission).

## Lifecycle

```
New project
  -> skill project-init: create the project, ask "team now or later?"
  -> skill team-init: deploy team/ into the project, fill in the placeholders
  -> new chat = Tech Lead: hand them team/roles/techlead.md;
     they confirm how they will work themselves and with the team
  -> work: Tech Lead runs missions
     (contract -> Developer -> Checker -> Reviewer -> Tester -> deploy)
```

If the team was deferred - deploy it later with the `team-init` skill.

## Where to start (for a new team member)

1. `README.md` (this file) - what lives where.
2. `TEAM.md` - the principles: the chain, roles, gates, rules.
3. `team/roles/` - the roles as living examples (developer, checker, reviewer, tester, researcher, architect, techlead).
4. `team/workflow.md` and `team/RUN.md` - the mechanics of a mission and of launching.

From there, go deeper via the links.
