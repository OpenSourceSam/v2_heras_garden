# PHASE 4: PROTOTYPE - Functional Completeness with Placeholders

**Version:** 2.0
**Created:** 2025-12-21
**Status:** ACTIVE
**Target:** Working prototype ready for Retroid hardware testing
**Duration:** 1.5-2 weeks

---

## Overview

Phase 4 delivers a **working prototype** with functional completeness. The goal is to get the game running on Retroid hardware for Sam's testing, using placeholder content where final assets aren't ready. This phase focuses on:

1. **Critical Blocker Fixes** - Farm plot bugs, documentation mismatches
2. **Functional Completeness** - All systems work end-to-end
3. **Placeholder Content** - Minimal dialogue, simple audio, basic art
4. **Android Build** - APK ready for Retroid testing
5. **Hardware Validation** - Sam tests on actual device

**Phase 5 will handle final polish, production assets, and release.**

---

## 4.0 - Critical Blocker Fixes

**Goal:** Fix showstopper bugs that prevent core gameplay

**Critical Issues Identified:**

### 4.0.1 - Farm Plot Seed-to-Crop ID Mapping

**Problem:** `game/features/farm_plot/farm_plot.gd:47` - plant() method uses seed_id instead of crop_id when calling GameState.get_crop_data()

**Fix:**
- Add seed-to-crop lookup logic
- CropData should have `seed_item_id` property to map back
- Update plant() to convert seed_id → crop_id before calling get_crop_data()

**Files to modify:**
- [game/features/farm_plot/farm_plot.gd](game/features/farm_plot/farm_plot.gd)
- [src/resources/crop_data.gd](src/resources/crop_data.gd) (if seed_item_id missing)

---

### 4.0.2 - Farm Plot State Synchronization

**Problem:** Farm plot state duplicated between GameState and FarmPlot nodes. Day advancement won't update visual crops.

**Fix:**
- Choose GameState as single source of truth
- Update [game/autoload/game_state.gd](game/autoload/game_state.gd:129) advance_day() to notify all FarmPlot nodes
- FarmPlot nodes should sync their visuals from GameState on day change

**Files to modify:**
- [game/autoload/game_state.gd](game/autoload/game_state.gd)
- [game/features/farm_plot/farm_plot.gd](game/features/farm_plot/farm_plot.gd)

---

### 4.0.3 - Documentation-Code Mismatch

**Problem:** Docs describe old `src/scenes/resources/` structure; code uses `game/features/`

**Fix:**
- Update [CONTEXT.md](CONTEXT.md) structure section
- Update [docs/execution/ROADMAP.md](docs/execution/ROADMAP.md) path references
- Update [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)
- Update [README.md](README.md)

---

### 4.0.4 - Missing Input Actions

**Problem:** `ui_cancel` input action referenced but not defined in project.godot

**Fix:**
- Define ui_cancel in [project.godot](project.godot) input map
- Map to Escape key and B button (Retroid cancel button)

---

### 4.0.5 - TODO Comment Cleanup

**Problem:** 8+ TODO comments in code that are already implemented (e.g., main_menu.gd)

**Fix:**
- Search codebase for all TODO/FIXME comments
- Remove completed TODOs
- For incomplete TODOs, create GitHub issue and reference in comment

---

### 4.0.6 - Placeholder Resource Icons

**Problem:** 4 new items have `icon = null`: moon_tear, sacred_earth, woven_cloth, pharmaka_flower

**Fix:**
- Create simple 32x32 colored square placeholders
- Assign to resource icon properties
- Colors: moon_tear=silver, sacred_earth=brown, woven_cloth=beige, pharmaka_flower=pink

---

### 4.0.7 - Create NPC Data Resources

**Problem:** NPCData class exists but no .tres files for 4 main NPCs

**Fix:**
- Create [game/shared/resources/npcs/hermes.tres](game/shared/resources/npcs/hermes.tres)
- Create [game/shared/resources/npcs/aeetes.tres](game/shared/resources/npcs/aeetes.tres)
- Create [game/shared/resources/npcs/daedalus.tres](game/shared/resources/npcs/daedalus.tres)
- Create [game/shared/resources/npcs/scylla.tres](game/shared/resources/npcs/scylla.tres)
- Set sprite_frames=null temporarily; dialogue_id from existing scenes

---

**Deliverables:**
- Farm plot lifecycle working end-to-end
- Documentation matches code reality
- All TODOs either implemented or removed
- Basic placeholder assets in place

**Verification:**
- Plant seed → advance day → crop grows → harvest works
- Jr Engineer can follow docs without confusion
- No console errors for missing resources

---

## 4.1 - Jr Engineer Quality Standards

**Goal:** Establish code quality guidelines to prevent anti-patterns

**Mandatory Practices for All Phase 4 Work:**

### 1. Resource Loading Validation

```gdscript
# WRONG:
var dialogue = load("res://game/shared/resources/dialogues/%s.tres" % id)

# RIGHT:
var dialogue_path = "res://game/shared/resources/dialogues/%s.tres" % id
var dialogue = load(dialogue_path)
if dialogue == null:
    push_error("Missing dialogue resource: %s" % id)
    return null
```

### 2. @onready Null Checks

```gdscript
@onready var button_start: Button = $Panel/ButtonStart
@onready var button_continue: Button = $Panel/ButtonContinue

func _ready() -> void:
    assert(button_start != null, "button_start not found in scene")
    assert(button_continue != null, "button_continue not found in scene")
```

### 3. Remove TODOs After Implementation

- If code is done, **delete the TODO**
- If code isn't done, keep TODO but add **GitHub issue reference**
- Example: `# TODO: Implement instant-text-skip (see Issue #5)`

### 4. Audio/SFX ID Validation

- Add validation helper to AudioController:
  ```gdscript
  func has_sfx(sfx_id: String) -> bool:
      return _sfx_library.has(sfx_id)
  ```
- Use before playing:
  ```gdscript
  if AudioController.has_sfx("ui_confirm"):
      AudioController.play_sfx("ui_confirm")
  ```

### 5. Magic Number Documentation

```gdscript
# WRONG:
const CATCH_WINDOW: float = 140.0

# RIGHT:
const CATCH_WINDOW: float = 140.0  # pixels from player center
```

---

## 4.2 - Dialogue (Minimal Playable)

**Goal:** Expand stub dialogues to minimal playable (5-10 lines each)

**Current State:**
- 3 of 16 dialogue files complete (prologue_opening, circe_intro, aiaia_arrival)
- 13 files are single-line stubs

**Phase 4 Scope (Prototype):**

- [ ] Expand 13 stub dialogue files to minimal playable (5-10 lines each):
  - act1_confront_scylla.tres
  - act1_extract_sap.tres
  - act1_herb_identification.tres
  - act2_binding_ward.tres
  - act2_calming_draught.tres
  - act2_daedalus_arrives.tres
  - act2_farming_tutorial.tres
  - act2_reversal_elixir.tres
  - act3_final_confrontation.tres
  - act3_moon_tears.tres
  - act3_sacred_earth.tres
  - act3_ultimate_crafting.tres
  - epilogue_ending_choice.tres

- [ ] Ensure main story path is followable (player knows what to do next)
- [ ] Implement core branching logic (flags_required, flags_to_set)
- [ ] **Placeholder dialogue acceptable** - can say "TODO: expand conversation" if needed
- [ ] Focus on functional flow, not literary quality

**Guidelines:**
- Each dialogue should advance the quest or provide context
- Use simple, direct language
- Include player choices where branching is required
- Test that flag logic gates content correctly

**Estimated effort:** 10-15 hours

**Phase 5 will handle:** Full narrative expansion (10-30 exchanges), flavor dialogue, professional writing

---

## 4.3 - Audio (Placeholder SFX)

**Goal:** Create simple placeholder audio so game isn't silent

**Current State:**
- AudioController library empty
- All 11 SFX missing (ui_open, ui_close, catch_chime, urgency_tick, failure_sad, etc.)

**Phase 4 Scope (Prototype):**

- [ ] Create simple placeholder SFX using beeps/clicks/generated tones:
  - **ui_confirm** = short beep (200ms, 800Hz)
  - **ui_move** = soft click (50ms, 400Hz)
  - **ui_open** = rising tone (300ms, 400→800Hz)
  - **ui_close** = falling tone (300ms, 800→400Hz)
  - **catch_chime** = 3-note ding (C-E-G)
  - **correct_ding** = success beep (150ms, 1000Hz)
  - **wrong_buzz** = error buzz (300ms, 100Hz)
  - **dig_thud** = low thud (100ms, 60Hz)
  - **failure_sad** = descending 3 notes (G-E-C)
  - **success_fanfare** = ascending 5 notes (C-D-E-G-C)
  - **urgency_tick** = metronome click (50ms, 600Hz)

**Tools:**
- Use Godot's AudioStreamGenerator
- OR use free online tone generators (e.g., onlinetonegenerator.com)
- Save as .wav files in [assets/audio/sfx/](assets/audio/sfx/)

- [ ] Add AudioController.has_sfx() validation helper
- [ ] Update all AudioController.play_sfx() calls to check existence first
- [ ] Load placeholder SFX into AudioController._sfx_library dictionary

**Estimated effort:** 5-8 hours

**Phase 5 will handle:** Professional audio sourcing/commission, music tracks, audio polish

---

## 4.4 - Art (Placeholder Sprites)

**Goal:** Replace null icons with simple placeholders

**Current State:**
- Only 5 placeholder rectangles exist
- 4 new items have `icon = null`
- All NPC sprite_frames = null

**Phase 4 Scope (Prototype):**

- [ ] Create 32x32 colored square placeholders for items:
  - moon_tear = silver (#C0C0C0)
  - sacred_earth = brown (#8B4513)
  - woven_cloth = beige (#F5F5DC)
  - pharmaka_flower = pink (#FFB6C1)

- [ ] Create simple NPC placeholder sprites (64x64 colored rectangles with labels):
  - Hermes = sky blue with "H"
  - Aeetes = gold with "A"
  - Daedalus = gray with "D"
  - Scylla = purple with "S"

- [ ] Create app icon placeholder (512x512 simple logo - just game title on colored background)

- [ ] **Art can be refined in Phase 5** - don't block on final art

**Tools:**
- Use simple image editor (Paint, GIMP, Aseprite)
- OR generate programmatically in Godot

**Estimated effort:** 3-5 hours

**Phase 5 will handle:** Final character sprites, animations, production art

---

## 4.5 - Recipe Data Completion

**Goal:** Create missing recipe resources for crafting system

**Current State:**
- Only 1 recipe exists: moly_grind.tres
- Need 4+ more recipes for quest progression

**Phase 4 Scope:**

- [ ] Create recipes for Act 2-3 potions:
  - calming_draught.tres (Act 2)
  - binding_ward.tres (Act 2)
  - reversal_elixir.tres (Act 2)
  - petrification_potion.tres (Act 3 - hardest)

- [ ] Each recipe needs:
  - ingredients: Array[Dictionary] with item_id and quantity
  - grinding_pattern: Array[String] (directional inputs)
  - button_sequence: Array[String]
  - timing_window: float (seconds)
  - result_item_id: String
  - result_quantity: int

**Example Recipe Structure:**
```
id: "calming_draught"
display_name: "Calming Draught"
ingredients: [{"item_id": "moly", "quantity": 1}, {"item_id": "lotus", "quantity": 1}]
grinding_pattern: ["ui_up", "ui_right", "ui_down", "ui_left"]
button_sequence: ["ui_accept", "ui_accept"]
timing_window: 2.0
result_item_id: "calming_draught_potion"
result_quantity: 1
```

**Difficulty Progression:**
- Calming Draught: Easy (2.0s window)
- Binding Ward: Medium (1.5s window)
- Reversal Elixir: Hard (1.2s window)
- Petrification Potion: Very Hard (1.0s window)

**Estimated effort:** 2-3 hours

---

## 4.6 - Difficulty Balancing (Basic)

**Goal:** Basic tuning so game is playable but not frustrating

**Tasks:**

- [ ] Test farm plot timing:
  - Crops should mature in 1-3 days (not too long for prototype testing)
  - Adjust days_to_mature in CropData if needed

- [ ] Test crafting timing windows:
  - Early recipes should be forgiving (2.0s+)
  - Final recipe should be challenging but beatable (1.0s)

- [ ] Test minigame difficulty:
  - Herb identification: 3 rounds, increasing difficulty
  - Moon tears: spawn rate should allow 3+ catches in 30 seconds
  - Sacred earth: 10 seconds should be tight but achievable
  - Weaving: 3 mistakes should be forgiving for simple patterns

- [ ] Test gold economy:
  - Player should have enough gold for seeds/items when needed
  - Selling harvests should provide reasonable income

**Verification:**
- Full playthrough (30-45 min) feels smooth
- No frustration spikes
- Player never soft-locked by lack of resources

**Estimated effort:** 5-8 hours (playtest + adjustments)

---

## 4.7 - Internal QA Playthrough

**Goal:** Test full game on PC before building for Android

**Tasks:**

- [ ] Full playthrough on PC (development environment):
  - Prologue → Act 1 → Act 2 → Act 3 → Epilogue
  - Test both endings if branching exists
  - Verify save/load at multiple checkpoints
  - Test all minigames
  - Test crafting all recipes

- [ ] Test edge cases:
  - What if player runs out of gold?
  - Can player break sequence by skipping content?
  - What if dialogue resource fails to load?

- [ ] Performance check:
  - Monitor FPS (should stay near 60fps)
  - Check memory usage (no leaks)

- [ ] Log all bugs in GitHub Issues with priority:
  - CRITICAL = crashes, soft-locks, blocker bugs
  - HIGH = major gameplay issues
  - MEDIUM = minor bugs, polish issues
  - LOW = cosmetic, nice-to-haves

- [ ] Fix all CRITICAL bugs before proceeding

**Deliverables:**
- Bug list with priorities
- Playthrough notes (timing, pacing feedback)
- All CRITICAL bugs fixed

**Estimated effort:** 8-10 hours (playtest + critical fixes)

---

## 4.8 - Android Build Configuration

**Goal:** Configure Godot export settings for Android/Retroid

**Tasks:**

- [ ] Install Android export templates in Godot 4.5.1
- [ ] Configure Android export preset:
  - Target API: 33+ (Android 14)
  - Screen orientation: Portrait (locked)
  - Resolution: 1080x1240
  - Package name: com.circesgarden.game
  - Version code: 1
  - Version name: 1.0.0-prototype

- [ ] Create debug keystore:
  - Use Godot's auto-generated debug keystore
  - Document location for Phase 5 release build

- [ ] Configure permissions:
  - Storage (for save files)
  - No other permissions needed

- [ ] Set app metadata:
  - Icon: placeholder 512x512
  - App name: "Circe's Garden (Prototype)"

- [ ] Build debug APK
- [ ] Test APK installs on PC (if emulator available)

**Deliverables:**
- Android export preset configured
- Debug APK builds without errors
- File size <100MB

**Verification:**
- APK builds successfully
- No export warnings or errors

**Estimated effort:** 3-5 hours

---

## 4.9 - Retroid Pocket Optimization

**Goal:** Ensure game runs smoothly on Retroid hardware

**Tasks:**

- [ ] Verify input mappings:
  - D-pad → ui_left/right/up/down
  - A button → ui_accept / interact
  - B button → ui_cancel
  - Start → pause menu (if implemented)

- [ ] Lock screen orientation to portrait in export settings

- [ ] Test resolution (1080x1240):
  - UI elements readable
  - Text legible
  - No touch-only controls

- [ ] Optimize for low-end Android:
  - Disable unnecessary particle effects if FPS drops
  - Reduce tilemap rendering if needed
  - Target 60fps minimum

- [ ] Test on PC first, then prepare for Retroid test

**Deliverables:**
- Optimized build for Retroid
- Input mapping verified

**Verification:**
- Game runs at 60fps on target hardware
- Controls feel responsive

**Estimated effort:** 2-3 hours

---

## 4.10 - Sam's Hardware Testing (CRITICAL GATE)

**Goal:** Sam physically tests prototype on Retroid Pocket Classic

**Prerequisites:**
- Debug APK ready
- Retroid Pocket Classic charged
- USB cable or wireless transfer ready

**Tasks for Sam:**

### 4.10.1 - Installation
- [ ] Connect Retroid to PC via USB or use wireless transfer
- [ ] Enable Developer Options and USB Debugging on Retroid
- [ ] Install APK:
  - Option A: `adb install circe_garden_prototype.apk`
  - Option B: Copy APK to device and install via file manager
- [ ] Launch "Circe's Garden (Prototype)" from app drawer

### 4.10.2 - First Launch Test
- [ ] Verify app icon displays
- [ ] Verify main menu loads
- [ ] Test d-pad navigation in menu
- [ ] Test "New Game" button
- [ ] Verify prologue loads

### 4.10.3 - Core Gameplay Test (15-30 minutes)
- [ ] Play through Prologue
- [ ] Test player movement with d-pad
- [ ] Test interaction with NPCs and objects
- [ ] Plant and harvest at least one crop
- [ ] Advance day using sundial
- [ ] Complete at least one crafting minigame
- [ ] Complete at least one side minigame
- [ ] Test dialogue choices
- [ ] Test save/load (exit and relaunch)

### 4.10.4 - Performance Check
- [ ] Monitor frame rate (should feel smooth)
- [ ] Check for stuttering or lag
- [ ] Verify audio plays correctly
- [ ] Test for 30+ minutes (battery/stability)
- [ ] Check for crashes or freezes

### 4.10.5 - Bug Reporting
- [ ] Document any crashes, freezes, errors
- [ ] Screenshot/video any visual glitches
- [ ] Note control issues or input lag
- [ ] Report all findings to dev

**Success Criteria:**
- Game installs and launches
- Sam can play for 15-30 minutes without CRITICAL bugs
- Core loop works: farm → craft → quest
- Controls feel responsive
- No show-stopping issues

**If Testing Fails:**
- Log all CRITICAL bugs
- Fix and rebuild APK
- Repeat hardware test

---

## 4.11 - Bug Fixes and Iteration

**Goal:** Fix all CRITICAL bugs from Sam's hardware test

**Tasks:**

- [ ] Review Sam's bug reports
- [ ] Prioritize bugs:
  - CRITICAL = fix immediately
  - HIGH = fix before Phase 5
  - MEDIUM/LOW = log for Phase 5 or post-launch

- [ ] Fix all CRITICAL bugs
- [ ] Re-test fixes in development environment
- [ ] Build new debug APK
- [ ] Sam re-tests on Retroid
- [ ] Iterate until no CRITICAL bugs remain

**Deliverables:**
- All CRITICAL bugs resolved
- Stable prototype build

**Verification:**
- Sam confirms game is stable and playable for 30+ minutes
- No blockers prevent continued testing

**Estimated effort:** Variable (depends on bug count)

---

## 4.12 - Phase 4 Quality Gates

**Gate 1: Pre-Testing Checklist** (Before 4.10 Hardware Testing)

- [ ] All automated tests passing (5/5)
- [ ] No console errors on fresh game launch
- [ ] Farm plot lifecycle works (plant → grow → harvest)
- [ ] At least 1 full quest path completable (Prologue → Act 1)
- [ ] Save/load preserves progress
- [ ] All 16 dialogue files have ≥5 lines (no single-line stubs)
- [ ] All 11 placeholder SFX present
- [ ] 5+ recipe resources created

**Gate 2: Hardware Testing Approval** (Sam's Sign-Off Required)

- [ ] Game launches and runs for 30+ minutes without crash
- [ ] Controls feel responsive on Retroid
- [ ] Performance stable (no obvious lag/stuttering)
- [ ] Sam can complete 15-30 minutes of gameplay
- [ ] No CRITICAL bugs discovered

**Gate 3: Phase 4 Completion** (Before Starting Phase 5)

- [ ] All CRITICAL bugs from Sam's testing fixed
- [ ] Prototype is playable end-to-end
- [ ] Core loop confirmed working
- [ ] Android APK builds reliably
- [ ] Documentation updated

**If any gate fails:**
- Create GitHub Issue with details
- Stop progression
- Fix blocker before proceeding

---

## Phase 4 Checklist (High-Level)

- [ ] 4.0 - Critical Blocker Fixes
- [ ] 4.1 - Jr Engineer Quality Standards
- [ ] 4.2 - Dialogue (Minimal Playable)
- [ ] 4.3 - Audio (Placeholder SFX)
- [ ] 4.4 - Art (Placeholder Sprites)
- [ ] 4.5 - Recipe Data Completion
- [ ] 4.6 - Difficulty Balancing (Basic)
- [ ] 4.7 - Internal QA Playthrough
- [ ] 4.8 - Android Build Configuration
- [ ] 4.9 - Retroid Pocket Optimization
- [ ] 4.10 - Sam's Hardware Testing
- [ ] 4.11 - Bug Fixes and Iteration
- [ ] 4.12 - Quality Gates (All 3 Passed)

---

## Success Criteria

**Phase 4 (Prototype) is complete when:**

- ✅ All critical blockers resolved (farm plot works, docs updated)
- ✅ No stale TODO comments in codebase
- ✅ All 16 dialogue files have ≥5 lines (minimal playable)
- ✅ All 11 placeholder SFX files present
- ✅ 5+ recipe .tres files created and tested
- ✅ NPCData .tres files created for all 4 main NPCs
- ✅ Art placeholders present (colored squares)
- ✅ Android APK builds successfully
- ✅ Game runs on Retroid hardware
- ✅ **Sam can complete 15-30 minutes of gameplay on Retroid**
- ✅ No CRITICAL bugs prevent testing
- ✅ Core loop works: farm → craft → quest → progress

---

## Phase 4 Deliverable

**Working prototype APK** with:
- Functional game systems (farm, craft, dialogue, minigames)
- Minimal playable dialogue (5-10 lines per file)
- Placeholder audio (simple beeps/clicks)
- Placeholder art (colored squares)
- Runs on Retroid Pocket Classic
- Ready for Sam's feedback

**Next Phase:** Phase 5 - Final Polish (production assets, full narrative, release build)

---

## Timeline

**Week 1: Foundation & Core Content**
1. Fix farm plot blockers (4.0)
2. Update documentation (4.0)
3. Implement quality standards helpers (4.1)
4. Expand dialogue stubs (4.2) - 5-10 lines each
5. Create missing recipe data (4.5)
6. Create placeholder audio (4.3)

**Week 2: Integration & Testing**
7. Create simple art placeholders (4.4)
8. Balance difficulty (4.6)
9. Internal QA playthrough (4.7)
10. Configure Android build (4.8)
11. Optimize for Retroid (4.9)
12. **Sam hardware testing (4.10)** ⭐
13. Fix critical bugs (4.11)

**Total Duration:** 1.5-2 weeks

---

**End of Phase 4: Prototype**
