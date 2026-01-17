# Kilo Code Project Guidance

Last updated: [Codex - 2026-01-16]

Purpose: short, project-specific guidance for Kilo Code modes. Detailed
documentation lives in `docs/agent-instructions/`.

Environment: Cursor (AI editor), not VS Code. MCP config: `.cursor/mcp.json`.

## Start Here
- `docs/agent-instructions/README.md`
- `docs/agent-instructions/reference/REPOSITORY_DOCUMENT_INDEX.md`
- `docs/execution/DEVELOPMENT_ROADMAP.md`
- `docs/playtesting/HPV_GUIDE.md`
- `docs/playtesting/PLAYTESTING_ROADMAP.md`

## MCP + Godot
- Use `mcp__godot__*` tools for playtesting and inspection.
- If MCP is unavailable, follow `docs/agent-instructions/setup-guides/mcp-setup.md`.
- If input simulation times out, check whether the debugger is paused and resume.

## Headless Test Commands
- Baseline: `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd`
- Smoke: `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --scene res://tests/smoke_test.tscn --quit-after 30`
- Phase 3: `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --script tests/phase3_scene_load_runner.gd`

## Conventions (Lightweight)
- Prefer existing patterns in nearby files.
- GDScript: `snake_case` for vars/functions, `PascalCase` for nodes/scenes,
  `UPPER_SNAKE` for constants.

## Repo Etiquette
- When asked to commit, prefer scoped commits; avoid history rewrites unless asked.
- When pausing or ending a work block, it is usually better to commit changes
  rather than leave them pending; ask if unsure.
- Commit messages: use `git-best-practices` skill when requested.
- Local hook: `.githooks/post-commit` can auto-commit Godot `.uid` files.

## Workflow Preferences
- Ask brief clarifying questions when a new task is assigned; then run a longer
  autonomous block once the initial Q&A is complete.
- Ask before creating new `.md` files; editing existing `.md` files is OK.
- If MCP or the debugger is not running, ask Sam to start it rather than
  spending long on troubleshooting.
- For playtesting fixes, prefer adjustments that fit the current structure and
  avoid large structural changes unless asked.

## Avoid Touching Unless Asked
- `.godot/`, `.venv/`, `archive/`, `.cursor/`, `.claude/roles/`,
  `docs/REPOSITORY_STRUCTURE_CATALOG.md`

## Edit Signoff
- Add `[ModelName - YYYY-MM-DD]` at the end of an editing session.

Edit Signoff: [Codex - 2026-01-16]
