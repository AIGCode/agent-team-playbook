# DEPLOY instruction template

> **Disclaimer.** This is an illustrative template of a deployment instruction for a production server - not a reproduction of anyone's real procedure and not a ready-made "100%" solution. You alone are responsible for the rollout and the data on your own server: which steps, commands, and rollback are needed and sufficient is decided and assembled by you alone. A mistake leads to breaking production and data loss - do not apply it blindly, check it against your own project.

The Developer fills in this template when a mission requires deploying to the server. The result is a `DEPLOY.md` file in the mission folder (`team/missions/<NNN>_<name>/DEPLOY.md`).

Purpose: the user goes through the instruction step by step (together with the developer or on their own) and at the end the contract is fulfilled. The instruction must be self-contained and precise - no "roughly", no missing details.

The document is read and executed by the user manually: they copy commands one by one, paste them into the console, drag files with the mouse. Hence three things that make it convenient: each command is on one line and ready to copy, the steps go in execution order, and the paths and values are substituted so that nothing has to be guessed.

## Fill-in rules

1. **Each command is one line**, ready to paste into the console. No multi-line commands, no wraps, no trailing backslashes. One command = one code block.
2. **For each command - either an expected response or a request for the result.** Under the command write: "Expected response: `...`" OR "Send me the output of this command." Do not leave a command without stating what to do with its result. If the output needs to be analyzed - state who to send it to: by default the Tech Lead (they run the session); mark "pass to the Developer" only if the question is about the internals of the code.
3. **State where the command is executed** - on the server (SSH) or locally (PowerShell/Bash). If the whole instruction is on the server - say so once in the introduction.
4. **Exact paths.** Source (`<project>/dev/<app>/...`) -> destination on the server (the full path). State the server root explicitly.
5. **Placeholders in CAPS** (`CLIENT`, `AMOUNT`, `DATE`). If the value is already known at the time of writing - substitute it and mark that it has been substituted.
6. **Back up unique data (index, logs) before the upload** - it is not in git, and if the upload breaks something, there will be nowhere to restore it from.
7. **Syntax check - before the file goes live.** On many stacks a file starts serving visitors the moment it is copied to the production path, so checking it there is already too late: while the check is running, the broken file returns errors. Check each modified file locally or in a temporary folder on the server - using the method from "Local environment" in the Developer role's `<context>` (e.g. `php -l` for PHP), and only after a clean check move it to the production path. Order of steps: backup → check → upload. If the check finds an error - do not upload the file and report it.
8. **Rollback** - how to return to the previous state for each modified artifact (git / backup). The code is rolled back to the version before the mission - the commit made before launching the Developer (`<hash>`, filled in by the Developer), if there is one; if there is no commit - from a backup or your own copy. Not to `HEAD`: the Developer's work may already have been committed, and `HEAD` will return the same broken version.
9. **Result verification** - the last step of the document: a command, button or page by which the user sees that everything works, with concrete expected values. Every step above already verifies itself (expected response, rule 2), and the final check is inside the document too - do not refer outside it. The user runs their own checks if they wish.
10. **Reworking an already-run DEPLOY (a repeat iteration).** If you are not creating the document from scratch but reworking a DEPLOY that the user has already run through - at the very beginning (before "What we deploy") give an "In short - what to do and what is new" block: number the user's actions in order and explicitly highlight what has changed since the previous run and from which step to start. The user works from the latest version and should not have to guess the delta themselves. Changes inside the code that the user does not make by hand - mark separately: "the script does this, not needed by hand".
11. **The document is executed mechanically, step by step.** Everything that has to be done is a separate numbered step; the text between steps is context, not action. Checking the finished document: go through the steps only, without reading the explanations between them - it should work. If the script changed, re-uploading it to the server is a separate step before the first command that uses it (including in a sub-block added later).

---

# DEPLOY: <mission name>

<A single introduction: where the commands are executed (server SSH / local), the application's server root, e.g. `<SERVER_ROOT>/<app>/`.>

## In short - what to do and what is new (mandatory on a repeat iteration)

<Only if this is a rework of an already-run DEPLOY. Number the user's actions in order; explicitly highlight what has changed since the previous run and from which step to start. Changes inside the script that need not be done by hand - mark "the script does this itself". If the document is created from scratch - this block is not needed.>

---

What we deploy - exactly **<N>** files:
- `<file>` - <what changed in one line>
- `<file>` - <what changed>

Note: `<file>` was NOT changed in the mission - it is NOT deployed. <if applicable>

---

## Step 0. Preparation / collecting values (if needed)

<Which values will be needed further and where to get them (the primary source + an alternative command). Record the values and mark the placeholders. If the values are known at the time of writing - substitute them and note the date/source. If the step is not needed - remove it.>

```
<command to obtain the value, one line>
```

Expected response: `<...>` OR: Send me the output.

---

## Step 1. Back up unique data (if affected)

<Index/logs/config that are not in git. If the deploy does not touch them - remove the step.>

```
<backup command, one line>
```

Expected response: `<...>`.

---

## Step 2. Syntax check before the upload

<Where we check - per the project's "Local environment": locally or in a temporary folder on the server, closed to web access, but not on the production path. If the check is in a temporary folder - first copy the files there as a separate action; delete the folder - at Step 7.>

```
<syntax check command for one modified file (e.g. php -l <temporary path>/<file>); one command per block>
```

Expected response: `<the clean check response, e.g. No syntax errors detected>`. On an error - do not upload the file, do not continue, and report: the production path has not been touched yet, there is nothing to roll back.

---

## Step 3. Upload the modified files to the server

Only after a clean check at Step 2. Copy (manually, as usual) to the server:
- `<project>/dev/<app>/<file>` -> `<SERVER_ROOT>/<app>/<file>`
- `<project>/dev/<app>/<file>` -> `<SERVER_ROOT>/<app>/<file>`

---

## Step 4. <Main operation>

<The essence: what will happen and why. Commands one by one, each on one line, under each an expected response or a request for the output.>

```
<command, one line>
```

Expected response: `<...>` OR: Send me the output of this command before continuing.

---

## Step 5. Result verification

In the code / index:

```
<verification command, one line>
```

Expected response: `<concrete values>`.

On the web:
- Open `<URL>`
- <what should be visible - concrete values>
- <what should NOT have changed - regressions>

---

## Step 6. Rollback (if something broke)

<For each modified artifact - how to return to the previous state.>

```
<command to roll back the data from the backup, one line>
```

Restore the code from git - from the pre-mission commit made before launching the Developer, if there is one: `git show <hash>:<project>/dev/<app>/<file>` (`<hash>` is filled in by the Developer); otherwise from your own copy. `HEAD` is not suitable for rollback: it may already contain the Developer's work.

---

## Step 7. Cleanup (after a successful check)

```
<removing backups/temporary files, one line>
```

<Note whether temporary files were created in the process.>
