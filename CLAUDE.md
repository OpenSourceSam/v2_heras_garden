# Claude Code Directives

## CRITICAL: NO SUB-AGENTS

**NEVER use the Task tool to spawn sub-agents.** This is an absolute rule with no exceptions.

Sub-agents burned 70k+ tokens in under a minute. This is unacceptable.

**Exception: USE the Skill tool to invoke project skills. Skills are NOT sub-agents.**

Skills provide specialized knowledge without spawning agents.

### Use Direct Tools Only

- Glob, Grep, Read, Edit, Write, Bash
- No Task tool for research, exploration, or delegation
- Even if skills instruct agent spawning, DO NOT DO IT

### Use Skills First - Before Manual Implementation

**CHECK AVAILABLE SKILLS BEFORE WRITING CODE**

Available project skills:
- `godot-dev` - Godot Engine expertise (scenes, nodes, GDScript)
- `godot-gdscript-patterns` - GDScript best practices and patterns
- `systematic-debugging` - Debug workflow for errors/bugs
- `test-driven-development` - TDD workflow before implementation
- `git-best-practices` - Commit message generation
- `skill-gap-finder` - Identify when to create new skills
- Other skills listed in tool description

**When to invoke skills:**
- Working with Godot: Use `godot-dev` or `godot-gdscript-patterns`
- Encountering bugs: Use `systematic-debugging`
- Writing new features: Use `test-driven-development`
- Creating commits: Use `git-best-practices`
- User explicitly asks you to "use your [X] skill"

**How to invoke:**
```
Skill(skill: "godot-dev")
Skill(skill: "systematic-debugging")
```

**IMPORTANT:** Don't manually implement what skills already know.

### Token Efficiency

- Opus: Strategic planning and architecture decisions only
- Sonnet: All execution and editing work
- Keep responses concise
- Don't read entire large files unless necessary

### Task Initiation

**ALWAYS run the token-aware-planning skill at the start of every new chat or task.**

Use `/token-aware-planning` or the Skill tool to invoke it before beginning work.

**After running token-aware-planning, check for relevant skills:**

1. Is this a Godot task? → Invoke `godot-dev` or `godot-gdscript-patterns`
2. Did something break? → Invoke `systematic-debugging`
3. Building new functionality? → Invoke `test-driven-development`
4. Making a commit? → Invoke `git-best-practices`

### Testing Best Practices for Godot

**When writing tests for this Godot project:**

1. **Use `extends SceneTree` for headless tests**
   - Access autoloads via `root.get_node_or_null("AutoloadName")`
   - Use `call_deferred("_run_all_tests")` in `_init()`
   - Exit with `quit(0)` for pass, `quit(1)` for fail

2. **Test game state transitions properly**
   - Reset state between tests: `GameState.new_game()`
   - Progress flags sequentially (e.g., complete quest 4 before testing quest 5)
   - Don't create inconsistent states (e.g., quest_6_complete without quest_4_complete)

3. **Understand default game state**
   - `new_game()` sets `prologue_complete=true` by default
   - `new_game()` adds starter items (e.g., 3 wheat_seeds)
   - Account for these in test expectations

4. **Test structure**
   - Group related tests in functions (e.g., `test_hermes_quest_flow()`)
   - Use descriptive test names that explain what's being verified
   - Provide failure details: `record_test("Test name", condition, "Expected X, got Y")`

5. **Use skills for testing guidance**
   - `test-driven-development` - Before writing new features
   - `verification-before-completion` - Before claiming tests pass
   - `godot-dev` - For Godot-specific testing patterns
