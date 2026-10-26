#!/usr/bin/env bash
# Stop hook: after a turn that changed project files (file edit or modifying shell command),
# the final answer must contain a "My initiative:" block. Missing -> block the stop once with the checklist.
# Project folder: $CLAUDE_PROJECT_DIR, else the session cwd.

node -e '
const fs = require("fs");

const content = e => (e && e.message && Array.isArray(e.message.content)) ? e.message.content
  : (e && e.message && typeof e.message.content === "string") ? [{ type: "text", text: e.message.content }] : [];
const isPrompt = e => e.type === "user" && (e.origin ? e.origin.kind === "human" : !e.isMeta && content(e).some(b => b.type === "text"));
const norm = s => String(s || "").replace(/\\/g, "/").replace(/\/+$/, "").toLowerCase();
const modifyingShell = /(^|[\s;&|(])(rm|rmdir|mv|cp|mkdir|touch|tee|sed\s+-i|git\s+(mv|rm|checkout|restore|reset|commit|push|add|stash|revert|clean))\b|>>?\s*[^\s&]|<<\s*\x27?EOF/;

function readTurn(path) {
  const entries = [];
  for (const l of fs.readFileSync(path, "utf8").split("\n")) { if (l) try { entries.push(JSON.parse(l)); } catch {} }
  let start = -1;
  for (let i = entries.length - 1; i >= 0; i--) { if (isPrompt(entries[i])) { start = i; break; } }
  return entries.slice(start + 1).filter(e => e.type === "assistant");
}

// True if the command names the project folder or a path inside it; C:/x is also matched as Git Bash /c/x.
function mentionsRoot(cmd, root) {
  const roots = [root];
  const drive = root.match(/^([a-z]):\/(.*)$/);
  if (drive) roots.push("/" + drive[1] + "/" + drive[2]);
  return roots.some(r => {
    for (let i = cmd.indexOf(r); i >= 0; i = cmd.indexOf(r, i + 1)) {
      const next = cmd[i + r.length];
      if (next === undefined || /[\/\s"\x27`;|&)]/.test(next)) return true;
    }
    return false;
  });
}

function check(inp) {
  const root = norm(process.env.CLAUDE_PROJECT_DIR || inp.cwd);
  if (!root) return { changed: false, reported: true };
  const inScope = s => { const p = norm(s); return p === root || p.startsWith(root + "/"); };
  const mentions = s => mentionsRoot(norm(s), root);
  const turn = readTurn(inp.transcript_path);
  const cwdInScope = inScope(inp.cwd);
  let changed = false, lastText = "";
  for (const e of turn) for (const b of content(e)) {
    if (b.type === "text" && b.text.trim()) lastText = b.text;
    if (b.type !== "tool_use") continue;
    const i = b.input || {};
    if (["Edit", "Write", "NotebookEdit"].includes(b.name) && inScope(i.file_path || i.notebook_path)) changed = true;
    if (["Bash", "PowerShell"].includes(b.name) && modifyingShell.test(i.command || "") && (mentions(i.command) || cwdInScope)) changed = true;
  }
  return { changed, reported: /\*\*My initiative:\*\*/.test(lastText) };
}

let raw = ""; process.stdin.on("data", d => raw += d).on("end", () => {
  let inp = {}; try { inp = JSON.parse(raw); } catch { return; }
  if (inp.stop_hook_active || !inp.transcript_path) return;
  let r; try { r = check(inp); } catch { return; }
  if (!r.changed || r.reported) return;
  // The final answer may reach the transcript a moment after the hook starts: re-read once before blocking.
  setTimeout(() => {
    try { r = check(inp); } catch { return; }
    if (!r.changed || r.reported) return;
    process.stdout.write(JSON.stringify({ decision: "block", reason:
      "Write the \"My initiative\" block.\n\n" +
      "The block is a record, not a ban. Initiative is allowed, and by this list the user sees where you acted without agreeing with them. It applies to any work, not only the contract.\n\n" +
      "Format: the line `---`, then on a separate line **My initiative:** and a numbered list \"what I did or decided myself - why - how to roll it back\". An item that changes the terms of the contract begins with the marker **Contract:**, the others - without the marker. If there was nothing like that - **My initiative:** none.\n\n" +
      "This includes:\n" +
      "1. Did something that was not discussed, or more than was discussed.\n" +
      "2. Decided for the user: an option, wording, order that they did not approve.\n" +
      "3. Stated a fact without reading the source.\n" +
      "4. Deleted or moved a file or folder without a word from the user.\n" +
      "5. Added something of your own to a decision of the user: project decisions, the contract, the plan, a task.\n" +
      "6. Acted without waiting for an answer to your question, or understood an ambiguous phrase your own way.\n\n" +
      "Small things inside the contract (a number, a path, a typo, the choice of method in the same places) do not go here.\n\n" +
      "The user decides what to roll back."
    }));
  }, 1500);
});'
