# Hook: the "My initiative" block

The hook holds the Tech Lead's rule "at the end of every final answer - the "My initiative" block" (`team/roles/techlead.md`, the responsibilities about what to bring to the user, and the "My initiative" block). Two scripts work as a pair: a reminder at the start of the session and a check when the answer stops. The general structure of hooks and the installation order - `team/hooks/README.md`.

## What it does

- [Claude Code] **Reminder** (`scripts/initiative_session_reminder.sh`, the SessionStart event: startup, resume, clear, context compaction). Tells the chat the block format in advance, so that it writes the block itself, and the check on stop only catches misses.
- [Claude Code] **Check** (`scripts/initiative_report.sh`, the Stop event). Looks at the turn since the user's last message: whether it changed project files - `Edit`, `Write`, `NotebookEdit` inside the project folder or a modifying shell command (`rm`, `mv`, `cp`, `mkdir`, `sed -i`, redirection into a file, modifying `git` commands, etc.), run in the project folder or with a path to it (including in the Git Bash form `/c/...`). If it did, and the last text of the answer has no `**My initiative:**`, it prevents the answer from finishing once and sends the format and the list of six items. The chat adds the block, the hook does not stop it a second time.

[Claude Code] The project folder - `$CLAUDE_PROJECT_DIR` (the project root, Claude Code passes it to the hook itself); if the variable is missing - the session's working folder. Nothing needs to be configured.

## What error it catches

Decisions the chat made for the user silently: did more than discussed; chose an option or wording itself; stated a fact without a source; deleted or moved a file; added something of its own to the user's decision; did not wait for an answer or understood a phrase its own way. The user sees only the outcome and does not know where it was decided for them - and without this cannot roll it back.

This is a record, not a ban: the work does not stop, initiative is allowed, it is just visible. The rule in the role is forgotten by the middle of a long session, the hook brings it back every time the turn changed files.

## What it costs

| What | Tokens |
|---|---|
| Reminder | ~150 once per session start and after each compaction or clearing of the context |
| Check | 0 if files did not change or the block is present; ~400 and a repeated answer on a miss |
| The block itself in the answer | ~30-200 per final answer (the role's rule, with the hook and without it) |

## Who should install it

- **Worth it:** almost any project where the chat changes files and the user wants to see where it was decided for them. The hook is cheap: when the rule is followed it costs nothing except the reminder at startup.
- **Not worth it:** if the user does not want the block in answers or checks every edit line by line - then the block duplicates their work. The role's rule stays in place until the user cancels it.

## How to install

The order - `team/hooks/README.md`, "How to install". Installation in Claude Code - `team/SETTINGS_CLAUDE_CODE.md`, "Hooks", `initiative.md`.

Install both scripts together: without the reminder the chat learns about the block only from the stop and writes the answer twice every time, without the check the block again rests on memory.

## How to check

1. New session: ask the chat to create a test file in the project. At the end of the answer there should be the `**My initiative:**` block - the reminder prompted it.
2. Ask it to create one more file and answer without the block: the answer stops, the hook sends "Write the "My initiative" block", the chat adds the block.
3. Ask a question without editing files: the hook stays silent.
4. Delete the test files.

## Limitations

- The hook recognizes modifying shell commands by a list of commands: it does not see files edited by a script (for example, `python script.py` that writes a file), and it may take a harmless command from the list for an edit. The cost of the error is small: at worst it asks for the block one extra time.
- Only the last text of the turn is checked: a block written in the middle of the answer does not count.
- The hook looks for the text `**My initiative:**` verbatim, together with the asterisks. The block format, the six items and the **Contract:** marker are repeated in both scripts. An edit of the rule in the role (and its translation into another language) requires the same edit in the reminder and in the check, otherwise the hook will start stopping correct answers.
