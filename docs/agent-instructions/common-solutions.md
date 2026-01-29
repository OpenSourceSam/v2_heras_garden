# Common Solutions (Living Log)

Archived from CLAUDE.md during Claude-centric overhaul (2026-01-29).

---

## Template for New Entries

```
### YYYY-MM-DD: <Short Title>
**Problem:** <What was broken/needed>
**Solution:** <What was done and why>
**Key Files Changed:**
- <path> - <what changed>
**Lessons Learned:**
- <pattern>
- <gotcha>
**Use This When:** <future situations>
```

---

## 2026-01-25: Intro transition stuck after prologue

**Problem:** New Game could load prologue but leave runtime scene on main menu
**Solution:** Route transitions through `get_tree().change_scene_to_file(...)`
**Files:**
- `game/features/ui/main_menu.gd`
- `game/features/cutscenes/prologue_opening.gd`
- `game/autoload/scene_manager.gd`
**Lesson:** `change_scene_to_file` reliably updates `current_scene`

---

## 2026-01-26: Visual polish transparency fix

**Problem:** Sprites had blocky backgrounds (opaque instead of transparent)
**Solution:** Regenerated 22 assets with RGBA format
**Lesson:** Always verify transparency with check-transparency.ps1

---

## 2026-01-28: Sprite improvements with outlines

**Problem:** Placeholder sprites lacked outlines and shading
**Solution:** Created Python tools to generate production-quality sprites
**Tools:** `tools/improve_*.py` (9 scripts)
**Lesson:** Batch generation with proper style guide compliance

---

[Opus 4.5 - 2026-01-29]
