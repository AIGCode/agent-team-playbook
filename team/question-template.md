# Template: a question to the user

The Tech Lead reads this file when a decision from the user is needed on how the application is built: the answer does not follow unambiguously from the architecture and from what was verified live, several options fit. Especially in complex projects with a large volume of data: there a question easily drowns in context, and the user answers the wrong question. A mission's questions are collected in one file `team/missions/<NNN>_<name>/reports/questions.md`, one section per question.

## The main thing

The user works only with the question: they do not reread the documentation and the context. So the question is self-contained - everything needed for the choice is in the question itself. The tone is telling a friend: the friend knows the project, but was not in this conversation.

Technical details are allowed when it cannot be explained without them (a friend sometimes cannot be told without them either). But in the options the details come from the option itself - what will happen in practice if it is chosen - not from the context that was read. Retelling the documentation inside an option is a sign that the option is described from the wrong side.

No file names, finding numbers, area labels or internal terms without an explanation.

## Five parts

~~~~markdown
## Question N. <title - what the decision is about, in human words>

### The gist

<The situation in the life of the application, as for a friend: what is happening, where the ambiguity is, why it matters (what will break or what we risk).>
<If two places in the application description contradict each other - say which ones, in your own words.>
<What is already decided by other answers - in one sentence, so it is not decided again.>
<What the following questions depend on - if they do: "question M depends on the answer - about such-and-such".>

### Terms

- **<word>** - <what it is in the life of the application, not in the documents>.
<Every word without which the question cannot be understood. Two similar words (for example, two states) - explain the difference.>

### Data chain

```
<Event>
   ↓
<Who receives it, what it does, where it writes>
   ↓
◆ FORK: <at which point the choice is>
   ↓
<what comes next>
```
<A parallel chain, if it affects the choice - as a separate block with an explanation. Two forks - ◆ FORK 1, ◆ FORK 2.>

### Options

**A. <the gist of the option in one sentence>.** <What the application does with this choice.>
- In practice: <what the user will see, how their work will change>.
- Risk: <what can go wrong - a concrete scenario, not "may be more complicated">.
- Cost / Condition: <what will be needed; under which condition the option works>.

**B. ...**

**C. ...** <If an option is in practice the same as another one - say so and remove it from the choice explicitly.>

**The team proposes <X>:** <why - from the application's main goal and its rules, in one or two sentences.>

### Question

<One line that can be answered by choosing an option.>
<Two forks - two choices in one line ("A, B or C? And after that: 1 or 2?").>
<Short accompanying questions - only if the choice is not safe without an answer; each one with why it matters.>
~~~~

## Rules

- **Options - 2-3**, each with: "in practice", risk, cost or condition. The risk is a concrete scenario with a consequence ("the guitar gets bought while it is on its way to us"), not an assessment.
- **The team's recommendation is mandatory** and rests on the application's main goal and its rules, not on development convenience.
- **The unknown is marked honestly:** "not verified live, we will verify it during the build" - and say whether it affects the choice.
- **Dependencies between questions:** a question that others depend on is asked first; in a dependent one - what is already decided.

## Retelling check

Before sending to the user, the question is retold by a fresh agent that sees only this question's section - without the architecture, the correspondence and earlier retellings.

- The task for the agent - following the sample below ("Retelling task"): retell what the question is about, how the options differ, what the team proposes; name everything that can be understood in two ways. The report - via `SendMessage`.
- The retelling is wrong in substance → the question is rewritten and goes to a fresh agent (not the same one: it has seen the old version).
- The retelling is correct, the remarks are wording clarifications → the Tech Lead makes them itself and sends the question to the user.
- To the user - a link to the file and briefly: what the question is about and the options, one line each.

### Retelling task

~~~~markdown
# Task: retelling a question to the user (mission <NNN>)

## Why
The questions in `questions.md` go to the project owner, who makes the decision without reading technical documents. If a question is understandable only to someone who knows the application's internals, the owner will answer the wrong question. You are the check: an outsider who sees only the text of the question.

## What to do
Read `team/missions/<NNN>_<name>/reports/questions.md` (only the section of the question whose number the Tech Lead names in the message) and retell it in your own words.

You read only this file. You do not open the architecture, other reports, the code or the project documents: your value is that you have not seen them.

## What goes into the retelling
1. What the question is about - 2-3 sentences: what the situation is, where the ambiguity is.
2. How the options differ - one line per option: what will happen in practice and what we risk.
3. What the team proposes and why - one line.
4. What remained unclear or ambiguous: a term without an explanation, a chain step that does not add up, an option that can be understood in two ways. Nothing - write so.

Do not judge which option is better - only the retelling and the places where the text can be misunderstood.

## Result format
Send the report as text via `SendMessage` (to: "team-lead") - plain text does not reach the Tech Lead. If you are allowed to write files, append the same text to `team/missions/<NNN>_<name>/reports/retell.md` as a section "Question N" (without overwriting earlier sections).

```
## Question N - retelling
1. About: ...
2. Options: A - ...; B - ...; C - ...
3. The team proposes: ...
4. Unclear: ...

## Verdict
PASS (everything is clear) | NEEDS_REVIEW (there are unclear places - item 4)
```
~~~~

## The user's answer

- The user may propose their own option. The Tech Lead checks it against the application's rules: what fits - accepts; what does not fit - explains with a concrete scenario how it will break, and proposes how to get the same thing in another way.
- The answer is recorded in the "Answers from the user" section of the same file: the date, the question, an exact description of the accepted decision with all clarifications from the discussion, and what remained open.
- The answer is not put into the architecture right away: first the Architect proposes how to integrate it, the user approves, then the edits.
