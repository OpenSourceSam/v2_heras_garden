# Stopgap Roadmap (Today Only) - Hera's Garden v2

Date: 2025-12-19
Status: TEMPORARY. Valid only for today while the senior PM overhauls structure and the full development roadmap.
Owner: Codex (junior PM mode)

---

## Purpose

This is a short, no-regrets roadmap to keep work moving without locking in long-term decisions. It focuses on tasks that will remain useful regardless of future structural changes.

---

## Nuances I Understand (Task Framing)

- This is not a replacement for the senior PM's new roadmap.
- I must avoid decisions that lock in story scope, gameplay features, or final architecture.
- Only do work that is foundational, reversible, or required under any direction the game takes.
- Every task below must be explainable as "will not be redone" even if the game pivots.

---

## Stopgap Roadmap (Today Only)

### Track A: Structure Integrity and Source-of-Truth Hygiene

Tasks:
1) Run a structure audit: compare repo contents to `PROJECT_STRUCTURE.md` and list mismatches.
2) Update `PROJECT_STRUCTURE.md` first, then align any files if needed.
3) Create a one-page "doc map" that lists canonical docs and their purpose.

Why this is no-regrets:
- Every future plan depends on a correct structure map and a consistent source of truth.
- This removes ambiguity without committing to gameplay design choices.

Success criteria:
- A mismatch list exists and is tracked.
- `PROJECT_STRUCTURE.md` matches reality and labels planned items clearly.
- A doc map exists and is referenced by `PROJECT_STATUS.md`.

---

### Track B: Documentation Readability and Encoding Cleanup

Tasks:
1) Fix encoding corruption in top-level docs and tests.
2) Standardize the project title to "Hera's Garden" in all visible docs and UI text.

Why this is no-regrets:
- Clean, readable docs are required under any plan.
- The title is confirmed by the project owner.

Success criteria:
- No garbled characters in docs or tests.
- All project-facing text reflects "Hera's Garden."

---

### Track C: Runtime Baseline and Wiring

Tasks:
1) Ensure every existing scene has a script attached if a script exists.
2) Verify `project.godot` input actions include movement and interaction.
3) Confirm the main scene loads without missing script errors.

Why this is no-regrets:
- These are wiring and bootability tasks that will be required in any direction.
- Attaching scripts does not force gameplay design; it only prevents runtime errors.

Success criteria:
- No missing-script errors on startup.
- Scene wiring is consistent (script exists => scene references it).

---

### Track D: Testability Baseline

Tasks:
1) Repair `tests/run_tests.gd` so it parses cleanly.
2) Add or repair smoke tests that verify basic wiring.

Why this is no-regrets:
- Tests help every future plan, regardless of feature set.
- Wiring tests are stable even if systems evolve.

Success criteria:
- Test runner parses without syntax errors.
- Smoke tests validate autoloads and scene wiring.

---

### Track E: Resource Registry Sanity (Optional if Time Allows)

Tasks:
1) Verify `GameState` resource paths point to existing .tres files.
2) Document any missing or placeholder resources.

Why this is no-regrets:
- Resource load errors will break any version of the game.
- This work is diagnostic, not design-dependent.

Success criteria:
- No missing resource paths in the registry.
- A short list of placeholder resources is documented.

---

## Explicit Out of Scope (Until Senior PM Roadmap)

- Story beats, quests, or narrative restructuring.
- New gameplay systems beyond wiring and minimal baseline.
- UI/UX redesigns beyond title alignment.
- Performance optimization or retroid-specific tuning.

---

## Stopgap Success Metrics (Today)

- Structure source-of-truth updated before any other changes.
- Docs and tests are readable and parse cleanly.
- Scenes and scripts are wired consistently.
- Project can launch without missing-script errors.

---

## Handoff Notes (End of Day)

- Record completed tasks in `PROJECT_STATUS.md`.
- List any remaining mismatches or blockers.
- Mark this roadmap as expired once the senior PM roadmap is ready.

---

End of stopgap roadmap.
