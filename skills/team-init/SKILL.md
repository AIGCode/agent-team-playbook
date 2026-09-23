---
name: team-init
description: >
  Deploying an agent team into a project from the team-playbook framework: copying
  the framework, adapting it to the project, launching the Tech Lead. Use when a
  project needs a team created. Triggers: "create a team", "deploy a
  team", "connect a team", "set up the project team", "team init".
user-invocable: true
---

# Deploying a team into a project

Installs the ready-made team framework (`~/.claude/team-playbook/` by default) into a project and adapts it to the project. Invoked from `project-init` (on the answer "create the team now") or directly.

## Steps

### 0. Find the framework
Check that the framework folder `~/.claude/team-playbook/` exists. If not - ask the user for the path to it and work with that path from then on. Why: the framework is a source folder, and everyone's disk layout is different; below, "the framework" is the folder that was found.

### 1. Copy the framework
Copy the contents of `team/` from the framework into the project root as `<project>/team/`: `ROLES.md`, `workflow.md`, `RUN.md`, the templates (`contract-template.md`, `task-templates.md`, `deploy-template.md`, `security-template.md`, `security-example.md`), `report-evaluation.md`, the `roles/` folder. The security templates are needed so the Tech Lead can set up the project's `SECURITY.md`: the Reviewer and `project-init` refer to it. Do not copy the `missions/` folder - it appears with the first mission.

### 2. Adapt to the project
Fill in the placeholders in the copied files:
- `<project>` - the project name/path.
- `[brief project description]` in the roles' `<context>` - one or two sentences on what the project is.
- "Local environment" in the `<context>` of the Developer and the Tester - whether there is a local runtime on the machine and how to check syntax (locally or in a temporary folder on the server). By it the Developer checks the code, the Tester chooses where to test, and DEPLOY - where to check syntax before uploading.
- `<model>` in `team/RUN.md` - the model alias for launching agents (for example, `opus`).
- `<context>` of each role where it exists (the Researcher has none - the role does not depend on the project): fill in the parameterized form with the project's real stack and server. This is only filling in: the role rules are not rewritten at this step (about them - below).
- `<SERVER_ROOT>` - the real root on the server (in the roles and in `deploy-template.md`).
- `<app>` stays a placeholder (the specific application is set by the Tech Lead in the mission assignment).

Filling in the placeholders is enough only if the project is on the same stack as the sample (PHP on shared hosting). The roles in the framework are a working sample: PHP sits not only in `<context>`, but also in the rules, examples and references (for example, the Reviewer's rules, the Developer's syntax check, the Tester's curl tests). If the stack is different, at this step invoke the `new-role` skill for each role with stack-specific parts - Developer, Architect, Reviewer, Tester, for the Tech Lead - the stack-specific references, for the Checker - the steps of finding consumers and checking compatibility (steps 3-4 of their `<workflow>`: `$settings`, `require`, `credentials.php`) and the examples; the Researcher does not depend on the stack. When rewriting, the role's purpose, boundaries and report format stay, the antipatterns stay in meaning (the stack-specific details in them are replaced), the stack-specific rules, examples and references are replaced with the rules of the project's stack.

With a different stack, adapt the templates too - they also contain PHP: `report-evaluation.md` (pattern signs in evaluating the Developer's report), `deploy-template.md` (syntax check and rollback commands), `security-example.md` (a PHP example of filling in `SECURITY.md` - replace it with your own example on the project's stack or remove it, so the Tech Lead does not take the PHP rules as a model). Otherwise the Tech Lead will evaluate reports and write the deploy by PHP signs.

The roles the project does not need - delete them and find all mentions of the role by its name (grep over the project's `team/`), bring each one in line. Why by search and not by a list: a role is mentioned in many places, and one missed mention means the Tech Lead follows the chain to a role that does not exist, or runs into its gate. Where a role usually appears, for example (not only): `team/ROLES.md`, `team/RUN.md` (agent names, the models table, parallelism rules), `team/workflow.md` (the chain, the rules, the list of assignments in the mission tree, the "When to skip a step" table), `team/task-templates.md`, `team/roles/techlead.md` (Teammates, delegation, examples), `team/report-evaluation.md` (the role's block). The missing ones - create with the `new-role` skill, the existing ones with stack-specific parts - rewrite for the stack with it as well.

### 3. Enable agent teams
Check `~/.claude/settings.json` (details in `team/RUN.md`):
```json
{ "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" } }
```

### 4. Launch the Tech Lead
A new chat = the technical lead. Hand them the `team/roles/techlead.md` role. Ask them to go through the startup procedure and confirm HOW they intend to work, themselves and with the team. Until they have confirmed - do not launch missions.

At the start the Tech Lead assembles the load-bearing elements for the project - the team, the plans (of work / development / testing), the patterns (`PATTERNS.md`), security: a simple project needs the minimum in one place, a complex one needs more, with extraction into separate files and splitting (plans by kind, patterns by role or by layer). The contract is always needed, except for trivial tasks (the condition - `team/workflow.md`, "When to skip a step"), the architecture - when there is something to hold together. If the project contains an `ARCHITECTURE.md` draft that the user has not accepted (it was created by `project-init` before the team was deployed), the Tech Lead considers the architecture absent - the first mission is an architectural one: otherwise the project relies on a document nobody has checked.

### 5. Work
After accepting the role, the Tech Lead runs missions along the chain from `team/workflow.md` (the architectural mission, the order Tester PLAN / deploy / Tester RUN and closing the mission are there too). From there the user either works with the project themselves, or the Tech Lead launches teammates per `team/RUN.md`.

## Important about the Tech Lead's context
The rules are loaded into the Tech Lead at the start of the session, and by the middle of the context they forget them. If you see them forgetting - have them re-read their role (`team/roles/techlead.md`) and ask them to say what they are doing and where they went wrong (let them work through their own mistakes).
