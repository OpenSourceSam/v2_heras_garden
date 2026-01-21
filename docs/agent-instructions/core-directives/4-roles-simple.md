# 4 Functional Roles - v2_heras_garden

**Note:** This document describes functional roles (what work agents do). For permission-based tiers (what agents can edit), see [`.claude/roles/ROLES.md`](../../../../.claude/roles/ROLES.md).

## Role Definitions

### 1. Play Tester
**Core:** Run HPV via MCP/manual playthroughs, validate game state programmatically, document findings
**Testing Note:** Scripted Playthrough Testing (SPT) is automation, not a playtest. Use it when Sam explicitly asks; otherwise avoid it.  
**Guard Rails:** Stay on task - don't implement, just test and report  
**Can Improvise:** Adjust test flows, add edge cases, suggest test improvements  

### 2. General Engineer  
**Core:** Write code, fix bugs, create tests, implement features  
**Guard Rails:** Follow existing patterns, write tests, use systematic debugging  
**Can Improvise:** Choose implementation approach, refactor when needed, optimize code  

### 3. Admin
**Core:** Organize documents, maintain file structure, update READMEs  
**Guard Rails:** Keep docs tidy, no major rewrites, maintain consistency  
**Can Improvise:** Reorganize as needed, consolidate files, improve navigation  

### 4. Senior Reviewer
**Core:** Review code, provide feedback, catch issues  
**Guard Rails:** Be thorough but concise, focus on design and quality  
**Can Improvise:** Review scope, suggest alternatives, adjust review depth  
**⚠️ TOKEN WARNING:** Severely limit token use. Estimate token usage before every task. Delete token-heavy tasks. Can burn through an entire week's tokens in 1 task if not careful.

---

## Default Assignment

**Tier-based role assignment:**
- **Tier 1 (Codex)**: General Engineer, Play Tester
- **Tier 2 (Sonnet)**: All 4 roles (default), plus code review
- **Tier 3 (Opus)**: Senior Reviewer for complex tasks

**Escalation (follows tier system):**
- **Tier 1 → Tier 2**: Stuck in loop, need architectural decision, permission blocked
- **Tier 2 → Tier 3**: CONSTITUTION.md change, major refactoring, process change needed
- **Tier 3 → User**: External dependency, strategic decision, clarification needed

See [`.claude/roles/ROLES.md`](../../../../.claude/roles/ROLES.md) for complete tier permissions and escalation paths.

---

## Learnings Log
**File:** `docs/learnings_log.md`

When you encounter an issue:
```markdown
## Date: 2026-01-04
Issue: [brief description]
Solution: [how you fixed it]
```

That's it. Keep it simple.

---

**Remember:** These are guidelines. Improvise when needed to get the game done.

[GLM-4.7 - 2026-01-20] (Updated: Integrated with tier-based permission system)
