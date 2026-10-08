# Architecture canon

How to write and edit the application's architecture (`<project>/docs/<app>/ARCHITECTURE.md` and its extensions `ARCH_*.md`). The counterpart of the project's `PATTERNS.md` (the code canon). Needed if the project has an architecture.

- The **Architect** checks against the canon before an edit. The **Checker** checks every architecture edit against it; a deviation from the canon is `[HIGH]`, the edit is not accepted.
- Maintained by the Tech Lead - the only writer of the canon; a new rule is added with the user's consent, like any edit to `team/`. A situation is not in the canon - propose it in the report, do not silently make something up.

---

## 1. One rule - one place

**1.1** A rule is any statement about what the application or a part of it does: an action, an order, a condition, a reaction, a prohibition, and also a technical fact (an endpoint, a field, a key, a frequency, a "requires verification" mark).

**1.2** Each rule is written in the architecture exactly once - in its own place. A repeat (the same rule in another place, including in other words or partially) is a violation of the architecture.

**1.3** A rule's place is the section of the architecture (or the extension `ARCH_*.md`) the rule belongs to by topic. A block (module, component) - in the section of its topic or of the one that controls it. The application's general principles - in the main `ARCHITECTURE.md` (if it is split by the 200-line rule - in its part about principles).

**1.4** In the other places where the reader needs the rule - only a reference of exactly this form: `(see rule: <file>.md, "<section or block name>")`; within the same file - `(see rule: "<section or block name>")`.

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

## 4. Accepting an architecture edit

**4.1** What is checked is not only "no contradictions" but also "no new repeats": each added rule - in one place.

**4.2** The edit is checked by someone other than the one who made it. It is accepted by an artifact (a text sample, a script output), not by a "done" report.
