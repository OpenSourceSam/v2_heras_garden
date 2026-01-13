# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Summary of Chat Session: Testing Methodology, Skills, and Documentation

**Date:** January 4, 2026
**Session Focus:** Establishing headed testing as default, skill system optimization, and documentation cleanup

---

## 1. Four-Level Testing Taxonomy Established

We formalized a **critical distinction** between testing approaches that was previously causing confusion:

### Level 1: Headless Logic Check (HLC)

- **Purpose:** Verify mechanics, state transitions, code correctness
- **Speed:** Fast (~minutes)
- **Tools:** CLI only (`--headless --script`)
- **Limitation:** **CANNOT** detect UI or playability issues
- **Use Case:** Fast regression testing, CI/CD validation
- **Reality Check:** Game can pass all headless tests while being entirely unplayable

### Level 2: Headed Playability Validation (HPV) (Preferred for Playtesters) ⭐

- **Purpose:** Validate human playability and UI visibility
- **Speed:** Slower (~hours)
- **Tools:** Godot Tools debugger, remote debug protocol
- **Capability:** Agent operates controls like human, can use teleporting
- **Use Case:** **Primary testing method for playtesters** (NOT engineers)
- **Key Advantage:** Can inspect visual state, validate UI rendering

### Level 3: Visual Autonomous Playtesting (Niche)

- **Purpose:** Specialized agent with screenshot capabilities
- **Tools:** Enhanced test scripts with visual capture
- **Use Case:** Edge cases requiring visual documentation
- **Status:** Reserved for explicit requests; otherwise use HPV via MCP/manual playthrough

### Level 4: Human-Operated Playtesting

- **Purpose:** Human plays, agent observes
- **Tools:** Real-time debugging, breakpoint inspection
- **Use Case:** Final validation, feel assessment

**Critical Rule:** HPV is the preferred path for playtesters. Engineers can use HLC for logic, and HPV is the recommended check for playability validation.

---

## 2. Skills System Renamed and Optimized

All 12 skills were **renamed to short initials** for efficiency:

| Old Name | New Name | Slash Command | Purpose |
|----------|----------|---------------|---------|
| git-best-practices | gbp | `/gbp` | Git workflow and commits |
| github | gh | `/gh` | GitHub operations |
| mcp-builder | mcpb | `/mcpb` | MCP server development |
| godot-gdscript-patterns | ggp | `/ggp` | GDScript best practices |
| systematic-debugging | sd | `/sd` | Debug workflow |
| test-driven-development | tdd | `/tdd` | TDD methodology |
| skill-creator | sc | `/sc` | Create new skills |
| loop-detection | ld | `/ld` | Loop detection |
| confident-language-guard | clg | `/clg` | Documentation guard |
| token-aware-planning | tap | `/tap` | Model-task matching |
| create-plan | cp | `/cp` | Implementation planning |
| godot-dev | gd | `/gd` | Godot development |

**Deleted:** 3 unused skills (skill-gap-finder, blocked-and-escalating, verification-before-completion)

**Benefit:** Faster skill invocation (`/gd` vs `/godot-dev`), cleaner command interface

---

## 3. Document Index Protocol and Repository Cleanup

### Document Index System

**Reference:** `docs/agent-instructions/reference/REPOSITORY_DOCUMENT_INDEX.md`

**Key Principle:** Centralized location for all agent instructions
- `docs/` - Documentation hub
- `docs/agent-instructions/` - **START HERE** for agent instructions
- `.claude/skills/` - 12 active skills (renamed)
- `tests/` - Test suites (HLC and HPV)

### Documentation Cleanup Performed

Created **comprehensive cleanup plan** addressing:
- 49+ references to deleted `beta_mechanical_test.gd` across 15+ files
- 3 references to deleted `January_Playtest_Walkthrough_jwp.md`
- Multiple obsolete Quest 2 documents
- Duplicate skills directories

**Files Updated:**
- Scripted playthrough tests removed; use MCP/manual HPV by default
- Documentation across 15+ files updated to remove stale references

---

## 4. Cardinal Rules: HLC vs HPV

**CRITICAL DISTINCTION ESTABLISHED:**

### HLC Limitations

HLC can tell you **IF** something broke, but **NOT WHY** the human experience is broken.

**Example:**
- HLC logs: "Dialogue timeout error"
- HPV inspection: "dialogue_box.visible=false when it should be true"

### When to Use Each

**Use HLC For:**
- Quest flag progression
- Inventory state changes
- Save/load data integrity
- Crafting recipe logic
- Fast regression testing

**Use HPV For:**
- Minigame UI visibility and clarity
- Dialogue text readability
- Crafting pattern display
- UI element positioning and contrast
- Animation timing and responsiveness
- Overall human experience

### Programmatic HPV

**Key Insight:** Agents can validate UX using HPV (headed mode) with MCP runtime inspection during a real playthrough:

```powershell
Godot*.exe --path . --remote-debug tcp://127.0.0.1:6007
```

**Capabilities:**
- Check `dialogue_box.visible` programmatically
- Verify `minigame_node != null`
- Capture screenshots
- Print game variables, UI flags, node properties
- Report findings in structured format

**The Limitation:** HLC does not capture visual state. Use HPV with MCP/manual input.

---

## 5. Related Documents

### Testing Methodology

- **`docs/testing/GODOT_TOOLS_GUIDE.md`** - Complete Godot Tools extension guide
  - Cardinal Rules section (lines 383-446)
  - Debugger configuration and usage
  - HLC vs HPV testing workflow

- **`tests/visual/playthrough_guide.md`** - HPV flow reference for manual/MCP playthroughs

### Agent Instructions

- **`docs/agent-instructions/reference/REPOSITORY_DOCUMENT_INDEX.md`** - Document index protocol
- **`docs/agent-instructions/reference/skills-catalog.md`** - Skills catalog (needs update for renamed skills)

### Project Status

- **`docs/execution/ROADMAP.md`** - Current phase (6.75 - Content Expansion)
- **`docs/REPOSITORY_STRUCTURE_CATALOG.md`** - Complete repository catalog

---

## 6. Key Achievements

1. **Established Testing Hierarchy:** HPV is the preferred path for playtesters
2. **Skills Optimization:** 12 skills renamed to short initials, 3 deleted
3. **Documentation Standardized:** Document index protocol, cleanup of 49+ stale references
4. **Scripted Playthrough Tests Removed:** HPV now defaults to MCP/manual playthrough
5. **Godot Tools Integration:** Full debugger workflow established for HPV

---

## 7. Impact on Development

**Before This Chat:**
- Confusion between HLC and HPV testing
- Skills with long names inefficient to invoke
- 49+ references to deleted test files
- No clear testing hierarchy

**After This Chat:**
- ✅ Clear 4-level testing taxonomy
- ✅ Skills renamed: `/gd`, `/gbp`, `/tap`, etc.
- ✅ Documentation cleaned and indexed
- Scripted playthrough tests removed; HPV uses MCP/manual playthrough
- ✅ Cardinal rules established for testing methodology

**Bottom Line:** Future agents now have clear guidance on when to use HPV vs HLC, efficient skill system, and centralized documentation. The testing paradox (headless tests passing while game is unplayable) is now explicitly addressed with the HPV playability validation requirement.

---

## Quick Commands Reference

```powershell
# Run HLC (headless logic checks)
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd

# Run dialogue tests
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/phase3_dialogue_flow_test.gd

# Run minigame tests
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/phase3_minigame_mechanics_test.gd

# Run HPV (headed playability validation)
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --path .
```

## Skills Quick Reference

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/gd` | Godot development | Creating/modifying scenes, nodes, GDScript |
| `/ggp` | GDScript patterns | Code organization, performance, best practices |
| `/sd` | Systematic debugging | Any error, bug, or unexpected behavior |
| `/tdd` | Test-driven development | Before writing new features |
| `/tap` | Token-aware planning | Model-task matching for complex work |
| `/cp` | Create plan | Multi-step feature implementation |
| `/gbp` | Git best practices | Commits, branches, history |
| `/gh` | GitHub operations | Issues, PRs, CI/CD |
| `/mcpb` | MCP server building | Tool integration |
| `/sc` | Skill creation | Extend Claude capabilities |
| `/ld` | Loop detection | Repeated errors or failed approaches |
| `/clg` | Documentation guard | Prevent overconfident language |

---

## Agent Best Practices

### File Discovery (CRITICAL)
- **ALWAYS** list a directory (`ls` or `Glob`) before reading files from it
- If a file doesn't exist, report it - **do NOT guess 10+ filename variations**
- After 3 identical read errors, **STOP and ask user** for the correct path
- Never assume documentation files exist based on naming patterns

### Task Scoping
- If a task is unclear, ask 1-2 clarifying questions **BEFORE** starting work
- Don't create new files unless explicitly needed for the task
- Answer questions directly - don't over-engineer responses
- When asked to "test" or "evaluate" something, propose a simple approach first

### Error Recovery
- Same error 3+ times in a row = **stop and reassess your approach**
- If user says "stop" = **actually stop immediately**, explain what happened
- When stuck, explain what you tried and ask for help
- Don't repeat failed actions hoping for different results

### Communication
- If you're about to try something that failed before, say so first
- Report what files/resources you found, not what you expected to find
- When uncertain, ask - don't guess repeatedly

### Local Git Hook (Optional)
- This repo includes `.githooks/post-commit` to auto-commit Godot `.uid` files after a normal commit.
- In a fresh clone, you can enable it with: `git config core.hooksPath .githooks`.
- If the hook is not enabled, `.uid` files may remain unstaged and need manual staging.

[Codex - 2026-01-09]
[Codex - 2026-01-12]
