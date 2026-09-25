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
  prompt: [per section 5 - links to the role and the task]
```

Deprecated parameters (the system ignores them, verified 2026-07-27):
- `team_name` - the team is implicit;
- `mode` - the agent inherits the permission mode of the main session; its rights cannot be restricted separately.

From the launch result you MUST save the full `agentId` of the form `name@session-XXXX`. You need it if another agent takes over the name - then it can only be reached by ID.

`subagent_type` for a long-lived role is `general-purpose`: the agent reads the role from `team/roles/<role>.md` via the link in the prompt (section 5). The `Explore` and `Plan` types are one-shot and cannot be resumed.

One writer agent (Developer, Architect) at a time. Read-only agents (Checker, Reviewer, Tester, Researcher) run in parallel if their scopes do not overlap. Exception - the Tester in RUN mode: it makes requests to the live site, so while it is working, do not launch other agents.

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

By default an agent runs on the main session's model: do not pass the `model` parameter to Agent. Changing an agent's model, higher or lower, is possible only by the user's decision: the Tech Lead asks before the launch and explains why. The prompts are designed for models of the Opus 4.8 class and above (see README).

To confirm which model an agent is actually running on, ask it, as its first action, to send the exact ID of its model from the system prompt.

## 4. Create a mission

Folder `team/missions/<NNN>_<name>/`, `contract.md` - from `team/contract-template.md`. The folder structure and numbering - a single tree in `team/workflow.md`, "Artifacts".

## 5. Prompt for a teammate

The prompt structure when calling the Agent tool:

```
Your role is team/roles/<role>.md, your task is team/missions/<NNN>_<name>/tasks/<role>.md. As your first action, read both files and accept this as your role, which you must follow until the end of this session.

[What from the role applies in this mission, if the role was not written for this project]

Begin work. Write the report to team/missions/<NNN>_<name>/reports/<role>.md. When done, send the Tech Lead via SendMessage (to: "team-lead") the report's outcome + Summary + the path to the report - plain text does not reach the Tech Lead.
```

## 6. Get the result

The teammate finishes the work and sends the outcome as a message via `SendMessage` (the line about this is in the prompt template, section 5; without it the Tech Lead only sees an idle notice, see section 2.1). The full report is in the file `team/missions/<NNN>_<name>/reports/<role>.md`.

The Tech Lead reads only the report's outcome (Verdict, for the Developer - Status and the acceptance criteria table, for the Researcher - the outcome at the top) + Summary + Action Items. The details - selectively, by the address from the issues.

## 7. Close the team

Not required. `TeamDelete` was removed from the system along with `TeamCreate` - the team is implicit and there is nothing to close. Individual agents live until the end of the session; there is no need to send them `shutdown` (see section 2.1).
