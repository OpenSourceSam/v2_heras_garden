# P3: World Spacing Polish Plan

**Generated:** 2026-01-23
**Purpose:** Address NPC spawn point clustering and interactable object spacing

## Current Layout Issues

### NPC Spawn Points (All at y=-32)
- **Hermes:** [160, -32]
- **Aeetes:** [224, -32]
- **Daedalus:** [288, -32]
- **Scylla:** [352, -32]
- **Circe:** [416, -32] (Note: Circe also appears in AiaiaShore location)

**Problems:**
- All NPCs clustered horizontally with only 64-pixel spacing
- Visual congestion when multiple NPCs appear simultaneously
- Scylla's position may be too close to boat dock at [128, 0]
- No vertical separation to distinguish NPC areas

### Interactable Objects (Clustered at y=0)
- **Sundial:** [64, 0]
- **Boat:** [128, 0]
- **MortarPestle:** [0, 0] (default position)
- **RecipeBook:** [-64, 0]
- **Loom:** [192, 0]
- **AeetesNote:** [-128, 0]
- **HouseDoor:** [-128, -64]

**Problems:**
- Most objects clustered at y=0 with tight spacing
- Boat and Sundial too close together
- No clear functional zones for different activity types

## Proposed New Layout

### Spawn Points - Staggered Vertical Layout
- **SpawnPoints/Hermes:** [160, -32] → [160, -96]  (Higher elevation - messenger)
- **SpawnPoints/Aeetes:** [224, -32] → [224, -32]  (Keep - elder statesman)
- **SpawnPoints/Daedalus:** [288, -32] → [288, 32]   (Lower - craftsman)
- **SpawnPoints/Scylla:** [352, -32] → [352, 96]    (Lowest - cove proximity)
- **SpawnPoints/Circe:** [416, -32] → [REMOVED]     (Handled separately in AiaiaShore)

### Interactable Object Zoning
**Gardening/Farming Zone (y=64 to y=0):**
- **GoldenGlowPlot:** [-192, 64] → [-192, 64] (keep)
- **FarmPlotA-C:** [0-64, 64] → [0-64, 64] (keep)
- **RecipeBook:** [-64, 0] → [-64, 64] (raise for garden access)
- **MortarPestle:** [0, 0] → [96, 64] (move to gardening zone)

**Central Hub Area (y=0):**
- **Sundial:** [64, 0] → [64, -32] (raise slightly)
- **AeetesNote:** [-128, 0] → [-128, -32] (raise slightly)
- **Boat:** [128, 0] → [128, -32] (raise slightly, increase separation)

**Crafting Zone (y=0 to y=-64):**
- **Loom:** [192, 0] → [192, -64] (lower for crafting area)
- **HouseDoor:** [-128, -64] → [-128, -96] (lower to house area)

## Scene Files to Modify

### world.tscn
- **SpawnPoints:**
  - Hermes position: [160, -96]
  - Daedalus position: [288, 32]
  - Scylla position: [352, 96]
  - Remove CirceSpawnPoint (she's location-specific)
- **Interactables:**
  - RecipeBook position: [-64, 64]
  - MortarPestle position: [96, 64]
  - Sundial position: [64, -32]
  - AeetesNote position: [-128, -32]
  - Boat position: [128, -32]
  - Loom position: [192, -64]
  - HouseDoor position: [-128, -96]

### No Other Scene Files Required
- Circe spawning is already handled properly in AiaiaShore
- All other object locations are functional and well-positioned

## Visual Flow Considerations

### Improved Navigation Flow
1. **Vertical Separation:** NPCs now occupy different elevation levels, creating visual hierarchy
2. **Activity Zones:** Clear areas for different activities:
   - High ground: Hermes (messenger, important)
   - Ground level: Aeetes (central figure)
   - Lower area: Daedalus (workshop feel)
   - Cove area: Scylla (water proximity)
3. **Reduced Congestion:** No more visual crowding at single point
4. **Better Sightlines:** Players can see NPCs from farther away

### Player Experience Benefits
- Clear visual distinction between NPCs
- Natural movement patterns (go up for Hermes, down for Daedalus)
- Boat dock now has breathing room from Sundial
- Crafting area (loom) separated from central hub

## Implementation Notes

### Critical Considerations
1. **Quest Trigger Alignment:** All quest triggers remain at y=64, ensuring consistency with existing game logic
2. **Marker Adjustments:** Quest markers should follow object positions if they're moved
3. **Collision Bounds:** Verify that spacing changes don't create new collision issues
4. **Visual Consistency:** Ensure elevation changes make sense with world design

### Potential Gotchas
1. **Scylla's Cove Proximity:** Moving Scylla to [352, 96] places her closer to the boat dock area - verify this doesn't create pathfinding issues
2. **Circe Removal:** Double-check that Circe only appears in AiaiaShore and not in the main world
3. **Dialogue Trigger Zones:** Some interactables (like AeetesNote) have dialogue triggers - ensure their collision areas still work after repositioning
4. **Mortar Accessibility:** Moving Mortar to [96, 64] puts it near farm plots - verify crafting area still functions properly

### Testing Recommendations
1. Test all NPC spawn combinations to ensure no overlap in new positions
2. Verify quest trigger zones still work after interactable repositioning
3. Check player pathing to all new locations
4. Ensure visual hierarchy is clear and intuitive