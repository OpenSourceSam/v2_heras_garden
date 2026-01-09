# Project Rules & Constraints

**Core directives all agents must follow**

These are the critical rules extracted from CLAUDE.md. All agents must understand and follow these constraints.

---

## 🚨 CRITICAL: NO SUB-AGENTS

**NEVER use the Task tool to spawn sub-agents.** This is an absolute rule with no exceptions.

Sub-agents burned 70k+ tokens in under a minute. This is unacceptable.

**Exception: USE the Skill tool to invoke project skills. Skills are NOT sub-agents.**

Skills provide specialized knowledge without spawning agents.

### Use Direct Tools Only

- Glob, Grep, Read, Edit, Write, Bash
- No Task tool for research, exploration, or delegation
- Even if skills instruct agent spawning, DO NOT DO IT

---

## 🛠️ Use Skills First - Before Manual Implementation

**CHECK AVAILABLE SKILLS BEFORE WRITING CODE**

Available project skills (see also: [`../core-directives/skill-inventory.md`](../core-directives/skill-inventory.md)):

- `godot-dev` - Godot Engine expertise (scenes, nodes, GDScript)
- `godot-gdscript-patterns` - GDScript best practices and patterns
- `pixel-art-professional` - Advanced pixel art techniques (dithering, palette optimization, shading)
- `systematic-debugging` - Debug workflow for errors/bugs
- `test-driven-development` - TDD workflow before implementation
- `git-best-practices` - Commit message generation
- `skill-gap-finder` - Identify when to create new skills
- `token-aware-planning` - Match model to task for efficiency
- `verification-before-completion` - Verify work before claiming complete
- Other skills listed in skill inventory

**When to invoke skills:**

1. Working with Godot → Use `godot-dev` or `godot-gdscript-patterns`
2. Working with pixel art → Use `pixel-art-professional` (dithering, palettes, shading)
3. Encountering bugs → Use `systematic-debugging`
4. Writing new features → Use `test-driven-development`
5. Creating commits → Use `git-best-practices`
6. Starting new task → Use `token-aware-planning`
7. User explicitly asks you to "use your [X] skill"

**How to invoke:**

```gdscript
Skill(skill: "godot-dev")
Skill(skill: "pixel-art-professional")
Skill(skill: "systematic-debugging")
```

**IMPORTANT:** Don't manually implement what skills already know.

---

## ⚡ Token Efficiency

- **Opus**: Strategic planning and architecture decisions only
- **Sonnet**: All execution and editing work
- Keep responses concise
- Don't read entire large files unless necessary

---

## 🚀 Task Initiation

**ALWAYS run the token-aware-planning skill at the start of every new chat or task.**

Use `/token-aware-planning` or the Skill tool to invoke it before beginning work.

**After running token-aware-planning, check for relevant skills:**

1. Is this a Godot task? → Invoke `godot-dev` or `godot-gdscript-patterns`
2. Working with pixel art? → Invoke `pixel-art-professional`
3. Did something break? → Invoke `systematic-debugging`
4. Building new functionality? → Invoke `test-driven-development`
5. Making a commit? → Invoke `git-best-practices`

---

## 📋 Multi-Step Project Planning Protocol

**When starting a new multi-step block of work, always follow this protocol:**

### Phase 1: Initial Understanding
- Explore codebase to understand current state
- Read relevant documentation
- Identify key files and patterns
- Use Glob, Grep, and Read tools directly (no sub-agents)

### Phase 2: Q&A Phase (MANDATORY for new blocks)
- Ask clarifying questions about scope, priorities, and assumptions
- Use AskUserQuestion tool to get user input
- Cover: implementation scope, file modifications, testing requirements, phase priorities

### Phase 3: Planning Phase
- Create detailed plan with phases
- Include specific file paths to modify
- Document user clarifications received
- State assumptions explicitly

### Phase 4: Review Phase
- Present plan to user
- Get approval before proceeding
- Adjust based on feedback

**When to apply this protocol:**

- ✅ New feature implementation
- ✅ Multi-file refactoring
- ✅ New quest/content development
- ✅ Significant testing methodology changes
- ✅ Project restructuring

**When NOT to apply:**

- ❌ Single file edits
- ❌ Small bug fixes
- ❌ Simple documentation updates
- ❌ Continuing existing task

---

## 📝 Planning and Documentation Guidelines

**CRITICAL: Avoid Documentation Clutter**

**DO NOT create one-off planning documents in `docs/plans/` unless the plan is a canonical reference needed by future agents.**

### When Planning:

1. **First Try TodoWrite**
   - Use `TodoWrite(todos=[...])` for most multi-step tasks
   - This is the preferred tracking method
   - Keep todo list as your plan

2. **Only Create Plan Documents If:**
   - The task is complex enough that a detailed plan is essential
   - The plan will be a **canonical reference** for future agents
   - You've tried TodoWrite and it's insufficient for the complexity

3. **Plan Document Storage:**
   - **Canonical docs** → `docs/plans/` (kept long-term, added to docs index)
   - **One-off implementation plans** → `temp/plans/` (deleted after completion)
   - **Never** create throwaway plans in `docs/plans/`

### Examples:

❌ **DON'T DO THIS:**
```
Created: docs/plans/my-implementation-plan-2026-01-03.md
Purpose: Just for this task
Result: Clutters repo with single-use documents
```

✅ **DO THIS:**
```
Option 1: Use TodoWrite
Option 2: If absolutely necessary, create in temp/plans/ and delete after completion
```

### Post-Task Cleanup:
- Review any plan documents created
- Move canonical docs to `docs/plans/` and add to index
- Delete one-off plans from `temp/plans/`
- Never leave throwaway plans in the repo

### Why This Matters:
- Keeps `docs/` clean with only canonical references
- Makes it easy for future agents to find important docs
- Reduces repository clutter and confusion
- TodoWrite is often sufficient for task tracking

**Rule of Thumb:**
- **80% of tasks** → TodoWrite
- **15% of tasks** → temp/plans/ (one-off plans)
- **5% of tasks** → docs/plans/ (canonical plans)

---

## 🧪 Testing Methodology Requirements

**CRITICAL:** This section establishes cardinal rules for how agents approach testing. These rules are essential for validating human playability of the game.

**Context:** HLC can pass (118/118) but humans may not be able to play due to UX issues. We use a two-layer testing strategy: Headless Logic Check (HLC) + Headed Playability Validation (HPV).

### Strongly Recommended Testing Approach

**For UX/Playability Validation (HPV):**
- **Preferred:** Use Godot Tools with HPV (headed playability validation) and programmatic debugging
- **Tools:** VS Code debugger (F5), remote debug protocol (`--remote-debug tcp://127.0.0.1:6007`), enhanced test scripts
- **Approach:** Agents autonomously inspect game state, verify UI visibility, capture visual state
- **Goal:** Validate that humans can see, understand, and interact with game UI

**For Logic Validation:**
**For Logic Validation (HLC):**
- **Appropriate:** Headless Logic Check via CLI (`Godot*.exe --headless --script tests/*.gd`)
- **Goal:** Verify mechanics work (quest flags, inventory, save/load, crafting logic, day advancement)
- **When to use:** Fast regression testing, CI/CD validation

### Critical Distinction: When to Use Each Approach

**Avoid falling back to HLC log parsing when the goal is UX validation.**

- **HLC log parsing** can tell you IF something broke, but not WHY the human experience is broken
- **HPV (headed) testing** lets agents see what renders and inspect game state at any moment

**When testing human playability:**
- ❌ **Don't:** Run HLC → parse logs → guess at UI issues
- ✅ **Do:** Run HPV with programmatic debugging → inspect visual state → document findings

### Programmatic Debugging for Autonomous Testing

Agents can validate UX autonomously using HPV (headed mode) with debugging:

1. **Launch game in headed mode with remote debug (HPV):**
   ```powershell
   Godot*.exe --path . --remote-debug tcp://127.0.0.1:6007 --script tests/autonomous_headed_playthrough.gd
   ```

2. **Enhanced test scripts inspect state programmatically:**
   - Check UI visibility flags: `dialogue_box.visible`
   - Verify nodes exist: `minigame_node != null`
   - Capture and analyze screenshots
   - Print game variables, node properties, state flags
   - All without human interaction

3. **Key insight:**
   The limitation is NOT that agents need humans to click F5. The limitation is that HLC does not capture visual state. Use HPV programmatically.

### Testing Best Practices for Godot

When writing tests for this Godot project:

1. **Use `extends SceneTree` for HLC scripts**
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

---

## ✅ Phase 4 Autonomous Execution Authorization

**GRANTED: Run Phase 4 (Balance and QA) completely autonomously.**

The user authorizes full execution of Phase 4 without additional input:

### Approved Actions:
- Execute all Phase 4 tasks from docs/execution/ROADMAP.md
- Run any HLC tests (`Godot*.exe --headless --script tests/*.gd`)
- Create new test files following existing patterns in `tests/` folder
- Run GdUnit4 suite and document results
- Update ROADMAP.md with Phase 4 findings and checkpoint
- Create verification scripts for difficulty tuning, D-pad controls, save/load
- Test soft-lock scenarios and document any issues
- Commit and push all Phase 4 changes to current branch

### Scope of Authorization:
- Phase 4 tasks: A (Full Playthrough Test), B (Difficulty Tuning), C (D-Pad Validation)
- Phase 4 tasks: D (Save/Load Validation), E (Soft-Lock Testing), F (Bug Logging)
- Any test files created for Phase 4 verification
- Documentation updates to ROADMAP.md
- Git operations for files I create

### Constraints:
- Stay within Phase 4 scope as defined in ROADMAP.md
- Don't modify game features (only testing/documentation)
- Report progress but don't ask for permission for each step
- If blockers arise, document them and continue with remaining tasks

**Authorization Start:** 2025-12-29
**Authorized by:** User (verbal approval)

---

## 📚 Additional Resources

**For comprehensive testing guidance, refer to:**
- **Human playability testing:** `tests/visual/playthrough_guide.md` - Testing methodology reference
- **Godot Tools reference:** `docs/testing/GODOT_TOOLS_GUIDE.md` - Cardinal Rules: HPV for UX validation section
- **Implementation patterns:** See `tests/autonomous_headed_playthrough.gd` for examples of programmatic state inspection

**For complete project directives, see:** `CLAUDE.md`

**For role-based permissions, see:** [`role-permissions.md`](./role-permissions.md)

**For skills inventory, see:** [`skill-inventory.md`](./skill-inventory.md)

---

**Last Updated:** 2026-01-08
**Source:** CLAUDE.md (lines 1-329)
**Purpose:** Core project rules and constraints for all agents

[Codex - 2026-01-08]
