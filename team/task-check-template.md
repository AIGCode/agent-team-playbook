# Template: the task check before launching an agent

The Tech Lead reads this file when they have written or edited a task for an agent (`team/missions/<NNN>_<name>/tasks/<file>.md`) and are about to launch the agent or send it the task by message. The check is a second pass over the task through the eyes of a checker, not of the author; the result is a file next to the task.

## The main thing

The task is the main lever of a mission's quality. An error in the task passes through the whole chain: the agent works per the task, and the Checker checks the work against the same task and does not see the error. It can only be caught before the launch.

- **The check is written after the last edit of the task.** Found an error - fix the task, then write the check. The task was edited after the check - the check is outdated, it is written anew.
- **The text of the task is checked, not the intent.** Before the check the task is re-read in full from the file: the author remembers what they meant to write and misses what is actually written.
- **To the user - only a link to the check file.** Do not retell the contents: a retelling eats the context of both.
- **The questions are short.** A question that requires reading one more document is multiplied by the number of tasks. Add a new question only if its cost pays off.

Cost: the text of the task passes through the Tech Lead's context roughly three times (write, re-read, write the check as a file of roughly the same size). For a mission of six tasks of ~6 KB each - on the order of 15-25 thousand tokens on top. Benefit: in most checks something in the task gets fixed before the agent is launched.

The rule applies in any project. In Claude Code it can be held by the hook `team/hooks/task-review.md` - it does not let an agent be launched without a fresh and complete check; it is installed with the user's consent. Without the hook the check rests on the Tech Lead's discipline. Hooks in Cursor - `team/RUN_CURSOR.md`, "Prerequisite".

## The check file

The name - `<task>.check.md` next to the task: for `tasks/developer_1.md` - `tasks/developer_1.check.md`. Six sections, the numbers and the lines "Checked against:", "Found:", "Fixed:" - exactly in this form: the hook checks completeness by them. The question texts are repeated in the hook's scripts by meaning: an edit of the template (and its translation) requires the same edit in the scripts (`team/hooks/task-review.md`, "Limitations").

- **Checked against:** - which sources you checked against: file, section, line. Not "checked everything", but what exactly you opened.
- **Found:** - what is wrong, or "nothing".
- **Fixed:** - what and where in the task (line), or "-".

~~~~markdown
# Check of task <task file>

## 1. What will the user get in hand after this agent?
Quote the lines of the task that hand the user a decision or reading, and for each - why the team cannot decide on its own. There are no such lines - quote the line that says the agent decides on its own. The quote - in "…".
Checked against: 
Found: 
Fixed: 

## 2. Does the agent have enough context to decide on its own?
Are the user's decisions, including ones not yet written into the project's files (said in this session), in the task or by a link from it?
Checked against: 
Found: 
Fixed: 

## 3. Is every fact, reference, line number checked against the source, not from memory?
Checked against: 
Found: 
Fixed: 

## 4. Where do I give the agent a ready-made answer?
Quote the requirements where the task gives the agent a specific decision, option or wording; for each - whose decision it is and where it is recorded (the user, the architecture, the project's decisions) or whether it is your guess. A guess - remove it from the task or mark it as a proposal that the agent checks.
Checked against: 
Found: 
Fixed: 

## 5. Are there contradictions with the contract, the agent's role, the architecture, itself?
Checked against: 
Found: 
Fixed: 

## 6. Is the agent name free, are the paths and result files correct?
Checked against: 
Found: 
Fixed: 
~~~~

The explanation lines under the section headings need not be repeated in the check file: the heading and the three lines are mandatory, the rest - as needed.

## Sample section

~~~~markdown
## 3. Is every fact, reference, line number checked against the source, not from memory?
Checked against: lines 12-18 of the task against `docs/<app>/ARCHITECTURE.md`, section "Queue"; the config path - against the file `dev/<app>/config/settings.php`, opened in the session.
Found: "line 39" in the task is ambiguous - it is a field number in the table, not a line of the file.
Fixed: line 15 - "field 39 of the field table".
~~~~
