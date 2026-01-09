# Learnings Index

Last updated: [Codex - 2026-01-08]

## Purpose

This index provides fast lookup of all learnings (bugs, loops, patterns) to enable:
- Pattern recognition (2+ similar → invoke `/skill skill-gap-finder`)
- Avoiding repeated mistakes
- Identifying when to create new skills
- Organizational memory across agent sessions

**Update this index whenever you create a new learning entry.**

---

## How to Use This Index

**Before starting work:**
1. Scan relevant categories for your task
2. Read matching learnings to avoid known pitfalls
3. Follow successful patterns

**When encountering an error:**
1. Check if similar bug exists (same file type + error category + phase)
2. If 2+ similar bugs → invoke `/skill skill-gap-finder`
3. Create new learning entry and update this index

**Categories:**
- File type: .gd, .tres, .tscn, .md, etc.
- Error category: test failure, resource load, build error, runtime error, etc.
- Phase: Phase 1 core systems, Phase 2 data, Phase 3 scenes, Phase 4 gameplay, testing, etc.

---

## Bugs (by category)

### Resource Loading (1 entry)
- 2025-12-29-missing-dialogue-choice-targets: Dialogue choice `next_id` targets missing .tres resources

### Testing (0 entries)
*No entries yet*

### GDScript Errors (0 entries)
*No entries yet*

### Build/Compilation (0 entries)
*No entries yet*

---

## Loops (0 entries)

- 2026-01-08-prologue-menu-overlap-loop: Prologue cutscene text overlaps main menu and regresses

---

## Patterns (successful solutions) (0 entries)

*No successful patterns documented yet*

---

## Skills Created from Learnings

*None yet - when 2+ similar learnings exist, skill-gap-finder will propose creating a skill*

---

## Archived/Superseded

*No archived learnings yet*

When a learning is captured in a skill, mark it as:
- Status: `superseded-by-skill-name`
- Move entry to this section

---

## Index Maintenance

**Who updates:** Any agent creating a learning entry

**When to update:**
- Immediately after creating new learning in bugs/loops/patterns
- When archiving a learning
- When a skill supersedes a learning
- During periodic cleanup (Opus-level)

**Format for entries:**
```
- YYYY-MM-DD-short-description: One-line summary of what happened
```

Signoff: [Codex - 2026-01-08]

**Categorization:**
Group by:
1. Primary category (Resource Loading, Testing, etc.)
2. Chronological within category (newest first)
3. Count of entries in each category for quick pattern spotting
