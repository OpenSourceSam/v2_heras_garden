# PHASE 2: STORY IMPLEMENTATION

**Dependencies:** Phase 1 complete (player, farming, crafting, dialogue systems working)

---

## OVERVIEW

Implement all 11 quests from Storyline.md across Prologue + 3 Acts + Epilogue.

**Approach:** Create one quest at a time, test, verify, commit.

---

## PROLOGUE: HEARTBREAK (2-3 min)

### Quest 0: Opening Cutscene

**Tasks:**
1. Create cutscene system (text overlays, fade transitions)
2. Implement Circe's internal monologue
3. Scene: Helios's palace (static background)
4. Dialogue: Circe watching Glaucos + Scylla
5. Dialogue: Helios grants permission to visit Aiaia
6. Transition: Fade to Aiaia island

**Deliverables:**
- `scenes/cutscenes/prologue_opening.tscn`
- `resources/dialogues/prologue_helios.tres`
- Background art: `assets/sprites/backgrounds/helios_palace.png`

**Test:** Can play from start, see dialogue, transition to Aiaia

---

## ACT 1: JEALOUSY & TRANSFORMATION (15-20 min)

### Quest 1: "Find the Pharmaka"

**Goal:** Learn herb identification minigame

**Tasks:**
1. Trigger: Player explores island, finds glowing area
2. Tutorial: Identify 3 pharmaka flowers among 60 total plants
3. Minigame difficulty: Easy (glowing obvious), Medium (subtle glow), Hard (movement)
4. Reward: 3× Pharmaka Flower

**Deliverables:**
- `src/minigames/herb_identification.gd`
- `scenes/minigames/herb_identification.tscn`
- Sprites: `assets/sprites/herbs/pharmaka_glow.png`

**Test:** Can identify all 3 pharmaka, fail on wrong selections

---

### Quest 2: "Extract the Sap"

**Goal:** First crafting tutorial

**Tasks:**
1. Trigger: Return to house with pharmaka
2. Tutorial: Simple crafting pattern (↑ → ↓ ←, repeat 3x)
3. No button prompts yet (tutorial level)
4. Success: Create Transformation Sap
5. Dialogue: Circe's dark resolve

**Deliverables:**
- Recipe: `resources/recipes/transformation_sap.tres`
- Dialogue: `resources/dialogues/circe_sap_crafted.tres`

**Test:** Can craft transformation sap, dialogue plays

---

### Quest 3: "Confront Scylla"

**Goal:** Transform Scylla (major story beat)

**Tasks:**
1. Trigger: Interact with boat on beach
2. Cutscene: Sailing to Scylla's cove
3. Interactive: Choice dialogue (3 options, all converge)
4. Animation: Scylla transformation (sprite swap + effects)
5. Cutscene: Zeus and Helios appear, declare exile
6. Set flags: `transformed_scylla`, `exiled_to_aiaia`

**Deliverables:**
- `scenes/locations/scylla_cove.tscn`
- `resources/dialogues/scylla_confrontation.tres`
- `resources/dialogues/zeus_exile.tres`
- Sprites: `assets/sprites/characters/scylla_before.png`, `scylla_after.png`
- VFX: Transformation particle effect

**Test:** Full quest playable, Scylla transforms, exile declared

---

## ACT 2: GUILT & FAILED REDEMPTION (30-40 min)

### Quest 4: "Build a Garden"

**Goal:** Farming tutorial

**Tasks:**
1. One week time skip (text: "ONE WEEK LATER")
2. Hermes arrives with pharmaka seeds
3. Tutorial: Till 9 plots, plant 3 types, water, advance time
4. Harvest: 3× Moly, 3× Nightshade, 3× Lotus
5. Set flag: `garden_built`

**Deliverables:**
- `resources/crops/moly.tres`, `nightshade.tres`, `lotus.tres`
- `resources/items/moly_seed.tres`, etc.
- Sprites: `assets/sprites/crops/moly_stages.png` (4 frames)

**Test:** Can farm all 3 crop types, harvest works

---

### Quest 5: "Calming Draught"

**Goal:** First failed redemption attempt

**Tasks:**
1. Unlock recipe: Calming Draught (2× Moly, 1× Lotus)
2. Crafting difficulty: Medium (16 inputs, 4 buttons, 1.5s timing)
3. Sail to Scylla's cave
4. Cutscene: Scylla rejects potion violently
5. Set flag: `calming_draught_failed`

**Deliverables:**
- `resources/recipes/calming_draught.tres`
- `resources/dialogues/scylla_rejects_calming.tres`

**Test:** Craft potion, Scylla refuses, player returns defeated

---

### Quest 6: "Reversal Elixir"

**Goal:** Second failed attempt

**Tasks:**
1. Aeëtes visits, teaches advanced recipe
2. Herb identification: Find 3× Saffron (hard mode)
3. Craft Reversal Elixir (harder pattern)
4. Give to Scylla, she drinks it
5. Potion fails, Scylla still a monster
6. Set flag: `reversal_elixir_failed`

**Deliverables:**
- `resources/npcs/aeetes.tres`
- `resources/dialogues/aeetes_teaches.tres`
- `resources/recipes/reversal_elixir.tres`
- `resources/dialogues/scylla_accepts_elixir.tres`

**Test:** Full sequence, potion fails, despair

---

### Quest 7: "Daedalus Arrives"

**Goal:** Emotional support, philosophical guidance

**Tasks:**
1. Daedalus ship arrives
2. Dialogue: Opens up about Scylla
3. Daedalus suggests: "Ask her what she wants"
4. Gift: Loom (unlocks weaving minigame)
5. Set flag: `met_daedalus`

**Deliverables:**
- `resources/npcs/daedalus.tres`
- `resources/dialogues/daedalus_conversation.tres`
- `src/minigames/weaving.gd` (optional minigame)

**Test:** Conversation works, loom appears, can weave (optional)

---

### Quest 8: "The Binding Ward"

**Goal:** Third failed attempt

**Tasks:**
1. Gather Sacred Earth (button mash minigame)
2. Craft Binding Ward (expert difficulty)
3. Attempt to bind Scylla
4. Scylla breaks free: "JUST LET ME DIE!"
5. Set flag: `binding_ward_failed`, `scylla_wants_death`

**Deliverables:**
- `resources/recipes/binding_ward.tres`
- `resources/dialogues/scylla_breaks_free.tres`
- Minigame: `src/minigames/dig_sacred_earth.gd`

**Test:** All attempts fail, Scylla's plea heard

---

## ACT 3: THE STONE SOLUTION (15-20 min)

### Quest 9: "Gather Final Ingredients"

**Goal:** Collect Moon Tears and Divine Blood

**Tasks:**
1. Advance to night (full moon)
2. Minigame: Catch 3× Moon Tears
3. Cutscene: Circe cuts palm for Divine Blood
4. Inventory check: All ingredients ready

**Deliverables:**
- Minigame: `src/minigames/moon_tear_catching.gd`
- Cutscene: `scenes/cutscenes/divine_blood.tscn`
- Items: `resources/items/moon_tear.tres`, `divine_blood.tres`

**Test:** Can collect all ingredients

---

### Quest 10: "Ultimate Crafting"

**Goal:** Craft Petrification Potion (hardest challenge)

**Tasks:**
1. Recipe unlocked: Petrification Potion
2. Crafting difficulty: EXPERT (36 inputs, 10 buttons, 0.6s timing)
3. Allow infinite retries (ingredients not consumed on fail)
4. Success: Create Petrification Potion

**Deliverables:**
- `resources/recipes/petrification_potion.tres`
- Enhanced crafting UI for difficulty

**Test:** Extremely hard but beatable, retries work

---

### Quest 11: "Final Confrontation"

**Goal:** Turn Scylla to stone (emotional climax)

**Tasks:**
1. Sail to Scylla's cave (final time)
2. Dialogue: Circe offers death as mercy
3. Choice: 3 dialogue options (all lead to forgiveness)
4. Scylla: "I forgive you"
5. Cutscene: Petrification animation (6 heads turn to stone)
6. Set flag: `scylla_petrified`

**Deliverables:**
- `resources/dialogues/final_confrontation.tres`
- Animation: Petrification effect
- Sprite: `scylla_statue.png`

**Test:** Full emotional sequence, statue remains

---

## EPILOGUE: ACCEPTANCE

### Ending Choice

**Tasks:**
1. One week time skip
2. Hermes visit: Exile partially lifted
3. Daedalus loom visible (callback)
4. Choice: "Witch Path" vs "Redemption Path"
5. Ending cutscene based on choice
6. Unlock Free-Play Mode

**Deliverables:**
- `resources/dialogues/epilogue_hermes.tres`
- `scenes/cutscenes/ending_a.tscn` (Witch of Aiaia)
- `scenes/cutscenes/ending_b.tscn` (Healer's Path)

**Test:** Both endings reachable, free-play unlocks

---

## IMPLEMENTATION ORDER

1. ✅ Get Prologue working first (validate cutscene system)
2. ✅ Act 1 Quest 1-3 (establish core loop)
3. ✅ Act 2 Quest 4 (validate farming)
4. ✅ Act 2 Quest 5-8 (failed redemptions)
5. ✅ Act 3 Quest 9-11 (climax)
6. ✅ Epilogue (endings)

**Estimate:** 2-3 weeks for full story implementation

---

## TESTING CHECKLIST

After each quest:
- [ ] Quest triggers correctly
- [ ] Dialogue displays properly
- [ ] Flags set correctly
- [ ] Can complete without errors
- [ ] Transitions to next quest
- [ ] No console errors

Full playthrough test:
- [ ] Start to finish (65-90 min)
- [ ] Both endings reachable
- [ ] All flags work
- [ ] Save/load doesn't break progression

---

**End of Phase 2 Roadmap**
