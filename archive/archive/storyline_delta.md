# Storyline Delta Checklist

Purpose: Track the gaps between the narrative script and the current in-game implementation so other agents can pick up targeted tasks quickly.

Sources
- Narrative: docs/design/Storyline.md
- Mechanical flow: docs/mechanical_walkthrough.md
- HPV reference: tests/visual/playthrough_guide.md
- Code paths: game/features/*, game/shared/resources/*

## Quest 0 - Prologue and Arrival

Current notes
- Prologue cutscene exists in game/features/cutscenes/prologue_opening.tscn.
- Arrival dialogue exists in game/shared/resources/dialogues/aiaia_arrival.tres and is triggered in game/features/world/world.gd.

Delta tasks
- [ ] Add a house interior scene (target: game/features/locations/aiaia_house.tscn) and a door trigger from game/features/world/world.tscn.
- [ ] Add an Aeetes note interactable inside the house and its dialogue resource (target: game/shared/resources/dialogues/aeetes_note.tres).
- [ ] Confirm quest_0_complete is set after the arrival sequence; adjust dialogue or scene flow if needed.
- [ ] Decide whether prologue_opening.tres should be kept, or if the cutscene script is the only source for prologue text.

## Quest 1 - Herb Identification

Current notes
- Quest 1 flow is functional through act1_herb_identification and the herb minigame.

Delta tasks
- [ ] Verify Hermes warning choice flow appears before quest_2_active is set (quest2_start + choice dialogues).
- [ ] Confirm quest_1_complete_dialogue_seen is set by the quest1_complete dialogue if that flag is still used.

## Quest 2 - Extract the Sap

Current notes
- Mortar interaction triggers crafting controller in game/features/world/world.gd.
- Recipe id is moly_grind (game/shared/resources/recipes/moly_grind.tres).

Delta tasks
- [ ] Align the Quest 2 instruction text with the recipe input (moly_grind includes one ui_accept button prompt).
- [ ] Confirm quest_2_active is set by the Hermes choice branch and quest_2_complete is set by crafting completion.

## Quest 3 - Confront Scylla and Exile

Current notes
- act1_confront_scylla.tres is short and sets quest_3_complete immediately.
- scylla_cove.tscn is a placeholder location with no confrontation cutscene.

Delta tasks
- [ ] Expand act1_confront_scylla.tres to include choice branches from docs/design/Storyline.md.
- [ ] Add a transformation cutscene (scene + script) and wire it from the confrontation flow.
- [ ] Add an exile cutscene (Zeus/Helios) and return to Aiaia before Act 2 starts.
- [ ] Set quest_3_complete after the cutscenes instead of at confrontation start.

## Act 2 - Quests 4-8 (Garden, Potions, Weaving)

Current notes
- Dialogue resources exist but are brief (quest4_start, quest5_start, quest6_start, quest7_start, quest8_start, act2_*).
- Weaving minigame exists in game/features/minigames/weaving_minigame.tscn.

Delta tasks
- [ ] Expand dialogue resources to match Storyline beats (Hermes updates, Aeetes teaching, Daedalus support).
- [ ] Check recipe vs narrative mismatches:
  - calming_draught uses pharmaka_flower; Storyline mentions lotus/golden_glow.
  - binding_ward uses nightshade + woven_cloth; Storyline mentions sacred earth.
- [ ] Update game/features/world/world.gd to route binding_ward crafting when quest_7_active or quest_8_active.
- [ ] Confirm loom flow awards woven_cloth and advances quest_7_complete as expected.

## Act 3 - Quests 9-11 and Epilogue

Current notes
- petrification_potion recipe does not include divine_blood.
- epilogue_ending_choice.tres has no choices and only sets free_play_unlocked.

Delta tasks
- [ ] Add divine_blood item data and a cutscene (or adjust Storyline to remove it).
- [ ] Add final confrontation dialogue choices and a petrification cutscene to conclude quest_11.
- [ ] Decide whether quest_11_complete should be set by crafting or after the final confrontation.
- [ ] Implement ending choice dialogue and ending flags if free play is intended.

## System Notes

- [ ] DialogueData.next_dialogue_id is not used by game/features/ui/dialogue_box.gd; decide if it should be supported or removed from resources.
- [ ] Confirm any quest flag naming changes (quest_0_active/complete) are reflected in tests and docs.

[Codex - 2026-01-11]
