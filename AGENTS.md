# Agent Runtime Rules (Shared)

Last updated: [Codex - 2026-01-16]

Purpose: concise onboarding for AI agents; details live in `docs/agent-instructions/`.

Environment: Cursor (AI editor), not VS Code. MCP config: `.cursor/mcp.json`.

## Start Here
- `docs/agent-instructions/README.md`
- `docs/agent-instructions/reference/REPOSITORY_DOCUMENT_INDEX.md`
- `docs/execution/DEVELOPMENT_ROADMAP.md`
- `docs/playtesting/HPV_GUIDE.md`
- `docs/playtesting/PLAYTESTING_ROADMAP.md`

## Repo Layout (High Level)
- `game/` gameplay scenes, scripts, resources
- `docs/` project documentation
- `tests/` automated tests
- `addons/` third-party Godot plugins

## MCP + Godot
- Use `mcp__godot__*` tools for playtesting and inspection.
- If MCP is unavailable, follow `docs/agent-instructions/setup-guides/mcp-setup.md`.
- If input simulation times out, it may help to check whether the debugger is paused and resume.

## Testing Commands (Headless)
- Baseline: `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd`
- Smoke: `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --scene res://tests/smoke_test.tscn --quit-after 30`
- Phase 3: `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --script tests/phase3_scene_load_runner.gd`

## Playtesting (Headed HPV)
- Run the project in Godot, then use MCP input and runtime inspection to validate UX.

## Code Conventions (Lightweight)
- Prefer existing patterns in nearby files.
- GDScript: `snake_case` for vars/functions, `PascalCase` for nodes/scenes, `UPPER_SNAKE` for constants.

## Repo Etiquette
- Prefer small, focused commits when asked; avoid history rewrites unless requested.
- Branch names: short and descriptive; if unsure, ask.
- Commit messages: use `git-best-practices` skill when asked.
- Local hook: `.githooks/post-commit` can auto-commit Godot `.uid` files. Enable via `git config core.hooksPath .githooks`.
- If the hook is off, stage `.uid` files with your change set.

## Avoid Touching Unless Asked
- `.godot/`, `.venv/`, `archive/`, `.cursor/`, `.claude/roles/`, `docs/REPOSITORY_STRUCTURE_CATALOG.md`

## Edit Signoff
- Add `[ModelName - YYYY-MM-DD]` at the end of an editing session.

Edit Signoff: [Codex - 2026-01-16]
