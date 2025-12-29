# Implementation Plan: Phase 3 Playable Game Loop

## Overview
Deliver a start-to-finish playable loop with NPC-driven quest progression, basic NPC life, and a navigable world. Keep quest area triggers as a safety fallback while shifting primary progression to NPC dialogue, per Phase 3 of the roadmap.

## Context
- Phase 3 priorities and tasks are defined in `docs/execution/ROADMAP.md:205` and `docs/execution/ROADMAP.md:260`.
- Player interaction is already implemented via `InteractionZone` in `game/features/player/player.gd:15` and `game/features/player/player.tscn`.
- NPC interactions currently call `DialogueBox.start_dialogue()` via `game/features/npcs/npc_base.gd:13`.
- Quest progression is currently area-trigger driven in `game/features/world/quest_trigger.gd` and `game/features/world/world.tscn`.
- Plugins for Phase 3 (LimboAI, QuestSystem, Dialogue Manager, BurstParticles2D) are listed in `docs/execution/ROADMAP.md` and already downloaded.

## Design Decision
Use NPC dialogue as the primary quest progression path while keeping existing QuestTriggers as a fallback for early/tutorial beats. NPCs will use LimboAI for simple wandering where possible; if navigation is missing, use a lightweight patrol lerp to avoid blocking progress.

## Implementation Phases

### Phase 3.1: Plugin Verification + NPC Life

**Objective**: Confirm plugin availability and add simple NPC movement/idle behavior.

**Tasks**:
- [ ] Verify plugin enablement per `docs/execution/ROADMAP.md` (Project Settings -> Plugins).
- [ ] Add a simple LimboAI behavior tree to NPCs using `BTPlayer` and `Blackboard` nodes (or a fallback patrol script if navigation is unavailable).
- [ ] Implement idle facing changes or minimal idle animation support in `game/features/npcs/npc_base.gd`.
- [ ] Ensure NPCs remain interactable and still call `interact()` correctly.

**Success Criteria**:

Automated Verification:
- [ ] `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd`
- [ ] GdUnit4 suite (`res://tests/gdunit4`) passes

Manual Verification:
- [ ] NPCs visibly wander or idle in `game/features/world/world.tscn`
- [ ] Interaction still triggers dialogue when standing near an NPC

### Phase 3.2: NPC-Driven Quest Progression (with Trigger Fallback)

**Objective**: Make NPC dialogue the main quest progression path while keeping safety triggers for early beats.

**Tasks**:
- [ ] Wire NPC-specific dialogue IDs in `game/features/npcs/*.tscn` to progress quest flags (update `game/shared/resources/dialogues/*.tres` as needed).
- [ ] Ensure dialogue choices and completion set quest flags via `DialogueData.flags_to_set` and choice `next_id` flows.
- [ ] Update `game/features/world/quest_trigger.gd` usage to keep only early/tutorial triggers active (fallback).
- [ ] Add a lightweight guard to prevent double-advancement when both NPC and trigger fire (single flag check).

**Success Criteria**:

Automated Verification:
- [ ] Update/add GdUnit test to validate NPC dialogue sets expected flags (e.g., Hermes -> quest_1_active).
- [ ] `tests/run_tests.gd` and GdUnit4 suite pass

Manual Verification:
- [ ] Talking to Hermes sets the next quest flag and unlocks the next dialogue
- [ ] Walking through early quest trigger still advances if NPC path fails

### Phase 3.3: Interaction Prompt + World Feel

**Objective**: Improve clarity for player interaction and make the world feel navigable.

**Tasks**:
- [ ] Add a simple interaction prompt (speech bubble or exclamation) that appears when the player is near an interactable (NPC, boat, sundial).
- [ ] Ensure prompt works with D-pad only and does not require mouse.
- [ ] Add lightweight world dressing and boundaries to `game/features/world/world.tscn` (trees, rocks, landmarks, boundary colliders).
- [ ] Verify key locations remain reachable (Scylla Cove, Sacred Grove).

**Success Criteria**:

Automated Verification:
- [ ] Existing tests pass (`tests/run_tests.gd`, GdUnit4 suite)

Manual Verification:
- [ ] Prompt appears reliably when near interactables
- [ ] World boundaries prevent walking off-map
- [ ] Landmarks help navigation without additional UI

### Phase 3.4: Start-to-Finish Playthrough Validation

**Objective**: Complete the full game loop without manual scene loading.

**Tasks**:
- [ ] Run the Phase 3 playthrough sequence in `docs/execution/ROADMAP.md` and log results.
- [ ] Fix any blockers or soft-locks discovered.
- [ ] Update Phase 3 checkpoint in the roadmap (50% and 100%) with notes and evidence.

**Success Criteria**:

Automated Verification:
- [ ] `tests/run_tests.gd` passes
- [ ] `tests/smoke_test.tscn` passes
- [ ] `tests/phase3_scene_load_runner.gd` passes

Manual Verification:
- [ ] New Game -> Ending works without manual scene loading
- [ ] NPCs are interactable and quest progression is clear
- [ ] D-pad only controls work across menus and minigames

## Dependencies
- LimboAI plugin enabled and discoverable via `ClassDB.class_exists("BTPlayer")`.
- Dialogue IDs and quest flags updated to match NPC-driven progression.
- Navigation mesh or fallback patrol behavior for NPC movement.

## Risks and Mitigations
- **Risk**: Double-advancement when trigger and NPC both fire.  
  **Mitigation**: Guard quest flags in NPC dialogue and trigger handlers.
- **Risk**: LimboAI unavailable or navigation missing.  
  **Mitigation**: Use simple patrol fallback without navigation.
- **Risk**: Dialogue/flag mismatches block progression.  
  **Mitigation**: Add a minimal GdUnit check for critical flags.

Edit Signoff: [Codex - 2025-12-29]
