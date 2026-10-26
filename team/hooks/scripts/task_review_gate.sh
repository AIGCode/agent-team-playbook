#!/usr/bin/env bash
# PreToolUse Agent|SendMessage: for every mission task file (team/missions/*/tasks/*.md) named in the prompt or message
# 1) if edited in this session, it must have been Read after its last edit;
# 2) a review file <task>.check.md must exist next to it, be newer than the task
#    and answer all six review questions (Checked against / Found / Fixed; section 1 quotes the task).
# Otherwise deny the launch.

node -e '
const fs = require("fs");
const path = require("path");
const slash = s => String(s || "").replace(/\\/g, "/");
const norm = s => slash(s).toLowerCase();
const content = e => (e && e.message && Array.isArray(e.message.content)) ? e.message.content : [];

const deny = reason => process.stdout.write(JSON.stringify({ hookSpecificOutput: {
  hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: reason
}}));

// Returns a list of problems in the check file text; empty list = valid.
function checkProblems(text) {
  const problems = [];
  const parts = text.split(/^## (?=\d+\.)/m);
  for (let i = 1; i <= 6; i++) {
    const body = parts.find(p => p.startsWith(i + "."));
    if (!body) { problems.push("no section ## " + i + "."); continue; }
    const field = name => { const f = body.match(new RegExp("^" + name + ":[ \\t]*(.+)$", "m")); return f ? f[1].trim() : ""; };
    if (field("Checked against").length < 40) problems.push("section " + i + ": \"Checked against:\" is empty or shorter than 40 characters - name which sources you checked against");
    if (!field("Found")) problems.push("section " + i + ": no \"Found:\"");
    if (!field("Fixed")) problems.push("section " + i + ": no \"Fixed:\"");
    if (i === 1 && !/"[^"]{3,}"/.test(body)) problems.push("section " + i + ": no quote from the task in \"…\" - the question is about the text of the task, not the intent");
  }
  return problems;
}

let raw = ""; process.stdin.on("data", d => raw += d).on("end", () => {
  let inp = {}; try { inp = JSON.parse(raw); } catch { return; }
  const ti = inp.tool_input || {};
  const prompt = slash(ti.prompt || (typeof ti.message === "string" ? ti.message : ""));
  // Paths are compared case-insensitively but opened as written: case-sensitive file systems need the original case.
  const found = (prompt.match(/team\/missions\/[^\s/]+\/tasks\/[^\s/]+\.md/gi) || []).filter(t => !/\.check\.md$/i.test(t));
  const tasks = [...new Map(found.map(t => [norm(t), t])).values()];
  if (!tasks.length) return;

  let uses = [];
  if (inp.transcript_path) {
    try {
      for (const l of fs.readFileSync(inp.transcript_path, "utf8").split("\n")) {
        if (!l) continue;
        let e; try { e = JSON.parse(l); } catch { continue; }
        if (e.type !== "assistant") continue;
        for (const b of content(e)) if (b.type === "tool_use") uses.push(b);
      }
    } catch {}
  }

  // Absolute path of a task: from tool uses in the transcript, else relative to cwd or its ancestors.
  function locate(t) {
    for (const b of uses) {
      const f = (b.input || {}).file_path;
      if (f && norm(f).endsWith(norm(t)) && fs.existsSync(f)) return f;
    }
    let dir = inp.cwd || process.cwd();
    for (let k = 0; k < 8; k++) {
      const c = path.join(dir, t);
      if (fs.existsSync(c)) return c;
      const up = path.dirname(dir); if (up === dir) break; dir = up;
    }
    return null;
  }

  const issues = [];
  for (const t of tasks) {
    let lastEdit = -1, lastRead = -1;
    uses.forEach((b, i) => {
      const f = norm((b.input || {}).file_path);
      if (!f.endsWith(norm(t))) return;
      if (["Write", "Edit"].includes(b.name)) lastEdit = i;
      if (b.name === "Read") lastRead = i;
    });
    if (lastEdit >= 0 && lastRead < lastEdit) issues.push(t + ": changed after the last reading - re-read it in full (Read)");

    const abs = locate(t);
    if (!abs) { issues.push(t + ": task file not found on disk"); continue; }
    const check = abs.replace(/\.md$/i, ".check.md");
    if (!fs.existsSync(check)) { issues.push(t + ": no check file " + check); continue; }
    if (fs.statSync(check).mtimeMs < fs.statSync(abs).mtimeMs) { issues.push(t + ": check file is older than the task - the task was edited after the check, check it again"); continue; }
    const p = checkProblems(fs.readFileSync(check, "utf8"));
    if (p.length) issues.push(t + ": check file is incomplete - " + p.join("; "));
  }
  if (!issues.length) return;

  deny("Launch stopped.\n- " + issues.join("\n- ") + "\n\n" +
    "The check file - next to the task, named <task>.check.md, written after the last edit of the task, per the template team/task-check-template.md. Six sections \"## 1.\" … \"## 6.\" (questions: 1 - what the user will get in hand, quotes of the task lines that hand them a decision or reading; 2 - whether the agent has enough context and decisions of the user, including unrecorded ones; 3 - facts, references, line numbers checked against the source; 4 - quotes of requirements with a ready-made answer and whose decision it is; 5 - whether there are contradictions with the contract, the role, the architecture, the architecture canon, itself (the plan item checked against the marks about tangled places in the plan); 6 - the agent name and the paths are correct). In section 1 - a quote from the task in \"…\". In each, three lines: \"Checked against:\" - which sources (file, section, line), \"Found:\" - what is wrong or \"nothing\", \"Fixed:\" - what and where (line) or \"-\". To the user - only a link to the check file.");
});'
