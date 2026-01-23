# Phase 9: Final Polish Roadmap

## Phase 9 Overview
Phase 9 is the final polish phase that begins after all core features, quests, and gameplay systems are complete and stable. This phase focuses on transforming the functional game into a polished, release-ready product by replacing placeholder assets, finalizing audio implementation, optimizing performance, and ensuring narrative consistency. Phase 9 starts after successful Android/Retroid build testing in Phase 8 and includes comprehensive playtesting with final production assets.

## Polish Categories

### Visual Polish
- [ ] Replace all 26 placeholder assets with final production art (maintain exact dimensions and file formats)
- [ ] Replace `golden_glow` placeholder IDs with lotus/saffron items in data and recipes
- [ ] Update player sprite (Circe) with final animation frames
- [ ] Replace world tilesets with final production graphics
- [ ] Update NPC portraits (Circe, Hermes, Aeetes, Daedalus, Scylla) with final art
- [ ] Replace scene-specific sprites (minigame backgrounds, UI elements)
- [ ] Create final app icon (512x512 for store listing)
- [ ] Ensure all visual assets maintain consistent art style and quality
- [ ] Add visual polish to core farming loop animations
- [ ] Optimize particle effects and animations for performance

### Audio Polish
- [ ] Add background music tracks for:
  - [ ] Main menu
  - [ ] World/garden area
  - [ ] Scylla Cove location
  - [ ] Sacred Grove location
  - [ ] Daedalus Workshop location
  - [ ] Minigames (can share music tracks)
- [ ] Verify all SFX are in place and properly implemented:
  - [ ] Existing sounds: `wrong_buzz`, `catch_chime`, `urgency_tick`, `failure_sad`
  - [ ] Add missing sounds: harvest sound, planting sound, day advance chime, potion craft success
  - [ ] Add ambient sounds for each location
- [ ] Set appropriate volume levels (music lower than SFX)
- [ ] Test audio doesn't cause frame drops on Retroid hardware
- [ ] Add audio fade-in/out effects for scene transitions

### Gameplay Feel
- [ ] Fine-tune input response times for all actions
- [ ] Polish movement feel and character momentum
- [ ] Add screen shake for impactful moments (petrification cutscene, major discoveries)
- [ ] Implement visual feedback for all player actions (planting, harvesting, crafting)
- [ ] Add particle effects for magical actions
- [ ] Polish minigame feel and responsiveness
  - [ ] Weaving minigame
  - [ ] Herb identification
  - [ ] Moon tears collection
  - [ ] Sacred earth ritual
- [ ] Add animation polish to NPC interactions
- [ ] Implement smooth camera transitions between locations
- [ ] Add subtle environmental animations (wind effects, water ripples)

### Narrative Polish
- [ ] Review all dialogue for typos, tone consistency, and clarity
- [ ] Ensure mythological references are accurate and engaging
- [ ] Verify character voice consistency (Circe, Hermes, Aeetes, Daedalus, Scylla)
- [ ] Add missing tutorial hints in early dialogue
- [ ] Enhance epilogue scene for satisfying narrative closure
- [ ] Create credits scene with:
  - [ ] Development credits
  - [ ] Art/audio credits
  - [ ] Tools used (Godot, Claude Code, etc.)
  - [ ] Special thanks
- [ ] Add "About" or credits option to main menu
- [ ] Polish quest notification text and timing
- [ ] Add environmental storytelling elements

## Execution Order

### Phase 9A: Core Asset Replacement (Week 1-2)
1. Replace player sprite and world tiles (most visible to player)
2. Replace crop and item icons (frequently used)
3. Update NPC portraits (character-defining assets)
4. Replace scene-specific sprites (location backgrounds)

### Phase 9B: Audio Implementation (Week 2-3)
1. Implement background music tracks
2. Add missing SFX and ambient sounds
3. Balance volume levels
4. Test audio performance

### Phase 9C: Gameplay Feel Polish (Week 3-4)
1. Fine-tune input response and movement
2. Add visual feedback systems
3. Polish minigame mechanics
4. Implement camera and transition polish

### Phase 9D: Narrative & UI Polish (Week 4-5)
1. Dialogue review and enhancement
2. Epilogue and credits completion
3. UI element polish
4. Environmental storytelling

### Phase 9E: Performance Optimization (Week 5-6)
1. Profile and optimize for 60 FPS target
2. Texture compression optimization
3. Memory usage testing
4. Scene optimization

## Completion Criteria

### Automated Verification
- [ ] Full headless test suite passes (5/5 tests)
- [ ] GdUnit4 test suite passes without failures
- [ ] No console warnings or errors in final build
- [ ] APK builds successfully for Android

### Manual Verification
- [ ] Full playthrough with final assets completes without issues (60+ minutes)
- [ ] Release build stable on Retroid hardware (60+ minute session)
- [ ] All placeholder assets replaced with final production art
- [ ] Audio implementation complete and balanced
- [ ] Performance maintains 60 FPS target on Retroid
- [ ] Dialogue review complete with no typos or tone inconsistencies
- [ ] Both ending paths provide satisfying closure
- [ ] Credits screen complete and accessible
- [ ] All edge cases handled gracefully (save/load, rapid inputs, etc.)

### Quality Assurance
- [ ] Save/load testing across all game states
- [ ] All CRITICAL and HIGH bugs from previous phases confirmed fixed
- [ ] No new bugs introduced during polish phase
- [ ] Store listing materials ready for distribution

## Handoff to Release

### Release Build Configuration
- [ ] Set release mode in export preset (not debug)
- [ ] Enable texture compression (VRAM Compression)
- [ ] Set correct orientation (landscape for Retroid)
- [ ] Configure minimum Android version for target device
- [ ] Set app permissions (minimal, storage only if save/load requires)
- [ ] Set version number in project.godot (e.g., 1.0.0)
- [ ] Set application name: "Circe's Garden"
- [ ] Configure app icon in export preset
- [ ] Set package name (com.yourname.circesgarden format)

### APK Signing
- [ ] Generate release keystore (keep secure backup)
- [ ] Sign APK with release key
- [ ] Document keystore password in secure location
- [ ] Test signed release APK on clean device installation

### Personal Gift Build
- [ ] Final signed release APK ready for installation on Retroid
- [ ] Test installation and full playthrough on target device
- [ ] Backup APK and keystore to secure location
- [ ] Create release notes and documentation

### Success Metrics
- Full playthrough with final assets completes without issues
- Release build stable on Retroid hardware (60+ minute session)
- All placeholder assets replaced
- Audio implementation complete and balanced
- Performance maintains 60 FPS target
- APK signed and installable on fresh device
- Store listing materials ready for distribution