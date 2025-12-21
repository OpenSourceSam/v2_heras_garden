# PHASE 5: FINAL POLISH - Production Quality and Release

**Version:** 1.0
**Created:** 2025-12-21
**Status:** PLANNED
**Prerequisites:** Phase 4 (Prototype) Complete
**Target:** Shippable v1.0 release
**Duration:** 1.5-2 weeks

---

## Overview

Phase 5 transforms the working prototype from Phase 4 into a **production-quality release**. This phase focuses on:

1. **Content Completion** - Full narrative dialogue, professional audio, final art
2. **Quality Assurance** - Comprehensive testing, bug fixes, polish
3. **Final Approval** - Sam's sign-off on release quality
4. **Release Build** - Signed APK, packaging materials, distribution

**Phase 4 delivered functional completeness; Phase 5 delivers professional polish.**

---

## 5.1 - Dialogue Expansion (Full Narrative)

**Goal:** Expand all dialogue to full, polished conversations

**Prerequisites:**
- Phase 4 minimal dialogue (5-10 lines per file) complete

**Phase 5 Scope:**

- [ ] Expand all 16 dialogue files to full conversations (10-30 exchanges each):
  - prologue_opening.tres (already complete)
  - circe_intro.tres (already complete)
  - aiaia_arrival.tres (already complete)
  - act1_confront_scylla.tres → 10-15 exchanges
  - act1_extract_sap.tres → 8-12 exchanges
  - act1_herb_identification.tres → 8-10 exchanges
  - act2_binding_ward.tres → 10-15 exchanges
  - act2_calming_draught.tres → 10-15 exchanges
  - act2_daedalus_arrives.tres → 12-18 exchanges
  - act2_farming_tutorial.tres → 8-10 exchanges
  - act2_reversal_elixir.tres → 10-15 exchanges
  - act3_final_confrontation.tres → 15-20 exchanges
  - act3_moon_tears.tres → 8-12 exchanges
  - act3_sacred_earth.tres → 8-12 exchanges
  - act3_ultimate_crafting.tres → 10-15 exchanges
  - epilogue_ending_choice.tres → 15-25 exchanges (both endings)

- [ ] Add flavor dialogue for repeat NPC interactions
- [ ] Add emotional depth and character voice consistency
- [ ] Proofread all text for typos, grammar, tone
- [ ] Verify all branching logic and flag gating works correctly

**Quality Standards:**
- Consistent narrative voice (Greek mythology theme, cozy tone)
- Player choices feel meaningful
- NPC personalities distinct
- Emotional arc clear: jealousy → guilt → redemption

**Estimated effort:** 40-50 hours

**Deliverables:**
- All dialogue files fully written
- Proofread and polished
- No placeholder text visible

---

## 5.2 - Professional Audio Integration

**Goal:** Replace placeholder audio with production-quality assets

**Prerequisites:**
- Phase 4 placeholder SFX (beeps/clicks) implemented

**Phase 5 Scope:**

### 5.2.1 - Sound Effects

- [ ] Source or commission professional SFX to replace placeholders:
  - **UI sounds:** button press, menu navigate, menu open/close
  - **Farming sounds:** till soil, plant seed, watering, harvest
  - **Crafting sounds:** grinding herbs, potion bubble, success/failure
  - **Minigame sounds:** herb glow, tear catch, dig thud, weave click
  - **Ambient sounds:** wind, waves, birds (optional)

**Sourcing Options:**
- Option A: Find royalty-free SFX (freesound.org, opengameart.org, zapsplat.com)
- Option B: Commission from audio artist
- Option C: Record custom sounds

### 5.2.2 - Music Tracks

- [ ] Source or commission music tracks:
  - **Main menu theme** (looping, cozy/mysterious)
  - **Aiaia ambient** (exploration, peaceful farming)
  - **Crafting theme** (focused, rhythmic)
  - **Tense music** (Scylla scenes, urgency)
  - **Victory theme** (quest completion, uplifting)
  - **Epilogue music** (reflective, bittersweet - 2 variants for endings)

**Music Style:** Greek-inspired, atmospheric, cozy with emotional depth

### 5.2.3 - Integration

- [ ] Replace all placeholder SFX in AudioController library
- [ ] Implement music track transitions via AudioController
- [ ] Balance volume levels (music vs SFX)
- [ ] Test audio on headphones and device speakers
- [ ] Add volume controls in settings menu

**Estimated effort:** 20-30 hours (sourcing + integration)

**Deliverables:**
- All SFX and music assets integrated
- No missing audio warnings
- Audio enhances atmosphere and feedback

---

## 5.3 - Final Art and Visual Assets

**Goal:** Replace placeholder art with production-quality sprites

**Prerequisites:**
- Phase 4 placeholder art (colored squares) in place

**Phase 5 Scope:**

### 5.3.1 - Character Sprites

- [ ] Replace placeholder NPC sprites:
  - **Circe:** Idle, walk, interact animations (32x32 or 64x64)
  - **Hermes:** Character sprite with wing motif
  - **Aeetes:** Bearded scholar appearance
  - **Daedalus:** Inventor with tools
  - **Scylla:** Before transformation (graceful) and after (monstrous)

**Sourcing Options:**
- Option A: Commission pixel artist
- Option B: Create using Aseprite or similar tool
- Option C: Use royalty-free assets with modifications

### 5.3.2 - Item Icons

- [ ] Replace colored square placeholders with 32x32 icons:
  - Herbs: moly, nightshade, lotus, saffron, pharmaka_flower
  - Crafted items: moon_tear, sacred_earth, woven_cloth
  - Potions: calming_draught, binding_ward, reversal_elixir, petrification_potion
  - Tools: watering_can, hoe, sickle

### 5.3.3 - Environment Tiles

- [ ] Enhance tilesets:
  - Ground tiles (grass, dirt, water)
  - Special location tiles (grove, cove, palace)
  - Farm plot states (untilled, tilled, planted)

### 5.3.4 - UI Elements

- [ ] Polish UI graphics:
  - Button sprites and hover states
  - Menu backgrounds
  - Dialogue box frames
  - Inventory panel design
  - Health/status bars (if any)

### 5.3.5 - App Icon

- [ ] Create production app icon (512x512):
  - Feature Circe or game logo
  - Clean, recognizable design
  - Follows Android icon guidelines

**Estimated effort:** Variable (depends on sourcing method)

**Deliverables:**
- All placeholder art replaced
- Cohesive visual style
- Professional app icon

---

## 5.4 - Difficulty and Balance Refinement

**Goal:** Final tuning for smooth player experience

**Tasks:**

- [ ] Full playthrough testing (multiple times):
  - Verify 65-90 minute target playtime for story mode
  - Confirm pacing feels smooth (no dead zones or rushes)

- [ ] Crafting difficulty curve:
  - Verify timing windows are challenging but fair
  - Petrification potion should be hardest but still achievable
  - Test with different player skill levels (if possible)

- [ ] Minigame difficulty:
  - Herb identification: 3 difficulty levels balanced
  - Moon tears: catch rate feels satisfying
  - Sacred earth: tight but not frustrating
  - Weaving: pattern complexity appropriate

- [ ] Economy balance:
  - Player never soft-locked by lack of gold
  - Selling crops provides meaningful income
  - Item costs feel fair

- [ ] Progression pacing:
  - Quests unlock at appropriate times
  - No waiting too long for crops
  - Story beats evenly distributed

**Deliverables:**
- Balanced game that feels fair and engaging
- 65-90 minute story mode playtime achieved
- Both endings reachable and satisfying

**Estimated effort:** 10-15 hours (testing + tweaks)

---

## 5.5 - Comprehensive QA and Testing

**Goal:** Final bug hunt and polish pass

**Tasks:**

### 5.5.1 - Full Playthroughs

- [ ] Complete multiple full playthroughs:
  - Playthrough 1: Ending A (mercy path)
  - Playthrough 2: Ending B (alternative path)
  - Playthrough 3: Speed run (test sequence breaks)

- [ ] Test all optional content:
  - Side quests (if any)
  - Free-play mode after completion
  - Extra dialogue branches

### 5.5.2 - Edge Case Testing

- [ ] Test boundary conditions:
  - Max inventory (stack limits)
  - Zero gold situations
  - Missing required items (should prevent progress gracefully)
  - Save/load at every major checkpoint

- [ ] Test error recovery:
  - Corrupted save file handling
  - Missing resource file handling
  - Invalid dialogue ID references

### 5.5.3 - Performance Testing

- [ ] Monitor performance:
  - FPS stays at 60+ throughout
  - Memory usage stable (no leaks)
  - Battery drain acceptable (2+ hours play)
  - No overheating on device

### 5.5.4 - Bug Fixing

- [ ] Review all open GitHub Issues
- [ ] Fix all CRITICAL and HIGH priority bugs
- [ ] Triage MEDIUM/LOW bugs:
  - Fix if time permits
  - Document for post-launch patches

**Deliverables:**
- No CRITICAL or HIGH bugs remain
- Game is stable and polished
- Performance meets targets

**Estimated effort:** 15-20 hours

---

## 5.6 - Sam's Final Approval Testing

**Goal:** Sam's final sign-off on release quality

**Tasks for Sam:**

### 5.6.1 - Full Playthrough on Retroid

- [ ] Play through entire game (Prologue → Epilogue)
- [ ] Test both endings
- [ ] Verify all polish improvements from Phase 5
- [ ] Confirm dialogue quality and narrative coherence
- [ ] Check audio integration (music and SFX)
- [ ] Verify art assets look good
- [ ] Test save/load multiple times

### 5.6.2 - Quality Assessment

- [ ] Evaluate overall game feel:
  - Does it feel complete and polished?
  - Is the story engaging?
  - Are controls responsive?
  - Is difficulty balanced?
  - Would you release this?

### 5.6.3 - Final Feedback

- [ ] Document any remaining issues
- [ ] Provide feedback on quality level
- [ ] Approve or request changes

**Success Criteria:**
- Sam approves game for release
- No major quality concerns
- Game meets vision for v1.0

**If approval fails:**
- Address Sam's feedback
- Make necessary changes
- Re-submit for approval

---

## 5.7 - Release Build and Signing

**Goal:** Create final signed APK for distribution

**Tasks:**

### 5.7.1 - Release Keystore

- [ ] Create release keystore (if not already done):
  ```bash
  keytool -genkey -v -keystore release.keystore -alias circes_garden -keyalg RSA -keysize 2048 -validity 10000
  ```
- [ ] **Document keystore password securely** (password manager)
- [ ] Back up keystore file (required for all future updates)

### 5.7.2 - Export Configuration

- [ ] Update Android export preset for release:
  - Use release keystore
  - Version code: 1
  - Version name: 1.0.0
  - Enable code optimization
  - Disable debug features

### 5.7.3 - Build Release APK

- [ ] Build signed release APK
- [ ] Test release APK on Retroid (verify identical to debug build)
- [ ] Verify file size (<100MB target)
- [ ] Document build date and version

**Deliverables:**
- Signed release APK: `circes_garden_v1.0.0_release.apk`
- Keystore backed up and password secured
- Build verified on hardware

---

## 5.8 - Packaging and Distribution Materials

**Goal:** Create all materials needed for release

**Tasks:**

### 5.8.1 - Screenshots

- [ ] Capture 5-8 high-quality screenshots:
  - Main menu
  - Prologue scene (narrative)
  - Farming gameplay
  - Crafting minigame
  - Dialogue choice
  - Minigame (herb ID or moon tears)
  - Act 3 scene
  - Epilogue moment

- [ ] Edit screenshots for clarity (crop, adjust brightness if needed)

### 5.8.2 - App Description

- [ ] Write short description (80 characters):
  > "A Greek mythology farming game about jealousy, guilt, and redemption."

- [ ] Write long description (4000 characters max):
  - Hook: What makes the game unique?
  - Story: Brief narrative setup
  - Features: Farming, crafting, minigames, narrative choices
  - Playtime: 65-90 minutes + free-play
  - Platform: Retroid Pocket Classic (Android)

### 5.8.3 - Credits and Attributions

- [ ] Create CREDITS.md listing:
  - Development team
  - Audio sources (if royalty-free)
  - Art sources (if royalty-free)
  - Tools used (Godot, etc.)
  - Inspiration (novel "Circe", Greek mythology)

### 5.8.4 - README for Distribution

- [ ] Create README.md for itch.io or distribution platform:
  - Game description
  - Installation instructions (sideload APK)
  - Controls (d-pad, buttons)
  - Known issues (if any)
  - Contact/support info

### 5.8.5 - Changelog

- [ ] Create CHANGELOG.md:
  - v1.0.0 - Initial release
  - Feature list
  - Known limitations

**Deliverables:**
- 5-8 screenshots
- Short + long descriptions
- CREDITS.md
- README.md
- CHANGELOG.md

---

## 5.9 - Source Code Archival

**Goal:** Tag release in Git for version control

**Tasks:**

- [ ] Commit all final changes
- [ ] Create Git tag for release:
  ```bash
  git tag -a v1.0.0 -m "Version 1.0.0 - Initial Release"
  git push origin v1.0.0
  ```
- [ ] Create GitHub release (if using GitHub):
  - Tag: v1.0.0
  - Title: "Circe's Garden v1.0.0"
  - Description: Release notes
  - Attach APK file

**Deliverables:**
- Source code tagged as v1.0.0
- GitHub release created (optional)

---

## 5.10 - Post-Release Planning (Optional)

**Goal:** Plan for future updates and patches

**Tasks:**

- [ ] Document known minor bugs for future patches
- [ ] List "nice-to-have" features cut from v1.0:
  - Extra dialogue variations
  - Achievements system
  - New Game+ mode
  - Additional minigames
  - Localization

- [ ] Create post-launch roadmap (if desired):
  - v1.0.1 - Bug fix patch (1-2 weeks after release)
  - v1.1.0 - QoL improvements (1-2 months)
  - v1.2.0 - Additional content (3-6 months)

- [ ] Set up feedback channels:
  - Email for bug reports
  - Itch.io comments
  - Discord server (optional)

**Deliverables:**
- Post-launch roadmap (optional)
- Feedback collection plan

---

## Phase 5 Checklist (High-Level)

- [ ] 5.1 - Dialogue Expansion (Full Narrative)
- [ ] 5.2 - Professional Audio Integration
- [ ] 5.3 - Final Art and Visual Assets
- [ ] 5.4 - Difficulty and Balance Refinement
- [ ] 5.5 - Comprehensive QA and Testing
- [ ] 5.6 - Sam's Final Approval Testing
- [ ] 5.7 - Release Build and Signing
- [ ] 5.8 - Packaging and Distribution Materials
- [ ] 5.9 - Source Code Archival
- [ ] 5.10 - Post-Release Planning (Optional)

---

## Success Criteria

**Phase 5 (Final Polish) is complete when:**

- ✅ All 16 dialogue files expanded to 10-30 exchanges (full narrative)
- ✅ Professional audio assets integrated (SFX + music)
- ✅ Final art sprites replace all placeholders
- ✅ Both story endings fully playable and polished
- ✅ No CRITICAL or HIGH priority bugs remain
- ✅ Game runs at 60fps on Retroid
- ✅ **Sam has approved game for release**
- ✅ Release APK signed and tested
- ✅ All packaging materials complete (screenshots, description, credits)
- ✅ Source code tagged as v1.0.0
- ✅ Game is ready for distribution

---

## Phase 5 Deliverable

**Shippable v1.0 release APK** with:
- Full narrative dialogue (professional quality)
- Professional audio (SFX + music)
- Final art assets (characters, items, UI)
- Polished gameplay (balanced, bug-free)
- Complete packaging materials
- Sam's approval

**Next Step:** Distribution (itch.io, direct download, etc.)

---

## Timeline

**Week 1: Content Completion**
1. Expand all dialogue to full conversations (5.1)
2. Source/integrate professional audio (5.2)
3. Integrate final art assets (5.3)
4. Final difficulty balancing (5.4)

**Week 2: QA and Release**
5. Comprehensive QA testing (5.5)
6. Sam's final approval testing (5.6)
7. Fix any remaining issues from Sam's feedback
8. Create release build (5.7)
9. Prepare packaging materials (5.8)
10. Tag source code and release (5.9)

**Total Duration:** 1.5-2 weeks

---

**End of Phase 5: Final Polish**
