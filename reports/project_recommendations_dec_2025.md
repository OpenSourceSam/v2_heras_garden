# Project Recommendations and Rationale (Dec 2025)

## Scope
This report summarizes structural and documentation issues observed across the repository and proposes a high-level path to finish Phase 1. It focuses on alignment, workflow clarity, and unblocking core gameplay implementation. No code changes are proposed here.

## Key Findings
1. **Identity and phase drift across docs**
   - `README.md` still uses "Hera's Garden" and shows Phase 0 in progress.
   - `PROJECT_STATUS.md` and other docs reference "Hera's Garden" and imply Phase 0 is complete.
   - This splits onboarding and leads contributors to different assumptions about what is done.

2. **Process guidance is fragmented and duplicated**
   - Guardrails and workflow rules are repeated across `DEVELOPMENT_WORKFLOW.md`, `DEVELOPMENT_ROADMAP.md`, `ANTIGRAVITY_FEEDBACK.md`, and `AGENT_PROTOCOL.md`.
   - Overlap without a single source of truth creates rule drift and conflicting interpretations.

3. **Scene templates and roadmap examples do not match current scenes**
   - Roadmap templates assume nodes like `Sprite` and `InteractionZone`.
   - `scenes/entities/player.tscn` uses `Sprite2D` and is missing an interaction Area2D.
   - `scenes/entities/farm_plot.tscn` does not have scripts attached.
   - This guarantees `@onready` null references if templates are pasted as-is.

4. **Core gameplay scripts are stubbed**
   - `src/entities/player.gd`, `src/entities/farm_plot.gd`, and `src/autoloads/scene_manager.gd` are placeholder shells.
   - Phase 1 tasks cannot be validated until these are implemented, so branches keep failing functional checks.

5. **Testing guidance is phase-mismatched**
   - `PLAYTESTER_GUIDE.md` mixes Phase 0 validation with Phase 1 expectations.
   - New testers expect movement/interaction before the core loop exists.

## Recommendations (What to Change, and Why)
1. **Normalize identity and phase status across top-level docs**
   - Update `README.md` and `PROJECT_STATUS.md` to the same project name and phase status.
   - Rationale: reduces onboarding confusion and prevents contributors from coding against different assumptions.

2. **Define a single canonical workflow document**
   - Make `DEVELOPMENT_WORKFLOW.md` the authoritative source for process rules and guardrails.
   - Trim `ANTIGRAVITY_FEEDBACK.md` and `AGENT_PROTOCOL.md` to short appendices that link back.
   - Rationale: one set of rules reduces drift and rework.

3. **Align scenes to roadmap templates before implementing Phase 1**
   - Fix node naming and attach scripts to scenes so `@onready` paths resolve.
   - Rationale: avoids immediate runtime errors when following roadmap templates.

4. **Publish an "implementation state" table**
   - Add a table in `PROJECT_STATUS.md` with columns like Scene ready, Script attached, Logic implemented.
   - Rationale: makes current progress explicit and prevents assumptions about stubbed systems.

5. **Split playtesting guidance by phase**
   - Separate Phase 0 validation from Phase 1+ expectations in `PLAYTESTER_GUIDE.md`.
   - Rationale: keeps testers aligned with actual functionality and reduces false bug reports.

## Proposed Documentation Restructure
- **README.md**
  - Concise identity, phase status, and links to canonical docs.
  - Keep it short: current phase, immediate next task, and pointers.

- **DEVELOPMENT_WORKFLOW.md**
  - Single source of truth for process steps, guardrails, and "one subsection per commit" rule.
  - Include a short preflight checklist: verify scene node names and script attachments.

- **DEVELOPMENT_ROADMAP.md**
  - Keep tasks and templates only, with a brief preflight note per section.

- **PROJECT_STATUS.md**
  - Truthful, minimal status and the implementation-state table.
  - Link from README and Workflow.

- **PLAYTESTER_GUIDE.md**
  - Separate Phase 0 and Phase 1+ expectations; link to Project Status.

- **ANTIGRAVITY_FEEDBACK.md / AGENT_PROTOCOL.md**
  - Reduce to short appendices or summaries that link to the canonical workflow.

## High-Level Path to Finish Phase 1
1. Normalize docs (identity and phase status).
2. Align scene node names and attach scripts before coding logic.
3. Implement Phase 1 sequentially: movement -> interaction -> farm plot.
4. Update `PROJECT_STATUS.md` after each subsection.
5. Update playtesting guidance once Phase 1 behaviors exist.

## Open Questions for the Team
- What is the final project name (Hera vs. Circe)?
- Is Phase 0 considered complete or still in progress?
- Should the roadmap templates be updated to match existing scenes, or should scenes be updated to match templates?

## Notes
This report is intentionally high-level. If approved, the next step would be a small set of doc-only commits that implement the restructuring and status alignment.
