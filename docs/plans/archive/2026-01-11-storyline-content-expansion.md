# Implementation Plan: Storyline Content Expansion

## Overview
Build out the missing narrative beats and quest wiring so the in-game flow aligns with the current story reference. This plan treats `docs/mechanical_walkthrough.md` as the canonical mechanical guide, uses `docs/design/Storyline.md` for narrative intent, and keeps `tests/visual/playthrough_guide.md` as the HPV reference.

## Context
- Mechanical flow reference: `docs/mechanical_walkthrough.md`
- Narrative script reference: `docs/design/Storyline.md`
- HPV playthrough reference: `tests/visual/playthrough_guide.md`
- Quest state and routing: `game/autoload/game_state.gd`, `game/features/npcs/npc_base.gd`
- World wiring and interactables: `game/features/world/world.gd`, `game/features/world/world.tscn`
- Dialogue resources: `game/shared/resources/dialogues/*.tres`
- Crafting recipes and items: `game/shared/resources/recipes/*.tres`, `game/shared/resources/items/*.tres`

## Design Decision
Anchor on the current implementation for flags and routing (mechanical walkthrough), then fill missing scenes and dialogue beats using the narrative script. Document deltas as a checklist so other agents can implement in parallel without re-reading the entire storyline.

## Implementation Phases

### Phase 1: Storyline Alignment and Deltas

**Objective**: Create a clear delta list between narrative intent and current implementation.

**Tasks**:
- [ ] Create `docs/design/storyline_delta.md` with a quest-by-quest checklist referencing `docs/design/Storyline.md`, `docs/mechanical_walkthrough.md`, and `tests/visual/playthrough_guide.md`.
- [ ] Flag missing scenes and interactions (house interior, note read, exile cutscene, weaving minigame) with file targets.
- [ ] Record any naming mismatches (quest names, item ids, dialogue ids) with suggested canonical names.

**Success Criteria**:

Automated Verification:
- [ ] None expected.

Manual Verification:
- [ ] Delta checklist can be used without opening the full storyline doc.

### Phase 2: Quest 0 - Prologue and Arrival

**Objective**: Ensure the prologue and arrival beats are playable and set the intended flags.

**Tasks**:
- [ ] Review `game/features/cutscenes/prologue_opening.tscn` and `game/shared/resources/dialogues/prologue_opening.tres` against the prologue in `docs/design/Storyline.md`.
- [ ] Implement a house interior scene (target: `game/features/locations/aiaia_house.tscn`) and a transition trigger from `game/features/world/world.tscn`.
- [ ] Add an Aeetes note interactable in the house and a dialogue resource for the note content.
- [ ] Confirm `quest_0_active`, `quest_0_complete`, and `aiaia_arrival_shown` timing in `game/autoload/game_state.gd` and `game/features/world/world.gd`.

**Success Criteria**:

Automated Verification:
- [ ] `tests/run_tests.gd` passes.

Manual Verification:
- [ ] Prologue plays to completion, arrival dialogue triggers once, and the note can be read in the house.

### Phase 3: Quest 1-2 - Hermes Warning and Sap Extraction

**Objective**: Solidify the Quest 1 completion to Quest 2 start flow and sap crafting.

**Tasks**:
- [ ] Validate Hermes warning choices in `game/shared/resources/dialogues/quest2_start.tres` and branch dialogues.
- [ ] Confirm `game/features/world/world.gd` maps Quest 2 to `moly_grind` and awards `transformation_sap`.
- [ ] Ensure `game/features/ui/crafting_controller.tscn` and minigame UI prompt the Quest 2 pattern clearly.
- [ ] Update Quest 2 completion wiring (dialogue or crafting completion) to set `quest_2_complete` and `quest_3_active`.

**Success Criteria**:

Automated Verification:
- [ ] `tests/run_tests.gd` passes.

Manual Verification:
- [ ] Quest 2 starts after Hermes warning and the mortar flow yields `transformation_sap`.

### Phase 4: Quest 3 - Scylla Transformation and Exile

**Objective**: Implement the confrontation, transformation, and exile beats in a playable flow.

**Tasks**:
- [ ] Expand `game/shared/resources/dialogues/act1_confront_scylla.tres` to include choice branches from `docs/design/Storyline.md`.
- [ ] Add or update a transformation cutscene in `game/features/locations/scylla_cove.tscn` and its script.
- [ ] Create an exile cutscene scene (target: `game/features/cutscenes/exile.tscn`) and transition back to Aiaia.
- [ ] Set `quest_3_complete` after the cutscene and start Act 2 flags.

**Success Criteria**:

Automated Verification:
- [ ] `tests/run_tests.gd` passes.

Manual Verification:
- [ ] Scylla confrontation choices appear, transformation plays, and exile cutscene transitions to Act 2.

### Phase 5: Act 2 - Quests 4-8 (Garden, Potions, Weaving)

**Objective**: Fill in Act 2 quest beats and any missing systems.

**Tasks**:
- [ ] Verify Aeetes and Daedalus dialogue flows in `game/features/npcs/npc_base.gd` and corresponding dialogue resources.
- [ ] Implement weaving minigame (target: `game/features/minigames/weaving_minigame.tscn`) and hook to `game/features/world/world.gd` loom flow.
- [ ] Align potion recipes (`calming_draught`, `reversal_elixir`, `binding_ward`) with dialogue instructions.
- [ ] Add quest completion dialogue flags where missing.

**Success Criteria**:

Automated Verification:
- [ ] `tests/run_tests.gd` passes.

Manual Verification:
- [ ] Act 2 quests progress in order and all minigames are accessible from the world scene.

### Phase 6: Act 3 - Final Ingredients, Petrification, Epilogue

**Objective**: Deliver the Act 3 finale and endings.

**Tasks**:
- [ ] Confirm Sacred Earth and Moon Tears minigames gate Quest 9-10 correctly.
- [ ] Implement final confrontation dialogue choices and petrification cutscene.
- [ ] Add epilogue choice dialogue and set ending flags (for free play or end state).

**Success Criteria**:

Automated Verification:
- [ ] `tests/run_tests.gd` passes.

Manual Verification:
- [ ] Quest 11 completes and an ending choice is presented with expected flags set.

## Dependencies
- Narrative approval for any edits that diverge from `docs/design/Storyline.md`.
- Art/animation assets for cutscenes and minigame UI polish.

## Risks and Mitigations
- **Risk**: Missing dialogue resource targets for choices.
  - **Mitigation**: Add a small test to validate `next_id` targets and run `tests/run_tests.gd`.
- **Risk**: Cutscene or scene transitions cause soft locks.
  - **Mitigation**: Add HPV checks using `tests/visual/playthrough_guide.md` and run short MCP playthroughs after each phase.

[Codex - 2026-01-11]
