# Tool: the project linter

A linter is a program that, without running the code, checks it against the project's rules: the code canon (`PATTERNS.md`), the security rules (`SECURITY.md`) and the architecture. This file is instructions on how to create a linter for your project: there is no code in it, because the linter is written on the project's stack and from its rules. Read by the Tech Lead (decides whether a linter is needed and when to build it) and the Developer (builds it per the mission assignment).

## The main thing

Three things without which a linter does more harm than good:

1. **The linter checks form, not meaning.** A clean linter does not mean correct code: the logic, the data model, "one job per module" - the machine does not see these. The Checker and the Tech Lead remain - the linter takes the mechanical part off them, so that attention goes to meaning.
2. **Every check is proven by a "bad / good example" pair.** Without this a check can formally pass and catch nothing - or catch a violation by an accidental sign. An unverified check gives false reassurance, and that is worse than not having it.
3. **Checks are taken from the project's rules, not invented.** Every check has a source - an item of `PATTERNS.md`, `SECURITY.md` or the architecture. No rule - no check: otherwise the linter starts demanding things the team did not agree on.

## What it is and why

Rules in documents rely on discipline: the Developer checks against them before coding, the Checker - after. The more rules and code, the more often something slips through, and checking the same thing by hand in every mission eats up the agents' context. The linter does the machine part itself and the same way every time: a violation that can be found mechanically does not reach the Checker.

The linter is a development tool, not part of the application: it does not go to the server and is run manually on the developer's machine.

## Levels

Every finding has one of three levels. Why three and not "error / not an error": some rules the machine checks fully, and some it only suspects, and they must not be mixed - either the linter blocks correct code or lets incorrect code through.

- **FAIL** - the rule is checked by the machine fully, the violation is unambiguous. Code with a FAIL is not accepted.
- **WARN** - a suspicion: the machine sees a sign, but whether it is a violation or not is decided by meaning. Every WARN is reviewed by the Checker (intended / a problem), the decision is made by the Tech Lead.
- **Info** - information without an assessment (for example, what from the architecture has not been built yet).

If a FAIL-level check cannot verify statically in a specific place (the value comes from a variable, the call name is computed), it does not stay silent but downgrades the finding to WARN with the note "could not verify". Why: silence here looks like "clean", and the violation goes unnoticed.

## Where the checks come from and when to build

The sources of the checks are `PATTERNS.md`, `SECURITY.md` and the project's architecture. A rule gets into the linter if it can be checked by the text of the code: a name, a file location, a forbidden call, a mandatory option. A rule about meaning stays with the Checker and the Reviewer. Checks of comments (mission numbers, absolute paths) are easily caught by a machine - they are worth including; the source is the Developer's and the Reviewer's role rules about comments.

That is why the linter is built after these documents: without them there is nothing to check against, and checks written before the rules lock in accidental decisions. When exactly to build it - the Tech Lead decides per project: for example, as the first item of the development plan, so as to accept all the following items with it, or later, when the rules have settled. The rules change - the linter is extended by the same mission as the rule, otherwise it checks against outdated ones.

## Where it lives

With the application it checks, by default `<project>/dev/<app>/tests/lint/`. Why with the application: the architecture rules and the layout are different for each application, and one common place would mix them. The default path is the same for all applications of the project, while each application has its own linter: this way the roles find the linter of any application without a hint. If the project needs another place - the Tech Lead records it in `PATTERNS.md` or in the architecture and specifies it in the assignment.

## In what language

In the language of the project's stack. Why: the project's developer can read and extend it, it runs where the code is checked, and it can check itself by the same rules.

Ready-made linters of the stack are used if they cover a rule: a standard check of syntax, style, types is already written and debugged, there is no point rewriting it. Own checks are added where the rule is project-specific: the folder layout from the architecture, a ban on calling an external API outside its module, a mandatory timeout on an outgoing request. The ready-made linter is called from inside your own, so that the team has one run command and one report.

## How it is built

The structure does not depend on the project - only the checks change:

- **Entry point** - one run command: collect the application's files, run all the checks, produce the output and the exit code.
- **The list of checks** in one place: identifier, level, where the check lives. A check is turned on and off by an entry in the list, not by editing code.
- **A uniform check input and output**: a check receives the root and the list of files, returns findings in one format - check identifier, level, file, line, message.
- **Two outputs.** The screen - short: all FAILs line by line, WARN and info only as counters, the total "FAIL n / WARN n / info n" and the path to the full report. The screen is read by the Tech Lead, and it should not grow with the number of warnings. The full report - a file with all findings line by line, the Checker goes through it. The report is the result of a run, it is not needed in git.
- **Exit code** non-zero on any FAIL and on a run error, so that a failure cannot be taken for a clean run.
- **The linter never opens files with secrets** - not even to check their contents. A finding with a secret would get into the report, and the report is read by agents. Which files are secret (a name pattern) is set in one place of the linter, for example in its config, by the project's data - determined by the Tech Lead with the user, per `SECURITY.md`. The rules about such a file are checked without reading it: for example (not only), that it does not get into git and that there is a template without values next to it. That is why secrets are kept in a separate file, not together with the settings: the settings file, including the security settings, the linter reads and checks in full, while a mixed file would have to be skipped together with the settings.
- **The linter's document** (a README next to it): how to run it and a table of checks - identifier, level, what it catches, what it does NOT catch, source. The "what it does NOT catch" column honestly shows where the machine ends and the Checker begins.

Example (hypothetical, not from a real project): the `PATTERNS.md` rule "HTTP requests - only through the client module" gives a FAIL-level check "HTTP function call outside the client folder"; the source in the table - the `PATTERNS.md` item number; what it does NOT catch - a request through a third-party library the check does not know.

## Self-check on "bad / good example" pairs

For every check - a pair of mini-examples of the application:

- **bad** - realistic code with exactly the violation the check catches, and a file of expected findings: which exact findings (level, check, file, line) must appear;
- **good** - the same code without the violation; there must be no findings of this check on it.

A separate self-check script runs all the pairs and compares the result with the expected one exactly, including the level. It also verifies completeness: the number of checks in the list = in the README table = the number of pairs. Why so strict: a check that catches the bad example by a side sign (by the file name, by the neighboring line) will stay silent on real code; an exact match and a good example "the same code without the violation" cut this off.

The bad examples break the rules on purpose, so they do not get into the regular linter run or into the project's tests: the examples folder is excluded from the run over the application and from the linter's run over its own code, the project's tests do not include it. Otherwise every run would give FAILs on the training code, and the real findings would get lost among them.

Two more things are useful: a run of all checks over all examples without failures of the linter itself, and a run of the linter over its own code - the tool cannot demand what it does not comply with itself (the application layout rules are skipped explicitly here, with a list in the output).

The order for adding a check: check -> entry in the list -> pair of examples with expected findings -> row in the README table -> the self-check passes in full.

## How the linter is built into the team's work

Applies if the application has a linter:

- **Developer** runs the linter before the report. FAIL = 0: every FAIL is fixed before the report. Puts the screen summary into the report, for each WARN left - one line "why it is so".
- **Checker** runs the linter themselves, without relying on the Developer's summary, opens the full report and for each WARN writes a verdict with a reason: intended or a problem. Any FAIL is a high-severity finding.
- **Tech Lead** reads the screen summary and the Checker's outcome, decides on disputed WARNs. In the assignment to the Developer and the Checker specifies the field "Linter: path / none", so that the agent does not have to search.

The linter itself is built by a regular mission: a contract (which rules become checks, which levels), the Developer writes, the Checker checks, including that each "bad / good" pair is honest and not tailored to the check.
