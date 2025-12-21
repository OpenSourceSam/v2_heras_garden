# Structure Audit - Hera's Garden v2

Date: 2025-12-19
Scope: Compare repo contents against `PROJECT_STRUCTURE.md` source-of-truth.

---

## Summary

The structure map is now aligned with the current repo for all major folders and core documents. Remaining gaps are planned items not yet created and a small set of cleanup candidates that should be removed or relocated when approved.

---

## Planned Items Not Yet Present (Expected Gaps)

These are marked [planned] in `PROJECT_STRUCTURE.md` and are not errors:
- `src/entities/npc.gd`
- `src/entities/interactable.gd`
- `src/ui/inventory_ui.gd`
- `scenes/entities/npc.tscn`
- `scenes/ui/hud.tscn`
- `resources/crops/tomato.tres`

---

## Cleanup Candidates (Present but Not Intended)

These files exist but should be removed or relocated after approval:

- `godot-mcp-cli-1.0.7.tgz`
- `New Text Document.txt`
- `nul`

---

## Observations

- `_docs/` is listed as planned; it currently only contains `.gitkeep`.
- `reports/` is accurate and contains time-stamped files.
- Local-only directories are present (`.venv`, `.godot`, `Godot_v4.5.1-stable_win64.exe/`), which should remain untracked or ignored.

---

## Actions Completed

- Updated `PROJECT_STRUCTURE.md` to reflect current repo.
- Created `DOCS_MAP.md` and marked it as current.

---

## Recommended Next Actions

1) Approve cleanup of candidate files.
2) Move long-form docs into `_docs/` once the senior PM finalizes the structure.
3) Update `PROJECT_STATUS.md` to reference `DOCS_MAP.md`.

---

End of structure audit.
