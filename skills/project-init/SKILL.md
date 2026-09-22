---
name: project-init
description: >
  Creating, initializing, and organizing a new project or work project
  with the right file structure for multi-tool AI development
  (Claude Code, Pi, Codex, Cursor, Copilot). Use when the user
  asks to create a project, start a new project, initialize a project,
  prepare a project structure, lay out project documents, create
  AGENTS.md/CONTEXT.md/PLAN.md, set up an AI-friendly workspace, or a project
  template. Triggers: "create a project", "create project", "new project",
  "start a project", "initialize a project", "project initialization",
  "prepare a project", "organize a project", "project structure",
  "project template", "project init", "init project", "scaffold project".
user-invocable: true
---

# Project structure for AI-assisted development

## Principles

1. A project must be understandable to any AI tool on the first read
2. Files are split into: project knowledge (universal) and instructions for AI (specific)
3. The structure scales: a small project starts with 3 files, a large one can have 15+
4. Each file has a single responsibility
5. An AI tool should not read everything - it reads the entry point and follows the links

## Project files

### Entry point (AI reads it first)

#### AGENTS.md
A single entry point for all AI tools. Read by: Claude Code, Codex, Pi, Cursor, Copilot, Windsurf, Aider, Gemini CLI.

Contains:
- What the project is (1-2 sentences)
- A table of the project's files (name, purpose)
- Key rules for working with the project
- API, versions, endpoints (if any)
- Build/test commands (if any)
- Contacts and roles (who is responsible for what)
- Sections with instructions for specific AI tools (if needed)

Size: up to 200 lines. If it exceeds this - for each bloated section decide:

1. **The information relates to the project** (business data, architecture, security)? → move it to the appropriate project file (CONTEXT.md, ARCHITECTURE.md, INDEX.md, etc.)

2. **The information belongs in AGENTS.md** but does not fit? → create an `AGENTS_[TOPIC].md` extension. The topic can be anything: a tool, a process, an area.

In AGENTS.md leave a brief description + a link: "More detail: see `AGENTS_[TOPIC].md`"

Extension examples:
- `AGENTS_CLAUDE.md` - instructions for Claude Code
- `AGENTS_PI.md` - instructions for Pi / Codex
- `AGENTS_DEPLOY.md` - the deploy procedure for agents
- `AGENTS_SECURITY.md` - security rules for agents
- Any other topic that does not fit in the main file

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
- **One application** - one architecture: `<project>/docs/<app>/ARCHITECTURE.md`. Every mission starts from it (the roles read the file of the needed application per the task).
- **A server with several applications** - the server architecture is added in the root `<project>/ARCHITECTURE.md`: how the applications are placed, the list of applications, shared decisions, links to their `docs/<app>/ARCHITECTURE.md`. The detail of each application stays in its `docs/<app>/ARCHITECTURE.md`.

It is extended the same way as AGENTS.md: when an architecture section grows too large - it is moved into a separate `ARCH_[TOPIC].md` file. In ARCHITECTURE.md a brief description + a link remains.

Extension examples:
- `ARCH_STACK.md` - technology stack, versions, dependencies
- `ARCH_PATTERNS.md` - design patterns, code conventions
- `ARCH_AUDIO.md` - audio pipeline, streaming
- `ARCH_API.md` - API, keys, security
- `ARCH_DATABASE.md` - DB schema, migrations
- `ARCH_BACKEND.md` - the server side
- `ARCH_FEATURES.md` - features, managers

Who writes it: the Architect per the Tech Lead's task (see the Architect role). Who edits it later: globally - the Architect; pointwise - the Tech Lead and only on the user's instruction.

Create: when the project has an application or a system of several components.

#### PATTERNS.md
The canon of "how": how recurring things are done in this project - naming (files, functions, variables), file layout, which method/helper for a typical task, error handling. This is not architecture (that is the corset of boundaries and connections): patterns are frequent and technical, applied constantly.

Why: without a canon each agent derives the pattern anew from the neighboring code, which itself drifts apart - "clusters" of inconsistent decisions grow. With `PATTERNS.md` the Developer checks against it before coding, the Checker verifies conformance.

It scales: a simple project - a single `PATTERNS.md`; a complex one - sets by role (`patterns/backend.patterns.md`, `patterns/frontend.patterns.md`). What to set up is decided by the Tech Lead by complexity.

The entry format is a decision, not prose: "for X - always Y, not Z" + a micro-example. Do not silently make up a new situation: no pattern - propose it and add it to `PATTERNS.md` (with the reason).

Create: when more than one agent works on the code or the patterns start to drift apart.

#### INDEX.md
A map of the project: which folders and files, what each is for, how to find what you need.

Contains:
- A folder tree with a description of each
- Key files with paths
- Navigation hints ("custom code has the `app-` prefix")

Create: when the project grows (>10 files or >3 nesting levels). Not a starting document but a navigational one.

#### SECURITY.md
Code security rules: web access control, endpoint validation, secrets, logging, file operations, a checklist before deploy. Like the patterns, they are tied to the stack and to the roles that apply them (the Developer writes by them, the Reviewer checks against them).

It scales by the extraction rule: few rules / the context is enough - they live as a section inside a role (the reviewer's checklist is built into `reviewer.md`); many - they are moved into a separate `<project>/SECURITY.md`, and the roles refer to it as the source of truth. What to set up is decided by the Tech Lead when assembling the team, by the project's complexity.

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

Create: after the first architectural or business decisions. Especially important for compliance projects (GoBD, GDPR).

---

### Active work (changes often)

#### PLAN.md
The work plan and current task status. A single file, do not split into PLAN.md and TASKS.md.

Contains:
- Work stages with checkboxes ([x] / [ ])
- Current status (what is done, what is next)
- Deadline estimates (if any)
- Blockers and dependencies

As the project grows, the plan can be versioned: `PLAN_V2.md`, `PLAN_V3.md`. The previous version stays as history (do not delete). The current version is named in AGENTS.md. Example: the project went through `PLAN_V3.md` → `PLAN_V4.md`.

Plans scale as a family. A simple project - everything in one `PLAN.md` (stages, development, testing as sections). Heavy development is moved into `dev-plan/DEV_PLAN.md` (+ `items/` by item), voluminous testing - into `TEST_PLAN.md`. The extraction rule: a section lives in the parent while it is small, and moves into its own file when it grows too large. `DEPLOY.md` is not a plan but a step-by-step rollout instruction, separate.

Create: from day one.

#### session-logs/
A log of work between AI sessions. Critically important for restoring context after a compact, degradation, or a new session. Without this file a new agent starts from scratch.

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
- At most 3 current files in the folder. Move old ones to `archive/`. Logs are NOT deleted.

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

**Procedure for starting a new session (insert into each project's AGENTS.md):**
1. Read AGENTS.md - the project's rules and context
2. Read the latest session log (the file with the most recent date). If the context is incomplete - read the previous log too.
3. Read the project context (CONTEXT.md, PLAN.md) if the log says so
4. Report briefly: "Read. Last session: [date]. We stopped at: [what]."
5. Ask: "Do we continue from here or is there another task?"

**The log's goal:** a new agent (any AI tool), after a context reset, should restore the full picture and continue the work in 1-2 minutes. If, after reading the log, the agent asks questions that have already been resolved - the log is written poorly.

Create: from the first session.

#### CORRESPONDENCE.md
Correspondence with colleagues, management, external contacts. New letters on top.

Contains:
- Date, to whom, subject
- The text in the original language
- Translation (if needed)
- The context of sending

Create: when communication on the project begins.

#### WORKFLOW.md
The project's working processes: the deploy order, code review, branching, special procedures.

Create: when the working process is non-standard and the AI cannot guess it.

---

### Research and documentation (grow with the project)

#### research/
The research folder. Files are numbered: `01_topic.md`, `02_topic.md`.

Each file is one piece of research: question, method, result, conclusions.

Create: at the first research.

#### docs/
Detailed documentation on applications: `docs/<app>/ARCHITECTURE.md` (the application architecture - the mission's source of truth), plus API descriptions, guides, procedures.

Create: as soon as the project has an application (its architecture lives in `docs/<app>/`); the server-wide part - in the root `ARCHITECTURE.md`.

#### archive/
Archive: old reports, completed research, outdated plans.

Create: when files accumulate in the main folder (rule: at most 3 files of one type in the main folder).

---

### The agent team (team/)

#### team/
The AI agent team folder. Each team member is an agent with its own specialization, instruction, and tasks. The roles can be anything: architect, developer, reviewer, checker, tester, researcher, and others.

Structure:
```
team/
  ROLES.md         - a description of all roles (who to launch and when)
  workflow.md      - the mission chain, artifacts
  RUN.md           - how to launch agents (commands, parameters, models)
  contract-template.md, task-templates.md, deploy-template.md, report-evaluation.md
  roles/
    <role>.md      - a role instruction (one role = one file)
  missions/
    <NNN>_<name>/  - contract (contract.md), tasks (tasks/), reports (reports/)
```

Create: when the project needs systematic help from agents (quality control, architecture, testing). At the project creation stage, ask the user: "Do we create the team now or later?" If later - remind them that the team is deployed with the `team-init` skill.

The ready-made portable team skeleton is `team-playbook/team/` (roles, workflow, templates). The `team-init` skill helps deploy it into a project and adapt it; the `new-role` skill creates a new role.

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
ARCHITECTURE.md             (the server architecture; the application detail - in docs/<app>/)
PATTERNS.md                 (the canon of "how"; a complex project - patterns/<role>.patterns.md)
INDEX.md
SECURITY.md
CONTEXT.md
DECISIONS.md
PLAN.md
dev-plan/                   (if development is voluminous: DEV_PLAN.md + items/)
WORKFLOW.md
session-logs/
CORRESPONDENCE.md
research/
docs/                       (docs/<app>/ARCHITECTURE.md - the application architecture)
archive/
team/                       (if production code - ask; deployed by team-init)
AGENTS_CLAUDE.md            (if the Claude Code section in AGENTS.md > 30-40 lines)
AGENTS_PI.md                (if the Pi section in AGENTS.md > 30-40 lines)
```

---

## Procedure for creating a new project

1. Determine the size: small / medium / large
2. Create the project folder in the projects directory (`company/` or `personal/`)
3. Create the files per the size template
4. Fill in AGENTS.md (the entry point + AI-tool sections if needed)
5. Fill in CONTEXT.md (what is known at the start)
6. Fill in PLAN.md (the first steps)
7. If the project includes code for production/deploy - ask the user: "Do we create the team now or later?" Now - deploy it with the `team-init` skill. Later - remind them that the team is deployed with the `team-init` skill (skeleton: `team-playbook/team/`).

## Rules

- One file = one responsibility. Do not mix context and instructions.
- Do not delete files without confirmation. Outdated ones - into archive/.
- AGENTS.md up to 200 lines. If it exceeds this - move details into separate files, leave a link in AGENTS.md.
- AI-tool sections in AGENTS.md: up to 30-40 lines each. If more - move them into `.claude/INSTRUCTIONS.md`, `.pi/INSTRUCTIONS.md`, etc.
- Write only what the AI cannot learn from the code.
- New letters in CORRESPONDENCE.md - on top.
- Decisions in DECISIONS.md - right after they are made, while you remember the reason.
