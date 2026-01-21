---
description: Lean HPV playtesting onboarding (Codex extension slash command)
argument-hint: [optional_focus]
allowed-tools: [Read, Grep, Glob]
model: haiku
---

# Playtesting Onboarding (Lean)

## Quick Orientation (about 30 seconds)
- HPV = headed playability validation using MCP.
- **You have complete vision into the game state** via `get_runtime_scene_structure`.
- Teleport-assisted setup is usually ok; do full walks only when requested.
- Minigames are typically skipped unless explicitly asked.

## How to "See" the Game

**You are NOT blind - you have complete visibility:**

| Tool | What It Shows | Quick Example |
|------|---------------|--------------|
| `get_runtime_scene_structure` | Full scene with positions | Player at `position=[384, 96]` |
| Debugger Variables panel | All runtime variables | `quest_flags` dictionary |
| Runtime eval | Direct node access | `GameState.get_flag("quest_2")` |

**To find player position:**
```bash
get_runtime_scene_structure
# Look for: World/Player: position=[x, y]
```

**To find NPC positions:**
```bash
get_runtime_scene_structure
# Look for: World/NPCs/Hermes: position=[x, y]
```

**To check quest state:**
```bash
get_runtime_scene_structure
# Look for: World/GameState → quest_flags
# OR use debugger Variables panel
```

## Key Files (start here)
- `game/autoload/game_state.gd` (flags + inventory)
- `game/features/npcs/npc_base.gd` (dialogue routing)
- `game/features/world/world.tscn` (quest triggers)
- `docs/playtesting/PLAYTESTING_ROADMAP.md` (log + status)
- `docs/playtesting/HPV_QUICK_REFERENCE.md` (detailed reference)

## Top Pitfalls (common fixes)
1. Trigger does not fire after teleport: check `monitoring` and overlaps.
2. `ui_accept` consumed by dialogue: check `DialogueBox.visible` before interacting.
3. Cutscene never completes: rely on `cutscene_finished` signals, not only awaits.
4. Boat interaction: requires dialogue closed; `ui_accept` should map to interact.
5. Choice selection: needs focused button; call `_show_choices()` if flaky.

## Logging (keep it short)
- What you tested, shortcuts used, and where runtime eval was needed.
- What worked vs blocked, with repro steps if possible.

If `$ARGUMENTS` is provided, focus on that quest range/system.
