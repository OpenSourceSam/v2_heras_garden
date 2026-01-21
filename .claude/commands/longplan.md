---
description: Autonomous multi-step work with dual-reviewer supervision (1A2A workflow)
argument-hint: <task_description>
allowed-tools: [Read, Grep, Glob, Edit, Write, Bash, TodoWrite, Skill, AskUserQuestion]
model: sonnet
---

# Long-Form Autonomous Planning (1A2A Workflow)

**Task:** `$ARGUMENTS`

## 1A Phase: Ask & Plan

You are in the **Ask Phase** - gather information and create a detailed plan before autonomous execution.

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

### Step 4: Present Plan for Approval
Before proceeding, summarize:
- What will be done
- What files will be modified
- What the user should expect

**WAIT for user to say "START 2A" before proceeding to autonomous phase.**

---

## 2A Phase: Autonomous Execution

**User has approved.** You are now in **Autonomous Phase** - work through the todo list independently.

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
