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
If MCP or the debugger is not running, ask Sam to start it rather than
spending long on troubleshooting.

## MiniMax MCP
- Skill docs: `.claude/skills/minimax-mcp/SKILL.md`
- Terminal quick start (direct API via scripts):
  - `cd .claude/skills/minimax-mcp`
  - `./scripts/web-search.sh "query"`
  - `./scripts/analyze-image.sh "prompt" "image.png"`
- MCP server (desktop): see `SKILL.md` for env vars and `uvx minimax-coding-plan-mcp -y`
- Codex wrapper tools:
  - `mcp__MiniMax-Wrapper__coding_plan_general`
  - `mcp__MiniMax-Wrapper__coding_plan_execute`
- **Delegation guidance**: Prefer MiniMax for web search, image analysis, research tasks
- **Trusted domains** (auto-approved): docs.anthropic.com, platform.claude.com, docs.cursor.com, cursor.com, cookbook.openai.com, godotengine.org, api.minimax.io
- **Other domains**: Ask permission before searching outside trusted list
- Direct API (extension): Use Bash tool with curl (see SKILL.md), saves 85-90% tokens
- **Decision trigger**: Before using Grep/Glob for research, ask: "Would MiniMax handle this better?"

## Testing
Headless: `.\Godot*\Godot*.exe --headless --script tests/run_tests.gd`
Headed (HPV): Launch Godot, use MCP for input/inspection. Teleport-assisted HPV is the default unless a full walk is requested.

## Conventions
- Follow patterns in nearby files
- GDScript: snake_case (vars/functions), PascalCase (nodes), UPPER_SNAKE (constants)

## Repo Rules
- When asked to commit, prefer scoped commits; avoid history rewrites unless asked
- When pausing or ending a work block, it is usually better to commit changes
  rather than leave them pending; ask if unsure
- Avoid creating or switching branches unless Sam explicitly asks; work in the
  current branch instead
- Ask before touching: .godot/, .venv/, archive/, .cursor/, .claude/roles/
- .uid files: use git hook (git config core.hooksPath .githooks) or stage manually
- Ask before creating new .md files; editing existing .md files is OK
- Prefer brief clarifying questions up front, then a longer autonomous pass
- Default to working within the current structure; flag major structural changes

[Codex - 2026-01-17]
