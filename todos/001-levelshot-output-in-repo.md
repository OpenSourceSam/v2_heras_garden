---
status: pending
priority: p2
issue_id: "001"
tags: [tools, screenshots, pipeline]
owner: "ai"
created: 2026-01-25
updated: 2026-01-25
---

# Problem Statement
Levelshot saves screenshots to `user://` (AppData), so outputs are outside the repo and hard to track or share.

# Context
- Why this matters: We want screenshots inside the repo for repeatable pipelines and easier QA.
- Related systems: Levelshot plugin, Godot editor capture flow.
- User impact: Screenshots are scattered in AppData and not visible to agents reviewing repo files.

# Current State
- Observed behavior: Levelshot saves to `user://levelshots/` in AppData.
- Where it happens: Editor-only capture flow.
- Scope of impact: All Levelshot captures.

# Target State
- Desired behavior: Levelshot output stored under a repo path (e.g., `temp/levelshots/` or `docs/screenshots/`).
- Success criteria summary: Capture produces a file inside the repo without manual copying.

# Repro Steps
1. Open Levelshot panel and capture `world.tscn`.
2. Observe output folder in AppData.
3. Confirm no output lands in repo.

# Findings
- Root cause clues: Levelshot uses `user://` for output by default.
- Constraints: `res://` may be read-only in some contexts.
- Unknowns: Whether Levelshot exposes an output path setting for `res://`.

# Proposed Solutions
1. Update Levelshot settings to use a repo path if supported.
2. Add a post-capture copy step (EditorScript) from `user://` to repo folder.
3. Add a capture helper that writes to repo directly when possible.

# Risks / Dependencies
- Risks: Writing to `res://` may fail on some setups or in editor-only contexts.
- Dependencies: Levelshot plugin settings and editor scripts.
- Rollback plan: Revert to `user://` output and manual copy.

# Tasks (Suggested Steps)
- [ ] Inspect Levelshot settings and plugin source for output path control.
- [ ] Decide on target repo folder and create it (if approved).
- [ ] Implement the chosen path or copy step.
- [ ] Test capture and verify output in repo.
- [ ] Update CLAUDE.md or docs with the new procedure.

# Acceptance Criteria
- [ ] Capture output lands inside repo path.
- [ ] No new errors in Godot output.
- [ ] Procedure documented for future agents.

# Verification
- Tests run: Manual Levelshot capture.
- Manual checks: File exists in repo path with expected dimensions.
- Evidence: Screenshot path logged in notes.

# Notes / References
- Plugin path: `addons/levelshot/`
- Current output: `user://levelshots/`

# Artifacts
- Screenshots:
- Logs:
- Save files:
