---
description: Autonomous multi-step work with dual-reviewer supervision (1A2A workflow)
argument-hint: <task_description>
allowed-tools: [Read, Grep, Glob, Edit, Write, Bash, TodoWrite, Skill, AskUserQuestion]
model: sonnet
---

# Long-Form Autonomous Planning (1A2A Workflow)

**Task:** `$ARGUMENTS`

## Compound Engineering Principles

**Core Philosophy:** Each unit of work should make future work easier.

This framework uses massive parallel delegation with 5-10+ subagents working simultaneously across multiple waves of work. Each wave compounds on the previous one, creating exponential progress rather than linear advancement.

**Key Principles:**
1. **Parallel Over Sequential** - Spawn multiple subagents simultaneously, not one at a time
2. **Skip-Around Pattern** - Never get stuck; move to next task and circle back
3. **Continuous Work** - No stopping for summaries or check-ins during 2A phase
4. **Compound Progress** - Each wave of work enables faster subsequent waves

## 1A Phase: Ask & Plan

You are in the **Ask Phase** - gather information and create a detailed plan before autonomous execution.

Spawn parallel sub-tasks using specialized agents:

```
Research Tasks:
- codebase-locator: Find all files related to the feature area
- codebase-analyzer: Understand existing patterns and architecture
- Explore: Investigate integration points and dependencies
```

For each research task, provide:
- Specific directories to examine
- Exact patterns or code to find
- Required output: file:line references


### Step 1: Understand the Task
- Use Glob/Grep/Read to explore relevant codebase areas
- Identify files that will be modified
- Understand existing patterns

### Step 2: Ask Clarifying Questions
Use AskUserQuestion to cover:
- Implementation scope and boundaries
- File modification permissions
- Testing requirements
- Phase priorities
- Any constraints or preferences

### Step 3: Create TodoWrite Plan
```javascript
TodoWrite(todos=[
  {content: "Task 1", status: "pending", activeForm: "Doing Task 1"},
  {content: "Task 2", status: "pending", activeForm: "Doing Task 2"},
  // ... more tasks
])
```

**Todo Quote for Autonomous Work:**
For each todo item (except final "keep working" task), append this reinforcement:

"Remember: Skip around stuck tasks. Try 2-3 alternatives. Move to next todo. Circle back. Keep working. Do not make major repo changes unless approved."

### Step 4: Sanity Check with MiniMax Reviewer

Before finalizing your plan, get external perspective:

```powershell
# Invoke MiniMax reviewer as "devil's advocate"
powershell -File .claude/skills/minimax-mcp/scripts/review-work.ps1 -Context "Plan summary" -Question "What risks or blind spots should I consider?"
```

**What to ask MiniMax:**
- "What's missing from this plan?"
- "What could go wrong that I haven't considered?"
- "Are there better approaches for [specific aspect]?"
- "What documentation should I reference?"

**Remember:** Use the feedback autonomously to strengthen your plan. MiniMax is advisory, not authoritative.

### Step 5: Create Self-Contained Plan File

For long autonomous sessions (30+ minutes), create a persistent .md file with:

**REQUIRED SECTIONS:**

1. **🚫 Common Pitfalls** - Anti-patterns to avoid
   - Table format: "Don't do X → Instead do Y"
   - Task-specific mistakes agents commonly make

2. **📚 Quick Reference Links** - Essential docs for this task
   - List: roadmaps, instructions, troubleshooting guides
   - Brief one-line description of each

3. **⚠️ Troubleshooting** - When things don't work
   - Table: Symptom → Check → Fix
   - Common failures and their solutions

4. **🔄 Reminders** - Keep these in mind throughout
   - "Remember to reference [doc] after every N tasks"
   - "Use [skill] when [situation] occurs"
   - Gentle guidance for autonomous execution

**Key phrasing for 2A autonomous work:**
- "Remember to reference X" (not "check X")
- "Keep in mind to use Y" (not "verify Y")
- "Use Z for W" (clear autonomous action)
- Avoid: "ask", "check", "verify" (can trigger stops)

### Step 6: Present Plan for Approval
Before proceeding, summarize:
- What will be done
- What files will be modified
- What the user should expect
- Any concerns raised by MiniMax review (and how you addressed them)

**WAIT for user to say "START 2A" before proceeding to autonomous phase.**

---

## Scope Guardrails (Finish Game Requests)

When the user says "finish the game" or "finish the roadmap":

- Default to **full local beta scope**, not a partial pass.
- Include **explicit success criteria** (intro stability, quest flow to ending, basic HPV, key visuals, tests).
- Do **not** narrow scope unless the user explicitly approves the reduction.
- Plan should cover **multiple phases** and be marked as multi-session if needed.
- If you must break into blocks, note that the **overall goal remains unchanged** and continue into the next block without waiting for re-approval unless a HARD STOP applies.

---

## 2A Phase: Autonomous Execution

**User has approved.** You are now in **Autonomous Phase** - work through the todo list independently without stopping to ask questions.

**CRITICAL:** During 2A, work continuously. Do NOT stop for:
- Clarification questions (make reasonable assumptions)
- "Should I do X?" (use your best judgment)
- "Is this correct?" (proceed with confidence)
- Progress summaries or "check-ins"
- Slow operations or challenging work
- One approach failing (try 2-3 alternatives)

**HARD STOPS still apply:** Creating .md files, git push, editing CONSTITUTION.md, actions outside scope.

### Compound Engineering: Multi-Agent Delegation

**Core Principle:** Each unit of work should make future work easier.

**Massive Parallel Delegation (5-10+ Subagents):**

During 2A phase, aggressively delegate work across multiple subagents working simultaneously:

### Context Management (2A Phase)

**CRITICAL for GLM-4.7:** Checkpoint based on FILE OPERATIONS, not time or todo count.

**Checkpoint triggers:**
1. **After 3 Write operations** (each returns ~1,500-2,000 tokens to context)
2. **After 5 total Read/Write operations** combined
3. **Before starting large batch operations** (reading/writing many files)

**Checkpoint procedure:**

1. **Update plan file with checkpoint:**
   - What's been completed (file list with line numbers)
   - Current blockers / pending items
   - Next 3-5 todos to work on
   - Critical state (quest flags, positions, etc.)

2. **Clear API context properly:**
   ```bash
   # Option 1: Proper context clear sequence
   /context clear
   /context status  # Verify it's actually cleared

   # Option 2: Start completely fresh (most reliable)
   - Close Cursor/Claude Code completely
   - Reopen and start new session
   - Reference plan: @temp/autonomous-work-[task].md
   ```

3. **Resume 2A phase:**
   - Reference the plan file: @temp/autonomous-work-[task].md
   - Continue with 2A phase from where you left off

**Why this doesn't violate "keep working":**
- You're not stopping to ask questions
- You're not providing a summary to the user
- You're just clearing token bloat and resuming
- Work continues uninterrupted across sessions

**GLM-4.7 Specific Notes:**
- GLM-4.7 has ~200K context (vs Claude's 1M)
- File operations are the primary context consumers
- `/clear` command is BUGGY - use `/context clear` or restart session entirely
- Consider using native Claude model for very long file-heavy sessions

**Example checkpoint format:**
```markdown
## Context Checkpoint [operation count]

### Operations Since Last Checkpoint
- Read: hermes_idle.tres, quest2_start.tres, daedalus_idle.tres (3)
- Write: act1_transformation_cutscene.tres, exile_cutscene.tres (2)
- Total: 5 operations → Checkpoint triggered

### Completed
- game/shared/resources/dialogues/act1_transformation_cutscene.tres - 64 lines
- game/shared/resources/dialogues/exile_cutscene.tres - 100 lines

### Current Todo
- Adding Daedalus mercy discussion dialogue

### Next 3 Todos
- Fix Aeetes character dialogue
- Add missing quest completion dialogues
- Implement missing choice branches

### Blockers
- None

### Critical State
- Quest 4 complete, met_daedalus flag set
- Next: act2_daedalus_mercy_discussion.tres
```

**Quick Reference Card:**

| Operation | Token Cost | Checkpoint After |
|-----------|------------|------------------|
| Read file | ~1,000-2,000 | Count toward 5 total |
| Write file | ~1,500-2,000 | **3 writes = checkpoint** |
| Edit file | ~500-1,000 | Count toward 5 total |
| Grep/Glob | ~100-500 | Negligible |
| TodoWrite | ~50-100 | Negligible |
| Bash (short) | ~100-500 | Negligible |

**When in doubt:** After creating 3 new dialogue files, ALWAYS checkpoint before continuing.

**When to delegate:**
- Research tasks (codebase exploration, pattern finding, dependency analysis)
- Implementation of independent features/components
- Testing and validation across multiple areas
- Documentation updates for different systems
- Asset generation (sprites, images, textures via MiniMax)
- Review and validation tasks

**Delegation Strategy:**
```
Wave 1 (Parallel Research - 5-10 agents):
- Agent 1: Locate all files related to feature X
- Agent 2: Analyze existing patterns in similar features
- Agent 3: Explore integration points and dependencies
- Agent 4: Review test coverage in relevant areas
- Agent 5: Check documentation and precedents
- Agent 6: Examine asset requirements
- Agent 7: Validate resource loading patterns
- Agent 8: Review related quest/dialogue systems
- ... continue as needed

Wave 2 (Parallel Implementation - 5-10 agents):
- Agent 1: Implement core feature A
- Agent 2: Implement core feature B
- Agent 3: Add tests for feature A
- Agent 4: Add tests for feature B
- Agent 5: Update documentation
- Agent 6: Generate required assets
- Agent 7: Validate integration points
- Agent 8: Handle edge cases
- ... continue as needed
```

**Key Points:**
- Spawn multiple subagents simultaneously, not sequentially
- Let them work in parallel on independent tasks
- Aggregate results and integrate
- Continue with next wave of subtasks
- Each wave makes future waves easier (compound engineering)

### Skip-Around Pattern

**When stuck on a task:**

1. **Document** the challenge in plan file (1-2 lines)
2. **Move immediately** to next todo item
3. **Circle back** to stuck items after making progress elsewhere
4. **Try 2-3 alternatives** before documenting as pending

**Examples of "stuck":**
- One approach failing → Try 2 more alternatives, then skip
- Slow operation → Note it, move to next task, come back
- Uncertain about implementation detail → Make reasonable assumption, note it, continue
- Sequential task blocked → Skip to parallel task, circle back

**Examples of NOT stuck (keep working):**
- Work is taking time → Time ≠ stop, keep going
- Challenging problem → Try alternatives, don't stop
- Need to research → Use MiniMax, keep going
- Multiple failures → Try more approaches, keep going

**Only stop for HARD STOPS:**
- Creating NEW .md files (not edits)
- Editing `.cursor/` directory
- Git push, force push, branch operations
- Editing CONSTITUTION.md
- Actions outside approved scope
- Explicit user request to stop/pause

### Work Guidelines

**DO autonomously:**
- Work through todos systematically without stopping
- Update plan file with quick notes (keep working)
- Delegate to 5-10+ subagents in parallel waves
- Skip around stuck tasks, circle back later
- Try 2-3 alternatives before documenting blockers
- Use skills before manual implementation
- Run tests when appropriate
- Commit changes when work blocks complete
- Continue working continuously until blocked or complete

**DO NOT:**
- Stop to provide progress summaries
- Stop to "check in" during work
- Stop when work is slow or challenging
- Stop when one approach fails (try alternatives)
- Ask "should I continue?" (unless HARD STOP)
- Wait for subagents sequentially (spawn them in parallel)

### Work Guidelines

**DO autonomously:**
- Complete all todo items systematically
- Handle blockers by continuing with other items
- Use skills before manual implementation
- Run tests when appropriate
- Commit changes when work blocks complete

**HARD STOPS (always ask, even in 2A):**
- Creating NEW .md files (not edits)
- Editing `.cursor/` directory
- Git push, force push, branch operations
- Editing CONSTITUTION.md
- Actions outside approved scope

### When Blocked

1. Note the blocker
2. Continue with other todo items
3. Summarize blockers at end
4. Don't get stuck - move forward

---

## Tracking with TodoWrite

All `/longplan` sessions use **TodoWrite** for progress tracking.

**Why TodoWrite:**
- Integrated with CLI `/todos` command for visibility
- Progress updated in real-time as you work
- No extra files cluttering the repo
- Automatically cleaned up after session ends

**Session Persistence (.md file):**
- `/longplan` creates an `.md` file ONLY when session persistence is needed
- Use when: terminal may close, work spans multiple sessions, user is away
- Format: `temp/autonomous-work-[task-name].md` or similar
- Shorter planning (via create-plan skill) uses TodoWrite only (no .md file needed)

**Tracking Best Practices:**
- Update todo status immediately when starting/finishing tasks
- Use `activeForm` to describe current action
- Mark blockers in notes, don't stop working
- Create .md file only if session may be interrupted

---

## Dual-Reviewer System

Use BOTH reviewers during 2A phase for quality control:

### GLM Devil's Advocate (Self-Review)

**When to use:**
- Before making significant changes
- After completing multi-step tasks
- When uncertain about approach

**How to invoke:**
Read `temp/glm-devils-advocate-prompt.md` and respond as the critical reviewer.

**Output format:**
```
### 🔍 Critical Review
**Concerns:** [list]
**Edge Cases Missed:** [list]
**Alternatives Not Considered:** [list]
**Recommendation:** PROCEED / REVISE / RECONSIDER
```

### MiniMax Reviewer (External Standards)

**When to use:**
- Checking against documentation standards
- Looking for precedents in trusted docs
- Verifying alignment with best practices

**How to invoke:**
```bash
powershell -File .claude/skills/minimax-mcp/scripts/review-work.ps1 -Context "what I did" -Question "question?"
```

**Output:** Retrieves relevant documentation from trusted domains (docs.anthropic.com, godotengine.org, etc.)

### Reviewer Strategy

| Reviewer | Use For | Frequency |
|----------|---------|-----------|
| GLM Devil's Advocate | Architecture, file changes, bug fixes | Before significant changes |
| MiniMax | Documentation standards, precedents | When uncertain about standards |

**Remember:** Reviewers are ADVISORS. Use judgment in applying feedback. Don't blindly follow - they're your "devil on your shoulder."

---

## Completion

When all todos complete:

1. **Summarize work done**
2. **List any blockers encountered**
3. **Show files modified**
4. **Ask if any follow-up needed**

---

## Example Flow

```
User: /longplan Fix the quest 4 dialogue bug

Agent: [1A Phase]
- Reads quest 4 dialogue files
- Asks: "Should I also check related quest files?"
- Creates TodoWrite plan
- Presents plan for approval
- WAITS...

User: START 2A

Agent: [2A Phase]
- Works through todos
- Uses GLM reviewer before major changes
- Uses MiniMax reviewer to check standards
- Completes work
- Summarizes results
```

---

**Signature:** `[GLM-4.7 - 2026-01-20]`
