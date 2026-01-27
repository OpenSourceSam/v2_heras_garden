# Image Analysis Subagent - Setup Guide

**Created:** 2026-01-26
**Status:** Ready for testing

## What Was Set Up

Two configuration files were created to enable GLM-4.6v image analysis capabilities:

### 1. Subagent Role Configuration
**File:** `.claude/roles/image-analysis-subagent.md`

Full subagent documentation including:
- Core responsibilities (screenshot analysis, sprite quality assessment, aesthetic feedback)
- Analysis protocol (step-by-step instructions)
- Quality criteria (Harvest Moon SNES style reference)
- Common issues detection guide
- Output format templates
- Success metrics

### 2. Skill Configuration
**File:** `.claude/skills/image-analysis/SKILL.md`

Quick-reference skill documentation including:
- When to use the subagent
- Standard prompts for different analysis types
- Quick start examples
- Integration patterns (with glm-image-gen, HPV, pre-commit)
- Common issues reference table

### 3. Test Script
**File:** `.claude/skills/image-analysis/test-analysis.sh`

Helper script for testing image analysis with path validation.

## How to Use

### Invoke as Skill

```bash
/skill image-analysis
```

Then provide the image path and analysis type.

### Direct MCP Tool Call

```bash
mcp__4_5v_mcp__analyze_image \
  --imageSource "temp/screenshots/world_main_map.png" \
  --prompt "Analyze this game screenshot for visual quality. Check for: blocky backgrounds, tiling seams, sprite transparency issues, pixel art scaling problems, overall Harvest Moon SNES readability. Provide specific, actionable feedback."
```

### Test Script

```bash
cd .claude/skills/image-analysis
./test-analysis.sh temp/screenshots/world_main_map.png
```

## What the Subagent Checks

### For Screenshots
- Blocky backgrounds and tiling seams
- Sprite transparency issues (halos, color bleeding)
- Pixel art scaling problems
- Scene composition and readability
- Overall aesthetic alignment

### For Individual Sprites
- Transparency quality (clean edges, proper alpha)
- Silhouette strength (recognizable at small size)
- Proportions (compact, not stretched)
- Color palette (dusk-friendly, Mediterranean theme)
- Pixel detail (minimal noise, clear features)
- Dimensions matching specification

### Style Reference
- Harvest Moon SNES: Clean pixel art, strong silhouettes, soft colors
- Circe's Garden adaptation: Mediterranean setting, mythic elements, dusk palette, moody atmosphere

## Current Status

**Setup:** Complete
**Testing:** MCP tool needs path format verification (Windows paths may need URL encoding)

The subagent configuration is ready, but the MCP tool (`mcp__4_5v_mcp__analyze_image`) encountered a path format error during initial testing. The error suggests the image path needs to be in a specific format (possibly URL-encoded or using forward slashes).

## Next Steps

1. **Fix MCP Path Format:** Investigate correct path format for Windows (likely forward slashes or file:// URL)
2. **Test with Known Good Image:** Run analysis on `temp/screenshots/world_main_map.png`
3. **Validate Output Quality:** Compare analysis results against manual review
4. **Integrate into Workflow:** Add to glm-image-gen pipeline (post-generation validation)
5. **Document Success Metrics:** Track accuracy, false positive rate, response time

## Integration Points

### With glm-image-gen Skill
After generating new sprites, automatically validate quality:
```bash
./generate-image.sh '{"subject":"..."}' 1024x1024 standard
./process-image.sh "$TEMP" "32x32" "assets/sprites/output.png"
# Then invoke image-analysis subagent
```

### With HPV (Playtesting)
When reviewing screenshots for local beta:
```bash
# Capture screenshot via F12
# Analyze with subagent for quality check
mcp__4_5v_mcp__analyze_image --imageSource "temp/screenshots/[name].png" --prompt "[screenshot prompt]"
```

### Pre-commit Validation
Before committing asset changes:
```bash
git status
# Analyze modified sprites
mcp__4_5v_mcp__analyze_image --imageSource "assets/sprites/modified.png" --prompt "[validation prompt]"
```

## File Structure

```
.claude/
├── roles/
│   └── image-analysis-subagent.md    # Full subagent configuration
├── skills/
│   └── image-analysis/
│       ├── SKILL.md                   # Quick-reference skill docs
│       ├── test-analysis.sh           # Test helper script
│       └── README.md                  # This file
```

## Related Documentation

- **Asset Specifications:** `assets/sprites/PLACEHOLDER_ASSET_SPEC.txt`
- **Image Generation:** `.claude/skills/glm-image-gen/SKILL.md`
- **Playtesting:** `.claude/skills/playtesting/SKILL.md`
- **Subagent Best Practices:** `.claude/skills/subagent-best-practices/SKILL.md`

## Troubleshooting

### MCP Tool Path Error
**Error:** "图片输入格式/解析错误" (Image input format/parse error)

**Possible Causes:**
- Windows backslash paths not supported
- Absolute path needs file:// prefix
- Path needs URL encoding

**Solutions to Try:**
1. Use forward slashes: `C:/Users/Sam/...`
2. Use file:// URL: `file:///C:/Users/Sam/...`
3. Use relative path from project root: `temp/screenshots/file.png`
4. Check MCP server documentation for path format requirements

### No Analysis Output
**Check:**
- Image file exists at specified path
- Image format is PNG or JPG (not SVG or other)
- MCP server is running
- Prompt is not empty

### Poor Quality Analysis
**Check:**
- Prompt is specific and detailed
- Reference materials are mentioned (asset specs, style guide)
- Analysis type matches image (screenshot vs sprite)

---

**Version:** 1.0
**Created by:** Claude (Sonnet 4.5)
**Last updated:** 2026-01-26
