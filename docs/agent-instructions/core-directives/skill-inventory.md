# Skills Inventory

**Available project skills and when to use them**

This catalog lists repo-local skills in `.claude/skills/` and mirrored in `.codex/skills/` for Codex.

---

## Quick Reference

| Skill | Purpose | When to Use |
|-------|---------|-------------|
| `godot` | Godot development | Working on Godot game features |
| `godot-gdscript-patterns` | GDScript patterns | Writing GDScript code |
| `godot-mcp-dap-start` | MCP/DAP restart | MCP tools unavailable |
| `playtesting` | HPV onboarding | Running playtests/logging |
| `git-best-practices` | Commit messages | Creating commits |
| `gh-address-comments` | PR review responses | Addressing review comments |
| `gh-fix-ci` | CI failure triage | Fixing failed checks |
| `github` | GitHub management | Issues/PRs |
| `create-plan` | Implementation planning | Complex planning tasks |
| `review` | Sanity code review | When asked to run `/review` |
| `clarify` | Clarify requirements | When asked to run `/clarify` |
| `explain` | CEO-friendly explanation | When asked to run `/explain` |
| `finish` | Wrap-up protocol | When asked to run `/finish` |
| `ground` | Context grounding | When asked to run `/ground` |
| `longplan` | 1A2A workflow | When asked to run `/longplan` |
| `token-plan` | Role/model selection | When asked to run `/token-plan` |
| `finishing-a-development-branch` | Branch finishing | Work complete and tests pass |
| `confident-language-guard` | Documentation guard | Editing .md files |
| `sam-ceo-communication` | CEO-friendly comms | Explaining work to Sam |
| `skill-creator` | Skill design | Creating/updating skills |
| `skill-installer` | Skill installation | Installing skills into repo |
| `subagent-best-practices` | Subagent delegation | Auto-injects when Task tool/subagents mentioned |
| `ralph` | Autonomous asset generation | Scalable content creation with MiniMax |
| `troubleshoot-and-continue` | Problem-solving protocol | When blocked - use before stopping |

Note: Slash commands and shortcuts can vary by client; prefer the full skill name when invoking.

---

## Detailed Skill Descriptions

See each skill's `SKILL.md` for full details:
- `confident-language-guard`
- `create-plan`
- `review`
- `clarify`
- `explain`
- `finish`
- `ground`
- `longplan`
- `token-plan`
- `finishing-a-development-branch`
- `gh-address-comments`
- `gh-fix-ci`
- `git-best-practices`
- `github`
- `godot`
- `godot-gdscript-patterns`
- `godot-mcp-dap-start`
- `playtesting`
- `sam-ceo-communication`
- `skill-creator`
- `skill-installer`
- `troubleshoot-and-continue`

Open `.claude/skills/<skill>/SKILL.md` for the full instructions.

---

## Usage Guidelines

- Invoke a skill when it directly matches the task.
- Prefer the full skill name over shorthand.
- Keep docs concise; avoid duplicating skill content in other files.

---

## Additional Resources

- Skills Location: `.claude/skills/`
- Codex Mirror: `.codex/skills/`
- Slash Commands: `.claude/commands/`
- Project Rules: `docs/agent-instructions/core-directives/project-rules.md`

---

**Last Updated:** 2026-01-27 (Added troubleshoot-and-continue skill)
**Source:** `.claude/skills/` directory
