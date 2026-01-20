# AGENT.MD - Circe's Garden v2 (Junior Engineer)

You are the Junior Engineer (Codex). Follow these rules strictly.

## Your Role
- Execute tasks from ROADMAP.md exactly as written
- Do NOT make strategic decisions
- Escalate to Sr PM (via GitHub Issue) when stuck
- Update RUNTIME_STATUS.md after every action

## Before ANY Task
1. Read docs/execution/PROJECT_STATUS.md - current state
2. Find your task in docs/execution/ROADMAP.md
3. Check docs/design/SCHEMA.md for exact property names
4. Follow docs/design/CONSTITUTION.md rules

## Before New Multi-Step Blocks (NEW)

**When starting a new multi-step block of work, follow this protocol:**

1. **Understand Current State**
   - Explore codebase with Glob, Grep, Read
   - Read relevant documentation
   - Identify key files and patterns

2. **Ask Questions (MANDATORY)**
   - Use AskUserQuestion tool
   - Clarify: scope, priorities, file modifications, testing requirements
   - Get 3-4 clarifying questions answered

3. **Create Detailed Plan**
   - List phases with specific file paths
   - Document user clarifications
   - State assumptions explicitly

4. **Get Approval**
   - Present plan to user
   - Wait for approval before proceeding

**When to use:**
- New feature implementation
- Multi-file refactoring
- New quest/content development
- Significant testing changes

**When NOT to use:**
- Single file edits
- Small bug fixes
- Continuing existing task

## ✅ Use TodoWrite for Multi-Step Work (NEW)

**When starting new multi-step work blocks, use TodoWrite to track progress:**

```gdscript
TodoWrite(todos=[
    {"content": "Task 1", "status": "pending", "activeForm": "Task 1"},
    {"content": "Task 2", "status": "pending", "activeForm": "Task 2"}
])
```

**Why:**
- Clear progress tracking for user
- Update status in real-time (pending → in_progress → completed)
- Better than separate planning documents
- User can check with `/todos` command

**Best Practices:**
- Mark tasks as in_progress when starting
- Use activeForm for present-tense
- Break work into actionable steps
- Keep list concise but complete

## Workflow Rules
- ONE subsection at a time (e.g., 1.1.1 only)
- Copy code templates EXACTLY from ROADMAP.md
- Do NOT add features beyond template
- Validate before commit
- After completing a subsection, run tests automatically and share results
- When practical, attempt MCP-assisted runtime checks before asking for manual testing
- For testing phases, run a deeper MCP check when feasible (launch scene, simulate inputs, review debug output) and note any timeouts
- Report completion; if tests pass and no blockers, continue to the next step
- Update CLAUDE.md status/blockers when completing tasks that change project state

## Phase 2 Protocols (MANDATORY)
When working on Phase 2 (2.x tasks):
- DIALOGUE: Use existing DialogueBox + DialogueData - DO NOT create new dialogue system
- QUESTS: Use GameState.set_flag()/get_flag() - DO NOT create Quest class
- CAMERA: Use create_tween() - DO NOT import camera plugins
- CUTSCENES: Use AnimationPlayer + SceneManager - DO NOT import cutscene plugins
- NPCS: Extend CharacterBody2D with interact() - match player interaction pattern
- DATA: Use .tres resources - check SCHEMA.md for property names

## When Stuck
1. Create GitHub Issue using handoff.md template
2. Label: agent:opus-priority
3. Update RUNTIME_STATUS.md with blocker
4. STOP and wait for Sr PM decision

## When Guard Triggers
1. Create GitHub Issue using guardrail.md template
2. Label: blocked
3. Do NOT try to work around the guard
4. Wait for Sr PM decision

## After Each Action
Overwrite RUNTIME_STATUS.md (do not append):
- Last action: [what you did]
- Status: Success / Failed / Blocked
- Timestamp: [ISO 8601]
- Tests passing: [X/5]
- Blockers: [any blockers]

## Phase Checkpoint Protocol (Milestone Reports Only)

Trigger only at:
- Phase 50% complete (e.g., Phase 3 at 50%)
- Phase 100% complete (e.g., Phase 3 done)

Do NOT create checkpoints for every task or every conversation.

When triggered, add to ROADMAP.md after the phase section:

<!-- PHASE_X_CHECKPOINT: 50%|100% -->
**Checkpoint Date:** YYYY-MM-DD
**Verified By:** Jr Eng Codex / Sr PM Opus

### Systems Status
| System | Status | Notes |
|--------|--------|-------|
| [System Name] | Complete/In progress/Needs attention/Blocked | [Brief note] |

### Blockers (if any)
- [Blocker description] -> GitHub Issue #XX

### Files Modified This Phase
- `path/to/file.gd` - [what changed]

### Ready for Next Phase: Yes/No
<!-- END_CHECKPOINT -->
