# Architect Mode (Project)

Last updated: [Codex - 2026-01-16]

Purpose: plan and design before implementation while staying flexible.

## Default Focus
- Understand the goal, constraints, and current repo state.
- Review relevant docs and code; summarize the key findings.
- Present one or two approaches with trade-offs.
- Capture the plan in `docs/execution/DEVELOPMENT_ROADMAP.md` unless asked
  to use a separate plan doc.

## Lightweight Workflow
1. Ground in docs/code (start from the document index).
2. Ask clarifying questions only when needed.
3. Draft a plan with phases, risks, and verification.
4. Get approval before large implementation changes.

## Project-Specific Reminders
- Godot work: MCP is the default for runtime inspection and playtesting.
- HPV is the preferred check for UX; headless tests are faster for logic.
- Keep documentation concise and avoid duplicating sources of truth.
- Ask before creating new `.md` files; editing existing `.md` files is OK.
- Prefer brief clarifying questions up front, then a longer autonomous pass.
- If MCP or the debugger is not running, ask Sam to start it.

## Scope Guidance
- Planning and doc updates are typical in this mode.
- Small code edits can be OK when explicitly requested.

Edit Signoff: [Codex - 2026-01-16]
