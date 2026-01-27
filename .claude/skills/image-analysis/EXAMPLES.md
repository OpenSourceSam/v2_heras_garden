# Image Analysis Subagent - Usage Examples

**Last updated:** 2026-01-26

## Quick Reference

### Skill Invocation
```bash
/skill image-analysis
```

### Direct Tool Call
```bash
mcp__4_5v_mcp__analyze_image --imageSource "[path]" --prompt "[prompt]"
```

## Example Scenarios

### Scenario 1: Validate Newly Generated Sprite

**Context:** glm-image-gen just created a new NPC sprite

```bash
# After generation completes
mcp__4_5v_mcp__analyze_image \
  --imageSource "assets/sprites/placeholders/npc_hermes.png" \
  --prompt "Analyze this 64x64 NPC sprite for Harvest Moon SNES style quality.

Target Proportions: ~48h x 32w centered (compact, not elongated)

Check For:
- Strong silhouette (recognizable at small size)
- Clean transparency (no halos or color bleeding)
- Mediterranean theme alignment (sky-blue tunic, gold trim, winged hat/sandals)
- Proper pixel art scaling (minimal noise, clear details)
- Dusk-friendly color palette (muted, not oversaturated)

Reference: assets/sprites/PLACEHOLDER_ASSET_SPEC.txt (item #13)

Provide specific feedback with P0/P1/P2 priority levels for any issues found."
```

**Expected Output:**
```markdown
## Analysis Summary
NEEDS WORK - Sprite has transparency issues

### Issues Found
**Critical (P0):**
- Halo effect around sprite edges (visible light ring on transparent background)
- Color bleeding in winged hat area (background pixels showing through)

**Important (P1):**
- Silhouette readable but could be stronger (caduceus staff blends into tunic)
- Colors slightly oversaturated for dusk theme

**Minor (P2):**
- Pixel art quality good overall
- Proportions match spec (~48h x 32w)

### What Works
- Compact body proportions (not stretched)
- Clear character design (Hermes recognizable)
- Good pixel density for 64x64

### Recommendations
1. Fix alpha channel: re-export with clean transparency edges
2. Darken tunic color by 15% for dusk-friendly palette
3. Add subtle outline to caduceus for better separation
```

---

### Scenario 2: Screenshot Quality Check (HPV)

**Context:** Playtesting screenshot review for local beta

```bash
# After capturing screenshot via F12
mcp__4_5v_mcp__analyze_image \
  --imageSource "temp/screenshots/world_main_map.png" \
  --prompt "Analyze this game screenshot for Circe's Garden visual quality.

Technical Specs:
- 32px tiles, 2x camera zoom
- Pixel art style, Harvest Moon SNES readability
- Mediterranean ancient Greek island theme

Check For:
1. Background: blocky patterns, visible tiling seams, color banding
2. Sprites: transparency issues (halos), proper layering, clipping errors
3. Pixel art: scaling artifacts, anti-aliasing problems, resolution clarity
4. Scene composition: sprite placement, visual clutter, readability at small size
5. Overall aesthetic: dusk-friendly palette, soft lighting, mythic/moody atmosphere

Provide location-specific feedback (e.g., 'top-left corner', 'NPC at center')."
```

**Expected Output:**
```markdown
## Analysis Summary
PASS - Good overall quality with minor issues

### Issues Found
**Critical (P0):**
- None

**Important (P1):**
- Visible tiling seam in grass tile at bottom-right corner
- Player sprite has slight halo effect when overlapping darker tiles

**Minor (P2):**
- Some sprites could benefit from stronger silhouettes
- Overall color palette good but slightly bright for dusk theme

### What Works
- Clean pixel art with minimal noise
- Strong character/item silhouettes
- Good scene composition (not cluttered)
- Proper layering and sprite placement
- Mediterranean theme clearly visible

### Recommendations
1. Fix grass tile seam: regenerate with better edge blending
2. Check player sprite alpha channel for transparency edge cleanup
3. Consider slight global darken for dusk-friendly palette
```

---

### Scenario 3: Pre-commit Validation

**Context:** About to commit modified potion icons

```bash
# Before git commit
mcp__4_5v_mcp__analyze_image \
  --imageSource "assets/sprites/placeholders/calming_draught_potion.png" \
  --prompt "Validate this 32x32 item icon meets Circe's Garden spec.

Spec Reference: assets/sprites/PLACEHOLDER_ASSET_SPEC.txt (item #9)
- Small bottle, soft blue/green liquid, gentle glow
- Calming and herbal vibe
- Short bottle silhouette (not elongated)
- Strong silhouette at 32x32 size
- Clean transparency (no halos)

Check:
1. Proportions: compact bottle, not tall/thin
2. Transparency: clean edges, proper alpha channel
3. Silhouette: recognizable as potion bottle at glance
4. Colors: soft blue/green, dusk-friendly palette
5. Overall: Harvest Moon SNES item icon readability

PASS or FAIL with specific issues."
```

**Expected Output:**
```markdown
## Analysis Summary
PASS - Ready to commit

### Issues Found
None - asset meets all specifications.

### What Works
- Compact bottle proportions (not stretched)
- Clean transparency edges (no halo effect)
- Strong silhouette - recognizable as calming potion
- Soft blue/green color fits calming/herbal theme
- Good readability at 32x32 size
- Dusk-friendly palette (not oversaturated)

### Recommendations
Asset is ready for commit. No changes needed.
```

---

### Scenario 4: Batch Analysis (Multiple Assets)

**Context:** Reviewing all newly generated potion icons

```bash
# Analyze each potion icon
for file in assets/sprites/placeholders/*_potion.png; do
  echo "Analyzing: $file"
  mcp__4_5v_mcp__analyze_image \
    --imageSource "$file" \
    --prompt "Quick quality check for 32x32 potion icon. Verify: compact proportions (not elongated), clean transparency, strong silhouette, dusk-friendly colors. One-line assessment: PASS/NEEDS WORK/FAIL."
  echo ""
done
```

**Expected Output:**
```
Analyzing: assets/sprites/placeholders/calming_draught_potion.png
PASS - Good compact proportions, clean transparency, soft blue/green colors.

Analyzing: assets/sprites/placeholders/binding_ward_potion.png
NEEDS WORK - Bottle slightly elongated, consider shortening height.

Analyzing: assets/sprites/placeholders/reversal_elixir_potion.png
PASS - Good two-tone swirl, compact shape, clean edges.

Analyzing: assets/sprites/placeholders/petrification_potion.png
FAIL - Halo effect around bottle, color bleeding in transparent pixels.
```

---

### Scenario 5: Transparency Issue Diagnosis

**Context:** Specific focus on transparency problems

```bash
mcp__4_5v_mcp__analyze_image \
  --imageSource "assets/sprites/placeholders/moon_tear.png" \
  --prompt "Diagnose transparency issues in this sprite.

Check specifically for:
1. Halo effect - light or dark ring around sprite edges
2. Color bleeding - background color visible in transparent pixels
3. Harsh edges - no smooth curves on diagonal/curved pixels
4. Partial transparency - pixels that are semi-transparent (should be opaque or transparent)

Report:
- Severity: NONE / MINOR / MODERATE / SEVERE
- Location: specific pixel areas affected
- Recommendation: how to fix (re-export, alpha channel cleanup, etc.)
"
```

**Expected Output:**
```markdown
## Transparency Diagnosis

**Severity:** MODERATE

**Issues Found:**
1. **Halo effect:** Light grey ring visible around moon tear droplet edges
   - Location: All outer edges
   - Cause: Anti-aliasing created semi-transparent pixels

2. **Color bleeding:** Dark background pixels visible in transparent areas
   - Location: Bottom-right corner
   - Cause: Export with background color not fully removed

**Recommendation:**
Re-export sprite with:
- Hard edge transparency (no anti-aliasing on edges)
- Alpha threshold set to 128 (fully opaque or fully transparent)
- Clean background before export
```

---

### Scenario 6: Style Comparison

**Context:** Compare asset against Harvest Moon SNES reference

```bash
mcp__4_5v_mcp__analyze_image \
  --imageSource "assets/sprites/placeholders/wheat_crop.png" \
  --prompt "Compare this asset to Harvest Moon SNES style.

Harvest Moon SNES Characteristics:
- Clean pixel art with minimal noise
- Strong silhouette (recognizable at small size)
- Soft, natural color palette
- Proper alpha blending (no halos)
- No anti-aliasing on edges
- Cozy, approachable aesthetic

Report:
1. What matches Harvest Moon SNES style
2. What deviates from style
3. Specific recommendations to align closer to reference
4. Overall compatibility score (0-100%)
"
```

**Expected Output:**
```markdown
## Style Comparison

**Compatibility Score:** 85%

**Matches Harvest Moon SNES Style:**
- Clean pixel art with minimal noise ✓
- Strong silhouette - wheat sprout recognizable ✓
- Soft, natural colors (warm gold tones) ✓
- Cozy, approachable aesthetic ✓

**Deviates from Style:**
- Slight anti-aliasing on leaf edges (Harvest Moon uses hard edges)
- Could be slightly more detailed ( Harvest Moon crops have more detail at 32x32)

**Recommendations:**
1. Remove anti-aliasing on leaf edges for crisp pixels
2. Add 1-2 extra pixels of detail to wheat head for better readability
3. Consider slightly warmer yellow tone for better Harvest Moon feel

**Overall:** Good alignment with minor polish needed.
```

---

## Prompt Templates

### Full Quality Assessment (Use for comprehensive review)
```
Analyze this image for Circe's Garden quality standards:

Visual Style: Harvest Moon SNES readability, Stardew Valley influence, Mediterranean ancient Greek island theme, dusk-friendly palette, 32px tiles, 2x zoom

Check For:
1. Background: blocky patterns, tiling seams, color banding
2. Transparency: clean edges, proper alpha channel
3. Pixel art: minimal noise, clear details, proper scaling
4. Proportions: compact, not stretched/elongated
5. Colors: natural earth tones, muted jewel accents
6. Lighting: soft ambient, no harsh specular
7. Silhouette: strong, recognizable at small size

Provide specific feedback with P0/P1/P2 priority levels.
```

### Quick Check (Use for fast validation)
```
Quick quality check for [asset type]. Verify: compact proportions, clean transparency, strong silhouette, dusk-friendly colors. One-line assessment: PASS/NEEDS WORK/FAIL.
```

### Transparency Focus (Use for specific transparency issues)
```
Check transparency: halo effect, color bleeding, harsh edges, partial transparency. Report severity, location, and fix recommendation.
```

### Style Comparison (Use for style validation)
```
Compare to Harvest Moon SNES style. Report what matches, what deviates, and recommendations for alignment. Provide compatibility score (0-100%).
```

---

## Integration Examples

### With glm-image-gen Pipeline
```bash
cd .claude/skills/glm-image-gen

# Generate sprite
URL=$(./scripts/generate-image.sh '{"subject":"..."}' 1024x1024 standard)
TEMP=$(./scripts/download-image.sh "$URL")
OUTPUT=$(./scripts/process-image.sh "$TEMP" "32x32" "assets/sprites/output.png")

# Validate quality
cd ../../..
mcp__4_5v_mcp__analyze_image \
  --imageSource "assets/sprites/output.png" \
  --prompt "Validate newly generated sprite meets Circe's Garden spec. Check: transparency, silhouette, proportions, colors, pixel art quality."

# If FAIL, regenerate with adjusted prompt
```

### With HPV Screenshot Review
```bash
# During playtesting session
ls temp/screenshots/

# Analyze most recent screenshot
mcp__4_5v_mcp__analyze_image \
  --imageSource "temp/screenshots/latest.png" \
  --prompt "Screenshot quality check for HPV. Focus on: visual bugs, sprite issues, background problems, overall readability."
```

### Pre-commit Hook Pattern
```bash
# Before committing
git diff --name-only | grep "\.png$"

# For each modified PNG, run analysis
for file in $(git diff --name-only | grep "\.png$"); do
  echo "Validating: $file"
  mcp__4_5v_mcp__analyze_image \
    --imageSource "$file" \
    --prompt "Pre-commit validation. Check: transparency, silhouette, proportions. One-line: PASS/FAIL."
done
```

---

## Troubleshooting

### MCP Tool Returns Error
**Error:** "图片输入格式/解析错误"

**Solutions:**
1. Use forward slashes in path: `C:/Users/Sam/...`
2. Try file:// URL: `file:///C:/Users/Sam/...`
3. Use relative path: `temp/screenshots/file.png`
4. Verify file exists: `ls -la [path]`

### No Analysis Output
**Checks:**
- Image file exists at path
- Image is PNG or JPG (not SVG)
- MCP server is running
- Prompt is not empty

### Poor Quality Analysis
**Improvements:**
- Make prompt more specific
- Reference asset spec document
- Specify analysis type (screenshot vs sprite)
- Include priority levels (P0/P1/P2)

---

**Version:** 1.0
**Related:** `.claude/roles/image-analysis-subagent.md`, `.claude/skills/image-analysis/SKILL.md`
