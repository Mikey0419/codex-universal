# ShellScout (Ruby terminal utility blueprint)

This example gives you a practical starting point for a Ruby-based shell utility that combines:

- **Thor** for command routing.
- **TTY::Prompt** for interactive terminal UX.
- **Pastel** for colorized output.
- **HTTParty** for API calls.
- **Dotenv** for local environment variables.
- **terminal-table** for readable tabular output.

## Why this is useful

ShellScout bundles common CLI utility patterns:

1. Pulling structured data from web APIs (`weather`).
2. Running interactive workflows (`focus`).
3. Verifying shell/env setup (`check`).

You can extend it into a personal daily assistant, ops helper, dev-experience CLI, or team onboarding tool.

## Quick start

```bash
cd examples/ruby-shell-utility
bundle install
bin/shell_scout help
```

## Example commands

```bash
bin/shell_scout weather "New York"
bin/shell_scout focus -m 1
bin/shell_scout check openai
```

## Design notes

- `weather` uses Open-Meteo because it does not require an API key for basic current conditions.
- `check` expects keys in the pattern `<NAME>_API_KEY`.
- `focus` uses `sleep` as a portable timer baseline. If you want notifications, integrate with `terminal-notifier` (macOS), `notify-send` (Linux), or webhook calls.

## Suggested next upgrades

- Add a `tasks` command with local SQLite persistence (`sqlite3` gem + Sequel).
- Add structured logging (`logger` + JSON output option).
- Add config file support (`dry-configurable` or YAML).
- Package as a gem and expose executable globally.
