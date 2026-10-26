#!/usr/bin/env bash
# SessionStart (startup, resume, clear, compact): tell the chat up front about the initiative block,
# so it writes the block itself and the Stop hook only catches misses.

echo '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"You have the \"My initiative\" hook: at the end of every final answer - the line ---, then on a separate line **My initiative:** and a numbered list of what you did or decided yourself without agreeing with the user (what - why - how to roll it back), or **My initiative:** none. An item that changes the terms of the contract begins with the marker **Contract:**, the others - without the marker. Small things inside the contract (a number, a path, a typo, the choice of method in the same places) do not go here. This is a record, not a ban. If the block is missing after edits to project files, the Stop hook will ask you to add it."}}'
