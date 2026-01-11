# Headless Walkthrough Report (2025-12-29)

## Status
- Archived reference. The scripted playthrough used here has been removed.
- Scripted Playthrough Testing (SPT) is avoided unless Sam explicitly asks.

## Scope (Historical)
- Ran the automated full playthrough script in headless mode.
- Captured failures and limitations compared to the mechanical walkthrough.

## Command (Historical)
```powershell
# Script removed; do not run in the current workflow.
```

## Results (Log Highlights)
- Minigames:
  - Error: `Invalid call. Nonexistent function 'new' in base 'PackedScene'.`
  - Location: historical scripted playthrough (script removed)
  - Likely related to missing or unimplemented weaving minigame scene.
- MCP:
  - `[MCP Input Handler] Debugger not active, input simulation unavailable`
  - Prevents scripted input in this run.
- Shutdown:
  - `ObjectDB instances leaked at exit`
  - `1 resources still in use at exit`

## Limitations
- No visual verification or screenshots (headless screenshots are empty per
  `docs/testing/TIER1_TESTING.md`).
- No human-level input or scene traversal; results are log-only.
- MCP not available for runtime controls in this run.

## Notes vs Mechanical Walkthrough
- Steps requiring real-time interaction, dialogue choices, or visual checks
  were not validated.
- Minigame coverage was limited due to the PackedScene error above.

Signoff: [Codex - 2026-01-09]
