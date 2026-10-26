# Architecture canon

How to write and edit the application's architecture (`<project>/docs/<app>/ARCHITECTURE.md` and its extensions `ARCH_*.md`). The counterpart of the project's `PATTERNS.md` (the code canon). Needed if the project has an architecture.

- The **Architect** checks against the canon before an edit. The **Checker** checks every architecture edit against it; a deviation from the canon is `[HIGH]`, the edit is not accepted.
- Maintained by the Tech Lead - the only writer of the canon; a new rule is added with the user's consent, like any edit to `team/`. A situation is not in the canon - propose it in the report, do not silently make something up.

---

## 1. One rule - one place

**1.1** A rule is any statement about what the application or a part of it does: an action, an order, a condition, a reaction, a prohibition, and also a technical fact (an endpoint, a field, a key, a frequency, a "requires verification" mark).

**1.2** Each rule is written in the architecture exactly once - in its own place. A repeat (the same rule in another place, including in other words or partially) is a violation of the architecture.

**1.3** A rule's place is the section of the architecture (or the extension `ARCH_*.md`) the rule belongs to by topic. A block (module, component) - in the section of its topic or of the one that controls it. The application's general principles - in the main `ARCHITECTURE.md` (if it is split by the 200-line rule - in its part about principles). Rules that change independently of each other (for example, the frequency, the content and the repeat of one message) are each written as their own item, not as one paragraph. Why: in a shared paragraph the rules catch on each other through caveats and brackets, and an edit of one touches the neighboring ones.

**1.4** In the other places where the reader needs the rule - only a reference of exactly this form: `(see rule: <file>.md, "<section or block name>")`; within the same file - `(see rule: "<section or block name>")`. A reference to the setup document (5.1) - only in the rule's place, of exactly this form: `(see setup: <path>, "<section>")`; the other places refer to the rule.

## 2. What is not a repeat

**2.1** A retelling of the technical part of the same section in plain language (for example, a "for the user" part to a service part).

**2.2** Navigation: a table of contents and an index of sections, a brief overview of cross-cutting topics, tables of links between sections (who controls whom, what depends on what, how it is launched), "Related sections" headers.

**2.3** A one-line purpose of a file in the file tree.

**2.4** The "for the user" part is written for a person: a repeat from another section in it is replaced with a link only if the sentence stays understandable without following the link. Otherwise the human text stays - it is not a repeat.

**2.5** Two complementary statements from different sides (for example, the list of events a module is subscribed to and the route of their handling) - not a repeat, if neither contains the other.

## 3. How to add and edit

**3.1** A new decision is added in the rule's place. Into other sections - only a reference, and only where the reader cannot do without it; in the "for the user" part - per 2.4.

**3.2** A repeat says more than the place (a nuance: a condition, an exception, a number) - that piece is moved to the rule's place, not left in the repeat.

**3.3** The "requires verification" mark and the source label go together with their fact: a fact without the mark reads as verified.

**3.4** The architecture describes how the application is built now, not how it got there: without decision dates, "was - became", a list of edits and their reasons. It is read by every executor before work: the history grows with every edit, and an old value next to a new one reads as current. The history - in git and the decision log (`DECISIONS.md`). The source label (3.3) and the date of acceptance or last update of the architecture are not history.

**3.5** A section recognized as tangled (a "restructure" finding, 4.3) is not supplemented or changed by an edit - neither by a rule, nor by a caveat, nor by a reference - until it has been rebuilt in the canon's form (1.3, sections 6-8). When a section has been recognized as tangled, the user decides on the spot (the Tech Lead passes the question to them), there are two ways out. The first, the priority one: rebuilding now. The second: the work goes on per the project's development plan (`PLAN.md` or `dev-plan/DEV_PLAN.md` extracted from it), and before each plan item that touches the section there is a mark with the section's name; the work does not go past the mark until the section is rebuilt. The marks are set by the Tech Lead - when the user has chosen the second way out, and before each item that touches the section and is added to the plan later. The places the edit goes to are checked against the plan's marks by the one who sets the task and by the executor - before the edit. Why: each edit into such a section adds a branch to a form that has already been decided to be taken apart, and the rebuilding gets more expensive; a mark in the plan stops the work before the edit, not at acceptance.

## 4. Accepting an architecture edit

**4.1** What is checked is not only "no contradictions" but also "no new repeats": each added rule - in one place.

**4.2** The edit is checked by someone other than the one who made it. It is accepted by an artifact (a text sample, a script output), not by a "done" report.

**4.3** A tangled place is a part of the architecture where the order and the branches are written so that they cannot be checked as a whole. The section the edit touched is read by the Checker in full, not only the edit, if it has a sign of tangling, for example: a long section (guideline - from 300 words) without a numbered order; a reference to a place in the text or a caveat of another branch ("as above", "below", "as in the branch", "unlike", "except for the branch"); branches in prose - many "→", "except", "otherwise" without numbers. The verdict - the canon's form (1.3, sections 6-8: "intended this way" with an explanation per a canon item) or a "restructure" finding: the edit is not accepted, further - per 3.5. Why: tangling grows edit by edit, and the check of one edit does not see it.

## 5. The mechanism, not the installation values

**5.1** The architecture describes the mechanism that holds for any installation of the application (another server, client, environment). An installation value - what will be different for another installation (for example, the server's addresses and paths, the names of fields and categories in an external system, rates, the backup method) - lives in the application's setup document in `docs/<app>/` (the project chooses the name), not in the architecture. Why: on a move or a second installation, the values change, not the mechanism, and one setup document is edited.

**5.2** A rule that holds only with the current installation's value is a violation of the architecture: first the mechanism, the value is its setting. A new installation detail is written into the setup document; into the architecture - only the change of the mechanism it requires. A rule without which the mechanism is unsafe (protection) is part of the mechanism: not a line of the setup, and a setting does not switch it off. Why: a rule written through the current value silently breaks where the value is different, and protection in the setup depends on how the setup was filled in.

**5.3** A parameter that the operator changes without editing the logic (for example, a period, a frequency, a pause, a threshold, a limit, an address) is named by the architecture as a key and the settings file where it lives; the rule that needs it refers to the key and does not repeat the number. Each key - in one file; the list of settings files and their keys - in one place of the architecture (1.3); a new settings file - only by an architecture edit. The value for the current installation - per 5.1; how the code reads the key - the project's `PATTERNS.md` (if it exists). Why: a number written in several places diverges at the first change.

## 6. Blocks and the links between them

The section is the basic structure of the application and applies to any application whose architecture is written per the canon: closed blocks (6.1), links between them only through the controlling component, shared code and shared values - once in the shared layer (6.2). Why: a small closed block with one job is written and edited reliably by AI (size - 6.1), and the application is changed block by block, without touching the others.

**6.1** A block does one job and is visible from outside only by its input and output: inside, it can be changed as long as the input and output stay the same. The size of a block's code file - per the Developer role's norm (`team/roles/developer.md`, "Code"); blocks are not merged for the sake of the norm - the number of blocks is set by the work, not by the length. A new capability is a new block, not an addition to an existing one. It does not fit into any block or diverges from the architecture - stop and a question to the Tech Lead, not into a place that looks suitable. Why: a block with two jobs is edited for the sake of one and breaks the other, and logic glued on wherever it happened to fit spreads across the application.

**6.2** Blocks do not call each other directly: the output of one is passed into the input of another by the controlling component (the introduction of section 7). Shared technical code (for example, external API clients, the database, the log) - in the shared layer without application rules; both the blocks and the controller use it, and this is not a call of a block by a block. A value needed by several blocks is written once - in the shared layer or as a settings key (5.3); the blocks take it from there and do not keep their own copy. Why: when the links go only through the controller, an edit of a block does not drag the neighbors along, and a copy of a shared value diverges from it at the first change.

**6.3** A block's description - input, job, output. When the block is called, under what condition and what is done with its output - in the controller's stages (section 7) or in a shared procedure (7.3); the block's description does not refer to them. Why: a block with "for one caller it is this way, for another that way" starts knowing its callers, repeats their rules and is edited with every new one.

**6.4** Changing a block's input or output is changing its contract: first a question to the Tech Lead, then an edit of the block and of the controllers that call it; the neighboring blocks are not touched. Why: the controllers' rules rely on the block's output, and a silently changed output leaves the controller without what it decides by.

## 7. A process by stages

The controlling component keeps the "what after what" order: it calls blocks, passes the output of one into the input of another and does not do the blocks' work itself. The section applies if the controller carries a unit of work (for example, a request, a record, a file) through several blocks and it has more than one outcome. A process with one outcome - in one line, without a list.

**7.1** What the controller does with one unit of work is written as a numbered list of stages in the order of execution; above the list - a line: the launch, the selection and order of units, the rule for all stages. A stage: condition (a block's output or a saved state) → action (a block call, a write, a reference to a rule) → what next: the next stage, "stop" (the unit is finished) or "→ stage N", only forward. Several outcomes of one stage - as a list "condition → action → what next" inside the stage, not as a caveat in a sentence (for example, "except when", "otherwise", "for one it is this way, for another that way"). The order of checks is written by stage numbers and nowhere else. Why: the order of checks is the logic of the process; in prose with caveats it is read differently, and a branch gets lost on an edit.

**7.2** A stage does not refer to the text of other stages and does not make caveats about them, for example: "as above", "below", "as in the branch", "unlike", "except for the branch", a "(stage N)" mark inside a stage. A piece needed by several stages is written once - as an item with a bold name after the stages; the stages refer to it per 1.4, the difference by stage - inside the item as a list "path → outcome → what next". A rule of another section in a stage - by a reference (1.4), a block's work - in the block's description, not in the stage. Why: a caveat in one stage changes the meaning of another, and only the one who reads the whole list sees it.

**7.3** A piece with branches that several controllers call (or a block and a controller) is a shared procedure: written once in the rule's place (1.3) as an item with a bold name, with the first line "Called by: <who, at which stage>", then the steps per 7.1-7.2. The difference by caller - inside a step as a list "caller → outcome → what next"; the outcome the caller reacts to as an error is named for each. Why: the "Called by" line shows whose branches an edit of the procedure touches.

**7.4** More than 15 stages in a process or steps in a procedure - it has grown too large: stop and a question to the Tech Lead, not a new stage; usually a part is moved out next to it - into a separate controller or procedure. Why: a long list is not held in the head as a whole, and an edit breaks a branch that is not visible.

**7.5** An edit of a process or a procedure is checked by the Checker against the whole list, even without a sign of tangling (4.3): each stage - per 7.1-7.2, the length - per 7.4; a new condition - as a stage in its place or as an item (7.1-7.2); a table "branch before the edit → stage after the edit (quote)" over all branches: none is lost and each fires in the same cases, a changed one - with a justification; if the application has a list of chains (`team/roles/techlead.md`, "End-to-end chain run"), the chains through this process are run through per the new text. Why: an edit of one branch imperceptibly changes the neighboring ones, and a check of the place of the edit does not see it.

## 8. A block's decision rule

**8.1** A block's decision rule (pure "input → output" logic with several cases) is written as a table: one row - one case (all input conditions) → output. If the order matters, the order of checking is the order of the rows, and this is said in one sentence above the table. A row does not refer to another row ("as X"): the outcome in each row is complete. Exactly one row fits each combination of input, or there is an "everything else" row. Why: in prose a missed combination is not visible, and the developer makes up the output on their own; a table is checked by going through the rows.
