# Claude Code settings

Everything that is set up by hand in Claude Code: where the framework and the skills live, `settings.json`, installing hooks. The framework's general documents hold the meaning of the rule and refer here.

## Installing the framework and skills

Put the `team-playbook/` folder in `~/.claude/team-playbook/`. Copy the skills from `skills/` into `~/.claude/skills/`, one folder per skill.

## Agent team

`~/.claude/settings.json` must contain:

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

## Hooks

### How to install

1. Copy the script from `team/hooks/scripts/` into `<project>/.claude/hooks/`.
2. Add the hookup to `<project>/.claude/settings.json`, the `hooks` section - a ready fragment is below, in the hook's section. If the `hooks` section already exists, the fragment is merged into it: the new entries are added to the arrays of the same events, the existing ones are not touched.
3. Restart the Claude Code session: the hook settings are read at startup.
4. Check that it fires following the "How to check" step in the hook's file.

The scripts are run via `bash` and use `node`: both must be available on the command line (on Windows, `bash` - from Git Bash). The script path in the hookup is set via `$CLAUDE_PROJECT_DIR` - a Claude Code variable with the project root, so that the hook finds the script from any folder of the session.

### `initiative.md`

Copy both scripts from `team/hooks/scripts/` into `<project>/.claude/hooks/` and add to `<project>/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          { "type": "command", "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/initiative_session_reminder.sh\"" }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          { "type": "command", "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/initiative_report.sh\"" }
        ]
      }
    ]
  }
}
```

### `task-review.md`

Copy both scripts from `team/hooks/scripts/` into `<project>/.claude/hooks/` and add to `<project>/.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          { "type": "command", "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/task_review_reminder.sh\"" }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Agent|SendMessage",
        "hooks": [
          { "type": "command", "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/task_review_gate.sh\"" }
        ]
      }
    ]
  }
}
```

## Auto-compact

It is set up in the project, like the hooks - in `<project>/.claude/settings.json`:

```json
{ "env": { "DISABLE_AUTO_COMPACT": "1" } }
```

If the `env` section already exists, the line is added to it. The setting is read at session startup.
