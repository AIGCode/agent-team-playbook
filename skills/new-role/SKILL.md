---
name: new-role
description: >
  Creating a new role (a specialist agent) for the team/ team. Use
  when you need to add a new member to the team or rewrite a role in a single
  style. Triggers: "create a role", "new role", "add a role", "new agent
  for the team", "rewrite a role", "new role", "add role".
user-invocable: true
---

# Creating a new team role

A role is an instruction for a specialist agent, a single file `team/roles/<role>.md`. The Tech Lead reads it and launches an agent with this prompt (see `team/RUN.md`).

## Principles

1. **A single style - XML tags.** All roles are written the same way: sections in `<role>`, `<context>`, etc. tags. A single skeleton = predictability for the Tech Lead and portability.
2. **Prompt by motivation, not by command.** Explain "why" rather than commanding in caps. "MUST", "MANDATORY", CAPS do not hold up better than a clear "why" - an agent that understands the reason follows the rule longer.
3. **The critical goes first.** A role is read top to bottom; after ~200 lines the agent starts ignoring what is lower. The most important (what it does, what it does not do, whether it is read-only) goes at the top, in `<role>`. Revising priorities means moving things higher, not appending at the end.
4. **Its own response format is mandatory.** Without a prescribed format the agent answers chaotically. Give the role a format in `<output_format>`: a PASS/FAIL verdict for roles with a "yes/no" result (developer, checker, architect), its own format for the rest (reviewer - severity, tester - PLAN/RUN, researcher - structured data without a verdict).
5. **Paths - by convention.** The team's internals - `team/...` (works in any project). The maintained project's files - `<project>/...`. Placeholders: `<app>` (application), `<NNN>` (mission number), `<SERVER_ROOT>` (root on the server).

## Role skeleton

Mandatory sections (present in all roles):
- `<role>` - who it is, what it does, what it fundamentally does NOT do, whether it is read-only. The communication language. 2-5 lines.
- `<task>` - what the role is assigned in terms of the result; what the task consists of.
- `<workflow>` - the order of work, step by step.
- `<antipatterns>` - what not to do (typical mistakes of this particular role).
- `<output_format>` - the response format (a verdict or its own).

Optional (as the role needs):
- `<context>` - the project's environment/stack. On top a parameterized form (placeholders), under it a generic example. Skip for a project-agnostic role (e.g. researcher).
- `<scope>` - a hard "included / out", if the role easily goes beyond its bounds (e.g. checker).
- `<rules>` - specific rules or criteria (e.g. the reviewer's 13 rules).
- `<examples>` - examples of correct / incorrect.
- `<references>` - a "where to look" table.

## Template

```
<role>
[Name] of project <project> (if the role is tied to a project). [One sentence: what it does]. [One phrase: what it fundamentally does NOT do / whether the role is read-only].
Communicate with the user in <language>. [If it writes code: code and code comments - in English.]
</role>

<context>            [optional; skip for project-agnostic roles]
<project> - [a brief project description]. Stack: <language and versions>, <DB>, <external APIs>. Hosting: <SERVER_ROOT>. Each application in its own folder `<project>/dev/<app>/`.

Example (a PHP project): a set of PHP applications on shared hosting (Apache). Stack: PHP 8.0+, MySQL/PDO, cURL, Shopify GraphQL API.
</context>

<task>
[What the role is assigned, in terms of the result.]

The task contains:
- What to do (a concrete result)
- Whitelist of files/docs (what to read, what to change)
- Constraints (what not to touch)
- The path for the report (`team/missions/<NNN>/reports/<role>.md`)
</task>

<scope>             [optional]
Included: [...]
Out: [what belongs to another role]
</scope>

<rules>            [optional; role-specific rules/criteria]
### Scope isolation
- Work only with files from the whitelist; if something outside the whitelist is needed - into the report, do not change it.
### Shell
- Shell via the Bash tool (does not require confirmation). If it does not work - into the report, wait for the Tech Lead.
</rules>

<workflow>
1. Read the task
2. Read the source of truth (`<project>/docs/<app>/ARCHITECTURE.md` / `<project>/SECURITY.md` / context)
3. Read the files from the whitelist
4. [the role's main action]
5. [self-check of the result]
6. Write the report to the file from the task
</workflow>

<antipatterns>
### 1. Drift from the task
[going beyond the whitelist, extra functionality, incidental refactoring -> into "Questions for the Tech Lead"]
### 2. [a typical mistake specific to this role]
### 3. Editing someone else's area
[documentation, entities, and decisions are maintained by the Tech Lead -> into the report, do not touch them yourself]
</antipatterns>

<output_format>
Write the report to the file specified in the task.

For a role with a "yes/no" result:
## Verdict
PASS | FAIL | NEEDS_REVIEW
## Issues
- [SEVERITY] file:line - description
## Action Items
- [ ] what needs to be done
## Summary
Up to 100 words.

For a reviewing role - its own format (e.g. severity HIGH/MEDIUM/LOW + a final table).
For the researcher - structured information with sources, no verdict.
</output_format>

<examples>          [optional]
### Example 1 (correct): [a short case for the role]
### Example 2 (incorrect): [a typical mistake for the role]
</examples>

<references>        [optional]
| Area | Where to look |
|---|---|
| Application architecture | `<project>/docs/<app>/ARCHITECTURE.md` |
| [pattern] | `<project>/dev/<app>/...` |
</references>
```

## Where to save and how to connect it

1. The role file: `team/roles/<role>.md`.
2. Add the role to `team/ROLES.md` - a brief description and when to launch it.
3. If the role is in the mission chain - write it into `team/workflow.md` (where in the chain, whether it can be skipped).
4. Check `team/RUN.md` - the agent name `<role>-N`, the model.
5. How to evaluate the role's report - add a block to `team/report-evaluation.md`.
6. The role's task format is taken from `team/task-templates.md`.

## An example before your eyes

The ready-made roles in `team/roles/` are living samples: developer/checker/architect (with a verdict), reviewer (severity), tester (two modes), researcher (project-agnostic, no verdict).
