# Prologue Text Overlaps Main Menu Loop

**Status:** active

**Agent:** Tier 1 - Codex

**Date:** 2026-01-08

**Category:** fix regression loop

**Trigger:** same visual overlap bug resurfaced multiple times during development

---

## Goal Being Attempted

Stop prologue cutscene text from overlapping the main menu and prevent repeated cutscene instances.

---

## Approaches Tried (list all 3+)

1. **Attempt 1:** Hide menu during cutscene
   - Result: Issue resolved short-term, later regressed.

2. **Attempt 2:** Add guard against double-start
   - Result: Reduced duplicates, later regressed.

3. **Attempt 3:** Disable menu buttons during cutscene
   - Result: Prevented overlap again, but recurred in future iterations.

---

## Why Agent is Blocked

Not blocked. This is a recurring regression that needs a recorded loop entry.

---

## Root Cause Investigation Attempted?

**Did agent follow `/skill systematic-debugging`?**
- [ ] Yes - completed Phase 1: Root Cause Investigation
- [x] No - skipped to focused fix for immediate overlap

**If no, why not?**
User requested a fast fix and a loop entry.

---

## Related Files

- `game/features/ui/main_menu.gd`
- `game/features/cutscenes/prologue_opening.gd`
- `game/autoload/cutscene_manager.gd`

---

## Escalation

**Escalation level:** Tier 1 -> User

**Escalation method:** learnings entry

**Action taken:** documented loop for visibility and future prevention.

---

## Similarity Check

**Check `.claude/learnings/INDEX.md` for similar loops:**
- Similar goal? no
- Similar error pattern? no
- Similar phase of work? yes (UX polish)

---

[Codex - 2026-01-08]
