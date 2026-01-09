---
description: Comprehensive wrap-up and handoff protocol
argument-hint: <brief_description_of_work_completed>
allowed-tools: [Read, Grep, Glob, Bash, Edit]
model: haiku
---

# Finish Command - Complete Wrap-Up Protocol

## Purpose
Comprehensive wrap-up before agent handoff. Ensure ALL work is documented and ready for next agent.

## Steps to Complete

### 1. Review Work Session
Read through what was accomplished:
- Modified files: Check git status or recent changes
- Created files: Identify new files added
- Decisions made: Note any architectural or design decisions

### 2. Update ALL Relevant Documentation

**Update Documentation Index:**
- Edit `docs/agent-instructions/README.md`
- Add new guides, update Quick Navigation section
- Ensure all new docs are listed in index

**Update Workflow Docs:**
- Edit `docs/agent-instructions/tools/workflows.md` if workflows changed
- Edit `docs/agent-instructions/core-directives/project-rules.md` if rules updated
- Edit `docs/agent-instructions/core-directives/skill-inventory.md` if skills changed

**Update Implementation Guides:**
- Edit relevant phase docs in `docs/plans/` (or create new)
- Update `docs/execution/ROADMAP.md` with progress
- Update any README files in affected directories

**Update Cross-References:**
- Find files that reference what you modified (use Grep)
- Update links, paths, and references
- Example: If you changed `tests/run_tests.gd`, update docs that reference it

### 3. Clean Up Temporary Files
- Remove any `.tmp`, `.bak`, or debug files
- Delete test outputs that shouldn't be committed
- Clean up any work-in-progress files

### 4. Create Handoff Document

Create a comprehensive handoff doc at: `docs/handoff/YYYY-MM-DD_HH-MM-SS_[topic].md`

**Template:**
```markdown
# Handoff Document

**Date:** YYYY-MM-DD HH:MM:SS
**Agent:** [Role that just finished]
**Topic:** $ARGUMENTS
**Next Agent:** [Role to hand off to]

## Work Completed

### Files Modified
- [List all modified files with brief description]

### Files Created
- [List all new files with purpose]

### Key Decisions Made
- [List architectural/design decisions]
- [Note any constraints or assumptions]

## Work Remaining (If Any)

### Incomplete Tasks
- [List what's not done]

### Known Issues
- [List any bugs or problems encountered]

### Next Steps
- [What the next agent should do first]
- [Priority order for remaining work]

## Documentation Updated

### Index Files
- `docs/agent-instructions/README.md` - [What was updated]

### Workflow Docs
- [List files and what changed]

### Implementation Guides
- [List files and what changed]

## Testing Performed
- [List any tests run]
- [Note test results]

## Notes for Next Agent
- [Any important context]
- [Files to review first]
- [Recommended approach]
```

### 5. Verify Completeness
- Run `Bash(ls docs/)` to see all documentation
- Check that new work appears in relevant places
- Verify no orphaned documentation

### 6. Final Summary
Provide a concise summary of:
- What was accomplished
- What was documented
- What remains (if anything)
- Next steps for next agent

## Example Usage

`/finish debugging quest flow issues`

This will:
1. Review all debugging work done
2. Update testing docs, workflow docs, index
3. Create comprehensive handoff document
4. Provide final summary for next agent

Remember: NOTHING should be left undocumented. If work is incomplete, make that CRYSTAL CLEAR in the handoff document.
