# Running the Team in Cursor

Operational commands for the Tech Lead if the project is run in Cursor. The mission chain, the roles and the gates are the same (`team/workflow.md`); only the mechanics of launching agents change. The section structure matches `team/RUN.md` (the Claude Code variant), so that references like "section 5" lead to the same place in both files.

In Cursor a role agent is a subagent: the main agent (the Tech Lead) launches it, the subagent works in its own context window and returns the result to the main chat. Verified against the Cursor documentation (September 2026): cursor.com/docs/context/subagents, cursor.com/docs/configuration/worktrees, cursor.com/changelog/04-24-26. Launching via Task and the model errors (sections 2, 3, 5) were corrected based on the run of 2026-09-23. `/<role>`, continuing by ID and background subagents were not tested in the run.

## Prerequisite

- Cursor with subagent support (version 2.4 and newer; `/multitask` - from 3.2).
- The Tech Lead is the main Agent chat. A separate flag in the settings, like `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` in Claude Code, is not needed.
- Cursor picks up `AGENTS.md` in the project root on its own. Cursor also loads skills from `~/.claude/skills/` (compatibility), there is no need to move them.

## 1. Create the team

A team in Cursor is the subagent files in the project's `.cursor/agents/`, one file per role. Each file is a short wrapper: frontmatter plus an instruction to read the role. The role text itself stays in `team/roles/<role>.md`, so that the role has a single source.

Template `.cursor/agents/<role>.md`:

```markdown
---
name: <role>
description: <one line: what the role does, from team/ROLES.md>. Launched by the Tech Lead per a mission task.
readonly: false
---

Your role is described in team/roles/<role>.md. As your first action, read this file in full and work strictly by it.
The task comes from the Tech Lead in the launch prompt. Write the report to a file, the path is given in the task.
```

Frontmatter fields:
- `name` - lowercase letters and hyphens; by it the role is invoked in the chat as `/<role>`. That Task will accept this name as `subagent_type` is not guaranteed (section 2).
- `description` - by it Cursor decides whom to delegate to. The line "Launched by the Tech Lead" lowers the chance that Cursor invokes the role on its own, without a task.
- `model` - do not specify. `inherit` - only if the main chat's model is allowed for subagents on your plan (section 3).
- `readonly` - leave `false` for all roles, including the reading ones. `readonly: true` forbids editing files, while the Checker, Reviewer, Tester and Researcher write their report to `reports/<role>.md`. The rule "reading roles do not change code" is held by the role text, as in Claude Code.
- `is_background` - do not specify (default `false`), the reason is in section 6.

Do not create wrappers for roles the project does not have. The Tech Lead does not need a wrapper: they are the main chat.

## 2. Launch a subagent

The Tech Lead formulates the task per `team/task-templates.md`, puts it in `team/missions/<NNN>_<name>/tasks/<role>.md` and launches the subagent with the Task tool.

**Attempt 1 - the role by name.** Only if the role name is among the allowed `subagent_type` values in this session's Task schema:

```
Task:
  description: <role> - <mission>
  subagent_type: <role>
  prompt: [section 5, short form]
```

**Attempt 2 - always, if Task rejected the role name or it is not in the list of types:**

```
Task:
  description: <role> - <mission>
  subagent_type: generalPurpose
  prompt: [section 5, long form: links to the role and the task]
```

Whether there is a wrapper in `.cursor/agents/` does not matter for this switch. In the run the role with a wrapper was visible in the chat's list of subagents, yet Task still answered `Invalid enum` and accepted only the built-in types (`generalPurpose`, `explore`, etc.). Wrappers are needed for `/<role>` in the chat and for delegation by Cursor itself, while the role name in Task is an attempt, not a guarantee.

Do not make built-in types other than `generalPurpose` (`explore`, `cursor-guide`, `bugbot` and others) a mission role: they have their own instructions and do not hold the role text.

Do not pass `model` in Task, except when the user has named a model ID from the list allowed for this agent (section 3).

### Launch errors

| Task error | What to do |
|------|------|
| Role name not accepted (`Invalid enum`, no such type) | Attempt 2: `generalPurpose` + the long form of the prompt |
| Model or plan (`Named models unavailable`, `Free plans can only use Auto`, unknown model ID) | Do not retry with `inherit` and do not pick an ID at random (`auto`, etc.). Tell the user: switch the **main** chat to Auto or to a model/plan allowed for subagents, then continue. Record the error in the mission's `agents.md` |
| Any other | Show the user the error text, do not work around it |

Do not execute the role yourself in the Tech Lead's chat instead of a subagent: then the separation of contexts is lost and whoever verifies the work ends up verifying themselves.

The user can also launch a role themselves, with a command in the chat: `/<role> <prompt from section 5>`.

From the launch result, save the agent ID: by it the subagent can be continued (section 2.1). Keeping the ID in the chat is unreliable: once the context is lost, it can no longer be found. The Tech Lead records it in a mission file (for example, as a line in `contract.md` or in `team/missions/<NNN>_<name>/agents.md`).

One writer at a time (Developer, Architect). Read-only roles (Checker, Reviewer, Tester, Researcher) can be launched in parallel if their scopes do not overlap: several subagents in one Tech Lead message start simultaneously. Exception - the Tester in RUN mode: it makes requests to the live site, so while it is working, do not launch other subagents.

Do not use `/multitask` for a mission. It splits the task into parts by itself and hands them out to subagents, while in a mission the tasks are handed out by the Tech Lead per the contract: otherwise "one writer at a time" is broken and it is lost who did which part.

Worktrees (`/worktree`, `/best-of-n`, `/apply-worktree`) are not needed for a mission: there is one writer, branch isolation is not required. If the project uses them anyway, that is a separate decision of the Tech Lead with the user.

## 2.1. Continuing work with an agent (without losing context)

Launching again (Task or `/<role>`) creates a new subagent from scratch. The previous one can be continued by its agent ID, with its context preserved (the files read, the tool results):

```
Resume agent <agent ID> and continue: <what to do next>
```

What to observe:
- For the Developer <-> Checker loop, continue the same subagents by ID instead of launching new ones: this way they do not reread the whole scope.
- If the ID is lost or the subagent does not continue, launch a new one and give it the path to the previous report and task. That is exactly why tasks and reports are kept on disk.

## 3. Models

The Tech Lead is the main chat's model, chosen in the Cursor model switcher. The prompts are designed for models of the Opus 4.8 class and above (see README).

| Role | How it is set |
|------|--------------|
| Tech Lead | Main chat (model switcher) |
| Developer, Architect, Checker, Reviewer, Tester, Researcher | Do not specify `model` either in Task or in the wrapper |

Without `model` a subagent gets `inherit` by default, that is, the Tech Lead's model. If the main chat has a named model and the plan forbids it for subagents, the launch fails. In the run on Free, both `inherit` and omitting `model` gave `Named models unavailable. Free plans can only use Auto`: the main chat's model is inherited, and on Free only Auto is available to subagents. There is only one solution - the user changes the main chat's model or the plan. Do not write a workaround ID into this file.

A model ID is passed in Task or in the wrapper's `model:` only if (a) the user named it and (b) it is in the list of models allowed for this agent. The format from the Cursor documentation: `claude-opus-5[effort=high,context=300k]`.

### Falling back to a backup model

If the primary model is temporarily unavailable (overload, the agent does not start or breaks off at startup, model errors instead of a reply) - the user switches the main chat's model to the backup. The Tech Lead does not invent their own `model:` for Task. A slow or unsuccessful agent reply is not a reason to fall back; that is a matter of the task, not the model.

To confirm which model a subagent is actually running on, ask it, as its first action, to name the ID of its model.

## 4. Create a mission

The same as in Claude Code: folder `team/missions/<NNN>_<name>/`, `contract.md` - from `team/contract-template.md`. The folder structure and numbering - a single tree in `team/workflow.md`, "Artifacts".

## 5. Prompt for a subagent

The prompt does not repeat the text of the role and the task, it gives links to them: the role and the task have one source - the file on disk.

**Short form** - only if `subagent_type` is the role's wrapper and Task accepted the name. The subagent reads the role itself via the wrapper (section 1):

```
Your task is team/missions/<NNN>_<name>/tasks/<role>.md. As your first action, read it.

[What from the role applies in this mission, if the role was not written for this project]

Begin work. Write the report to team/missions/<NNN>_<name>/reports/<role>.md. In your reply, return the report's outcome + Summary + the path to the report.
```

**Long form** - `generalPurpose` (there is no wrapper or Task rejected the role name). A link to both the role and the task:

```
Your role is team/roles/<role>.md, your task is team/missions/<NNN>_<name>/tasks/<role>.md. As your first action, read both files and accept this as your role, which you must follow until the end of this session.

[What from the role applies in this mission, if the role was not written for this project]

Begin work. Write the report to team/missions/<NNN>_<name>/reports/<role>.md. In your reply, return the report's outcome + Summary + the path to the report.
```

`SendMessage` and the `team-lead` recipient are not needed in Cursor: the subagent's reply returns to the main chat on its own.

## 6. Get the result

The subagent finishes the work, and its reply (outcome + Summary + path) arrives in the main chat. The full report is in the file `team/missions/<NNN>_<name>/reports/<role>.md`.

The Tech Lead reads only the report's outcome (Verdict, for the Developer - Status and the acceptance criteria table, for the Researcher - the outcome at the top) + Summary + Action Items. The details - selectively, by the address from the issues.

Background subagents (`is_background: true`) reply immediately but work separately, writing their state to `~/.cursor/subagents/`. The Tech Lead then has to track when they have finished, which is why background mode is not used for mission roles.

## 7. Close the team

Not required. The `.cursor/agents/` files stay in the project for the next missions. If worktrees were used in the project, remove the unneeded ones via `/delete-worktree`.
