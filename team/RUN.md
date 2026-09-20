# Running the Agent Teams

Operational commands for the Tech Lead. What to invoke and in what order.

## Prerequisite

`~/.claude/settings.json` must contain:

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

## 1. Create the team

No longer required. `TeamCreate` / `TeamDelete` have been removed from the system: a session has a single implicit team, and every launched agent joins it automatically (verified 2026-07-27).

## 2. Launch a teammate

The Tech Lead reads the role file (`team/roles/<role>.md`), formulates the task per `team/task-templates.md`, and launches the teammate:

```
Agent:
  name: "developer-N" | "architect-N" | "checker-N" | "reviewer-N" | "tester-N" | "researcher-N"
  subagent_type: "general-purpose"
  model: "<model>" (see section 3; specify it only when falling back to a backup)
  prompt: [instruction from team/roles/*.md + task]
```

Deprecated parameters (the system ignores them, verified 2026-07-27):
- `team_name` - the team is implicit;
- `mode` - the agent inherits the permission mode of the main session; its rights cannot be restricted separately.

From the launch result you MUST save the full `agentId` of the form `name@session-XXXX`. You need it if another agent takes over the name - then it can only be reached by ID.

`subagent_type` for a long-lived role is `general-purpose` or your own role from `.claude/agents/*.md`. The `Explore` and `Plan` types are one-shot and cannot be resumed.

One writer agent (Developer) at a time. Read-only agents run in parallel if their scopes do not overlap.

## 2.1. Continuing work with an agent (without losing context)

Calling `Agent` again ALWAYS creates a brand-new agent from scratch - even with the same name. Continuing an existing one goes only through:

```
SendMessage: to="<agent name>", summary="...", message="..."
```

Sending resumes the agent from its transcript, with all of its prior work - the files read and the tool results.

What to observe:
- Launch a role ONCE, then only via `SendMessage`.
- Do not reuse names. On a collision the name goes to the new agent, and the first one becomes unreachable by name - only the saved `agentId` remains.
- Do not send `shutdown` to an agent before the mission is closed: it is irreversible, unlike idling.
- An agent's plain text does NOT reach the Tech Lead. In each agent's task, state explicitly: report via `SendMessage` (to: "team-lead"). Without this the agent replies into the void, and the lead only sees an idle notice.

An agent does not die after reporting; it goes idle and stays available. Its row in the agents panel is hidden after 30 seconds of idling - that is display only; a message by name brings back both the row and the agent. Keep-alive messages are not needed.

Being unreachable by name means not death from idling but a change of the session identifier: agents launched in a previous session (`name@session-OLD`) do not answer by name after the session changes (observed 2026-07-27). That is why we keep tasks and reports on disk - `/resume` and `/rewind` do not restore agents, but files survive it.

To switch to an agent by hand - the up/down arrows in the agents panel, then Enter. `Shift+Down` no longer works.

## 3. Models

All roles run on a single model - `<model>` (an Agent tool alias, e.g. `opus`). Pass it as the `model` parameter when launching an agent; the Tech Lead session is set via `/model`. The prompts are designed for models of the Opus 4.8 class and above (see README).

| Role | How it is set |
|------|--------------|
| Tech Lead | Main session (`/model`) |
| Developer | `model: "<model>"` |
| Checker | `model: "<model>"` |
| Reviewer | `model: "<model>"` |
| Tester | `model: "<model>"` |
| Researcher | `model: "<model>"` |

The Agent tool accepts only aliases (`opus`, `sonnet`, `haiku`, etc.) - a specific version cannot be set via a parameter.

### Falling back to a backup model

If the primary model is temporarily unavailable (server overload `overloaded_error` / HTTP 529, the agent does not start or breaks off at startup, model errors instead of a reply) - switch the MAIN session's model via `/model` to the backup, and do NOT pass the `model` parameter to Agent: the agent will inherit the session's model. When the primary is available again - restore `model: "<model>"`. A slow or unsuccessful agent reply is not a reason to fall back; that is a matter of the task, not the model.

To confirm which model an agent is actually running on, ask it, as its first action, to send the exact ID of its model from the system prompt.

## 4. Create a mission

```
team/missions/NNN_short-name/
  contract.md    <- from team/contract-template.md
  tasks/         <- tasks for the agents
  reports/       <- agents' reports
```

The NNN number is the next in sequence. Check the last one: `ls team/missions/`.

## 5. Prompt for a teammate

The prompt structure when calling the Agent tool:

```
[Full text of team/roles/<role>.md]

--- TASK ---

[Full text of team/missions/NNN/tasks/<role>.md]

--- END ---

Begin work. Write the report to team/missions/NNN/reports/<role>.md
```

## 6. Get the result

The teammate finishes the work and returns a summary. The full report is in the file `team/missions/NNN/reports/<role>.md`.

The Tech Lead reads only Verdict + Summary + Action Items. The details - selectively, by the address from the issues.

## 7. Close the team

Not required. `TeamDelete` was removed from the system along with `TeamCreate` - the team is implicit and there is nothing to close. Individual agents live until the end of the session; there is no need to send them `shutdown` (see section 2.1).
