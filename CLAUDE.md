# Agent Onboarding

Environment: Cursor (not VS Code) | MCP: `.cursor/mcp.json` | Godot 4.5.1

## Quick Start
- Read: docs/agent-instructions/AGENTS_README.md
- Testing: docs/playtesting/HPV_GUIDE.md
- Roadmap: docs/execution/DEVELOPMENT_ROADMAP.md

## Repo Layout
game/ → gameplay code | docs/ → documentation | tests/ → test suites | addons/ → plugins

## MCP Tools
Use `mcp__godot__*` for playtesting. If unavailable: docs/agent-instructions/setup-guides/mcp-setup.md

## Testing
Headless: `.\Godot*\Godot*.exe --headless --script tests/run_tests.gd`
Headed (HPV): Launch Godot, use MCP for input/inspection

## Conventions
- Follow patterns in nearby files
- GDScript: snake_case (vars/functions), PascalCase (nodes), UPPER_SNAKE (constants)

## Repo Rules
- Small focused commits
- Ask before touching: .godot/, .venv/, archive/, .cursor/, .claude/roles/
- .uid files: use git hook (git config core.hooksPath .githooks) or stage manually

[Sonnet 4.5 - 2026-01-16]