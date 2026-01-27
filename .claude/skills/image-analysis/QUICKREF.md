# Image Analysis Subagent - Quick Reference

**Fast access to common tasks**

## One-Liners

### Analyze Screenshot
```bash
mcp__4_5v_mcp__analyze_image --imageSource "temp/screenshots/[file].png" --prompt "Screenshot quality check. Focus on: blocky backgrounds, tiling seams, sprite transparency, pixel art scaling, Harvest Moon SNES readability. Report specific issues with locations."
```

### Analyze Sprite
```bash
mcp__4_5v_mcp__analyze_image --imageSource "assets/sprites/[file].png" --prompt "Sprite quality check. Verify: clean transparency, strong silhouette, compact proportions, dusk-friendly colors, minimal pixel noise. Report: PASS/NEEDS WORK/FAIL with specific issues."
```

### Check Transparency
```bash
mcp__4_5v_mcp__analyze_image --imageSource "assets/sprites/[file].png" --prompt "Transparency check: halo effect, color bleeding, harsh edges, partial transparency. Report severity, location, fix recommendation."
```

### Validate Before Commit
```bash
mcp__4_5v_mcp__analyze_image --imageSource "assets/sprites/[file].png" --prompt "Pre-commit validation. Check: transparency, silhouette, proportions, colors. One-line: PASS or FAIL with issues."
```

## Common Issues Detected

| Issue | What to Look For |
|-------|------------------|
| **Blocky background** | Visible pixel grid, tiling patterns |
| **Halo effect** | Light/dark ring around sprite edges |
| **Color bleeding** | Background color in transparent pixels |
| **Stretched proportions** | Elongated body/limbs |
| **Oversaturated colors** | Too bright/vibrant |
| **Poor silhouette** | Not recognizable at small size |

## Quality Standards

**Style:** Harvest Moon SNES readability + Stardew Valley influence
**Theme:** Mediterranean ancient Greek island, dusk-friendly palette
**Specs:** 32px tiles, 2x zoom, pixel art
**Proportions:** Compact bodies, not stretched (NPCs: ~48h x 32w in 64x64)
**Colors:** Natural earth tones, muted jewel accents

## File Locations

- **Screenshots:** `temp/screenshots/`
- **Sprites:** `assets/sprites/`
- **Placeholders:** `assets/sprites/placeholders/`
- **Specs:** `assets/sprites/PLACEHOLDER_ASSET_SPEC.txt`

## Skill Invocation

```bash
/skill image-analysis
```

## Full Documentation

- **Setup:** `.claude/skills/image-analysis/README.md`
- **Examples:** `.claude/skills/image-analysis/EXAMPLES.md`
- **Subagent:** `.claude/roles/image-analysis-subagent.md`
- **Skill:** `.claude/skills/image-analysis/SKILL.md`

---

**Version:** 1.0 | **Created:** 2026-01-26
