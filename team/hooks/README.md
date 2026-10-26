# Team hooks

[Claude Code] A hook is a command that Claude Code runs on its own on a session event: before or after a tool call, when an answer stops, at the start of a session. A hook can add text to the Tech Lead's context (a reminder) or forbid a call (a gate). A rule in a role rests on discipline and is forgotten by the middle of a long session, while a hook fires every time.

This file is about how hooks are organized in the framework. Each hook is a separate file in this folder: what it does, what error it catches, what it costs, who should install it, how to install it. The hook scripts are in `scripts/`. Read by the Tech Lead: decides which hooks to propose to the user and installs them after the user agrees.

## The main thing

1. **The framework does not install hooks.** Only instructions are here. A hook is installed in a project when the user has agreed: each hook has a cost in tokens, and for a simple project it does not pay off.
2. **A hook supports a rule, it does not replace it.** The rule a hook holds is written in a role or in a template and works without the hook, just worse: it rests on the Tech Lead's memory. No hook - the rule still applies.
3. **The framework's hook scripts are written for Claude Code.** Hooks in Cursor - `team/RUN_CURSOR.md`, "Prerequisite".

## When to propose

The Tech Lead assesses the project's complexity and proposes hooks twice:

- **when the team is deployed** (`team-init`, after the role is accepted) - based on what is known about the project at the start;
- **when the project grows more complex** - for example, the number of tasks in a mission has grown, an architecture of several parts has appeared, errors in tasks have started reaching the Checker or the user.

The proposal to the user - briefly, for each hook: "the project is complex, it makes sense to install such-and-such hook: it catches this, it costs that much". The benefit and the cost are taken from the hook's file. The user agreed - the Tech Lead installs the hook and records it in the project's decisions (`DECISIONS.md`), so that the next session knows the hook is installed. Refused - does not insist, the rule works without the hook.

By the same complexity assessment the Tech Lead decides whether the project needs the new-chat onboarding instead of compact (`team/onboarding-template.md`). It is not a hook, but it is proposed at the same moments and in the same way - with the benefit and the cost.

## How to install

A hook is installed in the project, not globally: the decision about a hook is made based on the complexity of a specific project, and another project does not need it.

Installation in Claude Code - `team/SETTINGS_CLAUDE_CODE.md`, "Hooks".

## Hooks

| File | What it holds |
|---|---|
| `team/hooks/task-review.md` | The task check before launching an agent (`team/task-check-template.md`) |
| `team/hooks/initiative.md` | The "My initiative" block at the end of the Tech Lead's answer (`team/roles/techlead.md`) |
