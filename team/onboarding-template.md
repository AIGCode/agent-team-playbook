# New-chat onboarding template

The onboarding is the project document `ONBOARDING.md`, by which a new Tech Lead chat enters the project in stages, with a checkpoint stop after each one. In a complex project it replaces compact: when the context runs out, the work goes on not in the compacted chat but in a fresh one that starts by this document. This file covers when to set up an onboarding, what it costs, how to maintain it, and the template itself (at the bottom). Read by the Tech Lead.

## The main thing

1. **A new chat instead of compact.** Compact compresses the conversation its own way each time, and after it the chat assembles itself a little differently: it loses decisions, mixes up priorities. On a complex contract compact itself also spends a lot of tokens. A fresh chat started by the onboarding starts the same way and correctly: the decisions and the state are in files, not in a retelling.
2. **One startup point for the Tech Lead.** If an onboarding is set up, it is the only startup procedure for a new Tech Lead chat. The role's startup procedure (`team/roles/techlead.md`) and the line for the Tech Lead in the project's `AGENTS.md` refer to it rather than repeat it: two procedures diverge over time, and the chat starts now by one, now by the other. Chats without a role and with another role start by the common procedure in `AGENTS.md`: they do not need the Tech Lead's onboarding.
3. **In stages, not all at once.** Loading all documents at once mixes up priorities. The stages go from light to heavy, after each one - a checkpoint in your own words and waiting for the user: a misunderstanding is cheaper to catch at a stage than in the middle of a mission.

## When to set it up

The Tech Lead decides based on the project's complexity - the same way as with hooks, and at the same moments: when the team is deployed (`team-init`, after the role is accepted) and when the project grows more complex (`team/hooks/README.md`, "When to propose").

- **Not needed:** a simple project - the role's startup procedure and the startup procedure in `AGENTS.md` work as is.
- **Needed** - guiding signs, not a hard threshold, for example: a correct start requires more than 2-3 documents in a certain order; a large contract or missions that run across several chats; after compact the chat starts unstably (loses decisions, returns to closed questions).

The proposal to the user - briefly: what it gives and what it costs (below). Agreed - the Tech Lead sets up the onboarding and records it in the project's decisions (`DECISIONS.md`). Refused - the start goes by the role's startup procedure.

## What it costs

| What | Cost |
|---|---|
| Documents of stages 1-4 | on a large project on the order of 50-60 thousand tokens: the role, the entry point, the log, the plans, the launch documents, the architecture skeleton. The whole start is larger: the system prompt, memory and the conversation at the checkpoints are added to the documents (how to calculate it - "How to set it up", `<share>`) |
| Checkpoints | a stop with waiting for the user per each stage 1-4 at every start (without an architecture there is no stage 4 - 3 stops) |
| Without auto-compact | nobody covers the edge of the window: the Tech Lead watches the budget themselves and moves to a new chat in time |

In return every chat starts the same way, the role is confirmed by the user stage by stage, there is no drift after compact.

## Auto-compact

The onboarding replaces compact, so auto-compact is turned off. [Claude Code] Otherwise Claude Code compresses the context on its own at the edge of the window, and the chat continues working from a retelling, not from the onboarding. How to turn it off in Claude Code - `team/SETTINGS_CLAUDE_CODE.md`, "Auto-compact".

The cost - in the table above: the budget is watched by the Tech Lead (the reserve - in the template, "Context budget").

Auto-compact in Cursor - `team/RUN_CURSOR.md`, "Prerequisite".

## How to set it up

1. Copy the template (below) into `<project>/ONBOARDING.md`, next to `AGENTS.md`. Fill in all placeholders for the project: `<project>`; "What the project is"; `<share>` (how to calculate it - below); the real paths of the documents of stages 2-3 (the development plan, `PATTERNS.md` - if present, otherwise remove the line); the architecture skeleton and the checklist of stage 4; the references of stage 5; "Role clarifications" (at the start - only the general line, later - as approved by the user); "Where we are now" (the date and the next item); "User's rules" (the project's current agreements; none - the section is empty). Stage 4 - if the project has an architecture; if not - remove the stage.

   `<share>` - the free part of the window by the end of stage 4: 1 minus the start divided by the model's window. The start is the whole context occupied by the end of stage 4: the documents of the stages, the system prompt, memory, the conversation at the checkpoints. [Claude Code] The main way is to measure: go through the onboarding the first time and look at the occupied context with the `/context` command in Claude Code. Until the first start has happened - an estimate from below: what is occupied in an empty chat (the same `/context` at the start of a chat) plus the documents of the stages (the size in KB divided by about 4 - thousands of tokens). The conversation at the checkpoints is not included in the estimate, so after the first start replace the estimate with a measurement.
2. Make the onboarding the only startup point for the Tech Lead: keep the startup procedure in `AGENTS.md` - the other chats start by it - and add under it the line "The Tech Lead's chat does not perform the procedure above: its start is strictly per `ONBOARDING.md` (in stages, with checkpoints). There is no separate procedure for the Tech Lead here, so that there are not two different ones. The other chats start by the procedure above and do not read the onboarding". `AGENTS.md` is read by every chat (Cursor picks it up on its own), hence a line rather than a replacement: without the procedure a chat with another role would go into the Tech Lead's onboarding, without the line the Tech Lead would start by two procedures. The Tech Lead's role already refers to the onboarding.
3. Add the handoff sections to the session log (below, "Handoff in the session log").
4. Show the onboarding to the user: the items are approved by them.
5. Turn off auto-compact (above) - with the user's consent, together with the onboarding.

## Who maintains it

- **The items** (stages, checkpoints, "Role clarifications", "User's rules") are changed only by the user or by the Tech Lead with the user's approval. The onboarding sets how every next chat understands the role and the project, and a silently edited item changes the work of all following chats.
- **"Where we are now"** is updated by the Tech Lead themselves, when closing the session. It holds only what a new chat needs to continue: the next item and where what it needs lies. Not history: history is in the session log, while "Where we are now" is read at every start.

## Handoff in the session log

The onboarding is how to enter, the handoff is where to continue from. They work as a pair: "Where we are now" points to the latest log, and in the log (`session-logs/`, the format - the `project-init` skill) at the end of each part there are two sections:

```markdown
## Tech Lead's mistakes and lessons
- What I did wrong - what the user said (if they did) - the lesson in one line

## Handoff to the next Tech Lead
- **State:** what is closed, what is in progress (mission, plan item)
- **Immediate next step:** what to start with and what to read before it
- **Open:** unresolved items, awaited answers
- **On the server:** what changed on the server and what remains to be done there (if the mission is deployed)
- **Team:** this session's agents are not available in the new chat; everything is on disk (`team/missions/<NNN>_<name>/`)
- **Commits:** hashes or "not committed"
```

A new chat at stage 2 first reads the "Handoff" of the last part, the earlier parts - only if the state is unclear. A lesson that repeats from session to session the Tech Lead proposes to the user to add to "Role clarifications".

## Template

```markdown
# <project> - new-chat onboarding (Tech Lead), read in stages

The only startup point of a new Tech Lead chat. The onboarding's items do not change without the user's approval; the "Where we are now" section is updated by the Tech Lead themselves.

> **The main rule: do not load everything at once.** Go in stages. After each one - a short checkpoint in your own words and waiting for the user, then the next stage. The heavy part (the architecture) - at stage 4, not at the start.

> **Context budget - from the first step.** By the end of the onboarding about <share> of the window is free. The last ~15% is the reserve for closing: the state into the plan and the log, the handoff, loose ends. The reserve is not part of the working budget.
> - Read only what the current task needs.
> - Delegate reading to agents: bulk search and reading in full - to them, into your context - their outcome and the needed piece.
> - Do not reopen a whole file already read in this session: if you need a fact - pointwise.
> - Entered the reserve - stop, record the state, the handoff to the log, then a fresh chat per this onboarding.

**What the project is:** <1-2 lines>

## Stage 1 - Role

Read: `team/roles/techlead.md`.

**Checkpoint:** the role in your own words, in the first person:
1. Who I am and whom I talk to.
2. How I work: from the task through the contract to the result - as a diagram with ↓ arrows.
3. How I use the team: what I delegate, how I set tasks, the chain of roles - as a diagram with ↓ arrows.
4. What I do if the terms of the contract change along the way, and how I report my own decisions (the "My initiative" block, the **Contract:** marker).
5. What I am responsible for.

**Role clarifications:**
- The role's startup procedure is performed through the stages of this onboarding.
- <corrections learned in sessions - as approved by the user>

Wait for the user.

## Stage 2 - Where we are (without the architecture)

Read in turn:
1. `AGENTS.md` - the entry point: the gist of the project, the map of documents, the rules.
2. The latest `session-logs/SESSION_*.md` - first the "Handoff" of the last part.
3. `PLAN.md` (and the development plan with the current phase, if present).
4. If a mission is in progress - its `contract.md`.

**Checkpoint:** at what point the project is and what comes next. Wait for the user.

## Stage 3 - How to delegate (before the first agent launch)

Read: `team/ROLES.md`, `team/RUN.md`, `team/workflow.md`, `team/contract-template.md`, `team/task-templates.md`, `team/task-check-template.md`, `PATTERNS.md` (if present).

**Checkpoint:** the path from the task to the agent launch - as a diagram with ↓ arrows: when a contract is needed, how I set a task (whitelist, scope isolation), how I check it before the launch. Wait for the user.

## Stage 4 - Architecture: the skeleton in full, the areas per task

Read in full: <the architecture skeleton and, if present, the checklist>. The areas - not in advance, but when a task has entered them.

**Checkpoint:** the architecture in your own words - what it is, why it exists, why to follow it. Understanding, not a retelling. Wait for the user.

## Stage 5 - References on demand (do not read in advance)

- `<file>` - <when it is needed>

## Where we are now (<date>, after <mission or item>)

<2-3 lines: the next item and where what is needed to continue lies. The handoff - the latest `session-logs/SESSION_*.md`.>

## User's rules

- <the project's current agreements>
```
