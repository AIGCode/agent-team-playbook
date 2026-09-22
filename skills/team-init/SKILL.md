---
name: team-init
description: >
  Deploying an agent team into a project from the team-playbook skeleton: copying
  the skeleton, adapting it to the project, launching the Tech Lead. Use when a
  project needs a team created. Triggers: "create a team", "deploy a
  team", "connect a team", "set up the project team", "team init".
user-invocable: true
---

# Deploying a team into a project

Installs the ready-made team skeleton from `team-playbook/team/` into a project and adapts it to the project. Invoked from `project-init` (on the answer "create the team now") or directly.

## Steps

### 1. Copy the skeleton
Copy the contents of `team-playbook/team/` into the project root as `<project>/team/`: `ROLES.md`, `workflow.md`, `RUN.md`, the templates (`contract-template.md`, `task-templates.md`, `deploy-template.md`), `report-evaluation.md`, the `roles/` folder. Do not copy the `missions/` folder - it appears with the first mission.

Plus copy `team-playbook/TEAM.md` into the project root (`<project>/TEAM.md`): these are the team's operating principles - the Tech Lead reads them before the first mission, and `workflow.md` refers to them.

### 2. Adapt to the project
Fill in the placeholders in the copied files:
- `<project>` - the project name/path.
- `<context>` of each role: replace the parameterized form with the project's real stack and server; remove or replace the generic PHP example if the project is not on PHP.
- `<SERVER_ROOT>` - the real root on the server (in the roles and in `deploy-template.md`).
- `<app>` stays a placeholder (the specific application is set by the Tech Lead in the mission task).

Delete the roles the project does not need. Create the missing ones with the `new-role` skill.

### 3. Enable agent teams
Check `~/.claude/settings.json` (details in `team/RUN.md`):
```json
{ "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" } }
```

### 4. Launch the Tech Lead
A new chat = the Tech Lead. Hand it the `team/roles/techlead.md` role. Ask it to go through the startup procedure and confirm HOW it intends to work, itself and with the team. Until it has confirmed - do not launch missions.

At the start the Tech Lead assembles the load-bearing elements for the project - the team, the plans (of work / development / testing), the patterns (`PATTERNS.md`), security - by the principle from `team-playbook/TEAM.md` ("Load-bearing"): a simple project needs the minimum in one place, a complex one needs more, with extraction into separate files and splitting (plans by kind, patterns by role). The contract is always needed, the architecture - when there is something to hold together.

### 5. Work
After accepting the role, the Tech Lead runs missions per `team/workflow.md`: contract -> Developer -> Checker -> Reviewer -> Tester (PLAN/RUN) -> deploy. From there the user either works with the project themselves, or the Tech Lead launches teammates per `team/RUN.md`.

## Important about the Tech Lead's context
The rules are loaded into the Tech Lead at the start of the session, and by mid-context it forgets them. If you see it forgetting - let it re-read its role (`team/roles/techlead.md`) and ask it to say what it is doing and where it went wrong (let it analyze its own mistakes). More about the team's working principles - `team-playbook/TEAM.md`.
