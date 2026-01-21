# Skills Catalog

**Detailed skill descriptions with usage examples**

This catalog provides in-depth information about each skill, including usage patterns, examples, and best practices.

---

## 📋 Catalog Organization

### By Category

**Development Skills:**
- `godot` (`/gd`) - Godot Engine expertise
- `godot-gdscript-patterns` (`/ggp`) - GDScript patterns
- `test-driven-development` (`/tdd`) - TDD workflow

**Debugging & Quality:**
- `systematic-debugging` (`/sd`) - Debug workflow
- `loop-detection` (`/ld`) - Loop detection

**Planning & Organization:**
- `create-plan` (`/cp`) - Implementation planning
- `token-aware-planning` (`/tap`) - Model-task matching
- `skill-creator` (`/sc`) - Create new skills

**Tool Skills:**
- `git-best-practices` (`/gbp`) - Git workflow
- `mcp-builder` (`/mcpb`) - MCP server development
- `github` (`/gh`) - GitHub operations
- `confident-language-guard` (`/clg`) - Documentation guard

---

## 📚 Detailed Skill Descriptions

### godot

**Expert knowledge of Godot Engine game development**

#### What It Covers
- Scene tree architecture and node hierarchy
- 2D and 3D node types and their use cases
- GDScript programming patterns
- Signals and node communication
- Godot MCP tools
- Input handling and physics
- Animation systems
- UI development with Control nodes

#### When to Use
- Creating or modifying scenes
- Writing game scripts
- Understanding node relationships
- Solving Godot-specific problems
- Working with Godot API

#### Usage Example
```gdscript
# Before writing Godot code
Skill(skill: "godot")

# Then apply the guidance:
# - Use CharacterBody2D for player movement
# - Connect signals using connect() method
# - Follow scene tree patterns
```

#### Key Concepts
- **Scene Tree:** Scenes are collections of nodes in tree hierarchy
- **Node Types:** Node2D, Sprite2D, CharacterBody2D, Area2D, Control, etc.
- **Signals:** Godot's event system for node communication
- **Resources:** External assets (textures, audio, scenes) loaded via paths

#### File Locations
- **Skill Directory:** `.claude/skills/godot/`
- **Documentation:** `skill.md` in skill directory

---

### godot-gdscript-patterns

**GDScript best practices and patterns**

#### What It Covers
- GDScript syntax and idioms
- Common programming patterns
- Code organization
- Performance optimization
- Type hints and annotations
- Error handling patterns

#### When to Use
- Writing GDScript code
- Following Godot patterns
- Optimizing performance
- Learning GDScript idioms

#### Usage Example
```gdscript
# Before writing GDScript
Skill(skill: "godot-gdscript-patterns")

# Follow patterns like:
# - Use @onready for node references
# - Export variables for inspector
# - Use type hints for clarity
```

#### Key Patterns
- **@onready:** Lazy node initialization
- **Export variables:** Editor-exposed properties
- **Type hints:** Static typing for clarity
- **match statements:** Pattern matching (Godot 4+)

#### File Locations
- **Skill Directory:** `.claude/skills/godot-gdscript-patterns/`
- **Documentation:** `skill.md` in skill directory

---

### systematic-debugging

**Debug workflow for errors and bugs**

#### What It Covers
- Structured debugging methodologies
- Error analysis techniques
- Test failure diagnosis
- Log file interpretation
- Step-by-step problem solving

#### When to Use
- Encountering bugs or errors
- Tests failing unexpectedly
- Unexpected behavior
- Performance issues

#### Usage Example
```gdscript
# When a bug is encountered
Skill(skill: "systematic-debugging")

# Follow the structured approach:
# 1. Reproduce the error
# 2. Isolate the problem
# 3. Identify root cause
# 4. Implement fix
# 5. Verify solution
```

#### Debugging Steps
1. **Reproduce** - Can you make the error happen consistently?
2. **Isolate** - Where in the code does it occur?
3. **Identify** - What's the root cause?
4. **Fix** - Implement the solution
5. **Verify** - Test that the fix works

#### File Locations
- **Skill Directory:** `.claude/skills/systematic-debugging/`
- **Documentation:** `skill.md` in skill directory

---

### test-driven-development

**TDD workflow before implementation**

#### What It Covers
- Test-first development principles
- Red-green-refactor cycle
- Writing effective tests
- Test organization
- Mocking and stubbing

#### When to Use
- Writing new features
- Implementing new functionality
- Following TDD methodology
- Before any new code

#### TDD Cycle
1. **Red** - Write a failing test
2. **Green** - Write minimal code to pass
3. **Refactor** - Improve the code while keeping tests green

#### Usage Example
```gdscript
# Before implementing new feature
Skill(skill: "test-driven-development")

# Then:
# 1. Write test first
# 2. Run test (fails)
# 3. Write minimal code
# 4. Run test (passes)
# 5. Refactor
```

#### File Locations
- **Skill Directory:** `.claude/skills/test-driven-development/`
- **Documentation:** `skill.md` in skill directory

---

### token-aware-planning

**Match Claude model to task type for optimal token efficiency**

#### What It Covers
- Model capabilities and limitations
- Task categorization
- Token optimization strategies
- Work division approaches

#### When to Use
- Starting new tasks
- Planning work division
- Optimizing for model efficiency
- Determining approach

#### Model Guidelines
- **Opus:** Strategic planning and architecture decisions only
- **Sonnet:** All execution and editing work
- Keep responses concise
- Don't read entire large files unless necessary

#### Usage Example
```gdscript
# At start of new task
Skill(skill: "token-aware-planning")

# Then plan work:
# - Opus for high-level architecture
# - Sonnet for implementation
# - Use TodoWrite for tracking
```

#### File Locations
- **Skill Directory:** `.claude/skills/token-aware-planning/`
- **Documentation:** `skill.md` in skill directory

---

### git-best-practices

**Commit message generation and git workflow**

#### What It Covers
- Commit message conventions
- Git workflow best practices
- Change categorization
- Clear commit descriptions

#### When to Use
- Creating commits
- Writing commit messages
- Following git conventions
- Generating good commit history

#### Commit Format
```
type(scope): description

[optional body]

[optional footer]
```

**Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `test:` - Test additions/updates
- `docs:` - Documentation changes
- `refactor:` - Code refactoring
- `chore:` - Maintenance tasks

#### Usage Example
```gdscript
# Before committing
Skill(skill: "git-best-practices", args: "-m 'feat(quest): add quest 4 dialogue system'")

# Generates proper commit message with:
# - Clear type
# - Scope
# - Description
```

#### File Locations
- **Skill Directory:** `.claude/skills/git-best-practices/`
- **Documentation:** `skill.md` in skill directory

---

### skill-creator

**Create effective skills** (Tier 2+)

#### What It Covers
- Skill design principles
- Pattern capture
- Skill structure
- Documentation standards
- Testing skills

#### When to Use
- Creating new skills
- Extending capabilities
- Capturing patterns
- Tier 2+ agents only

#### Skill Structure
```yaml
---
name: skill-name
description: What it does
allowed-tools: tool list
---

# Skill Documentation
# Detailed description and usage
```

#### Usage Example
```gdscript
# Tier 2+ agents can create skills
Skill(skill: "skill-creator")

# Then create skill following:
# - Clear name and description
# - Proper structure
# - Complete documentation
```

#### File Locations
- **Skill Directory:** `.claude/skills/skill-creator/`
- **Documentation:** `skill.md` in skill directory

---

### confident-language-guard

**Prevent overconfident absolute language** (Tier 1)

#### What It Covers
- Language qualification
- Documentation best practices
- Avoiding absolutes
- Using qualified language

#### When to Use
- Editing .md files (mandatory for Tier 1)
- Writing documentation
- Avoiding absolute language
- Using qualified language

#### Language Guidelines
**Use:** "typically", "often", "recommended", "generally"
**Avoid:** "always", "never", "must", "all", "every", "none"

#### Usage Example
```gdscript
# Before editing .md files (Tier 1)
Skill(skill: "confident-language-guard")

# Then write with qualified language:
# "Typically, agents should..."
# NOT "Agents always..."
```

#### File Locations
- **Skill Directory:** `.claude/skills/confident-language-guard/`
- **Documentation:** `skill.md` in skill directory

---

### loop-detection

**Detect and escape loops**

#### What It Covers
- Loop identification
- Cycle detection
- Escape strategies
- Progress analysis

#### When to Use
- Stuck in loops
- Repeatedly attempting same action
- No progress after 3+ attempts
- Need to break cycle

#### Loop Indicators
- Same goal attempted multiple times
- Circular reasoning
- Repetitive error patterns
- No forward progress

#### Usage Example
```gdscript
# When stuck in loop
Skill(skill: "loop-detection")

# Analysis:
# - What are we repeating?
# - Why isn't it working?
# - What's the escape strategy?
```

#### File Locations
- **Skill Directory:** `.claude/skills/loop-detection/`
- **Documentation:** `skill.md` in skill directory

---

### create-plan

**Create detailed implementation plans**

#### What It Covers
- Implementation planning
- Phase structure
- Task breakdown
- Success criteria

#### When to Use
- Planning complex implementations
- Multi-step project planning
- Need detailed plan structure
- Research before planning

#### Plan Structure
```markdown
# Implementation Plan: Feature Name

## Overview
## Context
## Design Decision
## Implementation Phases
### Phase 1: Name
### Phase 2: Name
## Dependencies
## Risks and Mitigations
```

#### Usage Example
```gdscript
# For complex planning
Skill(skill: "create-plan")

# Then create detailed plan:
# - Research codebase
# - Design approach
# - Structure phases
# - Define success criteria
```

#### File Locations
- **Skill Directory:** `.claude/skills/create-plan/`
- **Documentation:** `skill.md` in skill directory

---

### mcp-builder

**MCP server development guide**

#### What It Covers
- MCP protocol
- Server architecture
- Tool design
- API integration

#### When to Use
- Building MCP servers
- Integrating external APIs
- Creating tools for LLMs
- MCP protocol work

#### MCP Best Practices
- **API Coverage:** Comprehensive vs workflow tools
- **Tool Naming:** Clear, descriptive names
- **Context Management:** Concise descriptions
- **Error Messages:** Actionable guidance

#### Usage Example
```gdscript
# When building MCP server
Skill(skill: "mcp-builder")

# Follow 4-phase process:
# 1. Deep research and planning
# 2. Implementation
# 3. Review and test
# 4. Create evaluations
```

#### File Locations
- **Skill Directory:** `.claude/skills/mcp-builder/`
- **Documentation:** `skill.md` in skill directory

---

### github

**Manage GitHub issues and operations**

#### What It Covers
- GitHub CLI
- Issue management
- Pull requests
- Repository operations

#### When to Use
- Working with GitHub
- Creating/managing issues
- GitHub operations
- Project management

#### Common Operations
- Create issues
- Manage pull requests
- Label issues
- Assign milestones

#### Usage Example
```gdscript
# For GitHub operations
Skill(skill: "github")

# Then use GitHub CLI:
# gh issue create
# gh pr create
# gh issue list
```

#### File Locations
- **Skill Directory:** `.claude/skills/github/`
- **Documentation:** `skill.md` in skill directory

---

## 🎓 Skill Usage Best Practices

### Before Writing Code

1. **Check if relevant skill exists**
   ```gdscript
   # Quick reference in skill-inventory.md
   ```

2. **Invoke the skill for guidance**
   ```gdscript
   Skill(skill: "skill-name")
   ```

3. **Apply skill knowledge**
   - Don't duplicate skill knowledge
   - Use skill-recommended patterns
   - Follow best practices

### Skill Invocation Patterns

```gdscript
# Simple invocation
Skill(skill: "godot")

# With arguments
Skill(skill: "git-best-practices", args: "-m 'commit message'")

# For planning
Skill(skill: "create-plan")

# For debugging
Skill(skill: "systematic-debugging")
```

### Don't Forget Skills

**Always check skills first:**
- Working with Godot → `godot`, `godot-gdscript-patterns`
- Encountering bugs → `systematic-debugging`
- Writing features → `test-driven-development`
- Starting tasks → `token-aware-planning`
- Creating commits → `git-best-practices`
- User asks explicitly → Use the requested skill

---

## 📖 Additional Resources

**Quick Reference:**
- **Skills Inventory:** [`../core-directives/skill-inventory.md`](../core-directives/skill-inventory.md)
- **Role Permissions:** [`../core-directives/role-permissions.md`](../core-directives/role-permissions.md)

**Skill Directories:**
- All skills: `.claude/skills/`
- Individual skill docs: `.claude/skills/{skill-name}/skill.md`

---

**Last Updated:** 2026-01-17
**Total Skills:** 18 project skills
**Purpose:** Comprehensive skill catalog with examples

[GLM-4.7 - 2026-01-20] (Fixed: godot-dev → godot)
