#!/usr/bin/env bash
# PostToolUse Write|Edit: after a mission task file (team/missions/*/tasks/*.md) changed,
# require a review pass written to <task>.check.md before launching the agent.

node -e '
let raw = ""; process.stdin.on("data", d => raw += d).on("end", () => {
  let inp = {}; try { inp = JSON.parse(raw); } catch { return; }
  const p = String((inp.tool_input || {}).file_path || "").replace(/\\/g, "/").toLowerCase();
  if (!/\/team\/missions\/[^/]+\/tasks\/[^/]+\.md$/.test(p) || p.endsWith(".check.md")) return;
  const check = inp.tool_input.file_path.replace(/\.md$/i, ".check.md");
  process.stdout.write(JSON.stringify({ hookSpecificOutput: {
    hookEventName: "PostToolUse",
    additionalContext:
      "You changed a task for an agent (" + inp.tool_input.file_path + "). Before launching the agent - a second pass per team/task-check-template.md: re-read the file in full (Read) through the eyes of a checker, not of the author, and write the check to " + check + " (overwrite it if it exists). Six sections, three lines in each; in section 1 - a quote from the task in \"…\" - \"Checked against:\" (which sources: file, section, line), \"Found:\" (what is wrong or \"nothing\"), \"Fixed:\" (what and where, line, or \"-\"):\n" +
      "## 1. What will the user get in hand after this agent? Quote the lines of the task that hand the user a decision or reading, and for each - why the team cannot decide on its own. There are no such lines - quote the line that says the agent decides on its own.\n" +
      "## 2. Does the agent have enough context to decide on its own: the decisions of the user, including ones not yet recorded?\n" +
      "## 3. Is every fact, reference, line number checked against the source, not from memory?\n" +
      "## 4. Quote the requirements where you give the agent a specific answer (a decision, option, wording); for each - whose decision it is and where it is recorded (the user, the architecture, the decisions of the project) or whether it is your guess.\n" +
      "## 5. Are there contradictions with the contract, the role of the agent, the architecture, the architecture canon, itself? The plan item of the task and the places the edit goes to are checked against the marks about tangled places in the development plan (team/architecture-canon.md, 3.5): no work goes past a mark. If the task writes or edits the architecture - it does not order writing in a form that the canon prohibits.\n" +
      "## 6. Is the agent name free, are the paths and result files correct?\n" +
      "Fix what you find in the task before writing the check: an edit of the task after the check makes the check outdated. To the user - only a link to the check file, do not retell the contents. The agent launch is blocked without a Read of the task after its last edit and without a complete check file newer than the task."
  }}));
});'
