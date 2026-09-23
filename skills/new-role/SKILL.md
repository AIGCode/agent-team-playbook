---
name: new-role
description: >
  Creating a new role (a specialist agent) for the team/ team and rewriting
  an existing role for the project's stack. Use when you need to add a new
  member to the team, rewrite a role in a single style or rewrite the
  sample role (PHP) for a different stack. Triggers: "create a role", "new role",
  "add a role", "new agent for the team", "rewrite a role", "rewrite a
  role for the stack", "adapt a role to Python/Node/...", "new role",
  "add role".
user-invocable: true
---

# Creating a new team role

A role is an instruction for a specialist agent, a single file `team/roles/<role>.md`. The Tech Lead reads it and launches an agent with this prompt (see `team/RUN.md`).

## Principles

1. **A single style - XML tags.** All roles are written the same way: sections in `<role>`, `<context>`, etc. tags. A single skeleton = predictability for the Tech Lead and portability.
2. **Prompt by motivation, not by command.** Explain "why" rather than commanding in caps. "MUST", "MANDATORY", CAPS do not hold up better than a clear "why" - an agent that understands the reason follows the rule longer.
3. **The critical goes first.** A role is read top to bottom; after ~200 lines the agent starts ignoring what is lower. The most important (what it does, what it does not do, whether it is read-only) goes at the top, in `<role>`. Revising priorities means moving things higher, not appending at the end.
4. **Its own response format is mandatory.** Without a prescribed format the agent answers chaotically. Give the role a format in `<output_format>` with an outcome the Tech Lead reads first: a PASS / FAIL / NEEDS_REVIEW verdict for roles with a "yes/no" result (Checker, Architect); the rest have their own format, but the outcome is also at the top or in an explicit block (Developer - a DONE / PARTIAL / BLOCKED status and a table "acceptance criterion - met - how verified"; Reviewer - a Verdict by HIGH + violations by severity + Summary; Tester - a Verdict in PLAN and in RUN with coverage of the contract's criteria; Researcher - the outcome at the top, covered / not found, sources, no verdict). Write the verdict rule in the role itself: without it PASS means whatever is convenient for the agent.
5. **Paths - by convention.** The team's internals - `team/...` (works in any project). The maintained project's files - `<project>/...`. Placeholders: `<app>` (application), `<NNN>` (mission number), `<SERVER_ROOT>` (root on the server).
6. **Rewriting a role for a stack.** The roles in `team/roles/` are a working sample for PHP on shared hosting. To move a role to a different stack, it is rewritten, not just filled in with placeholders. What does not depend on the stack is kept: the role's purpose, its boundaries (what it does, what it does not do, whether it is read-only), the antipatterns and the report format - the mission chain and the Tech Lead rely on them. The antipatterns are kept in meaning, while the stack-specific details in them are replaced: for example, "Overengineering for shared hosting" of the Architect is "design for the real constraints of your environment", and in a role for a different stack it is described through the constraints of that stack. What is tied to the stack is replaced: the stack-specific rules (for example, PDO and `htmlspecialchars` for the Developer, `.htaccess` and `php_sapi_name` for the Reviewer), code examples, references and official documentation. A practical approach: for each stack-specific rule, find the principle it implements (for example, "data is closed off from the web", "the script is not run via the web"), and write down how this principle is fulfilled in the new stack. If the principle is not needed in the new stack - remove the rule, rather than picking a similar one. When all roles are rewritten, update the phrases "the roles are a sample for PHP" and "in the sample - PHP" in `team/ROLES.md`: otherwise they will claim something that is no longer in the project.
7. **A reviewing role checks consistency too, not only breakages.** Any reviewing role (like the Checker) has consistency among its checks: the new does not diverge from the neighboring rules or code and from other places about the same concept, one concept is named and done the same way, the change is carried through to all dependent places. The search is over all the concepts of the new, not only by the name of what was changed. Why: each edit on its own can be correct, yet contradict a neighboring place, and a check only for breakages does not see this. The stopping criterion is a divergence from what already exists, not "it could be done better".

## Role skeleton

Mandatory sections (for executor and reviewing roles; the Tech Lead is built differently - they are a coordinator, not an executor, and instead of `<task>`, `<workflow>`, `<output_format>` they have `<responsibilities>`, `<delegation>`, the startup procedure and the contract procedure; the samples have deviations - the Reviewer has no `<task>` (what to check - in `<role>` and `<workflow>`), the Architect has no `<workflow>` (the task and the order - in `<task>` and `<rules>`)):
- `<role>` - who it is, what it does, what it fundamentally does NOT do, whether it is read-only. The communication language. 2-5 lines.
- `<task>` - what the role is assigned in terms of the result; what the assignment consists of.
- `<workflow>` - the order of work, step by step.
- `<antipatterns>` - what not to do (typical mistakes of this particular role).
- `<output_format>` - the response format (a verdict or its own).

Optional (as the role needs):
- `<context>` - the project's environment/stack. On top a parameterized form (placeholders), under it a generic example. Skip for a project-agnostic role (e.g. researcher).
- `<scope>` - a hard "included / out", if the role easily goes beyond its bounds (e.g. checker).
- `<rules>` - specific rules or criteria (e.g. the Reviewer's 13 rules).
- `<examples>` - examples of correct / incorrect.
- `<references>` - a "where to look" table.

## Template

```
<role>
[Name] of project <project> (if the role is tied to a project). [One sentence: what it does]. [One phrase: what it fundamentally does NOT do / whether the role is read-only].
Communicate with the user in <language>. [If it writes code: identifiers, comments, logs - in English; texts for clients (emails, interface) - in the language from the assignment.]
</role>

<context>            [optional; skip for project-agnostic roles]
<project> - [brief project description]. Stack: <language and versions>, <database>, <external APIs>. Hosting: <SERVER_ROOT>. Each application in a separate folder `<project>/dev/<app>/`. [If the role checks syntax, tests or writes the deploy:] Local environment: <whether there is a local runtime, how to check syntax>.

Example (PHP project): a set of PHP applications on shared hosting (Apache). Stack: PHP 8.0+, MySQL/PDO, cURL, Shopify GraphQL API. Local environment: there is no local server, PHP is not installed on the developer's machine; syntax is checked with `php -l` in a temporary folder on the server.
</context>

<task>
[What the role is assigned, in terms of the result.]

The assignment contains:
- What to do (a concrete result)
- Whitelist of files/docs (what to read, what to change)
- Constraints (what not to touch)
- The path for the report (`team/missions/<NNN>_<name>/reports/<role>.md`)
</task>

<scope>             [optional]
Included: [...]
Out: [what belongs to another role]
</scope>

<rules>            [optional; role-specific rules/criteria]
### Scope isolation
- Work only with files from the whitelist; if something outside the whitelist is needed - into the report, do not change it.
### Shell
- Shell via the Bash tool (does not require confirmation). If it does not work - describe it in the report and finish (the agent cannot wait for an answer).
</rules>

<workflow>
1. Read the assignment
2. Read the source of truth (`<project>/docs/<app>/ARCHITECTURE.md` / `<project>/SECURITY.md` / context)
3. Read the files from the whitelist
4. [the role's main action]
5. [self-check of the result; for a reviewing role - a separate consistency step: all the concepts of the new, a search over them, the neighboring places of the same file and section, the parts of the change against each other, whether it is carried through to all dependent places]
6. Write the report to the file from the assignment
</workflow>

<antipatterns>
### 1. Drift from the assignment
[going beyond the whitelist, extra functionality, incidental refactoring -> into "Questions for the Tech Lead"]
### 2. [a typical mistake specific to this role]
### 3. Editing someone else's area
[documentation, entities, and decisions are maintained by the Tech Lead -> into the report, do not touch them yourself]
</antipatterns>

<output_format>
Write the report to the file specified in the assignment.

For a role with a "yes/no" result:
## Verdict
PASS | FAIL | NEEDS_REVIEW
## Issues
- [SEVERITY] file:line - description
## Action Items
- [ ] what needs to be done
## Summary
Up to 100 words.

For a reviewing role - its own format (e.g. severity HIGH/MEDIUM/LOW + a final table), plus `## Verdict` with a rule (e.g. PASS = no HIGH) and `## Summary`. An inconsistency (a divergence from what already exists) is a separate finding type, with both places indicated; it affects the verdict the same way as a breakage.
For a role that does the work (like the Developer) - instead of a verdict, `Status: DONE / PARTIAL / BLOCKED` and a table "acceptance criterion - met - how verified".
For the researcher - the outcome at the top (covered / not found, sources), the full material - in files, no verdict.
</output_format>

<examples>          [optional]
### Example 1 (correct): [a short case for the role]
### Example 2 (incorrect): [a typical mistake for the role]
</examples>

<references>        [optional]
| Area | Where to look |
|---|---|
| Application architecture | `<project>/docs/<app>/ARCHITECTURE.md` |
| [pattern] | `<project>/dev/<app>/...` |
</references>
```

## Where to save and how to connect it

The main rule: the role must appear everywhere the team lists roles and decides whom to launch. The steps below are the typical places, but not a complete list: after connecting it, find the mentions of a similar role (grep by name, for example `Checker`, over the project's `team/`) and decide whether the new role is needed in each such place. Separately - "When to skip a step" and "Rules" of `team/workflow.md`: decide whether the role needs its own gate (what it holds and when it can be skipped) and whether rules like "one writer at a time" apply to it. Why: a missed place means the Tech Lead does not know about the role or launches it bypassing the rules.

1. The role file: `team/roles/<role>.md`.
2. Write the role into the list of writer or read-only roles in `team/workflow.md` ("Rules") and `team/RUN.md` (section 2). The "one writer at a time" rule rests on this list: without it the Tech Lead does not know whether the role can be launched in parallel with others.
3. Add the role to `team/ROLES.md` - a brief description and when to launch it.
4. Add the role to `team/roles/techlead.md`: to the Teammates list and to delegation (what to assign to it) - otherwise the Tech Lead will not use it.
5. If the role is in the mission chain - write it into `team/workflow.md` (where in the chain, whether it can be skipped) and into the list of assignments in the mission tree ("Artifacts").
6. Check `team/RUN.md` - the agent name `<role>-N`, the model.
7. How to evaluate the role's report - add a block to `team/report-evaluation.md`.
8. The role's assignment format is taken from `team/task-templates.md`.

## An example before your eyes

The ready-made roles in `team/roles/` are samples for PHP: checker/architect (with a verdict), developer (status and a criteria table), reviewer (severity + verdict), tester (two modes, a verdict in each), researcher (project-agnostic, outcome at the top, no verdict). For a different stack they are rewritten per principle 6; after rewriting, update the phrases about the PHP sample in `team/ROLES.md` (also in principle 6).
