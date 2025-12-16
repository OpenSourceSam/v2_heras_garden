# BUG REPORT - Visual Regression

**Date:** December 16, 2025
**Reported By:** Antigravity AI Agent (via user feedback)
**Severity:** Critical (Game Unplayable)

---

## Issue Summary

Game displays dark screen with only "SUN" text and a purple rectangle (player). No tiles visible. Dialogue system not triggering properly.

![Screenshot](C:/Users/Sam/.gemini/antigravity/brain/5cb04090-5cb2-4bc7-9596-f1f86a719734/uploaded_image_1765916164918.png)

---

## Root Cause Analysis

**Primary Issue:** `scenes/world.tscn` has an **EMPTY TileMapLayer**.

Looking at line 13-14 of `world.tscn`:
```
[node name="Ground" type="TileMapLayer" parent="."]
```

There is no `tile_map_data` property, meaning no tiles are painted. This violates **CONSTITUTION.md Section 6**:

> **Rule:** TileMapLayer nodes MUST have painted tiles before runtime.
> **V1 Failure:** Empty TileMapLayer → player fell through world.

**Secondary Issue:** The TileMapLayer has no `TileSet` assigned, which means even if tiles were painted, they wouldn't display.

---

## Steps to Reproduce

1. Run `scenes/world.tscn` (F5)
2. Observe dark screen with "SUN" label and purple rectangle
3. Move with WASD - player moves but no world visible

---

## Expected Behavior

- Grass tiles visible
- Farm plot visible and interactable
- Dialogue triggers on NPC/object interaction

---

## Fix Required

1. Open `scenes/world.tscn` in Godot Editor
2. Select `Ground` TileMapLayer node
3. Create or assign a TileSet with 32x32 grass tiles
4. Paint tiles to cover the playable area (minimum 20x20)
5. Save scene and test

---

## Prevention

Per CONSTITUTION.md checklist:
- [ ] TileSet created with 32x32 grid
- [ ] Source image assigned
- [ ] Tiles PAINTED in editor (not empty)
- [ ] Layer tested in isolation

---

## Files Affected

- `scenes/world.tscn` - Empty TileMapLayer
- Potentially missing: TileSet resource

---

**Status:** OPEN
