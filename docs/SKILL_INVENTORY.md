# Circe's Garden - Skill Inventory

**Last Updated:** 2026-01-28  
**Total Skills:** 32

---

## Superpowers Skills (Primary Workflow)

| Skill | File | Purpose |
|-------|------|---------|
| brainstorming | `.claude/skills/brainstorming/SKILL.md` | Pre-implementation design dialogue |
| dispatching-parallel-agents | `.claude/skills/dispatching-parallel-agents/SKILL.md` | Parallel subagent coordination |
| executing-plans | `.claude/skills/executing-plans/SKILL.md` | Batch plan execution with checkpoints |
| receiving-code-review | `.claude/skills/receiving-code-review/SKILL.md` | Process review feedback |
| requesting-code-review | `.claude/skills/requesting-code-review/SKILL.md` | Request code reviews |
| subagent-driven-development | `.claude/skills/subagent-driven-development/SKILL.md` | Sequential subagent execution |
| systematic-debugging | `.claude/skills/systematic-debugging/SKILL.md` | 4-phase debugging methodology |
| test-driven-development | `.claude/skills/test-driven-development/SKILL.md` | TDD with Godot/GUT examples |
| using-git-worktrees | `.claude/skills/using-git-worktrees/SKILL.md` | Git worktree management |
| using-superpowers | `.claude/skills/using-superpowers/SKILL.md` | Superpowers overview |
| verification-before-completion | `.claude/skills/verification-before-completion/SKILL.md` | Evidence-based completion |
| writing-plans | `.claude/skills/writing-plans/SKILL.md` | Create implementation plans |
| writing-skills | `.claude/skills/writing-skills/SKILL.md` | Create new skills |

---

## Project-Specific Skills

### Godot & Game Development
| Skill | File | Purpose |
|-------|------|---------|
| godot | `.claude/skills/godot/SKILL.md` | Godot engine guidance |
| godot-gdscript-patterns | `.claude/skills/godot-gdscript-patterns/SKILL.md` | GDScript best practices |
| godot-mcp-dap-start | `.claude/skills/godot-mcp-dap-start/SKILL.md` | MCP/DAP startup |
| playtesting | `.claude/skills/playtesting/SKILL.md` | HPV playtesting workflows |

### AI & Asset Generation
| Skill | File | Purpose |
|-------|------|---------|
| minimax-mcp | `.claude/skills/minimax-mcp/SKILL.md` | MiniMax MCP integration |
| glm-image-gen | `.claude/skills/glm-image-gen/SKILL.md` | GLM image generation |
| image-analysis | `.claude/skills/image-analysis/SKILL.md` | Vision analysis |

### Planning & Execution
| Skill | File | Purpose |
|-------|------|---------|
| longplan | `.claude/skills/longplan/SKILL.md` | Complex multi-step planning |
| ralph | `.claude/skills/ralph/SKILL.md` | Autonomous coding loop |

### GitHub & Git
| Skill | File | Purpose |
|-------|------|---------|
| github | `.claude/skills/github/SKILL.md` | Issue management |
| gh-address-comments | `.claude/skills/gh-address-comments/SKILL.md` | PR comment handling |
| gh-fix-ci | `.claude/skills/gh-fix-ci/SKILL.md` | CI failure fixing |
| git-best-practices | `.claude/skills/git-best-practices/SKILL.md` | Commit best practices |
| finishing-a-development-branch | `.claude/skills/finishing-a-development-branch/SKILL.md` | Branch completion |

### Recovery & Debugging
| Skill | File | Purpose |
|-------|------|---------|
| mcp-recovery | `.claude/skills/mcp-recovery/SKILL.md` | MCP recovery procedures |
| troubleshoot-and-continue | `.claude/skills/troubleshoot-and-continue/SKILL.md` | Recovery workflows |

### Meta & Communication
| Skill | File | Purpose |
|-------|------|---------|
| subagent-best-practices | `.claude/skills/subagent-best-practices/SKILL.md` | Subagent patterns |
| confident-language-guard | `.claude/skills/confident-language-guard/SKILL.md` | Language guidance |
| skill-creator | `.claude/skills/skill-creator/SKILL.md` | Create skills |
| skill-installer | `.claude/skills/skill-installer/SKILL.md` | Install skills |
| sam-ceo-communication | `.claude/skills/sam-ceo-communication/SKILL.md` | Non-technical communication |

---

## Deprecated Skills (Removed)

| Skill | Replacement | Reason |
|-------|-------------|--------|
| create-plan | writing-plans | More prescriptive, TDD-focused |
| clarify | brainstorming | More comprehensive |
| review | requesting-code-review | More comprehensive |
| token-plan | writing-plans | Redundant |
| explain | - | Not used |
| ground | - | Not used |
| finish | - | Not used |

---

## Usage Guide

### Starting New Feature
```
1. brainstorming → Design exploration
2. writing-plans → Detailed plan
3. subagent-driven-development → Execute
4. verification-before-completion → Verify
```

### Debugging Issues
```
systematic-debugging → 4-phase methodology
troubleshoot-and-continue → Persistence
```

### Code Review
```
requesting-code-review → Get review
receiving-code-review → Apply feedback
```

### Complex Tasks
```
longplan → Massive parallel planning
ralph → Autonomous coding loop
```

---

## Integration Notes

- **Superpowers skills** provide the primary workflow framework
- **Project-specific skills** add Godot, AI, and GitHub capabilities
- **All skills tested** and verified working
- **Godot-specific modifications** applied to TDD and debugging skills

---

*Maintained by: Agent*  
*Updated: 2026-01-28*
