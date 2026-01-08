# Skills Inventory

**Available project skills and when to use them**

This catalog lists all available project skills. Skills provide specialized knowledge without spawning sub-agents.

---

## 🎯 Quick Reference

| Skill | Shortcut | Purpose | When to Use |
|-------|----------|---------|-------------|
| `godot-dev` | `/gd` | Godot Engine expertise | Working with Godot projects |
| `godot-gdscript-patterns` | `/ggp` | GDScript best practices | Writing GDScript code |
| `systematic-debugging` | `/sd` | Debug workflow | Encountering bugs/errors |
| `test-driven-development` | `/tdd` | TDD workflow | Writing new features |
| `git-best-practices` | `/gbp` | Commit messages | Creating commits |
| `token-aware-planning` | `/tap` | Model-task matching | Starting new tasks |
| `skill-creator` | `/sc` | Create new skills | Patterns emerge (Tier 2+) |
| `confident-language-guard` | `/clg` | Documentation guard | Editing .md files |
| `loop-detection` | `/ld` | Loop detection | Stuck in loops |
| `create-plan` | `/cp` | Implementation planning | Complex planning tasks |
| `mcp-builder` | `/mcpb` | MCP server development | Building MCP servers |
| `github` | `/gh` | GitHub management | GitHub operations |

---

## 📚 Detailed Skill Descriptions

### godot-dev

**Expert knowledge of Godot Engine game development**

Use when:
- Working with Godot projects, scenes, or nodes
- Creating or modifying scenes
- Writing game scripts
- Solving Godot-specific problems

**Expertise includes:**
- Scene tree architecture
- Node types (2D, 3D, UI)
- GDScript programming
- Signals and node communication
- Godot MCP tools

**How to invoke:**
```gdscript
Skill(skill: "godot-dev")
```

---

### godot-gdscript-patterns

**GDScript best practices and patterns**

Use when:
- Writing GDScript code
- Following Godot patterns
- Optimizing GDScript performance
- Learning GDScript idioms

**Expertise includes:**
- GDScript syntax and best practices
- Common programming patterns
- Code organization
- Performance optimization

**How to invoke:**
```gdscript
Skill(skill: "godot-gdscript-patterns")
```

---

### systematic-debugging

**Debug workflow for errors and bugs**

Use when:
- Encountering bugs or errors
- Need structured debugging approach
- Test failures occur
- Unexpected behavior

**Expertise includes:**
- Debugging methodologies
- Error analysis
- Test failure diagnosis
- Structured problem-solving

**How to invoke:**
```gdscript
Skill(skill: "systematic-debugging")
```

---

### test-driven-development

**TDD workflow before implementation**

Use when:
- Writing new features
- Implementing new functionality
- Need to write tests first
- Following TDD methodology

**Expertise includes:**
- TDD principles
- Test writing
- Red-green-refactor cycle
- Test-first development

**How to invoke:**
```gdscript
Skill(skill: "test-driven-development")
```

---

### git-best-practices

**Commit message generation**

Use when:
- Creating commits
- Writing commit messages
- Following git conventions
- Generating good commit history

**Expertise includes:**
- Commit message conventions
- Git workflow best practices
- Change categorization
- Clear commit descriptions

**How to invoke:**
```gdscript
Skill(skill: "git-best-practices")
```

---

### token-aware-planning

**Match Claude model to task type for optimal token efficiency**

Use when:
- Starting new tasks
- Need to plan work
- Determining task approach
- Optimizing for model capabilities

**Expertise includes:**
- Model-task matching
- Token efficiency strategies
- Work division approaches
- Planning methodologies

**How to invoke:**
```gdscript
Skill(skill: "token-aware-planning")
```

---

### skill-creator

**Create effective skills**

Use when:
- Creating new skills
- Extending capabilities
- Capturing patterns
- Tier 2+ agents only

**Expertise includes:**
- Skill design
- Pattern capture
- Skill structure
- Documentation

**How to invoke:**
```gdscript
Skill(skill: "skill-creator")
```

---

### confident-language-guard

**Prevent overconfident absolute language**

Use when:
- Editing .md files (mandatory for Tier 1)
- Writing documentation
- Avoiding absolute language
- Using qualified language

**Expertise includes:**
- Language qualification
- Documentation best practices
- Avoiding absolutes
- Using "typically", "often", "recommended"

**How to invoke:**
```gdscript
Skill(skill: "confident-language-guard")
```

---

### loop-detection

**Detect and escape loops**

Use when:
- Stuck in loops
- Repeatedly attempting same action
- No progress after 3+ attempts
- Need to break cycle

**Expertise includes:**
- Loop identification
- Cycle detection
- Escape strategies
- Progress analysis

**How to invoke:**
```gdscript
Skill(skill: "loop-detection")
```

---

### create-plan

**Create detailed implementation plans**

Use when:
- Planning complex implementations
- Multi-step project planning
- Need detailed plan structure
- Research before planning

**Expertise includes:**
- Implementation planning
- Phase structure
- Task breakdown
- Success criteria

**How to invoke:**
```gdscript
Skill(skill: "create-plan")
```

---

### mcp-builder

**MCP server development guide**

Use when:
- Building MCP servers
- Integrating external APIs
- Creating tools for LLMs
- MCP protocol work

**Expertise includes:**
- MCP protocol
- Server architecture
- Tool design
- API integration

**How to invoke:**
```gdscript
Skill(skill: "mcp-builder")
```

---

### github

**Manage GitHub issues and operations**

Use when:
- Working with GitHub
- Creating/managing issues
- GitHub operations
- Project management

**Expertise includes:**
- GitHub CLI
- Issue management
- Pull requests
- Repository operations

**How to invoke:**
```gdscript
Skill(skill: "github")
```

---

## 🎓 Usage Guidelines

### Before Writing Code
1. Check if a relevant skill exists
2. Invoke the skill for guidance
3. Apply skill knowledge
4. Don't duplicate skill knowledge

### When to Invoke Skills

**Immediately when:**
- Working with Godot (`godot-dev`, `godot-gdscript-patterns`)
- Encountering bugs (`systematic-debugging`)
- Writing new features (`test-driven-development`)
- Starting new tasks (`token-aware-planning`)
- User explicitly asks

**Consider invoking when:**
- Planning complex work (`create-plan`)
- Creating commits (`git-best-practices`)
- Need quality verification (`verification-before-completion`)
- Working with pixel art (`pixel-art-professional`)
- Building MCP servers (`mcp-builder`)

### Skill Invocation Pattern

```gdscript
# Check available skills first
# Then invoke relevant skill
Skill(skill: "skill-name")

# For some skills, you can pass arguments
Skill(skill: "skill-name", args: "additional context")
```

---

## 📖 Additional Resources

**Skills Location:** `.claude/skills/`
**Skill Documentation:** Each skill has its own directory with detailed documentation
**Project Rules:** [`project-rules.md`](./project-rules.md)
**Role Permissions:** [`role-permissions.md`](./role-permissions.md)

---

**Last Updated:** 2026-01-08
**Source:** `.claude/skills/` directory
**Total Skills:** 12 project skills (clg, cp, gbp, gd, ggp, gh, ld, mcpb, sc, sd, tap, tdd)
