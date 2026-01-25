## Local Beta Pipelines (Pegged)

These are the minimum, repeatable pipelines that anchor local-beta work. Each includes inputs -> steps -> outputs -> verification + top failure modes.

### 1) Intro -> World Stability
**Inputs:** new game action, prologue skip
**Steps:**
1. Run project -> `MainMenu._on_new_game_pressed()`
2. In prologue, call `_request_skip()` (or press `ui_cancel`)
3. Confirm runtime scene path is `world.tscn`
4. Check fade alpha is 0 (`SceneManager._fade_rect.color.a`)
**Outputs:** runtime scene shows World; no black screen
**Verification:** `get_runtime_scene_structure` shows World; fade alpha 0
**Failure modes:**
- Scene load fails due to script parse errors (warnings-as-errors)
- Fade alpha stuck at 1.0 (black screen)
- MCP input not registered (use runtime eval fallback)

### 2) Quest 0-1 Smoke + Marker Toggles
**Inputs:** `quest_1_active` flag
**Steps:**
1. Set flag via `/root/GameState.set_flag('quest_1_active', true)`
2. Verify `World/QuestMarkers/Quest1Marker.visible == true`
3. Verify Boat/HouseDoor/MortarPestle exist
**Outputs:** marker visible + interactables present
**Verification:** marker visible only when quest active
**Failure modes:**
- Flag not set via autoload path
- Marker path mismatch / renamed node

### 3) Map Readability + Screenshot Loop
**Inputs:** concept art refs + current map layout
**Steps:**
1. Capture baseline Papershot
2. Make one readability tweak (paths/contrast/noise)
3. Capture after shot
4. Log before/after filenames
**Outputs:** paired screenshots in `temp/screenshots/`
**Verification:** visual delta recorded + note in Roadmap
**Failure modes:**
- Papershot folder mismatch
- No visual delta between passes

### 4) Minigame Smoke (Crafting)
**Inputs:** CraftingController in world
**Steps:**
1. Ensure `quest_2_active` true
2. Call `CraftingController.start_craft('moly_grind')`
3. Confirm minigame UI appears (no errors)
**Outputs:** minigame started (manual completion deferred)
**Verification:** Crafting UI visible / no runtime errors
**Failure modes:**
- Missing CraftingController node
- Recipe ID mismatch

### 5) Save/Load Sanity
**Inputs:** world state after intro
**Steps:**
1. Call `SaveController.save_game()`
2. Call `SaveController.load_game()`
3. Verify world still loaded
**Outputs:** save+load returns true
**Verification:** load returns true + world in tree
**Failure modes:**
- Save data mismatch; load returns false
- Load resets to main menu unexpectedly

---

## Local Beta Roadmap (Detailed Handoff)

### A) Core Playability
1. Full intro playthrough (no skip) -> world transition; log any black screen or fade issues.
2. Quest 0: Aeetes note triggers; house entry/exit placement verified.
3. Quest 1: Hermes intro dialogue; herb identification minigame completes; quest_1_complete set.
4. Quest 2: Moly grind crafting; quest_2_complete set.
5. Quest 3: Boat travel -> Scylla Cove; confrontation dialogue choices; transformation cutscene.
6. Return to world via boat; ensure spawn location correct.

### B) Act 2 Progression
7. Quest 4 farming loop: till/plant/water/advance/harvest (all 9 plots).
8. Quest 5 calming draught craft; dialogue outcome; quest_5_complete.
9. Quest 6 reversal elixir craft; sacred earth minigame; quest_6_complete.
10. Quest 7 Daedalus intro + weaving minigame; woven_cloth awarded; quest_7_complete.
11. Quest 8 binding ward craft; quest_8_complete.

### C) Act 3 + Endings
12. Quest 9: Scylla reappears; Moon Tears minigame; quest_9_complete; quest_10_active.
13. Quest 10: petrification crafting; quest_10_complete; quest_11_active.
14. Quest 11: final confrontation choices; petrification cutscene; quest_11_complete.
15. Epilogue: ending choice (witch/healer); free_play_unlocked set.

### D) Save/Load Checkpoints
16. Save after world entry; load; verify flags + inventory.
17. Save mid-Act 2; load; verify quest flags unchanged.
18. Save pre-ending; load; verify ending choice still available.

### E) Visual Readability
19. Paths: confirm main paths read at glance; adjust contrast if needed.
20. Landmarks: ensure 1-2 strong focal points; add shadow/outline if needed.
21. UI: dialogue box readability (size/contrast/speaker emphasis).
22. Capture screenshot pack: intro, world, quest marker, minigame, ending.

### F) Tests + Logs
23. Run `tests/run_tests.gd` and note pass/fail.
24. Run dialogue/minigame test suites if time.
25. Update `PLAYTESTING_ROADMAP.md` with results and blockers.
26. Update `DEVELOPMENT_ROADMAP.md` with decisions + remaining gaps.

---

## Pegs Installed This Pass
- Intro -> world transition validated via skip and fade alpha check.
- Quest 1 marker toggle verified via GameState flag; core interactables present.
- Map readability screenshot captured: `Screenshot 2026-01-25 13-35-02-406.jpg`.
- Minigame smoke: `CraftingController.start_craft('moly_grind')` invoked (UI appears; full completion deferred). Screenshot: `Screenshot 2026-01-25 13-45-00-385.jpg`.
- Save/load sanity: save_game + load_game returned true (world remains loaded).
