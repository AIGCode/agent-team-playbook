# DRAFT - Contract: <name>

> # DRAFT - NOT APPROVED
> <If the work rests on a provisional basis (draft architecture, decisions not yet accepted) - say so explicitly here: what to treat as a hypothesis rather than a fact. If the basis is solid - remove this line.>

> **The contract has two parts.**
> **PART 1 - for the user:** what we are doing, why, and how we verify it - in plain language. Self-contained: to understand the scope, there is no need to open other documents. Three layers - a pyramid: 1 - what it is and why, 2 - how it works, 3 - the details.
> **PART 2 - for the executor (AI):** the exact steps, endpoints, fields, sources - how exactly to do it and where to take the data from.
> Layer 3 is linked to part 2 by the item label (T1, T2... / E1, E2...). Layers 1-2 have no labels.

<!--
The filling rules sit in comments next to the section they belong to. In the finished contract the comments can be deleted.
THE CONTRACT DOES NOT MAKE DECISIONS ABOUT HOW THE APPLICATION IS BUILT. It says what should come out and refers to decisions already made (architecture, DECISIONS). Found an open question about how things are built (data schema, where things live, how errors are handled, how data is written) - stop: design first (Architect + Developer) and approval by the user, then the contract. Otherwise the executor will neatly build an unthought-out solution, and the reviewers will accept it as agreed.
ORDER: part 1 → approval by the user → part 2. Part 2 is not written before approval: if part 1 is edited, the work on it is lost.
BRIDGE: labels only in layer 3 and in part 2. The dependency is one-way - part 1 is clear without part 2; part 2 expands part 1, not the other way around.
-->

---

# PART 1 - FOR THE USER

<!--
Part 1 is a conversation between two friends. You tell a friend what we are going to do and why, the way you would tell them in person: in your own words, with what you both already know from the conversation. The friend knows the project, but was not part of this conversation and will not go digging into the files.

FORM: an enumeration - as a list; a process or a data path - as a diagram with arrows ↓; what it will look like - as a screen mockup; a structure or a hierarchy - as a tree. Prose only connects and explains, it does not replace lists and diagrams.
LANGUAGE: no code snippets, commands, field names, endpoints, internal numbers, or "go read file X" - all of that goes in part 2. A technical term - only as an anchor, when it has to be relied on, and with an immediate translation into human language. Show a result through the function ("we can publish a listing"), not through the mechanics ("the API returned X"). Honestly: without smoothing over the risks and without nudging toward agreement.
EDITING: a new piece goes into the layer whose question it answers, not where the gap was noticed. The layers do not repeat each other: each next one expands the previous one. Many edits and the layers have drifted - part 1 is rewritten in full, not patched.
-->

<details open>
<summary><b>Layer 1. What we are up to</b></summary>


<!--
The friend asked: "So, what are you up to?" Tell them.
Here: what we are doing, why, a list "what you will get" (all the results of the mission), what you do, what goes to the server, one line - what is not here. Nothing else: after this layer the essence is already clear.
-->

<What we are doing and why.>

**What you will get:**
- <what will exist after the mission: a file, a section of a document, a working function - not an action>

**What you do** - <each user action and the document they follow to do it>. <No actions - "nothing except approving the contract".>

**Server** - <what goes to the server and when / "we do not touch it".>

**What is not here:** <one line; in detail - layer 3, "What is NOT included".>

</details>

<details>
<summary><b>Layer 2. How it will work</b></summary>


<!--
The friend got interested: "And how will it work?" Tell them in more detail.
Here: how it is built and what it looks like - the model, screens, the data path, where things are stored; risks. No steps and no executors: that is layer 3.
-->

<A diagram with arrows ↓ - if there is a chain (a data path, the order of steps, who reacts to what). No chain - do not draw a diagram.>

<How it is built - prose connects and explains the diagram.>

**Risks**
- <what can go wrong> - <how we protect ourselves / roll back. Honestly, in human language.>

</details>

<details>
<summary><b>Layer 3. The details</b></summary>


<!--
The friend says: "Let's go through the details, I want to check." Walk them through everything.
At the end of each paragraph, in parentheses - the item label (T1, T2...), by which part 2 is linked to it.
Here: the steps by stage (for example, before the build / the build) - in prose, a paragraph per stage, each with a label; what is outside the mission. There is no table of steps in part 1: the detailed "how we verify" for each step is in part 2, "Specification by item".
End with what will tell you both it is done - a checklist: the work is accepted by it (part 2, "Acceptance"). The checklist contains every result from the "what you will get" list of layer 1 and every step label of this layer, each item has a step label. Each item has a visible result: what the user will see, not what the agent did. Below the checklist - the line "Not counted as done": which pro-forma answers do not close the work.
A SUMMARY IS MANDATORY: layer 3 opens with a summary - what it covers and in which groups of steps, 2-3 sentences of prose. Before each table - a preview: what it covers and what matters most, 1-2 sentences; not a table of contents. Details are not shown without a summary.
-->

<Layer summary: what it covers and in which groups of steps.>

**<Stage>**

<What we do at this stage and why - in human language.> (T1)

### What is NOT included

- <what is deliberately outside this mission and where it goes (another mission / stage / decided separately)>

### How we will know it is done

- [ ] <...>

Not counted as done: <what looks done but does not close the work.>

</details>

<!--
CHECK BEFORE SHOWING: read part 1 as if you were this friend: did you understand everything and did you not get bored. Cross-check the labels: every label of layer 3 and every result of "what you will get" is in the checklist.
-->

---

# PART 2 - FOR THE EXECUTOR (AI)

<details>
<summary><b>Part 2 in full</b></summary>

> The exact specification. The labels match layer 3 of part 1. It is written only after the user has approved part 1. Before approval there is one line here: "Part 2 - after approval of part 1".

<!--
Precision over readability.
- Endpoints, methods, exact field names, versions - verbatim.
- Sources explicitly: the reading order + which file is the source of truth for which fields. No "it will figure it out".
- The provenance of the item list (the report or document the list is taken from) - so completeness can be cross-checked.
- The provisional is marked: an item rests on a draft decision - say so, do not present it as a fact.
- Scope isolation in technical terms (what is read-only, do not copy tokens).
- An entry point for continuation across days / by another lead.
-->

## Versions / environment

<API versions, environment>

## Data sources (reading order)

1. <file - why read it>
2. <file - the source of truth for which fields>

<The provenance of the item list: the report or document the list is taken from (+ lines), where completeness is cross-checked.>

## Specification by item

### T1 - <name>
- Request/steps: <endpoint, method, fields>
- Expected: <what we count as success>
- How we verify: <what we will do to make sure; expands the part 1 checklist item with this label>
- Field source: <the application's documentation (`docs/<app>/`) or a report>.

## What we do not touch (technically)

- <read-only files, tokens, production>

## Facts log - requirements for the result

The log in `reports/` is the document by which the next step is taken. It must be self-contained:
- **One item = one fact**, by label. Do not pile things together.
- **A verdict for each item:** confirmed / works differently (how exactly) / not verified (why).
- **The fact concretely, without clutter:** what the system actually does + the minimally necessary evidence. Do not paste raw dumps.
- **Mark the unverified explicitly**, with a reason - no silent gaps.
- **Consequence** (if any): what the fact affects downstream; if it changes a decision - move it to `<project>/DECISIONS.md`.
- **Reads on its own:** the next step is clear without restarting the work and without someone else's context.

## Acceptance (for the Tech Lead)

- **The work is not accepted until all the "How we will know it is done" items (part 1) are met.** If any item is unmet or marked "not verified" without justification - the work is returned to the developer for revision, and the contract is not closed. An item "not verified, because..." with a justification is not accepted automatically: the Tech Lead takes it to the user, and the user decides - accept it as is, verify it differently, or return it for revision. Otherwise "not verified - no access" becomes a way to close the contract without verifying anything.
- **If the result requires user actions** (deploy, manual steps on the server, manual configuration outside the code) - the developer prepares a separate instruction document in `DEPLOY.md` format (sample: `team/deploy-template.md`; result - `team/missions/<NNN>_<name>/DEPLOY.md`): self-contained, in plain language - what to upload/run, the expected output, rollback. Without it, work with manual steps is not accepted.

## State and entry point

- **Status:** <date, draft/approved/closed, what is already done>
- **On return, start with:** <first step>
- **Order / dependencies:** <sequence of items>
- **Facts log:** <path to reports/, append not overwrite; requirements - see the section above>

</details>

---

Statuses: `draft` - a draft, work not started; `approved` - the user has approved the contract, work in progress; `closed` - the result is accepted, the mission is closed (set by the Tech Lead at the closure step, `team/workflow.md`).

```yaml
status: draft
approved_by: none
approved_at: none
closed_at: none
```
