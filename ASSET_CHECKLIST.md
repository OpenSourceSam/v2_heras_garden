# CIRCE'S GARDEN - ASSET CHECKLIST

**Purpose:** Complete list of all assets needed for the game

---

## SPRITES (All 32x32 base, or multiples of 32)

### Characters

**Circe (Player)**
- [ ] `hera_idle.png` (32×32, 4 frames)
- [ ] `hera_walk.png` (32×32, 4 frames)
- [ ] `hera_portrait.png` (64×64, dialogue)

**Scylla**
- [ ] `scylla_before.png` (32×48, beautiful nymph)
- [ ] `scylla_after.png` (64×96, 6-headed monster)
- [ ] `scylla_statue.png` (64×96, stone version)

**Hermes**
- [ ] `hermes_idle.png` (32×32)
- [ ] `hermes_portrait.png` (64×64)

**Aeëtes**
- [ ] `aeetes_portrait.png` (64×64)

**Daedalus**
- [ ] `daedalus_portrait.png` (64×64)

**Gods (Cutscenes)**
- [ ] `helios.png` (64×64, glowing)
- [ ] `zeus.png` (64×64, angry)

---

### Crops (Growth Stages)

**Each crop: 4 stages (seed → sprout → growing → mature)**

- [ ] `moly_stages.png` (32×32 × 4 frames, white flowers)
- [ ] `nightshade_stages.png` (32×32 × 4 frames, purple berries)
- [ ] `lotus_stages.png` (32×32 × 4 frames, pink blooms)
- [ ] `saffron_stages.png` (32×32 × 4 frames, red stamens)

**Placeholder:** Use colored squares for early testing

---

### Items (Inventory Icons)

**Seeds**
- [ ] `moly_seed_icon.png` (32×32)
- [ ] `nightshade_seed_icon.png` (32×32)
- [ ] `lotus_seed_icon.png` (32×32)
- [ ] `saffron_seed_icon.png` (32×32)

**Harvested Herbs**
- [ ] `moly_icon.png` (32×32)
- [ ] `nightshade_icon.png` (32×32)
- [ ] `lotus_icon.png` (32×32)
- [ ] `saffron_icon.png` (32×32)

**Special Items**
- [ ] `sacred_earth_icon.png` (32×32)
- [ ] `moon_tear_icon.png` (32×32)
- [ ] `divine_blood_icon.png` (32×32)

**Potions**
- [ ] `transformation_sap_icon.png` (32×32, purple-gold)
- [ ] `calming_draught_icon.png` (32×32, blue)
- [ ] `reversal_elixir_icon.png` (32×32, silver)
- [ ] `binding_ward_icon.png` (32×32, glowing chains)
- [ ] `petrification_potion_icon.png` (32×32, white)

---

### Tilesets

**Ground Tiles** (32×32 each)
- [ ] `grass.png` (base terrain)
- [ ] `dirt.png` (paths)
- [ ] `tilled_soil.png` (farmable)
- [ ] `stone.png` (cliffs)
- [ ] `sand.png` (beach)
- [ ] `water.png` (animated, 4 frames)

**Autotile:** Create 16-tile autotile set for smooth transitions

---

### UI Elements

**Dialogue**
- [ ] `dialogue_box.png` (panel 9-slice)
- [ ] `dialogue_choice_button.png` (9-slice)
- [ ] `dialogue_arrow.png` (continue indicator)

**HUD**
- [ ] `inventory_slot.png` (32×32 frame)
- [ ] `inventory_panel.png` (panel background)
- [ ] `health_bar.png` (if needed)
- [ ] `day_counter_bg.png`

**Crafting**
- [ ] `mortar_pestle.png` (64×64)
- [ ] `crafting_bg.png` (full screen)
- [ ] `pattern_arrow.png` (directional indicators)
- [ ] `button_prompt.png` (A, B, X icons)

**Menus**
- [ ] `main_menu_bg.png`
- [ ] `button_normal.png` (9-slice)
- [ ] `button_hover.png` (9-slice)
- [ ] `button_pressed.png` (9-slice)

---

### Backgrounds (Static)

- [ ] `helios_palace.png` (1080×1240, prologue)
- [ ] `aiaia_beach.png` (1080×1240, arrival)
- [ ] `scylla_cove.png` (1080×1240, confrontations)
- [ ] `aiaia_garden.png` (1080×1240, farming area)
- [ ] `titan_battlefield.png` (1080×1240, pharmaka location)

---

### VFX (Effects)

- [ ] `transformation_particles.png` (purple swirl)
- [ ] `petrification_sparkles.png` (white sparkles)
- [ ] `glow_aura.png` (for pharmaka)
- [ ] `water_ripple.png` (for watering)
- [ ] `harvest_pop.png` (item pickup)

---

## AUDIO

### Music (OGG format, looping)

- [ ] `main_theme.ogg` (calm, atmospheric)
- [ ] `prologue_theme.ogg` (melancholy)
- [ ] `transformation_theme.ogg` (dark, intense)
- [ ] `guilt_theme.ogg` (somber)
- [ ] `final_confrontation.ogg` (emotional)
- [ ] `epilogue_theme.ogg` (hopeful or bittersweet)

**Placeholder:** Use royalty-free tracks from freesound.org or incompetech.com

---

### SFX (WAV format, short)

**Farming**
- [ ] `till_soil.wav` (digging sound)
- [ ] `plant_seed.wav` (gentle plop)
- [ ] `water_crop.wav` (splash)
- [ ] `harvest.wav` (satisfying pop)

**Crafting**
- [ ] `grind_stone.wav` (mortar grinding)
- [ ] `correct_input.wav` (chime)
- [ ] `wrong_input.wav` (buzz)
- [ ] `crafting_success.wav` (magical sparkle)
- [ ] `crafting_fail.wav` (fizzle)

**UI**
- [ ] `button_click.wav`
- [ ] `dialogue_advance.wav` (text blip)
- [ ] `menu_open.wav`
- [ ] `menu_close.wav`

**Story Events**
- [ ] `transformation_scream.wav` (Scylla's pain)
- [ ] `petrification.wav` (stone spreading)
- [ ] `divine_appear.wav` (gods arriving)
- [ ] `sail_boat.wav` (traveling)

**Ambient**
- [ ] `ocean_waves.wav` (looping)
- [ ] `wind.wav` (looping)
- [ ] `birds_chirping.wav` (daytime)

---

## FONTS

- [ ] `main_font.ttf` (readable, fantasy style)
- [ ] `title_font.ttf` (decorative, Greek-inspired)

**Recommendation:** Use Google Fonts (Cinzel, Philosopher, EB Garamond)

---

## RESOURCE FILES (.tres)

### Crops (4 total)
- [ ] `resources/crops/moly.tres`
- [ ] `resources/crops/nightshade.tres`
- [ ] `resources/crops/lotus.tres`
- [ ] `resources/crops/saffron.tres`

### Items (20+ total)
- [ ] Seeds: 4 types
- [ ] Herbs: 4 types
- [ ] Special: 3 types
- [ ] Potions: 5 types
- [ ] Tools: watering_can, hoe

### Recipes (5 total)
- [ ] `resources/recipes/transformation_sap.tres`
- [ ] `resources/recipes/calming_draught.tres`
- [ ] `resources/recipes/reversal_elixir.tres`
- [ ] `resources/recipes/binding_ward.tres`
- [ ] `resources/recipes/petrification_potion.tres`

### Dialogues (20+ total)
- [ ] Prologue: 2 dialogues
- [ ] Act 1: 6 dialogues
- [ ] Act 2: 8 dialogues
- [ ] Act 3: 4 dialogues
- [ ] Epilogue: 3 dialogues

### NPCs (4 total)
- [ ] `resources/npcs/hermes.tres`
- [ ] `resources/npcs/aeetes.tres`
- [ ] `resources/npcs/daedalus.tres`
- [ ] `resources/npcs/scylla.tres` (if needed)

---

## PLACEHOLDER STRATEGY

**For Early Development:**

1. **Sprites:** Use colored rectangles
   - Circe: Yellow 32×32
   - Scylla: Purple 64×96
   - Crops: Green squares with stage numbers

2. **Tiles:** Single color blocks
   - Grass: #4CAF50 (green)
   - Dirt: #8B4513 (brown)
   - Tilled: #654321 (dark brown)

3. **UI:** Godot built-in themes
   - Use default Panel, Button, Label styles

4. **Audio:** Silence or beeps
   - Generate simple tones for testing

5. **Backgrounds:** Solid colors
   - Helios Palace: Gold (#FFD700)
   - Aiaia: Sky blue (#87CEEB)
   - Scylla Cove: Dark blue (#000080)

---

## ASSET SOURCES (Placeholders)

**Free Resources:**
- OpenGameArt.org
- Itch.io (CC0 assets)
- Kenney.nl (game assets)
- Freesound.org (audio)
- Google Fonts (typography)

**AI Generation:**
- Use AI art tools for quick placeholders
- Midjourney, DALL-E, Stable Diffusion
- Document that final art needs professional touch

---

## COMPLETION TRACKING

**Total Assets:** ~150 files
**Priority:**
1. ✅ Core gameplay sprites (player, crops, tiles)
2. ✅ UI elements
3. ✅ Story event art (Scylla transformation)
4. ⚪ Polish art (VFX, backgrounds)
5. ⚪ Audio (can be last)

---

**End of Asset Checklist**
