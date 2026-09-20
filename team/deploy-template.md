# DEPLOY instruction template

The Developer fills in this template when a mission requires deploying to the server. The result is a `DEPLOY.md` file in the mission folder (`team/missions/<NNN>_<name>/DEPLOY.md`).

Purpose: the user goes through the instruction step by step (together with the developer or on their own) and at the end the contract is fulfilled. The instruction must be self-contained and precise - no "roughly", no missing details.

The document is read and executed by the user manually: they copy commands one by one, paste them into the console, drag files with the mouse. Hence three things that make it convenient: each command is on one line and ready to copy, the steps go in execution order, and the paths and values are substituted so that nothing has to be guessed.

## Fill-in rules

1. **Each command is one line**, ready to paste into the console. No multi-line commands, no wraps, no trailing backslashes. One command = one code block.
2. **For each command - either an expected response or a request for the result.** Under the command write: "Expected response: `...`" OR "Send me the output of this command." Do not leave a command without stating what to do with its result. If the output needs to be analyzed - state who to send it to: by default the Tech Lead (they run the session); mark "pass to the Developer" only if the question is about the internals of the code.
3. **State where the command is executed** - on the server (SSH) or locally (PowerShell/Bash). If the whole instruction is on the server - say so once in the introduction.
4. **Exact paths.** Source (`<project>/dev/<app>/...`) -> destination on the server (the full path). State the server root explicitly.
5. **Placeholders in CAPS** (`CLIENT`, `AMOUNT`, `DATE`). If the value is already known at the time of writing - substitute it and mark that it has been substituted.
6. **Back up unique data (index, logs) before changes** - it is not in git.
7. **Syntax check** (`php -l`) for each modified PHP file before running.
8. **Rollback** - how to return to the previous state for each modified artifact (git / backup).
9. **Result verification** - both in the code/index and on the web, with concrete expected values (tie it to the "User verification" checklist from the contract).
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

## Step 1. Upload the modified files to the server

Copy (manually, as usual) to the server:
- `<project>/dev/<app>/<file>` -> `<SERVER_ROOT>/<app>/<file>`
- `<project>/dev/<app>/<file>` -> `<SERVER_ROOT>/<app>/<file>`

---

## Step 2. Back up unique data (if affected)

<Index/logs/config that are not in git. If the deploy does not touch them - remove the step.>

```
<backup command, one line>
```

Expected response: `<...>`.

---

## Step 3. Syntax check on the server

```
<cd into the root + php -l for each PHP file; one command per block>
```

Each must return `No syntax errors detected`. On an error - do NOT continue, roll back (Step 6) and report.

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
- <what should be visible - tie it to the "User verification" items from the contract>
- <what should NOT have changed - regressions>

---

## Step 6. Rollback (if something broke)

<For each modified artifact - how to return to the previous state.>

```
<command to roll back the data from the backup, one line>
```

Restore the code from git: `git show HEAD:<project>/dev/<app>/<file>` or from your own copy.

---

## Step 7. Cleanup (after a successful check)

```
<removing backups/temporary files, one line>
```

<Note whether temporary files were created in the process.>
