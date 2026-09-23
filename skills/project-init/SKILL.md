---
name: project-init
description: >
  Creating, initializing, and organizing a new project or work project
  with the right file structure for AI-assisted development
  in Claude Code. Use when the user
  asks to create a project, start a new project, initialize a project,
  prepare a project structure, lay out project documents, create
  AGENTS.md/CONTEXT.md/PLAN.md, set up an AI-friendly workspace, or a project
  template. Triggers: "create a project", "create project", "new project",
  "start a project", "initialize a project", "project initialization",
  "prepare a project", "organize a project", "project structure",
  "project template", "project init", "init project", "new project",
  "create project", "project structure", "project template", "scaffold project".
user-invocable: true
---

# Project structure for AI-assisted development

## Principles

1. A project must be understandable to a new session on the first read
2. The project's files are project knowledge; instructions for agents (roles, chain, templates) live in the team (`team/`, `TEAM.md`)
3. The structure scales: a small project starts with 3 files, a large one can have 15+
4. Each file has a single responsibility
5. The model should not read everything - it reads the entry point and follows the links

## Project files

### Entry point (AI reads it first)

#### AGENTS.md
The project's single entry point: a new session reads it first and follows the links from it further.

Contains:
- What the project is (1-2 sentences)
- A table of the key files (name, purpose) - only those to start reading from; the full folder map is in `INDEX.md`
- Key rules for working with the project. Special project procedures that the model cannot guess (for example, a non-standard rollout order) - here too, as a line
- API, versions, endpoints (if any)
- Build/test commands (if any)
- Contacts (people: who is responsible for what). Agent roles are not here but in `team/ROLES.md`

Size: up to 200 lines. If it exceeds this - move the information of a bloated section that relates to the project (business data, architecture, security) to the appropriate project file (CONTEXT.md, ARCHITECTURE.md, INDEX.md, etc.), leave a link in AGENTS.md.

The entry point is `AGENTS.md` only. There is no need to split it into several files within this procedure: if that becomes necessary, the Tech Lead decides it together with the user.

Create: always, from day one. CLAUDE.md is not needed - everything is in AGENTS.md.

---

### Architecture and structure (a description of the application/system)

#### ARCHITECTURE.md
How the application or system is built: components, the links between them, technologies, patterns, principles.

Contains:
- Development principles and priorities
- A system diagram (ASCII/markdown)
- A description of the components
- Data flows
- The technology stack
- Server paths, hosting

It scales by the number of applications (the extraction rule):
- **One application** - one architecture: `<project>/docs/<app>/ARCHITECTURE.md`. If the architecture is set up, every mission starts from it (the roles read the file of the needed application per the assignment).
- **A server with several applications** - the server architecture is added in the root `<project>/ARCHITECTURE.md`: how the applications are placed, the list of applications, shared decisions, links to their `docs/<app>/ARCHITECTURE.md`. The detail of each application stays in its `docs/<app>/ARCHITECTURE.md`.

When a section of one architecture grows too large, it is moved into a separate `ARCH_[TOPIC].md` file. In the main file a brief description + a link remains. The extensions are part of the architecture: the Architect writes and maintains them, just like the main `ARCHITECTURE.md`.

Extension examples:
- `ARCH_STACK.md` - technology stack, versions, dependencies
- `ARCH_PATTERNS.md` - architectural patterns: layers, interaction of components (code patterns - naming, layout, helpers - are in `PATTERNS.md`)
- `ARCH_AUDIO.md` - audio pipeline, streaming
- `ARCH_API.md` - external APIs, versions, endpoints (security rules - in `SECURITY.md`)
- `ARCH_DATABASE.md` - DB schema, migrations
- `ARCH_BACKEND.md` - the server side
- `ARCH_FEATURES.md` - features, managers

Who writes it: the Architect per the Tech Lead's assignment (see the Architect role). Who edits it later: globally - the Architect; pointwise - the Tech Lead and only on the user's instruction.

Create: when the project has an application or a system of several components. Without a team - as a draft when the project is created; with a team - in the architectural mission, do not create a draft.

#### PATTERNS.md
The canon of "how": how recurring things are done in this project - naming (files, functions, variables), file layout, which method/helper for a typical task, error handling. This is not architecture (that is the corset of boundaries and connections): patterns are frequent and technical, applied constantly.

Why: without a canon each agent derives the pattern anew from the neighboring code, which itself drifts apart - "clusters" of inconsistent decisions grow. With `PATTERNS.md` the Developer checks against it before coding, the Checker verifies conformance.

It scales: a simple project - a single `PATTERNS.md`; a complex one - sets by role or by layer (`patterns/<name>.patterns.md`, for example `patterns/backend.patterns.md`, `patterns/frontend.patterns.md`). What to set up is decided by the Tech Lead by complexity (in a project with a team - by the principle from `TEAM.md`, "Load-bearing").

The entry format is a decision, not prose: "for X - always Y, not Z" + a micro-example. Do not silently make up a new situation: no pattern - the agent proposes it in the report (with the reason), the Tech Lead decides and adds it to `PATTERNS.md` - they are the only writer of patterns, so that the canon does not drift apart (in a project without a team - whoever runs the project).

Create: when more than one agent works on the code or the patterns start to drift apart.

#### INDEX.md
A map of the project: which folders and files, what each is for, how to find what you need.

Contains:
- A folder tree with a description of each
- Key files with paths
- Navigation hints ("custom code has the `app-` prefix")

The difference: the file table in `AGENTS.md` is only the key files to start reading from; `INDEX.md` is the full folder map. The `INDEX.md` that the Researcher puts next to the results is something else: the file index of one piece of research.

Create: when the project grows (>10 files or >3 nesting levels). Not a starting document but a navigational one.

#### SECURITY.md
Code security rules: web access control, endpoint validation, secrets, logging, file operations. The rollout order (backup, check, upload, rollback) is not here: it lives in the mission's deploy instruction per the `team/deploy-template.md` template. Like the patterns, they are tied to the stack and to the roles that apply them (the Developer writes by them, the Reviewer checks against them).

It scales by the extraction rule: few rules / the context is enough - they live as a section inside a role (the Reviewer's checklist is built into `reviewer.md`); many - they are moved into a separate `<project>/SECURITY.md`, and the roles refer to it as the source of truth. What to set up is decided by the Tech Lead when assembling the team, by the project's complexity.

A template and a filled-in example are `team/security-template.md` and `team/security-example.md`.

Create (as a separate file): when there are many security rules and they overflow the role, or the project has code to deploy to a server.

---

### Project context and data (accumulate during work)

#### CONTEXT.md
The project's accumulated context: business data, facts, figures, account states, conditions, constraints.

Structure:
```markdown
# Project context

## Description
What the project is, why it is needed, who the client is.

## Requirements
Mandatory requirements, conditions, constraints.
(tariffs, fees, limits, deadlines, legal requirements)

## Data
Accumulated facts from research.
(account states, check results, figures)

## Relations
Dependencies on other projects and systems.
```

Create: from day one. This is the place for everything the AI cannot learn from the code.

#### DECISIONS.md
Key decisions with reasons. The most valuable file for the AI - it cannot infer "why" from the code.

Format of each entry:
```markdown
## [Date] Decision title
Decision: what was decided
Reason: why exactly this way
Alternatives: what was considered and why it was rejected
```

The difference from `CONTEXT.md`: there - facts, here - the choice and its reason. Written by the Tech Lead (as the work goes and when a mission is closed); architectural decisions - by the Architect per the assignment; in a project without a team - by whoever runs the project. The decisions of one application can live in `docs/<app>/DECISIONS.md` - then the root one holds the project's shared decisions.

Create: after the first architectural or business decisions. Especially important for compliance projects (for example, GoBD, GDPR - substitute the requirements of your jurisdiction).

---

### Active work (changes often)

#### PLAN.md
The work plan and current task status. A single file, do not split into PLAN.md and TASKS.md.

Contains:
- Work stages with checkboxes ([x] / [ ])
- Current status (what is done, what is next)
- Deadline estimates (if any)
- Blockers and dependencies

`PLAN.md` - the stages and status of the whole project. In a project with a team, work on the plan goes in missions: a large plan item - several missions, a small one - one; each mission has its own contract, and `PLAN.md` is updated when it is closed.

There is always one current plan - `PLAN.md`. An outdated plan (for example, after the project changes course) is moved to `archive/`, versions do not pile up side by side.

Plans scale as a family. A simple project - everything in one `PLAN.md` (stages, development, testing as sections). The extraction rule: a section lives in the parent while it is small, and moves into its own file when it grows too large:
- `dev-plan/DEV_PLAN.md` - a development plan over several stages (in a project with a team, a stage is a mission): which stages, in what order, what depends on what; `dev-plan/items/` - one item per file, the details of one item. The difference: `PLAN.md` - the status of the whole project, `DEV_PLAN.md` - the sequence of development stages, the mission contract - one mission. Create when development does not fit into a section of `PLAN.md`.
- `TEST_PLAN.md` - the project's testing strategy: what and how we test overall (kinds of tests, environments, what is checked by hand). The difference: the tests of one mission are in `reports/tester-plan.md` of its folder. Create when testing is voluminous and the strategy does not fit into a section of `PLAN.md`.

`DEPLOY.md` is not a plan but a step-by-step rollout instruction, separate: one per mission (`team/missions/<NNN>_<name>/DEPLOY.md`, per the `team/deploy-template.md` template).

Create: from day one.

#### session-logs/
A log of work between AI sessions. Critically important for restoring context after a compact, degradation, or a new session. Without this file a new agent starts from scratch.

The difference from the team: a mission's state lives in its folder (`team/missions/<NNN>_<name>/` - contract, tasks, reports); `session-logs/` - the course of work by day, including outside missions.

**Structure:**
```
session-logs/
  SESSION_YYYY-MM-DD.md    - one file per day
  archive/                 - old logs
```

**Rules:**
- Each day - a separate file: `SESSION_YYYY-MM-DD.md`
- If there are several parts in one day (a break, a compact, a task switch) - append to the same file (a new section "Part 2", "Part 3")
- The entry is made at the end of the session (before finishing/compact)
- Keep a few current files in the folder (for example, the last 3 - pick the limit for the project). Move old ones to `archive/`. Logs are NOT deleted.

**Entry format:**
```markdown
# Session YYYY-MM-DD

## What was done
- Item 1
- Item 2

## Where we stopped
Current state, the last action.

## What's next
Next steps, priorities.

## Open questions
Unresolved questions, awaited answers.
```

**Procedure for starting a new session (insert into each project's AGENTS.md).** This is the start of any session in the project. If the chat is assigned a role (for example, Tech Lead), after this procedure it goes through its role's startup procedure:
1. Read AGENTS.md - the project's rules and context
2. Read the latest session log (the file with the most recent date). If the context is incomplete - read the previous log too.
3. Read the project context (CONTEXT.md, PLAN.md) if the log says so
4. Report briefly: "Read. Last session: [date]. We stopped at: [what]."
5. Ask: "Do we continue from here or is there another task?"

**The log's goal:** a new session, after a context reset, should restore the full picture and continue the work in 1-2 minutes. If, after reading the log, the agent asks questions that have already been resolved - the log is written poorly.

Create: from the first session.

#### CORRESPONDENCE.md
Correspondence with colleagues, management, external contacts. New letters on top.

Contains:
- Date, to whom, subject
- The text in the original language
- Translation (if needed)
- The context of sending

Create: when communication on the project begins.

---

### Research and documentation (grow with the project)

#### research/
The research folder. Files are numbered: `01_topic.md`, `02_topic.md`.

Each file is one piece of research: question, method, result, conclusions.

This is for research not tied to a mission: before the project, before the team, shared for the project. Research within a mission goes to `research/` of the mission folder (`team/missions/<NNN>_<name>/research/`); application materials (data flows, API) - to `docs/<app>/`.

Create: at the first research outside a mission.

#### docs/
Detailed documentation on applications: `docs/<app>/ARCHITECTURE.md` (the application architecture - the mission's source of truth), plus API descriptions, data flows, guides, procedures and, if needed, `docs/<app>/DECISIONS.md` - the decisions of one application (see `DECISIONS.md`).

The difference from `research/`: here - what describes the application and is needed while it lives; in `research/` - research (question, method, conclusions).

Create: as soon as the project has an application (its architecture lives in `docs/<app>/`); the server-wide part - in the root `ARCHITECTURE.md`. In a project with a team, `ARCHITECTURE.md` is not created as a draft - it is written by the Architect in the architectural mission (see `ARCHITECTURE.md` above, "Who writes it"); the `docs/<app>/` folder itself, for other documents, is created as usual.

#### archive/
Archive: old reports, completed research, outdated plans.

Create: when files accumulate in the main folder (for example, the rule "at most 3 files of one type in the main folder" - pick the limit for the project).

---

### The agent team (team/)

#### team/
The AI agent team folder. Each team member is an agent with its own specialization, instruction, and tasks. The roles can be anything: Architect, Developer, Reviewer, Checker, Tester, Researcher, and others.

Structure:
```
TEAM.md            - the team's operating principles (in the project root; copied by team-init)
team/
  ROLES.md         - a description of all roles (who to launch and when)
  workflow.md      - the mission chain, artifacts
  RUN.md           - how to launch agents (commands, parameters, models)
  contract-template.md, task-templates.md, deploy-template.md, report-evaluation.md
  security-template.md, security-example.md - a template and a PHP example for the project's SECURITY.md
  roles/
    <role>.md      - a role instruction (one role = one file)
  missions/
    <NNN>_<name>/  - the mission folder; its structure is a single tree in team/workflow.md ("Artifacts")
```

Create: when the project needs systematic help from agents (quality control, architecture, testing). At the project creation stage, ask the user: "Do we create the team now or later?" If later - remind them that the team is deployed with the `team-init` skill.

The ready-made portable team framework is the `team-playbook` folder (`~/.claude/team-playbook/` by default): `team/` (workflow, templates and roles; the roles are a working sample for PHP, for a different stack they are rewritten) and `TEAM.md`. The `team-init` skill helps deploy it into a project and adapt it (if the framework is not in the default location, it will ask for the path); the `new-role` skill creates a new role or rewrites an existing one for the stack.

---

## Scaling

### Small project (research, an integration at the start)
```
AGENTS.md
PLAN.md
CONTEXT.md
```

### Medium project (active development)
```
AGENTS.md
CONTEXT.md
PLAN.md
session-logs/
CORRESPONDENCE.md
DECISIONS.md
research/
```

### Large project (a system with code, deploy, security)
```
AGENTS.md
ARCHITECTURE.md             (the server architecture; the application detail - in docs/<app>/; with a team - not as a draft, written by the Architect in the architectural mission)
PATTERNS.md                 (the canon of "how"; a complex project - patterns/<name>.patterns.md by role or by layer)
INDEX.md
SECURITY.md
CONTEXT.md
DECISIONS.md
PLAN.md
dev-plan/                   (if development is voluminous: DEV_PLAN.md + items/)
TEST_PLAN.md                (if testing is voluminous)
session-logs/
CORRESPONDENCE.md
research/
docs/                       (docs/<app>/ARCHITECTURE.md - the application architecture; with a team - from the Architect)
archive/
TEAM.md, team/              (if production code - ask; deployed by team-init)
```

---

## Procedure for creating a new project

1. Determine the size: small / medium / large
2. Create the project folder in the projects directory (for example, with a split into `company/` and `personal/`, if the user has one)
3. Create the files per the size template. `ARCHITECTURE.md` (the root one and `docs/<app>/`) as a draft - only if there is no team when the project is created. With a team it is written by the Architect in the architectural mission (`TEAM.md`, Core rules): a draft would prevent this mission from starting (the file already exists) and would remain accepted by nobody. So ask the team question (step 7) before this step. If the team is deployed later, a draft created before it counts as unaccepted: the Tech Lead will start with the architectural mission (see `team-init`)
4. Fill in AGENTS.md (the entry point)
5. Fill in CONTEXT.md (what is known at the start)
6. Fill in PLAN.md (the first steps)
7. If the project includes code for production/deploy - ask the user: "Do we create the team now or later?" Now - deploy it with the `team-init` skill. Later - remind them that the team is deployed with the `team-init` skill (framework: `~/.claude/team-playbook/` by default).

## Rules

- One file = one responsibility. Do not mix context and instructions.
- Do not delete files without confirmation. Outdated ones - into archive/.
- AGENTS.md up to 200 lines. If it exceeds this - move details into project files (see "Size" under AGENTS.md), leave a link in AGENTS.md.
- Write only what the AI cannot learn from the code.
- New letters in CORRESPONDENCE.md - on top.
- Decisions in DECISIONS.md - right after they are made, while you remember the reason.
