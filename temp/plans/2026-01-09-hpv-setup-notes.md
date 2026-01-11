# Temporary HPV Setup Notes

## Purpose
This note captures the current HPV (Headed Playability Validation) setup, the immediate intent, and a practical path to validate Quest 1 and Quest 2 end-to-end without running minigames. It is intended as a short-lived reference while the workflow is being vetted.

## Current Setup (Observed)
- Godot editor can be launched via CLI with `-e --path .` to activate the MCP server.
- MCP connection runs over WebSocket on port 9080.
- Godot debug server listens on port 6007 when a debug session is active.
- MCP can:
  - Run the project.
  - Inspect the runtime scene tree.
  - Evaluate runtime expressions (code-level visibility).
  - Simulate input (ui actions) for headed playthrough.

## What We're Attempting (Qualified Intent)
- Prefer a headed, human-like playthrough from the start menu through Quest 2, while using MCP runtime inspection to confirm state.
- Use code-level checks to confirm quest flags, inventory updates, and active UI nodes without relying on screenshots.
- Keep the workflow as lightweight and repeatable as possible while the quest flow is still evolving.
- Minigame testing is explicitly out of scope for HPV and is handled separately; playtesters do not validate minigame mechanics here.

## Expected Behavior (If Setup Is Healthy)
- MCP connects after the Godot editor is running.
- The game can be launched via MCP and remains responsive to simulated input.
- The runtime scene tree reflects the current screen (menu, prologue, world, minigame).
- Runtime evaluations can read key state, e.g.:
  - `GameState` flags for prologue/quest completion.
  - `Player` position after simulated movement.
  - Quest nodes and signals when quest flows are active.

## Full HPV Validation (Quest 1 -> Quest 2)
This is a suggested, robust pass that balances automation with verification while skipping minigames. It should be repeatable and tolerant of small scene changes:

1. Start at main menu (headed)
   - MCP: `run_project`.
   - MCP: confirm menu nodes present in runtime tree.
2. Enter new game
   - Simulate `ui_accept`.
   - Confirm prologue UI appears in runtime tree.
3. Advance prologue
   - Simulate taps/inputs to advance text.
   - Confirm `prologue_complete` flag toggles.
4. Enter world
   - Confirm `World` and `Player` nodes appear.
   - Simulate movement and verify `Player.global_position` changes.
5. Trigger Quest 1
   - Move to quest trigger or use in-world interaction.
   - Confirm quest-related UI/minigame nodes appear.
6. Skip Quest 1 minigame (manual testing handled separately)
   - Mark Quest 1 complete using the approved shortcut.
   - Verify `quest_1_complete` flag and inventory updates.
7. Trigger Quest 2
   - Navigate to mortar & pestle or trigger via interaction.
   - Confirm crafting controller is available.
8. Skip Quest 2 minigame (manual testing handled separately)
   - Mark Quest 2 complete using the approved shortcut.
   - Verify `quest_2_complete` flag and inventory updates.

## Current Execution Plan (Option A, minigames skipped)
This is the quick plan for the current run, intended to keep inputs human-like while skipping minigames:

1. Start menu -> Prologue
   - MCP `run_project`, then `ui_accept` to begin.
   - Tap through prologue dialogue until `World` is active.
2. Enter World
   - Confirm `World` + `Player` nodes.
   - Move via D-pad to Quest 1 trigger area.
3. Quest 1 start
   - Advance dialogue until Quest 1 completion moment.
   - Apply approved Quest 1 completion shortcut.
   - Verify `quest_1_complete` and `pharmaka_flower` inventory updates.
4. Quest 2 activation
   - Walk to Hermes, interact, advance dialogue until `quest_2_active` is true.
5. Quest 2 completion shortcut (approved)
   - Interact with MortarPestle to confirm access.
   - Mark Quest 2 complete without running the minigame.
   - Verify `quest_2_complete` and `transformation_sap` inventory updates.

## Current Run Status (2026-01-09)
- Previous runtime session was gone; restarted via MCP and re-launched the project.
- Entered World from main menu (prologue advanced via input).
- Hermes interactions triggered via `Hermes.interact()` to advance quest dialogues quickly.
- Quest 1 minigame skipped (per HPV policy) using:
  - `World._on_herb_minigame_complete(true, [...])`
  - `GameState.add_item('pharmaka_flower', 3)`
- Quest 2 minigame skipped (per HPV policy) using:
  - `MortarPestle.interact()` then `CraftingController._on_crafting_complete(true)`
- Current flags/items:
  - `quest_1_complete = true`
  - `quest_2_active = true`
  - `quest_2_complete = true`
  - `pharmaka_flower = 3`
  - `transformation_sap = 1`
- Quest 3 progressed:
  - `quest_3_active = true` via Hermes `quest3_start`
  - `quest_3_complete = true` via Quest3 trigger (`act1_confront_scylla` dialogue) and `_end_dialogue()`
- Quest 4 started:
  - `quest_4_active = true` via Aeetes `quest4_start` and `_end_dialogue()`
## Practical Robustness Checks
- Before HPV begins, ensure Godot editor + MCP are running via the `godot-mcp-dap-start` script; if MCP still fails after restart, then ask Sam.
- If runtime tree does not update, confirm Godot editor is open and MCP is connected.
- If inputs appear ignored, verify MCP input handler logs and that the game window is focused.
- If quest flags do not change, confirm quest resources are present and quest flow has not been deprecated.

## HPV Checklist (Minigames Skipped)
- If a minigame appears during HPV, do not play it.
- Use the approved completion shortcut for that quest and log the skip.

## HPV Pitfalls Observed (for review)
- MCP runtime session can be inactive after reconnect; must `run_project` before runtime queries work.
- Repeated `ui_accept` taps are slow/timeout-prone; direct dialogue `_end_dialogue()` is more reliable for HPV.
- `ui_accept` near Hermes does not always trigger interaction; call `Hermes.interact()` directly.
- Runtime expression quoting is brittle; use single quotes inside expressions to avoid parse errors.
- Movement via simulated input can fail; `set_global_position(...)` is the reliable fallback.

## Quest 4 HPV Deep-Test Log (2026-01-09)
- Runtime had reset to main menu; used `GameState.new_game()` and manually restored quest flags to resume near Quest 4.
- Switched to world scene via `SceneManager.change_scene("res://game/features/world/world.tscn")`.
- Aeetes interaction initially returned `quest4_inprogress` (Quest 4 active, not complete).
- Triggered Quest4 Area2D manually: `QuestTriggers/Quest4._on_body_entered(Player)` to start `act2_farming_tutorial`.
- Ended `act2_farming_tutorial` dialogue; confirmed `quest_4_complete = true` and `garden_built = true`.
- Interacted with Aeetes again; `quest4_complete` dialogue played.
- Stuck: `quest_4_complete_dialogue_seen` did not set after `quest4_complete`.
  - Observed mismatch: dialogue sets `quest4_complete_dialogue_seen` (missing underscore) while code checks `quest_4_complete_dialogue_seen`.
  - Workaround: manually set `quest_4_complete_dialogue_seen = true` to proceed.
  - Fix applied in repo: `quest4_complete.tres` now sets `quest_4_complete_dialogue_seen`.
    - Note: runtime in this session still had the old resource; re-verify on a fresh run.

## Quest 5 Start (HPV continuation)
- Interacted with Aeetes; `quest5_start` dialogue triggered.
- Ended `quest5_start` dialogue; confirmed `quest_5_active = true`.
- Minigame/crafting steps are out of scope for HPV; no Quest 5 completion attempted here.

## Quest 4 Fix Validation + Quest 5 Start (restart run)
- Restarted runtime to pick up updated `quest4_complete.tres` resource.
- Reinitialized flags (post-Quest 3) and switched to world scene.
- Interacted with Aeetes; `quest4_complete` dialogue appeared.
- Ended `quest4_complete` dialogue; confirmed `quest_4_complete_dialogue_seen = true` (fix validated).
- Interacted with Aeetes again; `quest5_start` dialogue triggered.
- Ended `quest5_start` dialogue; confirmed `quest_5_active = true`.

## Quest 5 HPV Deep-Test Log (2026-01-09)
- Verified `quest_5_active = true` before proceeding.
- Triggered Quest5 Area2D: `QuestTriggers/Quest5._on_body_entered(Player)` to start `act2_calming_draught`.
- Ended `act2_calming_draught` dialogue; confirmed `quest_5_complete = true` (minigame skipped per HPV policy).
- Interacted with Aeetes; `quest5_complete` dialogue played.
- Stuck: `quest_5_complete_dialogue_seen` did not set after `quest5_complete`.
  - Observed mismatch: dialogue sets `quest5_complete_dialogue_seen` (missing underscore) while code checks `quest_5_complete_dialogue_seen`.
  - Fix applied in repo: `quest5_complete.tres` now sets `quest_5_complete_dialogue_seen`.
  - Workaround in-session: manually set `quest_5_complete_dialogue_seen = true`.

## Quest 5 Fix Validation + Quest 6 Start (restart run)
- Restarted runtime to pick up updated `quest5_complete.tres` resource.
- Reinitialized flags through Quest 5 complete and returned to world scene.
- Interacted with Aeetes; `quest5_complete` dialogue played.
- Ended `quest5_complete` dialogue; confirmed `quest_5_complete_dialogue_seen = true` (fix validated).
- Interacted with Aeetes again; `quest6_start` dialogue triggered.
- Ended `quest6_start` dialogue; confirmed `quest_6_active = true`.

## Quest 6 Restart Run (2026-01-09)
- Restarted runtime and began reapplying flags; long multi-flag batch caused MCP connection close.
  - Switched to single-flag commands to stabilize MCP.
- Reapplied flags through Quest 6 active and loaded world scene.
- Triggered Quest6 Area2D to start `act2_reversal_elixir`.
- Ended `act2_reversal_elixir` dialogue; confirmed `quest_6_complete = true`.
- Interacted with Aeetes; dialogue did not advance to `quest6_complete` (returned `aeetes_idle`).
  - Manually set `quest_7_active = true` to proceed with HPV flow.
- Found new mismatch: `quest6_complete.tres` sets `quest6_complete_dialogue_seen` (missing underscore).
  - Fix applied in repo: `quest6_complete.tres` now sets `quest_6_complete_dialogue_seen`.

## Quest 6 Fix Validation + Quest 7 Start (restart run)
- Restarted runtime to pick up updated `quest6_complete.tres`.
- Reapplied flags through `quest_6_complete` (batching flags caused MCP timeouts, used single-flag writes).
- Manually launched `quest6_complete` dialogue to verify flag setter:
  - `dialogue_ui.start_dialogue("quest6_complete")` then `_end_dialogue()`.
  - Confirmed `quest_6_complete_dialogue_seen = true` (fix validated).
- Attempted to spawn Daedalus to start Quest 7:
  - Manual spawn worked briefly, but Daedalus despawned because `quest_7_active` was false.
  - Indicates a gating issue: `quest7_start` requires Daedalus, but Daedalus only spawns when `quest_7_active` is already true.
- Workaround: manually started `quest7_start` dialogue via dialogue box.
  - Ended dialogue; confirmed `quest_7_active = true`.

## Quest 7 HPV Deep-Test Log (2026-01-09)
- Confirmed `quest_7_active = true` before proceeding.
- Started `act2_daedalus_arrives` dialogue directly (minigame skipped per HPV policy).
- Ended `act2_daedalus_arrives`; confirmed `quest_7_complete = true`.
- Found another flag mismatch:
  - `quest7_complete.tres` sets `quest7_complete_dialogue_seen` (missing underscore) while code checks `quest_7_complete_dialogue_seen`.
  - Fix applied in repo: `quest7_complete.tres` now sets `quest_7_complete_dialogue_seen`.
  - Workaround in-session: manually set `quest_7_complete_dialogue_seen = true`.
- Advanced to Quest 8 by manually setting `quest_8_active = true` (Daedalus completion gate).

## Quest 7 Fix Validation + Quest 8 Start (restart run)
- Restarted runtime to pick up updated `quest7_complete.tres`.
- Large flag batch timed out; continued with smaller batches and single-flag writes.
- Manually launched `quest7_complete` dialogue; ended it and confirmed `quest_7_complete_dialogue_seen = true`.
- Started `quest8_start` dialogue directly (Daedalus gating issue persists).
- Ended `quest8_start`; confirmed `quest_8_active = true`.

## Quest 8 HPV Deep-Test Log (2026-01-09)
- Triggered Quest8 Area2D to start `act2_binding_ward`.
- Ended `act2_binding_ward`; confirmed `quest_8_complete = true` (minigame skipped per HPV policy).
- Found another flag mismatch:
  - `quest8_complete.tres` sets `quest8_complete_dialogue_seen` (missing underscore) while code expects `quest_8_complete_dialogue_seen`.
  - Fix applied in repo: `quest8_complete.tres` now sets `quest_8_complete_dialogue_seen`.
  - Workaround in-session: manually set `quest_8_complete_dialogue_seen = true`.
- Advanced to Quest 9 by setting `quest_9_active = true`.

## Quest 8 Fix Validation + Quest 9 Flow (restart run)
- Restarted runtime to pick up updated `quest8_complete.tres`.
- Flag reapplication required small batches; large batches timed out.
- Manually launched `quest8_complete` dialogue; ended it and confirmed `quest_8_complete_dialogue_seen = true`.
- Started `quest9_start` dialogue manually; confirmed `quest_9_active = true`.
- Ran `act3_sacred_earth` dialogue; confirmed `quest_9_complete = true`.
- Found another flag mismatch:
  - `quest9_complete.tres` sets `quest9_complete_dialogue_seen` (missing underscore).
  - Fix applied in repo: `quest9_complete.tres` now sets `quest_9_complete_dialogue_seen`.
  - Workaround in-session: manually set `quest_9_complete_dialogue_seen = true`.
- Advanced to Quest 10 by setting `quest_10_active = true`.

## Quest 10 HPV Deep-Test Log (2026-01-09)
- Started `act3_moon_tears` dialogue; ended it and confirmed `quest_10_complete = true`.
- Found another flag mismatch:
  - `quest10_complete.tres` sets `quest10_complete_dialogue_seen` (missing underscore).
  - Fix applied in repo: `quest10_complete.tres` now sets `quest_10_complete_dialogue_seen`.
  - Workaround in-session: manually set `quest_10_complete_dialogue_seen = true`.
- Advanced to Quest 11 by setting `quest_11_active = true`.

## Quest 11 + Epilogue HPV Deep-Test Log (2026-01-09)
- Started `act3_final_confrontation`; ended it and confirmed `quest_11_complete = true`.
- Found another flag mismatch:
  - `quest11_complete.tres` sets `quest11_complete_dialogue_seen` (missing underscore).
  - Fix applied in repo: `quest11_complete.tres` now sets `quest_11_complete_dialogue_seen`.
  - Workaround in-session: manually set `quest_11_complete_dialogue_seen = true`.
- Triggered Epilogue Area2D; `epilogue_ending_choice` dialogue appeared.
- Ended `epilogue_ending_choice`; confirmed `free_play_unlocked = true`.

## Quest 11 Fix Validation (restart run)
- Restarted runtime; large flag batches timed out, so flags were applied in smaller groups.
- Manually launched `quest11_complete` dialogue; ended it and confirmed `quest_11_complete_dialogue_seen = true` (fix validated).

## When This Is "Vetted" (Provisional)
This workflow can be considered vetted after a full headed playthrough from the menu through Quest 2 completes with:
- Inputs registering correctly.
- Quest flags updating as expected.
- Minigames skipped in HPV and verified separately.
- No soft-locks or blocked transitions.

[Codex - 2026-01-09]

