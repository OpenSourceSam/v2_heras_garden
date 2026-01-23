# Phase 4 Synthesis: Remaining Buildout Planning

**Generated:** 2026-01-23
**Source:** 5 parallel subagents planning P2/P3 tasks and future phases
**Purpose:** Complete buildout plan for remaining work

---

## Executive Summary

**Phase 4 Complete:** All future work planned with detailed implementation guides.

**Deliverables Created:**
1. P2: Quest flag reconciliation plan
2. P2: Dialogue tone alignment plan (Act 2)
3. P3: World spacing polish plan
4. Phase 8: Android build preparation checklist
5. Phase 9: Final polish roadmap

---

## P2: Quest Flag Flow Reconciliation

**File:** `temp/phase4-p2-quest-flag-reconciliation-plan.md`

**Issues Addressed:**
- Missing flags: `quest_8_complete_dialogue_seen`, `quest_11_complete_dialogue_seen`, `quest_3_complete_dialogue_seen`
- No auto-setting mechanism for completion dialogue tracking
- Unused flags: `quest_0_complete`, `garden_built`

**Solution Approach:**
1. Add `mark_dialogue_completed()` helper method to GameState
2. Modify DialogueBox to automatically set completion flags
3. Fix NPCBase flag references
4. Clean up flag initialization

**Files to Modify:**
- `game/autoload/game_state.gd` - Add helper method
- `game/features/ui/dialogue_box.gd` - Auto-track completion
- `game/features/npcs/npc_base.gd` - Fix flag checks
- `game/shared/resources/dialogues/*.tres` - Add metadata

**Implementation Effort:** Medium (4-5 files, coordinated changes)

---

## P2: Dialogue Tone Alignment (Act 2)

**File:** `temp/phase4-p2-dialogue-tone-alignment-plan.md`

**Act 2 Storyline:** "GUILT & FAILED REDEMPTION" - Circe's desperate attempts to undo Scylla's transformation through increasingly complex witchcraft, ultimately realizing that only death may bring mercy.

**Character Tone Requirements:**

**Aeetes (Harsh Teacher):**
- Matter-of-fact, blunt, rarely comforting
- Warns against false hope ("I told you," "Prepare for disappointment")
- Progression: Stern → grudging concern → resigned

**Daedalus (Supportive Mentor):**
- Gentle, philosophical, encouraging
- Teaches that true mercy comes from choice
- Already well-toned in current implementation

**Circe (Desperate Atoner):**
- Progression: Hopeful → determined → despairing → resigned
- Internal conflict between love, guilt, and mercy

**Priority Changes:**
1. **High**: Add Aeetes's "pharmaka doesn't undo pharmaka" warning
2. **High**: Include Scylla's plea to be let die (binding ward)
3. **Medium**: Add emotional depth to crafting dialogues
4. **Low**: Polish Daedalus's already well-tuned dialogue

**Files to Modify:**
- `act2_farming_tutorial.tres`
- `act2_calming_draught.tres`
- `act2_reversal_elixir.tres`
- `act2_binding_ward.tres`
- `daedalus_intro.tres`

**Implementation Effort:** Medium (dialogue writing, no code changes)

---

## P3: World Spacing Polish

**File:** `temp/phase4-p3-world-spacing-plan.md`

**Current Layout Issues:**
- All NPCs clustered at y=-32 with 64-pixel horizontal spacing
- Interactable objects clustered at y=0
- Visual congestion when multiple NPCs appear

**Proposed New Layout:**

**NPC Spawn Points (Vertical Stagger):**
- Hermes: [160, -32] → [160, -96] (higher elevation, importance)
- Aeetes: [224, -32] → [224, -32] (unchanged, central figure)
- Daedalus: [288, -32] → [288, 32] (crafting workshop feel)
- Scylla: [352, -32] → [352, 96] (closer to cove)
- Circe: Removed (location-specific in AiaiaShore only)

**Interactable Objects (Activity Zones):**
- Gardening Zone: Mortar, Farm plots
- Central Hub: Boat, Recipe book
- Crafting Zone: Loom, Sundial
- Raised from y=0 to y=-32 for better visibility

**Files to Modify:**
- `game/features/world/world.tscn` - Update node positions

**Implementation Effort:** Low (scene file coordinate changes)

---

## Phase 8: Android Build Preparation

**File:** `temp/phase4-phase8-android-prep-plan.md`

**Already Configured:**
- ✅ Android export presets (Debug/Release)
- ✅ Basic settings (landscape, SDK 24)
- ✅ App icon (512x512 SVG)
- ✅ Environment setup script (`tools/setup_android_build.cmd`)

**Missing - Prerequisites:**
- ❌ Touch input mappings (currently keyboard/gamepad only)
- ❌ Keystore configuration for release builds
- ❌ VRAM texture compression for mobile
- ❌ Performance testing/optimization

**Prerequisites Checklist:**
1. Add touch input mappings to project.godot
2. Configure keystore for release signing
3. Optimize textures for mobile VRAM
4. Test on target device (Retroid Pocket Classic)
5. Performance profiling and optimization
6. APK testing and distribution

**Platform Considerations:**
- Touch controls for all gamepad actions
- Screen size (Retroid: 3.5" 640x480)
- Battery/performance optimization
- Save system compatibility

**Implementation Effort:** High (platform-specific work, testing on device)

---

## Phase 9: Final Polish Roadmap

**File:** `temp/phase4-phase9-polish-roadmap.md`

**Polish Categories:**

**Phase 9A: Core Asset Replacement**
- 26 placeholder assets to replace
- Character sprites, animations, UI elements
- Background art, environmental assets

**Phase 9B: Audio Implementation**
- Background music (exploration, tension, climax themes)
- Sound effects (interactions, minigames, cutscenes)
- Ambient sounds (world, locations)
- Volume balancing and mixing

**Phase 9C: Gameplay Feel Polish**
- Input response tuning
- Movement polish
- Visual feedback improvements
- Minigame feel adjustments

**Phase 9D: Narrative & UI Polish**
- Dialogue review (tone, pacing, emotional impact)
- Epilogue and credits
- Environmental storytelling
- UI/UX improvements

**Phase 9E: Performance Optimization**
- Profiling and bottleneck identification
- Texture optimization
- Code performance improvements

**Completion Criteria:**
- ✅ All placeholder assets replaced
- ✅ Full audio implementation
- ✅ Manual playthrough passes all quality checks
- ✅ Retroid Pocket testing successful
- ✅ Save/load system robust
- ✅ Release build configured

---

## Updated Execution Roadmap

### Immediate (Phase 7 Remaining)
- [ ] Manual Ending A/B validation (using created checklist)
- [ ] Dialogue fix runtime verification (using created procedure)

### P2 Tasks (Phase 7 continuation)
- [ ] Quest flag flow reconciliation (medium effort)
- [ ] Dialogue tone alignment - Act 2 (dialogue writing)

### P3 Tasks (Phase 7 continuation)
- [ ] World spacing polish (low effort)

### Phase 8: Android Export
- [ ] Touch input mapping
- [ ] Keystore configuration
- [ ] Texture optimization
- [ ] Device testing

### Phase 9: Final Polish
- [ ] Asset replacement (26 placeholders)
- [ ] Audio implementation
- [ ] Gameplay feel polish
- [ ] Narrative polish
- [ ] Performance optimization

---

## Dependencies

```
Phase 7 P2/P3 Tasks
├─ No external dependencies
└─ Can start immediately

Phase 8 (Android)
├─ Requires: Phase 7 core features complete
└─ Requires: Touch controls implemented

Phase 9 (Polish)
├─ Requires: All features complete (Phase 7 + 8)
└─ Sequential: 9A → 9B → 9C → 9D → 9E
```

---

## Success Criteria (Plan Complete When)

☑ Debugger testing guide created
☑ Buildout needs assessed (P1/P2/P3)
☑ Debugger test procedures created
☑ P1 buildout execution complete
☑ P2/P3 tasks planned
☑ Phase 8 roadmap created
☑ Phase 9 roadmap created

---

## Next Steps

**After This Session:**
1. User reviews Phase 4 plans
2. Prioritizes P2/P3 tasks for execution
3. Decides on Phase 8/9 timeline
4. Manual testing (Ending A/B, dialogue fix) can proceed using created checklists

**All Planning Complete:** The project now has comprehensive plans for all remaining work through Phase 9 (release readiness).

---

**Plan Status:** ✅ COMPLETE
**Files Created:** 5 planning documents
**Coverage:** P2, P3, Phase 8, Phase 9
