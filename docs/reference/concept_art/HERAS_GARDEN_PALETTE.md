# Hera's Garden Color Palette & Style Guide

## Overview

This document defines the official color palette and style standards for all visual assets in Hera's Garden. All sprites, UI elements, and game art must adhere to these guidelines to maintain visual consistency.

**Base Style:** Harvest Moon SNES-inspired pixel art with Mediterranean mythological themes

---

## Base Color Palette

### Outline Color
```
#404040 - Dark gray (1px outlines on all sprites)
```

### Ground & Dirt Colors
```
Light:  #C4A484 - Sandy brown
Base:   #A0846C - Earth brown
Shadow: #7C6450 - Deep brown
```

**Usage:** Farmable soil, paths, dirt patches

### Foliage Colors
```
Highlight: #88CC50 - Bright grass green
Base:      #64A838 - Standard foliage green
Shadow:    #4C7828 - Deep forest green
```

**Usage:** Crops, grass, bushes, trees, plant stems

### Mediterranean Theme Colors
```
Sand:       #E8D8B8 - Warm beach sand
Ocean Blue: #5098C8 - Aegean sea blue
Gold:       #D4A040 - Golden sunlight
Terracotta: #B86040 - Mediterranean tile red
Stone Gray: #888888 - Building stone
```

**Usage:** Architecture, environmental accents, UI elements, water bodies

---

## Style Rules

### 1. Outlines
- **ALL sprites must use 1px #404040 outlines**
- Outlines define shape separation and readability
- No colored outlines (dark gray only)
- Consistent 1px thickness regardless of sprite size

### 2. Shading System
- **Cell shading with 2-3 shades per element**
- Light → Base → Shadow (3 shades max)
- No gradients or dithering
- Flat colors with hard edges
- Shadow placement indicates light source from top-left

### 3. Background Transparency
- **Mandatory transparent backgrounds for all sprites**
- Use alpha channel, no colored backgrounds
- Enables proper layering in game engine

### 4. Pixel Dimensions
- **Standard sizes: 32x32 or 16x16 pixels**
- Characters: 16x24 pixels (per HARVEST_MOON_STYLE.md)
- Items/crops: 16x16 or 32x32 depending on detail needs
- Always use powers of 2

### 5. Perspective
- **Top-down orthographic view**
- Camera angle: ~45 degrees above ground
- Characters viewed from above, showing head and shoulders
- Ground tiles viewed straight down

### 6. Prohibited Techniques
- ❌ Dithering (no checkerboard patterns)
- ❌ Anti-aliasing (crisp pixel edges only)
- ❌ Gradients (flat colors only)
- ❌ Outlines thicker than 1px
- ❌ Colored outlines (use #404040 only)
- ❌ Semi-transparent pixels (full opacity or full alpha only)

---

## Character Color Palettes

### Skin Tones
```
Highlight: #FFE8C0 - Light skin highlight
Base:      #F8D8A0 - Standard skin tone
Shadow:    #E8C880 - Skin shadow
```

### Hair Colors (Character-Specific)

#### Circe (Protagonist)
```
Highlight: #E8C070 - Golden blonde highlight
Base:      #D4A040 - Golden blonde base
Shadow:    #B08030 - Golden blonde shadow
```

#### Hermes
```
Highlight: #F0D090 - Light sandy blonde
Base:      #D8B060 - Sandy blonde
Shadow:    #B09040 - Dark sandy blonde
```

#### Aeetes
```
Highlight: #605040 - Dark grey highlight
Base:      #403830 - Dark charcoal base
Shadow:    #282018 - Near-black shadow
```

#### Daedalus
```
Highlight: #D8A880 - Light brown highlight
Base:      #B88050 - Brown base
Shadow:    #805030 - Dark brown shadow
```

#### Scylla
```
Highlight: #806050 - Dark brown highlight
Base:      #504040 - Dark brownish-black base
Shadow:    #382828 - Deep shadow
```

### Clothing Colors

#### Circe's Outfit
```
Primary (Dress):   #7890C8 - Soft blue
Shadow (Dress):    #5870A8 - Blue shadow
Accent (Belt):     #D4A040 - Gold belt
```

#### Hermes' Attire
```
Primary (Tunic):   #E8D8B8 - Sand/cream
Shadow (Tunic):    #C8B898 - Sand shadow
Accent (Sandals):  #B86040 - Terracotta leather
```

#### Aeetes' Robes
```
Primary (Robe):    #506880 - Dark teal
Shadow (Robe):     #384858 - Teal shadow
Accent (Trim):     #D4A040 - Gold trim
```

#### Daedalus' Clothing
```
Primary (Tunic):   #888888 - Stone gray
Shadow (Tunic):    #606060 - Gray shadow
Accent (Tool):     #B86040 - Copper/brown tools
```

#### Scylla's Appearance
```
Primary (Body):    #78A8C8 - Sea blue
Shadow (Body):     #5088A8 - Blue shadow
Accent (Details):  #E8D8B8 - Pale highlights
```

---

## Crop & Plant Colors

### Moly (Magical Herb)
```
Stem Highlight: #88CC50 - Bright green
Stem Base:      #64A838 - Standard green
Stem Shadow:    #4C7828 - Dark green

Flower Highlight: #D8B8F8 - Light lavender
Flower Base:      #B890D8 - Lavender purple
Flower Shadow:    #9068B0 - Deep purple
```

**Visual Notes:** Small white star-shaped flowers with purple center, serrated green leaves

### Nightshade (Toxic Plant)
```
Stem Highlight: #78A838 - Yellow-green
Stem Base:      #587828 - Olive green
Stem Shadow:    #385018 - Dark olive

Berry Highlight: #B878D8 - Bright purple
Berry Base:      #9048B0 - Purple
Berry Shadow:    #603078 - Dark purple
```

**Visual Notes:** Dark purple-green leaves, small purple berries (toxic appearance)

### Wheat (Food Crop)
```
Stalk Highlight: #E0C060 - Light gold
Stalk Base:      #C4A040 - Golden brown
Stalk Shadow:    #A08030 - Dark gold

Grain Highlight: #F0D870 - Bright golden grain
Grain Base:      #D4A040 - Standard grain
Grain Shadow:    #B08020 - Dark grain
```

**Visual Notes:** Tall golden stalks with grain heads at top, sways slightly in animation

### Golden Glow (Magical Crop)
```
Stem Highlight: #FFE8A0 - Pale gold-green
Stem Base:      #D4A040 - Gold
Stem Shadow:    #B08020 - Dark gold

Glow Highlight: #FFFFD0 - Near-white center
Glow Base:      #F0D040 - Bright gold
Glow Shadow:    #C09010 - Deep gold
```

**Visual Notes:** Emits subtle glow effect, central flower resembles small sun

---

## Environment Colors

### Water Bodies
```
Highlight: #88D0E0 - Light blue
Base:      #5098C8 - Ocean blue
Shadow:    #3870A0 - Deep blue
```

**Usage:** Wells, ponds, fountains, water features

### Stone & Architecture
```
Highlight: #A8A8A8 - Light stone
Base:      #888888 - Standard stone
Shadow:    #606060 - Dark stone
```

**Usage:** Buildings, walls, paths, statues

### Wood & Timber
```
Highlight: #C4A484 - Light wood
Base:      #A0846C - Standard wood
Shadow:    #7C6450 - Dark wood
```

**Usage:** Fences, tool handles, doors, furniture

---

## Usage Guidelines

### Creating New Assets

#### Step 1: Set Up Palette
1. Create color swatches from this document
2. Organize by category (outlines, skin, clothing, environment)
3. Use exact hex codes (no approximations)

#### Step 2: Apply Outlines
1. Draw sprite base shapes
2. Apply 1px #404040 outline to all edges
3. Ensure outline connects all separate elements

#### Step 3: Add Shading
1. Determine light source (default: top-left)
2. Apply base color to main areas
3. Add highlight to top-left edges
4. Add shadow to bottom-right edges
5. Use maximum 3 shades per element

#### Step 4: Check Transparency
1. Remove all background colors
2. Verify alpha channel is clean
3. Test against different colored backgrounds

### Consistency Requirements

#### DO:
✓ Use exact hex codes from this palette
✓ Apply 1px #404040 outlines to all sprites
✓ Use 2-3 shades per element (highlight, base, shadow)
✓ Maintain top-down perspective
✓ Keep backgrounds transparent
✓ Test sprites in-game before finalizing

#### DON'T:
✗ Create custom colors not in palette (except for new special items)
✗ Use dithering or gradients
✗ Exceed 3 shades per element
✗ Use colored outlines
✗ Forget transparency
✗ Mix perspectives within sprite sets

### Special Exceptions

**New mythological items:** If a new item requires colors outside this palette:
1. Choose colors that complement Mediterranean theme
2. Stick to earth tones, blues, golds, purples
3. Document new colors in this file
4. Maintain 2-3 shade shading rule

**UI elements:** UI can use slightly expanded palette for clarity, but should draw from these base colors.

---

## Quality Checklist

Before finalizing any sprite:

- [ ] All outlines are #404040 and 1px thick
- [ ] Maximum 3 shades per element
- [ ] Transparent background (no colored backing)
- [ ] Correct dimensions (16x16, 32x32, or 16x24 for characters)
- [ ] Top-down perspective maintained
- [ ] Colors match exact hex codes in this document
- [ ] No dithering or anti-aliasing
- [ ] Test in-game against different backgrounds

---

## File Organization

**Source Art:** `docs/reference/concept_art/`
- Reference images and style guides
- Palette documentation
- Character design sheets

**Game Assets:** `game/textures/sprites/` and `assets/sprites/`
- Final sprite sheets
- Individual sprite frames
- Organized by category (characters, items, crops, UI)

**Placeholders:** `assets/sprites/placeholders/`
- Temporary sprites during development
- Tagged for replacement with final art

---

## Related Documents

- `HARVEST_MOON_STYLE.md` - Character sprite specifications
- `../execution/DEVELOPMENT_ROADMAP.md` - Asset creation pipeline
- `../agent-instructions/AGENTS_README.md` - Agent contribution guidelines

---

## Version History

- **2026-01-26** - Initial palette definition with Mediterranean theme colors and character palettes

---

**Remember:** Consistency is key to a cohesive visual style. When in doubt, refer to existing sprites and match their color choices and shading patterns.
