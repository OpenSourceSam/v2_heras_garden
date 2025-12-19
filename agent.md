# AGENT.md - Hera's Garden v2

First-class context for AI agents (Claude, Codex, etc.) working on this project.

---

## Quick Context

| Key | Value |
|-----|-------|
| Project | Godot 4.5 narrative farming game |
| Target | Retroid Pocket Classic (Android, 1080x1240, d-pad) |
| Phase | 1 - Core Systems |
| First Read | docs/execution/PROJECT_STATUS.md |

---

## Directory Map

```
src/
  autoloads/     → Singletons (GameState, SaveController, SceneManager)
  entities/      → Game objects (player.gd, farm_plot.gd)
  ui/            → UI scripts (dialogue_box.gd, main_menu.gd)
  core/          → Constants and utilities
  resources/     → Resource class definitions (.gd)

scenes/          → .tscn files ONLY (mirror src/ structure)
resources/       → .tres data files (crops/, items/, dialogues/, npcs/)
tests/           → Test scripts (run_tests.gd)
reports/         → Time-stamped work logs and reviews
_docs/           → Archived and supplementary docs
```

---

## Canonical Documents

Read in this order when starting:

| Priority | File | Purpose |
|----------|------|---------|
| 1 | docs/execution/PROJECT_STATUS.md | Current state, what's done, next steps |
| 2 | docs/execution/ROADMAP.md | Implementation templates with code |
| 3 | docs/design/CONSTITUTION.md | Immutable rules (TILE_SIZE=32, etc.) |
| 4 | docs/design/SCHEMA.md | Exact property names for data structures |

Other references:
- `docs/overview/DOCS_MAP.md` - Index of all documentation
- `docs/design/Storyline.md` - Full narrative (read when implementing story)
- `RESTRUCTURE.md` - Repo restructure plan (read before moving files)

---

## Execution Workflow

### Before ANY Task

```
1. Read docs/execution/PROJECT_STATUS.md
   - What phase are we in?
   - What's already done?
   - What's the next task?

2. Find task in docs/execution/ROADMAP.md
   - Locate section (e.g., 1.2.1)
   - Read the FULL subsection
   - Note the code template

3. If touching data:
   - Check docs/design/SCHEMA.md for exact property names
   - Never guess - copy/paste names
```

### During Task

```
1. ONE subsection at a time
   - Don't batch multiple tasks
   - Complete, validate, commit, then next

2. Follow template EXACTLY
   - Copy code from docs/execution/ROADMAP.md
   - Fill obvious placeholders only
   - Don't "improve" or add features

3. Validate continuously
   - Check file locations match PROJECT_STRUCTURE.md
   - Verify property names against docs/design/SCHEMA.md
   - Test in isolation before integrating
```

### After Task

```
1. Run tests
   godot --headless --script tests/run_tests.gd

2. Update docs/execution/PROJECT_STATUS.md
   - Mark task complete
   - Update progress percentage
   - Note any issues found

3. Commit with standard format

4. Report completion (see format below)
```

---

## Reporting Format

Use this format after completing any task:

```markdown
## Task [X.X.X] Complete

**Implemented:**
- [What was created/changed]
- [Be specific: "Added InteractionZone to player.tscn"]

**Files Changed:**
- path/to/file.gd (new)
- path/to/file.tscn (modified)

**Validation:**
- [x] Tests pass (5/5)
- [x] No runtime errors
- [x] Matches docs/execution/ROADMAP.md template

**Next Task:** X.X.Y - [Brief description]
```

---

## Testing Protocol

### Automated Tests

```bash
godot --headless --script tests/run_tests.gd
```

**Expected output:** All tests pass

**Current tests:**
1. Autoloads registered
2. Resource classes compile
3. TILE_SIZE constant defined
4. GameState initialization
5. Scene wiring (scripts attached)

### Manual Validation

Before committing, verify:
- [ ] File in correct location (src/ for .gd, scenes/ for .tscn)
- [ ] Property names match docs/design/SCHEMA.md
- [ ] Code matches docs/execution/ROADMAP.md template
- [ ] No TODO stubs left incomplete

---

## Commit Standards

### Format

```
<type>: <summary>

- Detail 1
- Detail 2

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: <Agent> <noreply@anthropic.com>
```

### Types

| Type | Use For |
|------|---------|
| feat | New feature or functionality |
| fix | Bug fix |
| docs | Documentation only |
| test | Test changes |
| refactor | Code restructure (no behavior change) |
| chore | Build/config changes |

### Example

```
feat: implement player interaction system

- Add InteractionZone (Area2D + CollisionShape2D) to player.tscn
- Implement _try_interact() in player.gd
- Add "interact" input action to project.godot

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```

---

## Handoff Protocol

When ending a session:

### 1. Commit All Work
```bash
git add -A
git commit -m "<type>: <summary>"
git push
```

### 2. Update docs/execution/PROJECT_STATUS.md

Include:
- What was completed
- Current progress percentage
- Next immediate task
- Any blockers or issues

### 3. Leave Clear Trail

Your work should be reviewable by reading:
1. Git log (what changed)
2. docs/execution/PROJECT_STATUS.md (current state)
3. reports/ folder (detailed work logs if applicable)

---

## Anti-Patterns

Things that have caused problems in this project:

| Don't | Do Instead |
|-------|------------|
| Implement multiple subsections at once | ONE task, validate, commit, then next |
| Guess property names | Copy from docs/design/SCHEMA.md |
| Add features not in docs/execution/ROADMAP.md | Stick to template exactly |
| Skip validation | Run tests before every commit |
| Commit without updating status | Always update docs/execution/PROJECT_STATUS.md |
| Use magic numbers | Use Constants.TILE_SIZE etc. |
| Embed scripts in .tscn | Reference scripts from src/ |
| Leave TODO stubs unmarked | Document incomplete work in status |

---

## Quick Reference

### Key Constants (from src/core/constants.gd)

```gdscript
TILE_SIZE = 32
PLAYER_SPEED = 100.0
INTERACTION_RANGE = 32
STARTING_GOLD = 100
SAVE_FILE_PATH = "user://savegame.json"
```

### Key Autoloads

```gdscript
GameState      # Central state, inventory, flags
SaveController # Save/load to disk
SceneManager   # Scene transitions
AudioController # Sound management
```

### Common Commands

```bash
# Run tests
godot --headless --script tests/run_tests.gd

# Check git status
git status

# View recent commits
git log --oneline -5
```

---

## When Stuck

1. Re-read docs/execution/ROADMAP.md section for your task
2. Check docs/design/SCHEMA.md for correct property names
3. Check docs/design/CONSTITUTION.md for rules that might apply
4. Look at existing implementations for patterns
5. Document the blocker in docs/execution/PROJECT_STATUS.md
6. Ask for clarification rather than guessing

---

End of AGENT.md
