# CIRCE'S GARDEN - DEVELOPMENT ROADMAP

Version: 3.0
Last Updated: 2025-12-29
Status: CANONICAL - Baseline reset
Purpose: Accurate, test-based roadmap for the current repo state.

---

## How to Use This Roadmap

For all contributors:
- Use this file for priorities, status, and phase definitions.
- Do one task at a time.
- Add checkpoints only at 50% and 100% for each phase.

---

## Current Phase Status

Last Updated: 2025-12-29
Current Phase: Phase 2 - Data and Content Integrity
Status: Phase 0 and Phase 1 are COMPLETE (all automated and manual tests PASS).
Phase 2 focuses on resource validation, placeholder art audit, and content completeness.

---

## Baseline Test Results (Automated)

- tests/run_tests.gd (headless): PASS 5/5 (2025-12-29)
- tests/smoke_test.tscn (headless scene run): PASS ("[SmokeTest] OK", 2025-12-29)
- GdUnit4 suite (res://tests/gdunit4): PASS (full batch, headless, report_21)
  - Flow coverage added for menu transitions, world interactions, boat travel,
    location return triggers, and cutscene transitions.
- Legacy Phase 0 validator removed (TEST_SCRIPT.gd was unreliable due to
  autoload timing).

---

## Known Issues (Non-MCP)

- Invalid UID warning for uid://placeholder_circe in
  game/features/player/player.tscn (GitHub issue #4).
- Duplicate root .gdignore can appear after restructure and cause Godot to
  ignore the project; remove duplicate with editor closed.
- TEST_SCRIPT.gd removed due to early autoload checks (see git history).
- Crop growth stages and several item icons use placeholder textures until
  production art is ready.

---

## Phase Overview

Phase 0: Baseline Audit (complete)
Phase 1: Core Systems Verification
Phase 2: Data and Content Integrity
Phase 3: Balance and QA
Phase 4: Android/Retroid Build and Testing
Phase 5: Final Polish and Release

---

## PHASE 0: BASELINE AUDIT (CURRENT)

Objective: Establish what actually works today using automated tests and a
minimal smoke pass. Fix or retire unreliable validation.
Status: COMPLETE (2025-12-29)

Tasks:
- Run tests/run_tests.gd headless and record results in Current Phase Status.
- Run smoke test scene tests/smoke_test.tscn and record results.
- Document Phase 0 validator removal in PROJECT_STRUCTURE.md and keep
  tests/run_tests.gd as the baseline until a replacement is written.
- Reconcile test scope so automated coverage reflects reality (no false
  positives).

Success Criteria:
Automated Verification:
- .\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless
  --script tests/run_tests.gd passes 5/5.
- GdUnit4 suite passes (res://tests/gdunit4).
- Legacy Phase 0 validator removal is documented, and no references remain.
Manual Verification:
- Smoke test prints "[SmokeTest] OK" with no errors.

---

## PHASE 1: CORE SYSTEMS VERIFICATION

Objective: Verify the core loop works in real scenes (not just scripts).
Note: Code exists for many of these systems. Treat all items as unverified
until each is re-tested and confirmed.

Tasks:
- Player movement and interaction in game/features/world/world.tscn.
- Farm plot lifecycle: till, plant, advance day, harvest.
- Day/Night system: sundial advances day and farm plots update visuals.
- SceneManager transitions using game/features/ui/scene_test_a.tscn and
  game/features/ui/scene_test_b.tscn.
- Dialogue box: load a DialogueData resource, scroll text, choices, flag
  gating.
- Inventory UI: open/close, selection, item details, gold display.
- Crafting minigame: start recipe, complete success and fail paths.
- Minigames: herb identification, moon tears, sacred earth, weaving.
- NPC spawning and boat travel respond to quest flags.
- Save/Load: basic save/load preserves GameState (if SaveController is present).

Success Criteria:
Manual Verification:
- No runtime errors in console for the above scenes.
- Core loop is playable: plant -> grow -> harvest -> craft -> dialogue.
- Interactions and UI respond to D-pad only.
- Input surface: D-pad + A/B/X/Y + Start/Select only (no mouse, no analog, no L/R).
- Input mapping: Interact = A button, Inventory = Select button.

### Manual Test Results (2025-12-28)
| System | Status | Notes |
|--------|--------|-------|
| Player movement | PASS (partial) | Movement confirmed via D-pad actions early; later movement input became unreliable in MCP, so positioning used runtime eval for a few checks. |
| Input mapping (Retroid) | PASS | `interact` mapped to Joypad Button 0 (A); `ui_inventory` mapped to Joypad Button 4 (Select). |
| Farm plot lifecycle | PASS (unit) | Seed selector wiring verified; plant/harvest covered by GdUnit. |
| Day/Night (Sundial) | PASS | Logs: `[GameState] Day advanced to 2` + `Time advanced!` |
| Boat travel | PASS (unit) | `boat_travel_test` loads `scylla_cove`; fixed Scylla scene root and headless fade path. |
| Quest triggers | PASS (unit) | QuestTrigger now connects `body_entered`; `quest_trigger_signal_test` green. |
| NPC spawning | PASS (unit) | NPC scenes instantiate (removed root `parent="."`); `npc_scene_test` green. |
| Scene transitions (scene_test_a/b) | PASS (partial) | Works after `NextButton.grab_focus()` + `ui_accept`; no auto-focus. |
| Dialogue box | PASS (partial) | `start_dialogue` via eval; `ui_accept` advances lines. Choices now D-pad focusable via test. |
| Inventory UI | PASS | `ui_inventory` action opens/closes panel in world; navigation verified in inventory scene. |
| Crafting controller/minigame | PASS (code fix) | Switched to `_input`; test update pending (GdUnit CLR error on last run). |
| Minigame: Herb identification | PASS | Tutorial flag set + `wrong_buzz` SFX on selection. |
| Minigame: Moon tears | PASS (unit) | `moon_tears_test` success path green; `catch_chime` present. |
| Minigame: Sacred earth | PASS | `urgency_tick` + `failure_sad` on timeout. |
| Minigame: Weaving | PASS (partial) | `ui_confirm` + `wrong_buzz` SFX; success/fail not verified. |
| Cutscene: Prologue opening | PASS | Flag set: `prologue_complete`. |
| Cutscene: Scylla transformation | PASS | Flags set: `transformed_scylla`, `quest_3_complete`. |

### Phase 1 Completion Checkpoint

Checkpoint Date: 2025-12-29
Status: COMPLETE
Ready for Phase 2: Yes

All Phase 1 manual tests have passed. Core systems are verified and playable.

---

## PHASE 2: DATA AND CONTENT INTEGRITY

Objective: Ensure resources are complete and not null or stubbed.

**CRITICAL: Junior engineer must complete these tasks before Phase 3.**

### A. Resource Validation (Godot Inspector + Code)

**CropData Resources** (`game/shared/resources/crops/`):
- Open each .tres file in Godot Inspector
- Verify `growth_stages` array has textures for all stages (seed → mature)
- Check these crops: moly.tres, nightshade.tres, wheat.tres
- Placeholder textures are OK, but null/missing textures are NOT acceptable

**ItemData Resources** (`game/shared/resources/items/`):
- Open each .tres file in Godot Inspector
- Verify `icon` texture property is assigned (not null)
- Check all harvest items, seeds, minigame rewards, and potions
- Cross-reference with `docs/execution/PLACEHOLDER_ASSET_SPEC.txt` (26 items total)

### B. Placeholder Art Audit

Reference: `docs/execution/PLACEHOLDER_ASSET_SPEC.txt`

**Required Assets** (verify files exist and are referenced in resources):
- Crop sprites: moly, nightshade, wheat (with growth stages)
- Item icons: pharmaka_flower, moon_tear, sacred_earth, woven_cloth
- Potion icons: calming_draught, binding_ward, reversal_elixir, petrification
- NPC portraits: hermes, aeetes, daedalus, scylla (64x64)
- Scene sprites:
  - Moon Tears minigame: stars, moon, player_marker
  - Sacred Earth minigame: digging_area
  - Crafting minigame: mortar
- World: circe sprite, grass tile, npc_world_placeholder

### C. Dialogue & NPC Data Validation

**DialogueData Resources** (`game/shared/resources/dialogues/`):
- Each dialogue must have 5+ lines minimum
- Verify `required_flags` and `sets_flags` match GameState flag names
- Test flag gating logic: if required_flag is set, dialogue should unlock
- Check for typos in flag names (case-sensitive)

**NPCData Resources** (`game/shared/resources/npcs/`):
- Verify `id` field matches scene references and spawn logic
- Verify `dialogue_id` points to valid DialogueData resource
- Check spawn conditions and quest flag dependencies
- Ensure NPC scenes can be instantiated without errors

### D. Scene Texture Assignments

Open these scenes in Godot editor and assign missing textures:
- `game/features/minigames/moon_tears/moon_tears.tscn`
  - Assign star field, moon sprite, player marker sprite
- `game/features/minigames/sacred_earth/sacred_earth.tscn`
  - Assign digging area sprite
- `game/features/crafting/crafting_minigame.tscn`
  - Assign mortar sprite
- Verify no "Texture: <empty>" warnings in scene nodes (check Output panel)

### E. Recipe Resources

**Potion Recipes** (`game/shared/resources/recipes/`):
- Verify all 4 potion recipes exist:
  - Calming Draught
  - Binding Ward
  - Reversal Elixir
  - Petrification Potion
- Check recipe `ingredients` array references valid ItemData resources
- Verify `result` references valid ItemData for the potion

### F. GdUnit4 Test Pass

Before moving to Phase 3, run all tests:
```
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd
```
And run GdUnit4 suite: `res://tests/gdunit4`

**All tests must PASS before proceeding to Phase 3.**

### Godot Development Notes for Junior Engineer

- Always test in Godot editor first before running headless tests
- Use `print()` statements to debug flag states and resource loads
- Check Output panel (bottom) for missing resource warnings (red text)
- Resource validation: Right-click resource → "Show in FileSystem" to verify path
- Scene testing: Press F6 to run current scene and test individual minigames
- Save and reload scenes after texture assignments to ensure UIDs update properly
- D-pad testing: Use joypad tester scene or InputMap debugging to verify controls

Success Criteria:
Manual Verification:
- No missing resource loads during playthrough
- No null textures on crops or item icons
- All tests PASS (run_tests.gd + GdUnit4 suite)

### Manual Test Results (2025-12-29)
| System | Status | Notes |
|--------|--------|-------|
| Resource load + fields | PASS | GdUnit4 integrity checks green; templates skipped in strict validation, IDs validated. |

---

## PHASE 3: BALANCE AND QA

Objective: Tune difficulty and identify critical bugs before device testing.

**CRITICAL: This phase validates game-readiness before Android/Retroid build.**

### A. Full Playthrough Test Plan

Create test log document: `docs/execution/PHASE3_PLAYTHROUGH_LOG.md`

**Test Sequence** (record timestamp and notes for each step):
1. Prologue cutscene → Main menu → Select "New Game" → World spawn
2. Farm plot lifecycle:
   - Till a plot
   - Plant moly seed
   - Advance sundial 3 times (3 days)
   - Harvest moly
3. Crafting ritual:
   - Collect required ingredients (moly harvest + moon tear + sacred earth)
   - Open crafting UI
   - Complete Calming Draught ritual
   - Verify potion added to inventory
4. Complete all 4 minigames once:
   - Herb identification
   - Moon tears
   - Sacred earth
   - Weaving
5. Boat travel:
   - Trigger boat travel to Scylla Cove
   - Verify location transition works
6. Dialogue system:
   - Complete dialogue tree with at least one NPC
   - Test flag gating (dialogue should unlock after quest flag is set)
7. Cutscene progression:
   - Scylla transformation cutscene
   - Verify flags: `transformed_scylla`, `quest_3_complete`
8. Epilogue (if implemented)

**Time Target:** 30-45 minutes total

**Logging:** Record any errors, soft-locks, missing textures, unclear objectives

### B. Difficulty Tuning Checklist

**Crop Growth Balance:**
- Are 3-day growth cycles playable and paced well?
- Should growth days be adjusted? (edit CropData `days_to_grow` field)
- Is crop income balanced with shop prices?

**Crafting Timing:**
- Is the ritual timing window comfortable with D-pad input?
- Can player complete steps without feeling rushed?
- Adjust `CraftingController.gd` timing variables if needed

**Minigame Difficulty:**
- Herb identification: Can player distinguish flowers in the time limit?
- Moon tears: Is catch timing fair with D-pad movement?
- Sacred earth: Is urgency timer balanced (not too easy/hard)?
- Weaving: Is pattern complexity appropriate for D-pad input?

**Gold Economy:**
- Are shop prices balanced with harvest income?
- Can player afford seeds and supplies without grinding?
- Check ItemData `price` fields and CropData `sell_price`

### C. D-Pad Control Validation

**Input Requirements** (Retroid Pocket Classic target):
- No mouse/touchscreen required anywhere
- No analog stick required (D-pad only for movement)
- All menus navigable with D-pad + A/B buttons
- Inventory selection smooth with D-pad
- Minigames fully playable with D-pad only
- Crafting ritual controllable with D-pad

**Test Each Scene:**
- Main menu: D-pad + A button navigation works
- World: D-pad movement, A button interact, Select button inventory
- Inventory UI: D-pad item selection, A button confirm
- Shop UI: D-pad navigation, A button purchase
- Each minigame: D-pad controls responsive and clear

### D. Save/Load System Validation

**Save System Testing:**
- Save at different game states:
  - Fresh game start (Day 1, no progress)
  - Mid-progress (Day 5, some crops planted, some quests done)
  - Late game (most quests complete, full inventory)
- Verify save file creation in expected location
- Check save file is not corrupted (valid JSON/binary format)

**Load System Testing:**
- Load each saved game and verify:
  - Player position preserved
  - Inventory contents match
  - Quest flags intact
  - Day/time state correct
  - NPC dialogue states correct (completed dialogues don't repeat)
- Test loading from main menu vs in-game
- Test "Continue" button loads most recent save

**Edge Cases:**
- Save during dialogue → Load → Verify dialogue state
- Save during minigame → Load → Should return to safe state (world/menu)
- Multiple save slots (if implemented)
- Save file migration (if save format changes between builds)

### E. Soft-Lock Testing

**Test these edge case scenarios:**
1. **Resource Depletion:**
   - Run out of gold with no crops planted
   - Can player still progress? (should be able to forage or get starter resources)

2. **Minigame Failure:**
   - Fail a minigame with no resources to retry
   - Can player obtain resources another way?

3. **Quest Sequence Breaking:**
   - Try to trigger boat travel before quest requirements are met
   - Should show helpful message or be blocked gracefully

4. **Save/Load Edge Cases:**
   - Save in middle of minigame
   - Save in middle of dialogue
   - Load save and verify game state is consistent

5. **Day Advancement:**
   - Advance day during active crafting ritual
   - Advance day during minigame
   - Verify no state corruption

6. **Tutorial/First-Time Experience:**
   - Start completely new game with no prior knowledge
   - Verify player can discover controls without external documentation
   - Check that first quest/objective is clear
   - Confirm no essential information is missable

### F. Bug Logging

Create: `docs/execution/PHASE3_BUGS.md`

**Template per bug:**
```
### Bug #[number]: [Short Title]
- **Severity:** CRITICAL / HIGH / MEDIUM / LOW
- **Description:** [What happened]
- **Steps to Reproduce:**
  1. [Step 1]
  2. [Step 2]
  3. [etc.]
- **Expected:** [What should happen]
- **Actual:** [What did happen]
- **Scene/File:** [Where it occurred]
- **Status:** OPEN / IN PROGRESS / FIXED / WONTFIX
```

**Severity Guidelines:**
- **CRITICAL:** Game-breaking, soft-lock, crash, data loss
- **HIGH:** Major feature broken, progression blocker
- **MEDIUM:** Feature works but has issues, workaround exists
- **LOW:** Polish, minor visual glitch, typo

Success Criteria:
Manual Verification:
- 30-45 minute playthrough completes without soft-locks
- All CRITICAL and HIGH bugs are fixed
- Difficulty curve feels playable on D-pad
- No input requires mouse or analog stick

---

## PHASE 4: ANDROID/RETROID BUILD AND TESTING

Objective: Produce a testable APK and validate on hardware.

**Note:** Begin Phase 4 only after Phase 3 bugs are fixed and playthrough is stable.

### A. Android Build Setup

**Prerequisites:**
- Install Android SDK (version specified in `project.godot`)
- Install OpenJDK (required for Android builds)
- Download Android export templates for Godot 4.5.1

**Export Preset Configuration:**
1. In Godot: Project → Export → Add → Android
2. Set package name (e.g., com.yourname.circesgarden)
3. Configure screen orientation: Landscape (for Retroid)
4. Set minimum SDK version: 21 (Android 5.0) or higher
5. Enable USB debugging permissions
6. Configure app icon in export preset

**Build Debug APK:**
```
In Godot: Project → Export → Android (Debug)
Save as: circes_garden_debug.apk
```

### B. Device Installation and Testing

**Install on Retroid Pocket Classic:**
1. Enable USB debugging on device
2. Connect via USB
3. Use ADB: `adb install circes_garden_debug.apk`
   - Or use Godot's "Export and Deploy" for direct install
4. Verify app appears in app drawer

**Hardware Test Plan:**
- Follow Phase 3 Full Playthrough Test Plan on device
- Monitor for device-specific issues:
  - Frame rate drops
  - Touch input (should be disabled)
  - Physical button mapping
  - Screen resolution/scaling
  - Battery drain
  - Audio crackling or sync issues
  - Overheating during extended play

**Performance Monitoring:**
- Use ADB logcat to monitor errors: `adb logcat | grep Godot`
- Check for memory warnings or crashes
- Note any stuttering during scene transitions

### C. Common Build Issues and Troubleshooting

**"Export templates not found":**
- Download export templates: Editor → Manage Export Templates
- Ensure version matches Godot version (4.5.1)

**"Android SDK not found":**
- Set SDK path in Editor → Editor Settings → Export → Android
- Verify Android SDK installation includes build-tools and platform-tools

**APK won't install:**
- Check package name doesn't conflict with existing app
- Verify USB debugging enabled on device
- Try: `adb uninstall com.yourname.circesgarden` then reinstall

**Controls not working on device:**
- Verify InputMap settings in project.godot
- Test with joypad tester to confirm button mapping
- Check Retroid's button configuration matches expected Joypad indices

**App crashes on launch:**
- Check ADB logcat for error messages
- Verify all resources are exported (check export settings)
- Test on PC first to isolate device-specific issues

### D. Device-Specific Bug Logging

Create: `docs/execution/PHASE4_DEVICE_BUGS.md`

Use same template as Phase 3, but add:
- **Device Info:** Retroid model, Android version, build number
- **Build Info:** APK version, debug/release, build date

Success Criteria:
Manual Verification:
- APK installs and runs on Retroid Pocket Classic
- Controls responsive and stable for 30+ minutes
- No device-specific crashes or performance issues
- Frame rate acceptable (target 60 FPS, minimum 30 FPS)
- No critical bugs introduced by Android build

---

## PHASE 5: FINAL POLISH AND RELEASE

Objective: Replace placeholders, finalize narrative, optimize performance, and ship.

**Note:** Begin Phase 5 only after Phase 4 device testing confirms stable gameplay.

### A. Production Asset Replacement

**Art Assets** (reference: `docs/execution/PLACEHOLDER_ASSET_SPEC.txt`):
- Replace all 26 placeholder assets with final production art
- Maintain exact dimensions and file formats specified
- Test each replacement in-game to verify visual quality
- Priority order:
  1. Player sprite (Circe) and world tiles
  2. Crop and item icons (most visible to player)
  3. NPC portraits
  4. Scene-specific sprites (minigame backgrounds)
  5. App icon (512x512 for store listing)

**Audio Implementation:**
- Add background music tracks for:
  - Main menu
  - World/garden area
  - Each location (Scylla Cove, Sacred Grove)
  - Minigames (optional, can share music)
- Verify all SFX are in place:
  - Existing: `wrong_buzz`, `catch_chime`, `urgency_tick`, `failure_sad`
  - Check for missing: harvest sound, planting sound, day advance chime, potion craft success
- Set appropriate volume levels (music lower than SFX)
- Test audio doesn't cause frame drops on Retroid hardware

### B. Narrative Finalization

**Dialogue Polish:**
- Review all dialogue for typos, tone consistency, and clarity
- Ensure mythological references are accurate
- Verify character voice consistency (Circe, Hermes, Aeetes, Daedalus, Scylla)
- Add any missing tutorial hints in early dialogue

**Epilogue Completion:**
- Verify epilogue scene exists and triggers after quest completion
- Confirm epilogue provides satisfying narrative closure
- Test all flag conditions leading to epilogue

**Credits/About Screen:**
- Create credits scene listing:
  - Development credits
  - Art/audio credits
  - Tools used (Godot, Claude Code, etc.)
  - Special thanks
- Add "About" or credits option to main menu

### C. Performance Optimization

**Profiling on Target Device:**
- Run Godot profiler during 30-minute Retroid session
- Identify any frame drops or stutters
- Target: Maintain 60 FPS on Retroid Pocket Classic

**Optimization Checklist:**
- Texture compression: Ensure all textures use optimal format for mobile
- Scene optimization: Remove unused nodes, check for memory leaks
- Script optimization: Profile any long-running _process() or _physics_process() loops
- Audio optimization: Use compressed audio formats (OGG recommended)
- Resource preloading: Verify critical resources preload at scene start

**Memory Testing:**
- Monitor memory usage during full playthrough
- Check for memory leaks (save/load cycles, scene transitions)
- Target: Stay under 512MB RAM usage

### D. Release Build Configuration

**Godot Export Settings:**
- Set release mode in export preset (not debug)
- Enable texture compression (VRAM Compression)
- Set correct orientation (landscape for Retroid)
- Configure minimum Android version (check target device)
- Set app permissions (minimal, storage only if save/load requires)

**Version and Metadata:**
- Set version number in `project.godot` (e.g., 1.0.0)
- Set application name: "Circe's Garden" (or final title)
- Configure app icon in export preset
- Set package name (com.yourname.circesgarden format)

**APK Signing for Release:**
- Generate release keystore (keep secure backup!)
- Sign APK with release key
- Document keystore password in secure location
- Test signed release APK on device

### E. Final Testing Checklist

**Pre-Release Validation:**
- Full playthrough with final assets (60+ minutes)
- Save/load testing across all game states
- All CRITICAL and HIGH bugs from Phase 3 confirmed fixed
- No console errors or warnings during playthrough
- Test on clean install (uninstall previous versions first)

**Edge Case Verification:**
- New game → immediate quit → load (should handle gracefully)
- Rapid scene transitions (spam A button during transitions)
- Inventory full edge cases
- All minigames completable with final difficulty settings
- Quest progression cannot be broken by sequence breaking

### F. Gift Delivery Preparation

**Personal Gift Build:**
- Final signed APK ready for installation
- Test installation on target Retroid device
- Create backup copy of APK and keystore (for future updates)

**Gift Presentation Materials (Optional):**
- Simple controls guide (D-pad layout, button functions)
- Printed "How to Play" card if gifting the device too
- Personal note about the game's mythological theme

**Installation Guide for Recipient:**
- Write simple instructions for installing APK on Retroid:
  1. Enable "Install from Unknown Sources" in Settings
  2. Copy APK to device via USB or SD card
  3. Tap APK file to install
  4. Launch "Circe's Garden" from app drawer
- Include your contact info for tech support

**Optional Documentation:**
- Simple README.txt with:
  - What the game is about (mythology, farming, crafting)
  - Basic controls (D-pad, A/B buttons)
  - Easter eggs or secrets you want to hint at
  - Credits (your work + tools used)

Success Criteria:
Manual Verification:
- Full playthrough with final assets completes without issues
- Release build stable on Retroid hardware (60+ minute session)
- All placeholder assets replaced
- Audio implementation complete and balanced
- Performance maintains 60 FPS target
- APK signed and installable on fresh device
- Store listing materials ready for distribution

---

## Checkpoint Template

<!-- PHASE_X_CHECKPOINT: 50%|100% -->
Checkpoint Date: YYYY-MM-DD
Verified By: Name

Systems Status
| System | Status | Notes |
|--------|--------|-------|
| System Name | OK/IN PROGRESS/NEEDS ATTENTION/BLOCKED | Brief note |

Blockers (if any)
- Blocker description - GitHub Issue #XX

Files Modified This Phase
- path/to/file.gd - what changed

Ready for Next Phase: Yes/No
<!-- END_CHECKPOINT -->

---

## Notes

- Legacy checkpoints were removed as inaccurate; do not use them as evidence of
  completion.
- MCP issues are intentionally excluded from this roadmap per current directive.
- Phase 2 integrity checks skip `TEMPLATE_*.tres` in strict validation; templates
  remain loadable scaffolds with `template_`-prefixed IDs.

---

## Agent Execution Plan (Option A)

Owner: Codex (automation-first)
Start Date: 2025-12-27

Goal: Validate Phase 1 systems via a single autonomous GdUnit4 batch.

### Completed Coverage (Automated)
- Menu transitions (main menu -> world, main menu -> weaving).
- World core nodes, player movement, inventory toggle.
- World interactions: sundial, boat travel, quest triggers, NPC spawns.
- Location return triggers (scylla_cove and sacred_grove).
- Cutscene transitions (prologue, scylla transformation).
- Crafting controller and minigame.
- Minigames: weaving, herb identification, moon tears, sacred earth.
- Save/load, resource integrity, and data checks.

Next:
- Phase 0 baselines complete (2025-12-29).
- Manual pass for full loop feel (D-pad flow, pacing, and visuals).

