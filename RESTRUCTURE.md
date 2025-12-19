# RESTRUCTURE.md - Repo Restructure Plan (Hera's Garden v2)

This file is the executable restructure plan for Codex or any engineer. Follow it in order. Do not skip validation steps. Use `git mv` for all moves to preserve history.

Key rules:
- Close the Godot editor before any file moves.
- Move one feature at a time, commit after each step.
- Do not edit `project.godot` until Phase 4.
- If anything breaks, use the rollback steps.

---

## Phase 1: Add .gdignore files

Add empty `.gdignore` files to prevent Godot from importing non-game directories:
- `docs/`
- `_docs/`
- `reports/`
- `tools/` (create if needed)

---

## Phase 2: Move docs out of root

Create this structure and move files:

```
docs/
  overview/
    README.md (create - docs landing page)
    docs/overview/DOCS_MAP.md (move from root)
  design/
    docs/design/Storyline.md (move from root)
    docs/design/CONSTITUTION.md (move from root)
    docs/design/SCHEMA.md (move from root)
  execution/
    docs/execution/PROJECT_STATUS.md (move from root)
    docs/execution/ROADMAP.md (move from root)
```

Keep in root:
- README.md
- LICENSE (if present)
- project.godot
- icon.svg
- .gitignore
- agent.md

After moving docs:
- Update `docs/overview/DOCS_MAP.md` with the new locations.

---

## Phase 3: Reorganize game content (feature-based) - HIGH RISK

Target structure:

```
game/
  features/
    player/
      player.tscn
      player.gd
    farm_plot/
      farm_plot.tscn
      farm_plot.gd
    world/
      world.tscn
    ui/
      main_menu.tscn + main_menu.gd
      dialogue_box.tscn + dialogue_box.gd
      debug_hud.tscn + debug_hud.gd
  shared/
    resources/ (all .tres data files)
  autoload/
    game_state.gd
    save_controller.gd
    scene_manager.gd
    audio_controller.gd
    constants.gd
```

### Critical safety rules

Do not:
- Move all files at once.
- Skip testing between moves.
- Edit `project.godot` yet.
- Use `mv` instead of `git mv`.
- Move files while Godot is open.
- Forget to update `.tscn` script paths.

Do:
- Create one folder at a time.
- Move one feature at a time.
- Test after each move.
- Use `git mv` for everything.
- Commit after each successful move.

Escape hatch:
- If anything breaks: `git reset --hard HEAD`

### Phase 3.1: Create folder structure (safe)

```bash
# Close Godot editor first
cd /c/Users/Sam/Documents/GitHub/v2_heras_garden

mkdir -p game/features/player
mkdir -p game/features/farm_plot
mkdir -p game/features/world
mkdir -p game/features/ui
mkdir -p game/shared/resources
mkdir -p game/autoload
```

Validation:

```bash
ls -la game/
ls -la game/features/
```

Commit:

```bash
git add game/
git commit -m "chore: create game folder structure for reorganization"
```

### Phase 3.2: Move autoload scripts (medium risk)

Pre-check:

```bash
ls -la src/autoloads/
ls -la src/core/
```

Move commands (one at a time):

```bash
git mv src/autoloads/game_state.gd game/autoload/game_state.gd
git status

git mv src/autoloads/save_controller.gd game/autoload/save_controller.gd
git status

git mv src/autoloads/scene_manager.gd game/autoload/scene_manager.gd
git status

git mv src/autoloads/audio_controller.gd game/autoload/audio_controller.gd
git status

git mv src/core/constants.gd game/autoload/constants.gd
git status
```

Validation:

```bash
ls -la game/autoload/
git status
```

Commit:

```bash
git commit -m "refactor: move autoload scripts to game/autoload/"
```

Note: Do not open Godot yet. Autoload paths are now broken until Phase 4.

### Phase 3.3: Move player feature (high risk)

Pre-check:

```bash
ls -la scenes/entities/player.tscn
ls -la src/entities/player.gd
```

Move files:

```bash
git mv src/entities/player.gd game/features/player/player.gd
git status

git mv scenes/entities/player.tscn game/features/player/player.tscn
git status
```

Fix `.tscn` reference:

Open `game/features/player/player.tscn` and replace:

```
[ext_resource type="Script" path="res://src/entities/player.gd" id="..."]
```

with:

```
[ext_resource type="Script" path="res://game/features/player/player.gd" id="..."]
```

Validation:

```bash
grep "player.gd" game/features/player/player.tscn
```

Commit:

```bash
git add game/features/player/player.tscn
git commit -m "refactor: move player to game/features/player/"
```

Optional test:

```bash
godot --editor --quit game/features/player/player.tscn
```

### Phase 3.4: Move farm_plot feature (medium risk)

Pre-check:

```bash
ls -la scenes/entities/farm_plot.tscn
ls -la src/entities/farm_plot.gd
```

Move files:

```bash
git mv src/entities/farm_plot.gd game/features/farm_plot/farm_plot.gd
git mv scenes/entities/farm_plot.tscn game/features/farm_plot/farm_plot.tscn
```

Fix `.tscn` reference:

Replace:

```
[ext_resource type="Script" path="res://src/entities/farm_plot.gd" id="..."]
```

with:

```
[ext_resource type="Script" path="res://game/features/farm_plot/farm_plot.gd" id="..."]
```

Validation:

```bash
grep "farm_plot.gd" game/features/farm_plot/farm_plot.tscn
```

Commit:

```bash
git add game/features/farm_plot/farm_plot.tscn
git commit -m "refactor: move farm_plot to game/features/farm_plot/"
```

### Phase 3.5: Move world scene (high risk)

Move file:

```bash
git mv scenes/world.tscn game/features/world/world.tscn
```

Fix `.tscn` references:

Search and replace old paths:

```bash
grep "res://scenes/" game/features/world/world.tscn
grep "res://src/" game/features/world/world.tscn
```

Common fixes:

```
[ext_resource type="PackedScene" path="res://scenes/entities/player.tscn" id="..."]
[ext_resource type="PackedScene" path="res://scenes/entities/farm_plot.tscn" id="..."]
```

Replace with:

```
[ext_resource type="PackedScene" path="res://game/features/player/player.tscn" id="..."]
[ext_resource type="PackedScene" path="res://game/features/farm_plot/farm_plot.tscn" id="..."]
```

Validation:

```bash
grep "res://scenes/entities/" game/features/world/world.tscn
grep "res://game/features/" game/features/world/world.tscn
```

Commit:

```bash
git add game/features/world/world.tscn
git commit -m "refactor: move world to game/features/world/"
```

### Phase 3.6: Move UI features (medium risk)

Do each UI scene separately and commit after each.

3.6.1 main_menu:

```bash
git mv src/ui/main_menu.gd game/features/ui/main_menu.gd
git mv scenes/ui/main_menu.tscn game/features/ui/main_menu.tscn
```

Update script path inside `game/features/ui/main_menu.tscn`:
- Old: `res://src/ui/main_menu.gd`
- New: `res://game/features/ui/main_menu.gd`

```bash
git add game/features/ui/main_menu.tscn
git commit -m "refactor: move main_menu to game/features/ui/"
```

3.6.2 dialogue_box:

```bash
git mv src/ui/dialogue_box.gd game/features/ui/dialogue_box.gd
git mv scenes/ui/dialogue_box.tscn game/features/ui/dialogue_box.tscn
```

Update script path inside `game/features/ui/dialogue_box.tscn`:
- Old: `res://src/ui/dialogue_box.gd`
- New: `res://game/features/ui/dialogue_box.gd`

```bash
git add game/features/ui/dialogue_box.tscn
git commit -m "refactor: move dialogue_box to game/features/ui/"
```

3.6.3 debug_hud:

```bash
git mv src/ui/debug_hud.gd game/features/ui/debug_hud.gd
git mv scenes/ui/debug_hud.tscn game/features/ui/debug_hud.tscn
```

Update script path inside `game/features/ui/debug_hud.tscn`:
- Old: `res://src/ui/debug_hud.gd`
- New: `res://game/features/ui/debug_hud.gd`

```bash
git add game/features/ui/debug_hud.tscn
git commit -m "refactor: move debug_hud to game/features/ui/"
```

### Phase 3.7: Move resources (low risk)

Pre-check:

```bash
ls -la resources/
```

Move entire resources folder:

```bash
git mv resources/* game/shared/resources/
git status
```

If git shows deletes, undo and retry one folder at a time:

```bash
git reset --hard HEAD

git mv resources/crops game/shared/resources/crops
git mv resources/items game/shared/resources/items
git mv resources/dialogues game/shared/resources/dialogues
git mv resources/npcs game/shared/resources/npcs
```

Commit:

```bash
git commit -m "refactor: move resources to game/shared/resources/"
```

### Phase 3.8: Clean up empty folders (safe)

Check leftover folders:

```bash
ls -la src/
ls -la scenes/
ls -la resources/
```

Remove empty directories:

```bash
rmdir src/entities src/ui src/autoloads src/core src/
rmdir scenes/entities scenes/ui scenes/
rmdir resources/crops resources/items resources/dialogues resources/npcs resources/
```

Commit:

```bash
git add -A
git commit -m "chore: remove old empty src/, scenes/, resources/ folders"
```

### Phase 3.9: Final Phase 3 validation

```bash
tree game/ -L 3
git status
```

Check for orphaned files:

```bash
find . -name "*.gd" -not -path "./game/*" -not -path "./.git/*" -not -path "./addons/*" -not -path "./tests/*" -not -path "./_docs/*"
find . -name "*.tscn" -not -path "./game/*" -not -path "./.git/*" -not -path "./addons/*" -not -path "./tests/*"
```

If validation fails, do not proceed. Fix and re-run.

---

## Phase 4: Update project.godot - CRITICAL

This step fixes autoload and scene paths. If you edit `project.godot` incorrectly, Godot will not open.

### Phase 4.0: Backup

```bash
cp project.godot project.godot.backup
ls -la project.godot.backup
```

Restore if needed:

```bash
cp project.godot.backup project.godot
```

### Phase 4.1: Read current paths

```bash
cat project.godot | grep "res://"
```

### Phase 4.2: Update autoload paths

Find `[autoload]` and replace only the paths (keep `*` and key names):

From:

```
GameState="*res://src/autoloads/game_state.gd"
SaveController="*res://src/autoloads/save_controller.gd"
SceneManager="*res://src/autoloads/scene_manager.gd"
AudioController="*res://src/autoloads/audio_controller.gd"
Constants="*res://src/core/constants.gd"
```

To:

```
GameState="*res://game/autoload/game_state.gd"
SaveController="*res://game/autoload/save_controller.gd"
SceneManager="*res://game/autoload/scene_manager.gd"
AudioController="*res://game/autoload/audio_controller.gd"
Constants="*res://game/autoload/constants.gd"
```

Validation:

```bash
grep "autoload" -A 10 project.godot
```

### Phase 4.3: Update main scene path

Find:

```
run/main_scene="res://scenes/ui/main_menu.tscn"
```

Replace with:

```
run/main_scene="res://game/features/ui/main_menu.tscn"
```

Validation:

```bash
grep "main_scene" project.godot
```

### Phase 4.4: Search for remaining old paths

```bash
grep -n "res://src/" project.godot
grep -n "res://scenes/" project.godot
grep -n "res://resources/" project.godot
```

Fix any remaining paths to the new `game/` structure.

### Phase 4.5: Validate syntax

```bash
godot --headless --quit --path .
```

If it fails:
- Check errors, then restore the backup and retry.

If it passes:

```bash
godot --editor --quit
```

### Phase 4.6: Full integration test

```bash
godot --headless --script tests/run_tests.gd
```

If any test fails:
- Test 1 failure: autoload paths wrong -> recheck `[autoload]` in `project.godot`
- Test 2 failure: resource paths wrong -> verify `game_state.gd` paths to `game/shared/resources/`
- Test 5 failure: scene script paths wrong -> recheck `.tscn` script references

If tests pass:

```bash
git add project.godot
git commit -m "refactor: update project.godot paths for new structure"

rm project.godot.backup
git add -A
git commit -m "chore: remove project.godot backup after successful migration"
```

### Phase 4.7: Final sanity check

```bash
godot --editor
```

Verify:
1. `game/` folder visible in FileSystem.
2. `game/features/player/player.tscn` opens without errors.
3. `game/features/world/world.tscn` opens with player visible.
4. Run the game (F5) and main menu loads.

---

## Phase 5: Remove bloat

- Delete `Godot_v4.5.1-stable_win64.exe/` (do not commit binaries).
- Delete `nul` and any other junk files.
- Delete any `.uid` files if not needed.

---

## Phase 6: Rename agent.md to AGENTS.md

Rename for visibility and update any references.

---

## Phase 3-4 Summary Checklist

Before marking Phase 3-4 complete:

- [ ] All `.gd` files live under `game/autoload/` or `game/features/`
- [ ] All `.tscn` files live under `game/features/`
- [ ] All `.tres` files live under `game/shared/resources/`
- [ ] Old `src/`, `scenes/`, `resources/` folders removed
- [ ] `project.godot` autoload paths updated
- [ ] `project.godot` main scene path updated
- [ ] No hits for `res://src/` in `project.godot`
- [ ] No hits for `res://scenes/` in `project.godot`
- [ ] Tests pass: `godot --headless --script tests/run_tests.gd`
- [ ] Godot editor opens without path errors
- [ ] Game runs (F5) without errors
- [ ] All changes committed
- [ ] `project.godot.backup` removed

---

## Emergency rollback procedure

If Phase 3 or 4 breaks the project:

```bash
git log --oneline -20
# Identify the commit before Phase 3 started

git reset --hard <commit-sha>
git status
```

If you need to preserve work:

```bash
git branch restructure-backup
git reset --hard <safe-commit>
# Later: git cherry-pick <commit-sha>
```

---

## Execution order

1. Phase 1: .gdignore files
2. Phase 2: Docs move
3. Phase 3: Game restructure (incremental)
4. Phase 4: project.godot updates
5. Phase 5: Cleanup
6. Phase 6: Rename

Validation after each phase:

```bash
godot --headless --script tests/run_tests.gd
```

Notes:
- Use `git mv` for all moves.
- Commit after each phase.
- Update `docs/overview/DOCS_MAP.md` after docs move.
- Update `agent.md` directory map after the restructure is complete.
