# DRAFT - Contract: <name>

> # DRAFT - NOT APPROVED
> <If the work rests on a provisional basis (draft architecture, decisions not yet accepted) - say so explicitly here: what to treat as a hypothesis rather than a fact. If the basis is solid - remove this line.>

> **The contract has two parts.**
> **PART 1 - for the user:** what we are doing, why, and how we verify it - in plain language. Self-contained: to understand the scope, there is no need to open other documents.
> **PART 2 - for the executor (AI):** the exact steps, endpoints, fields, sources - how exactly to do it and where to take the data from.
> The link between the parts is the item label (T1, T2... / E1, E2...): one label appears in both parts.

<!--
HOW TO FILL IN (a reminder; in the finished contract delete this or keep it collapsed):

PART 1 - FOR THE USER. The basis is understanding, not mechanics.
- Plain human language. The user does NOT have to know technical terms and is not obliged to want to.
- NO code snippets, commands, field names, endpoints, internal numbers, or "go read file X" - all of that goes in part 2.
- A technical fragment (a field name, a parameter) in part 1 is allowed ONLY as an anchor, when it has to be relied on, and ONLY with an immediate translation into human language. The user must understand this term 100%. A raw term without an explanation is forbidden.
- Self-containment: if a fact from another document is needed - retell it here briefly, do not refer out.
- Show a result only when it is tied to a function/feature (not "the API returned X", but "we can publish a listing").
- Each item: WHAT / WHY / HOW WE VERIFY. The "how" is in plain words (what we will do to make sure), not with which request. A table is better.
- Honest, without smoothing over the risks and without nudging toward agreement.
- Skimmable: short, tables. If it is not clear on the first read - rewrite it, do not append.

PART 2 - FOR THE EXECUTOR (AI). Precision over readability.
- Endpoints, methods, exact field names, versions - verbatim.
- Sources explicitly: the reading order + which file is the source of truth for which fields. No "it will figure it out".
- The provenance of the item list (the report or document the list is taken from) - so completeness can be cross-checked.
- The provisional is marked: an item rests on a draft decision - say so, do not present it as a fact.
- Scope isolation in technical terms (what is read-only, do not copy tokens).
- An entry point for continuation across days / by another lead.

BRIDGE: one label in both parts. The dependency is one-way - part 1 is clear without part 2; part 2 expands part 1, not the other way around.
-->

---

# PART 1 - FOR THE USER

## What this is and why

<1-3 paragraphs in plain language: what the work is, why it is needed, what the output will be. No tech.>

## What exactly we do, why, and how

<The full list of mission items. A table. The "how" is in human language.>

| Label | What we do | Why it is needed | How we verify / how we will know |
|---|---|---|---|
| T1 | <in human language> | <why> | <what we will do to make sure> |

## Environment / conditions (if any)

<What the user needs to know about the environment: where we work, what we touch in production, what to prepare in advance. In plain language.>

## What is NOT included

- <what is deliberately outside this mission and where it goes (another mission / stage / decided separately)>

## How we will know it is done

- [ ] <a testable statement in plain language, with a reference to a label>

## Risks

- <what can go wrong and how we roll back - honestly, in human language>

---

# PART 2 - FOR THE EXECUTOR (AI)

> The exact specification. The labels match part 1.

## Versions / environment

<API versions, environment>

## Data sources (reading order)

1. <file - why read it>
2. <file - the source of truth for which fields>

<The provenance of the item list: the report or document the list is taken from (+ rows), where completeness is cross-checked.>

## Specification by item

### T1 - <name>
- Request/steps: <endpoint, method, fields>
- Expected: <what we count as success>
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

---

Statuses: `draft` - a draft, work not started; `approved` - the user has approved the contract, work in progress; `closed` - the result is accepted, the mission is closed (set by the Tech Lead at the closure step, `team/workflow.md`).

```yaml
status: draft
approved_by: none
approved_at: none
closed_at: none
```
