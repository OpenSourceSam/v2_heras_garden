# NPC Spawn Test Procedures

**Last Updated:** 2026-01-23
**Purpose:** Debugger-based test procedures for NPC spawn conditions

---

## Hermes Spawn Test

**Test Procedure:**
```
1. Set breakpoint at game/features/world/npc_spawner.gd:20 (_update_npcs)
2. In Variables panel, set:
   - prologue_complete = true
   - quest_3_complete = false
3. Enter world scene or trigger spawn update
4. At breakpoint, verify spawn conditions:
   - Line 23: GameState.get_flag("prologue_complete") == true
   - Line 24: not GameState.get_flag("quest_3_complete") == true
5. Continue and verify Hermes appears at SpawnPoints/Hermes
```

**Expected Spawn Conditions:**
- prologue_complete must be true
- quest_3_complete must be false (Hermes leaves after Quest 3)
- Spawns at SpawnPoints/Hermes location in world.tscn

**Key Files:**
- `game/features/world/npc_spawner.gd:20-60` (_update_npcs function)
- `world.tscn` - SpawnPoints/Hermes node

---

## Aeetes Spawn Test

**Test Procedure:**
```
1. Set breakpoint at game/features/world/npc_spawner.gd:27 (Aeetes check)
2. In Variables panel, set:
   - quest_3_complete = true
   - quest_7_active = false
   - quest_4_active = true (or 5 or 6)
3. Trigger spawn update
4. At breakpoint, verify spawn conditions:
   - Line 28: GameState.get_flag("quest_3_complete") == true
   - Line 28: not GameState.get_flag("quest_7_active") == true
   - Line 29-31: One of quest_4/5/6_active == true
5. Continue and verify Aeetes appears at SpawnPoints/Aeetes
```

**Expected Spawn Conditions:**
- quest_3_complete must be true (arrives after confrontation)
- quest_7_active must be false (leaves when Daedalus arrives)
- One of quest_4/5/6 must be active (Act 2 quests)

**Key Files:**
- `game/features/world/npc_spawner.gd:27-31` (Aeetes spawn logic)
- `world.tscn` - SpawnPoints/Aeetes node

---

## Scylla Spawn Test

**Test Procedure:**
```
1. Set breakpoint at game/features/world/npc_spawner.gd:39 (Scylla check)
2. In Variables panel, set:
   - quest_8_active = true (or 9, 10, or 11)
3. Navigate to Scylla's Cove location
4. At breakpoint, verify spawn conditions:
   - Line 40-43: One of quest_8/9/10/11_active == true
5. Continue and verify Scylla appears at SpawnPoints/Scylla
```

**Expected Spawn Conditions:**
- One of quest_8/9/10/11 must be active (Act 3 quests)
- Location-specific: Only spawns in Scylla's Cove
- Different dialogue based on active quest

**Key Files:**
- `game/features/world/npc_spawner.gd:39-43` (Scylla spawn logic)
- `scylla_cove.tscn` - SpawnPoints/Scylla node

---

## Daedalus Spawn Test

**Test Procedure:**
```
1. Set breakpoint at game/features/world/npc_spawner.gd:33 (Daedalus check)
2. In Variables panel, set:
   - quest_7_active = true
   - met_daedalus = false
3. Trigger spawn update
4. At breakpoint, verify spawn conditions:
   - Line 33: GameState.get_flag("quest_7_active") == true
5. Continue and verify Daedalus appears
```

**Expected Spawn Conditions:**
- quest_7_active must be true
- Replaces Aeetes during Act 2

**Key Files:**
- `game/features/world/npc_spawner.gd:33-38` (Daedalus spawn logic)

---

## Debug Variables for NPC Testing

**At _update_npcs() breakpoint (npc_spawner.gd:20):**
- `spawned_npcs` dictionary - Currently spawned NPCs
- `GameState.quest_flags` - All quest flags
- `SpawnPoints/*` - Spawn point locations in scene tree

**Spawn Condition Checks:**
- Each NPC has specific flag requirements
- Check `npc_spawner.gd` lines 20-60 for exact conditions
- Use Variables panel to modify flags and test different combinations

---

## NPC Spawn Verification Steps

**Complete NPC Spawn Test:**
```
1. Set breakpoint at npc_spawner.gd:20 (_update_npcs)
2. Set required flags in Variables panel
3. Trigger spawn (enter location or reload scene)
4. At breakpoint, verify condition checks pass
5. Continue to npc_spawner.gd:54 (_spawn_npc)
6. Verify scene_tree.get_node(spawn_point) succeeds
7. Verify NPC instance is created
8. Verify NPC is added to spawned_npcs dictionary
9. Check scene tree for NPC visibility
```

---

## Common Issues to Check

**NPC not appearing:**
- Verify required flags are set correctly
- Check spawn point exists in scene tree
- Verify NPC scene file exists
- Check for conflicting spawn conditions

**Wrong NPC appearing:**
- Check flag priority in npc_spawner.gd
- Verify spawn conditions aren't overlapping
- Check spawned_npcs dictionary for conflicts

**NPC not interactable:**
- Verify NPC is visible in scene tree
- Check interaction_area collision shape
- Verify interact() function is connected

---

## Spawn Point Locations

**World Scene (world.tscn):**
- SpawnPoints/Hermes - Near house
- SpawnPoints/Aeetes - Workshop area
- SpawnPoints/Daedalus - Workshop area (replaces Aeetes)

**Scylla's Cove (scylla_cove.tscn):**
- SpawnPoints/Scylla - Cove entrance

**Sacred Grove (sacred_grove.tscn):**
- No dedicated spawn points (location-based)

---

**Next:** See [minigame_test_procedures.md](minigame_test_procedures.md) for minigame testing
