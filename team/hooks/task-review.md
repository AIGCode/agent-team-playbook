# Hook: the task check before launching an agent

The hook holds the Tech Lead's rule "a task is checked before an agent is launched" (`team/task-check-template.md`). Two scripts work as a pair: a reminder after a task edit and a gate before an agent launch. The general structure of hooks and the installation order - `team/hooks/README.md`.

## What it does

- [Claude Code] **Reminder** (`scripts/task_review_reminder.sh`, the PostToolUse event on `Write|Edit`). The Tech Lead has written or edited a task file `team/missions/*/tasks/*.md` - the hook adds an instruction to their context: re-read the task in full through the eyes of a checker and write `<task>.check.md` next to it, per the six questions of the template.
- [Claude Code] **Gate** (`scripts/task_review_gate.sh`, the PreToolUse event on `Agent|SendMessage`). Finds the task paths `team/missions/*/tasks/*.md` in the launch prompt or in the message to an agent and forbids the call if for any of them:
  - the task was edited in this session and was not re-read (Read) after the last edit;
  - there is no check file `<task>.check.md` next to it;
  - the check file is older than the task - the task was edited after the check;
  - the check is incomplete: one of the six sections `## 1.` … `## 6.` is missing, a section has no "Checked against:", "Found:", "Fixed:" lines, "Checked against:" is shorter than 40 characters, section 1 has no quote from the task in "…".

In the refusal the gate writes what is wrong - the Tech Lead fixes it and launches again.

## What error it catches

An error in the task itself: a path without a root, a fact or a line number from memory, an ambiguous reference, an unfinished case, a decision handed to the user without need, the Tech Lead's ready-made answer disguised as a task for the agent, a contradiction with the contract or the role. Such an error passes through the whole chain: the agent works per the task, and the Checker checks the work against the same task and does not see the error.

Without the gate the reminder stays a wish: by the middle of a long session the Tech Lead skips the check. The gate is cheap and makes the check mandatory.

## What it costs

| What | Tokens |
|---|---|
| Reminder | ~700 per each edit of a task file; with a series of small edits it repeats every time |
| Gate | 0 if the check is in order; ~350 on a refusal |

This is the cost of the scripts themselves. The cost and benefit of the check they require, and the rule on the set of questions - `team/task-check-template.md`, "The main thing".

## Who should install it

- **Worth it:** missions have several tasks for agents, the project has an architecture of several parts, tasks refer to many files and lines, errors in tasks have already reached the Checker or the user.
- **Not worth it:** a simple project, the tasks are short and rare. The check rule applies there too, but without the hook: the cost of a reminder on every edit does not pay off.

## How to install

The order - `team/hooks/README.md`, "How to install". Installation in Claude Code - `team/SETTINGS_CLAUDE_CODE.md`, "Hooks", `task-review.md`.

Install both scripts together: without the reminder the Tech Lead learns about the check only from the gate's refusal, without the gate the check again rests on memory.

## How to check

1. Create a test task in the mission folder (for example, "answer in one line: ok") and launch an agent on it without writing the check: the gate should refuse with the text "Launch stopped" and a list of reasons.
2. Write `<task>.check.md` per the template and launch again: the launch goes through.
3. Edit the task and launch without a new check: refusal "check file is older than the task".

## Limitations

- The gate sees only a task named in the prompt by a path of the form `team/missions/<NNN>_<name>/tasks/<file>.md`. A prompt per the `team/RUN.md` template (section 5) contains such a path; a task passed as text in the prompt is not checked by the gate.
- The task file is looked up by the paths from the session, then from the working folder upward. A task outside the project may not be found - then the gate refuses with "task file not found".
- The gate checks "re-read after an edit" only within the current session: it does not see an edit from a past session, but it will catch an outdated check by the file times.
- The gate checks the section numbers `## 1.` … `## 6.` and the field names ("Checked against:", "Found:", "Fixed:") by exact text; the question texts are repeated in the reminder and in the gate's refusal by meaning. An edit of the template `team/task-check-template.md` (and its translation into another language) requires the same edit in the reminder and in the gate: otherwise the gate will start rejecting correct checks, and the reminder will diverge from the template.
