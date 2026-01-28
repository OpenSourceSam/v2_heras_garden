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

## Testing
Headless: `.\Godot*\Godot*.exe --headless --script tests/run_tests.gd`
Headed (HPV): Launch Godot, use MCP for input/inspection

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
- Creating new .md files: request permission during the 1A planning phase (longplan).
  If a new .md is created without prior approval, continue the work block and
  report it at the end for decision (delete/move/keep).
- Prefer brief clarifying questions up front, then a longer autonomous pass
- Default to working within the current structure; flag major structural changes

## Skill Inventory

### Superpowers Skills (Primary)
- `brainstorming` - Clarify and explore ideas
- `dispatching-parallel-agents` - Coordinate multiple subagents
- `executing-plans` - Execute development plans
- `receiving-code-review` - Process and apply code review feedback
- `requesting-code-review` - Request and manage code reviews
- `subagent-driven-development` - Develop using subagent patterns (NEW)
- `systematic-debugging` - Structured debugging workflows
- `test-driven-development` - TDD workflows
- `using-git-worktrees` - Git worktree management
- `using-superpowers` - Superpowers overview and guidance
- `verification-before-completion` - Pre-completion verification
- `writing-plans` - Create implementation plans
- `writing-skills` - Create new skills

### Project-Specific Skills
- `longplan` - Complex multi-step planning (1A2A workflow)
- `ralph` - Autonomous coding loop with MiniMax
- `minimax-mcp` - MiniMax MCP integration
- `godot` - Godot engine guidance
- `godot-gdscript-patterns` - GDScript best practices
- `godot-mcp-dap-start` - Godot MCP/DAP startup
- `playtesting` - Game playtesting workflows
- `glm-image-gen` - GLM image generation
- `image-analysis` - Image quality assessment
- `mcp-recovery` - MCP recovery procedures
- `subagent-best-practices` - Subagent delegation patterns
- `troubleshoot-and-continue` - Recovery workflows
- `confident-language-guard` - Documentation language guidance
- `skill-creator` - Create new skills
- `skill-installer` - Install skills from repos
- `sam-ceo-communication` - Non-technical communication
- `github` - GitHub issue management
- `gh-address-comments` - Address PR comments
- `gh-fix-ci` - Fix CI failures
- `git-best-practices` - Git commit best practices
- `finishing-a-development-branch` - Branch completion workflow

### Deprecated/Removed Skills (Replaced by Superpowers)
- ~~`create-plan`~~ → use `writing-plans`
- ~~`clarify`~~ → use `brainstorming`
- ~~`explain`~~ → not used
- ~~`ground`~~ → not used
- ~~`finish`~~ → not used
- ~~`review`~~ → use `requesting-code-review` or `receiving-code-review`
- ~~`token-plan`~~ → use `writing-plans`

[Codex - 2026-01-27]
