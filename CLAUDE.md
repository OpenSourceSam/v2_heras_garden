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
- `pixel-art-professional` - Advanced pixel art techniques (dithering, palette optimization, shading)
- `systematic-debugging` - Debug workflow for errors/bugs
- `test-driven-development` - TDD workflow before implementation
- `git-best-practices` - Commit message generation
- `skill-gap-finder` - Identify when to create new skills
- Other skills listed in tool description

**When to invoke skills:**
- Working with Godot: Use `godot-dev` or `godot-gdscript-patterns`
- Working with pixel art: Use `pixel-art-professional` (dithering, palettes, shading)
- Encountering bugs: Use `systematic-debugging`
- Writing new features: Use `test-driven-development`
- Creating commits: Use `git-best-practices`
- User explicitly asks you to "use your [X] skill"

**How to invoke:**
```
Skill(skill: "godot-dev")
Skill(skill: "pixel-art-professional")
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
2. Working with pixel art? → Invoke `pixel-art-professional`
3. Did something break? → Invoke `systematic-debugging`
4. Building new functionality? → Invoke `test-driven-development`
5. Making a commit? → Invoke `git-best-practices`

### Testing Methodology Requirements

**CRITICAL:** This section establishes cardinal rules for how agents approach testing. These rules are essential for validating human playability of the game.

**Context:** Headless logic tests pass (118/118) but humans cannot play due to UX issues. We use a two-layer testing strategy combining logic validation with human-like playability validation.

#### Strongly Recommended Testing Approach

**For UX/Playability Validation:**
- **Preferred:** Use Godot Tools with headed visual testing and programmatic debugging
- **Tools:** VS Code debugger (F5), remote debug protocol (`--remote-debug tcp://127.0.0.1:6007`), enhanced test scripts
- **Approach:** Agents autonomously inspect game state, verify UI visibility, capture visual state
- **Goal:** Validate that humans can see, understand, and interact with game UI

**For Logic Validation:**
- **Appropriate:** Headless tests via CLI (`Godot*.exe --headless --script tests/*.gd`)
- **Goal:** Verify mechanics work (quest flags, inventory, save/load, crafting logic, day advancement)
- **When to use:** Fast regression testing, CI/CD validation

#### Critical Distinction: When to Use Each Approach

**Avoid falling back to headless CLI log parsing when the goal is UX validation.**

- **Headless log parsing** can tell you IF something broke, but not WHY the human experience is broken
- **Headed visual testing** lets agents see what renders and inspect game state at any moment

**When testing human playability:**
- ❌ **Don't:** Run headless test → parse logs → guess at UI issues
- ✅ **Do:** Run headed test with programmatic debugging → inspect visual state → document findings

#### Programmatic Debugging for Autonomous Testing

Agents can validate UX autonomously using headed mode with debugging:

1. **Launch game in headed mode with remote debug:**
   ```powershell
   Godot*.exe --path . --remote-debug tcp://127.0.0.1:6007 --script tests/visual/beta_mechanical_test.gd
   ```

2. **Enhanced test scripts inspect state programmatically:**
   - Check UI visibility flags: `dialogue_box.visible`
   - Verify nodes exist: `minigame_node != null`
   - Capture and analyze screenshots
   - Print game variables, node properties, state flags
   - All without human interaction

3. **Key insight:**
   The limitation is NOT that agents need humans to click F5. The limitation is that headless mode CAN'T capture visual state. Use headed mode programmatically.

#### Detailed Guidelines

For comprehensive guidance on testing methodology, refer to:
- **Human playability testing:** `tests/visual/January_Playtest_Walkthrough_jwp.md` - Testing Methodology Cardinal Rules section
- **Godot Tools reference:** `docs/testing/GODOT_TOOLS_GUIDE.md` - Cardinal Rules: Headed Testing for UX Validation section
- **Implementation patterns:** See `tests/visual/beta_mechanical_test.gd` for examples of programmatic state inspection

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

### Phase 4 Autonomous Execution Authorization

**GRANTED: Run Phase 4 (Balance and QA) completely autonomously.**

The user authorizes full execution of Phase 4 without additional input:

**Approved Actions:**
- Execute all Phase 4 tasks from docs/execution/ROADMAP.md
- Run any Godot headless tests (`Godot*.exe --headless --script tests/*.gd`)
- Create new test files following existing patterns in `tests/` folder
- Run GdUnit4 suite and document results
- Update ROADMAP.md with Phase 4 findings and checkpoint
- Create verification scripts for difficulty tuning, D-pad controls, save/load
- Test soft-lock scenarios and document any issues
- Commit and push all Phase 4 changes to current branch

**Scope of Authorization:**
- Phase 4 tasks: A (Full Playthrough Test), B (Difficulty Tuning), C (D-Pad Validation)
- Phase 4 tasks: D (Save/Load Validation), E (Soft-Lock Testing), F (Bug Logging)
- Any test files created for Phase 4 verification
- Documentation updates to ROADMAP.md
- Git operations for files I create

**Constraints:**
- Stay within Phase 4 scope as defined in ROADMAP.md
- Don't modify game features (only testing/documentation)
- Report progress but don't ask for permission for each step
- If blockers arise, document them and continue with remaining tasks

**Authorization Start: 2025-12-29**
**Authorized by: User (verbal approval)

---

[Claude Haiku 4.5 - 2026-01-02] - Added Testing Methodology Requirements section with cardinal rules for headed testing vs headless validation
