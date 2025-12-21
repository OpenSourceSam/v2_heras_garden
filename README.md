# Circe's Garden v2

A cozy farming game for the Retroid Pocket Classic, built with Godot 4.5.1.

---

## About

**Hera, queen of the gods,** escapes the politics of Olympus to find peace in a forgotten cloud-garden. With the help of an unexpected friend, **Medusa**, she learns that true contentment comes from patience, cultivation, and simple joys.

**Playtime:** 1-2 hours
**Target Platform:** Retroid Pocket Classic (Android 14, 1240x1080 display)
**Engine:** Godot 4.5.1

---

## Project Structure


```
v2_heras_garden/
|-- docs/                         # Canonical documentation
|-- _docs/                        # Workflow and archives
|-- reports/                      # Time-stamped reports
|-- game/                         # Feature-based game structure
|   |-- autoload/                 # GameState, SaveController, etc.
|   |-- features/                 # player, farm_plot, ui, world, etc.
|   `-- shared/resources/         # .tres data files
|-- src/resources/                # Resource class scripts (legacy; still used)
|-- assets/                       # Sprites, audio, fonts
|-- tests/                        # Automated tests
|-- tools/
|-- PROJECT_STRUCTURE.md          # Source of truth for layout
|-- docs/execution/PROJECT_STATUS.md  # Current phase and progress
```

---

## For AI Agents

**If you're an AI working on this project, START HERE:**

1. **Read foundation documents:**
   - `docs/design/CONSTITUTION.md` - Immutable technical rules
   - `docs/design/SCHEMA.md` - Data structure definitions
   - `PROJECT_STRUCTURE.md` - File organization
   - `_docs/WORKFLOW_GUIDE.md` - Step-by-step guide
   - `docs/execution/PROJECT_STATUS.md` - Current phase and tasks

2. **Verify current state:**
   ```bash
   cat docs/execution/PROJECT_STATUS.md  # Check current phase
   git log --oneline -5   # Check recent commits
   ```

3. **Follow the rules:**
   - Never hardcode tile sizes (use `TILE_SIZE = 32`)
   - Always check `docs/design/SCHEMA.md` for property names
   - Verify autoloads are registered in `project.godot`
   - Test each phase before moving to next

---

## Development Phases


| Phase | Goal | Status |
|-------|------|--------|
| **Phase 0** | Foundation (docs, autoloads, structure) | Complete |
| **Phase 1** | Core Loop (plant -> grow -> harvest) | In Progress (core systems implemented; validation pending) |
| **Phase 2** | Persistence (save/load) | In Progress (scaffolding only) |
| **Phase 3** | Content (NPCs, dialogue, quests) | In Progress (scaffolding only) |
| **Phase 4** | Polish (UI, audio, balance) | Not Started |

See `docs/execution/PROJECT_STATUS.md` for detailed progress.

---

## Testing

**Run automated tests:**
```bash
godot --headless --script tests/run_tests.gd
# If `godot` isn't on PATH, use the bundled executable:
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64_console.exe --headless --script tests/run_tests.gd
```

**Manual test checklist:**
- [ ] Game launches without errors
- [ ] Player can move
- [ ] Can plant and harvest crops
- [ ] Save/load works
- [ ] No console errors

---

## Lessons Learned from V1

V1 failed due to:
1. **Autoloads not registered** in `project.godot`
2. **Property name hallucinations** (AI guessed wrong names)
3. **Empty TileMapLayers** (not painted in editor)
4. **Magic numbers** (random 16px/32px mix)
5. **Duplicate systems** (two inventories, partial migration)

V2 prevents these with:
- Pre-registered autoloads in `project.godot`
- `docs/design/SCHEMA.md` as single source of truth
- Checklist-driven development workflow
- Named constants (`TILE_SIZE = 32`)
- Complete each phase before starting next

---

## Contributing

**For AI agents:**
- Follow `_docs/WORKFLOW_GUIDE.md` step-by-step
- Never skip phases
- Always verify before assuming
- Commit after each completed step

**For humans:**
- Read `docs/design/CONSTITUTION.md` before making changes
- Follow existing patterns in `docs/design/SCHEMA.md`
- Test thoroughly before committing

---

## License

_To be determined_

---

## Credits

**Concept & Design:** AI-Original-Steak-Sauce
**Engineering:** Claude (Anthropic)
**Engine:** Godot Engine 4.5.1

---

**Status:** Phase 1 in progress - Core systems implemented; validation pending

See `docs/execution/PROJECT_STATUS.md` for current task list.
