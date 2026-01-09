# Visual Issues Fix Plan for MiniMax

## Issues Identified

### Issue 1: NPC Character Size Inconsistency
**Problem:** Characters are massively different sizes in-game
- **Root Cause:** All NPC sprites have different actual dimensions despite being labeled "64x64"
- **Visual Impact:** Characters appear with wildly inconsistent scale (Circe looks huge, Scylla different size)

**Evidence from sprite analysis:**
- Circe: 64x64 canvas, but actual drawn character is ~40x50 pixels
- Scylla: 64x64 canvas, but actual drawn character is ~45x60 pixels
- Hermes: 64x64 canvas, but actual drawn character is ~35x55 pixels
- All have different proportions and fill different amounts of their 64x64 canvas

### Issue 2: Grass Tile Rendering Problem
**Problem:** Main map grass is "partially grass, partially blank monocolored tiles"
- **Root Cause:** 32x32 grass tile has dithering pattern that doesn't tile seamlessly
- **Visual Impact:** Creates visible seams/gaps when tiled, looks broken

**Evidence:**
- `placeholder_grass.png` is 32x32 RGBA with green dithering pattern
- Pattern doesn't align properly when repeated in grid
- Likely the edges don't match (top edge ≠ bottom edge, left ≠ right)

## Plan for MiniMax to Execute

### Part 1: Fix NPC Sprite Consistency

**Objective:** Regenerate all 5 NPC sprites with **identical base dimensions and proportions**

**Requirements for MiniMax:**
1. **Standardize character proportions:**
   - All characters should be exactly **48 pixels tall** (body height)
   - All characters should be **32 pixels wide** (body width)
   - Canvas size remains 64x64 (gives 8px padding on all sides)
   - Character should be centered in canvas

2. **Regenerate these sprites with pixel-art-professional skill:**
   - `npc_circe.png` - Purple robed enchantress (48h x 32w, centered in 64x64)
   - `npc_scylla.png` - Sea monster form (48h x 32w, centered in 64x64)
   - `npc_hermes.png` - Messenger with wings (48h x 32w, centered in 64x64)
   - `npc_aeetes.png` - King with crown (48h x 32w, centered in 64x64)
   - `npc_daedalus.png` - Inventor with tools (48h x 32w, centered in 64x64)

3. **Quality standards:**
   - Maintain Stardew Valley quality (6-shade color ramps, hue shifting)
   - Keep accessories (wings, crown, etc.) but scale proportionally
   - Ensure all fit within 48x32 body bounds
   - Use same pixel density/detail level across all characters

### Part 2: Fix Grass Tile Seamless Tiling

**Objective:** Regenerate grass tile to tile perfectly without seams

**Requirements for MiniMax:**
1. **Create seamless tileable grass:**
   - Size: 32x32 pixels
   - Pattern: Green grass with subtle dithering
   - **CRITICAL:** Top edge must match bottom edge exactly
   - **CRITICAL:** Left edge must match right edge exactly
   - Test by placing 3x3 grid - should look like continuous grass field

2. **Use pixel-art-professional skill with dithering expertise:**
   - Apply Bayer or Floyd-Steinberg dithering
   - Ensure dithering pattern wraps seamlessly
   - Color palette: Earthy green tones (match existing muted palette)

3. **Output:**
   - Replace `assets/sprites/tiles/placeholder_grass.png`
   - Verify tiling by visual inspection

## Execution Steps for MiniMax

1. **Invoke pixel-art-professional skill**
2. **Generate standardized NPCs:**
   - Use art MCP server to create 5 NPCs with exact proportions above
   - Save to `assets/sprites/placeholders/npc_*.png`
3. **Generate seamless grass tile:**
   - Create tileable 32x32 grass with proper edge wrapping
   - Save to `assets/sprites/tiles/placeholder_grass.png`
4. **Verification:**
   - Check all NPC sprites are same proportions (48x32 body in 64x64 canvas)
   - Test grass tile tiling by creating 3x3 grid screenshot

## Expected Outcome

- All 5 NPCs appear at consistent scale in-game
- Grass background tiles seamlessly without visible seams
- Visual cohesion dramatically improved
