# Standard Workflows

**Common workflows and procedures for agents**

This document outlines standard workflows that agents should follow for common tasks.

---

##  Multi-Step Project Planning Protocol

**When starting a new multi-step block of work, always follow this protocol:**

### Phase 1: Initial Understanding
1. Explore codebase to understand current state
2. Read relevant documentation
3. Identify key files and patterns
4. Use Glob, Grep, and Read tools directly for pinpoint discovery; use MiniMax MCP sub-agents early for broad, multi-file digestion

**Example:**
gdscript
# Find relevant files
Glob(pattern: "**/*quest*.gd")
Glob(pattern: "**/*dialogue*.gd")

# Search for patterns
Grep(pattern: "quest_.*_complete")
Grep(pattern: "signal.*quest")

# Read key files
Read(file_path: "game/shared/resources/dialogues/quest3_start.tres")


### Phase 2: Q&A Phase (Recommended for new blocks)
1. Ask clarifying questions about scope, priorities, and assumptions
2. Use AskUserQuestion when it helps gather missing requirements
3. Cover: implementation scope, file modifications, testing requirements, phase priorities

**Example Questions:**
- "Should this feature work with existing save/load system?"
- "Do you want automated tests included?"
- "What are the priority requirements?"
- "Are there any constraints I should know about?"

### Phase 3: Planning Phase
1. Create detailed plan with phases
2. Include specific file paths to modify
3. Document user clarifications received
4. State assumptions explicitly

**Finish-game requests (default behavior):**
- Treat “finish the game / finish the roadmap” as a full local-beta scope unless the user narrows it.
- Include explicit success criteria and multi-phase steps.
- Avoid scope reduction unless the user explicitly approves it.

**Example Plan:**
gdscript
# Use TodoWrite for tracking
TodoWrite(todos=[
    {"content": "Update quest_4.gd to add new dialogue", "status": "pending", "activeForm": "Updating quest_4.gd"},
    {"content": "Create test for quest progression", "status": "pending", "activeForm": "Creating quest test"},
    {"content": "Run tests to verify functionality", "status": "pending", "activeForm": "Running tests"}
])


### Phase 4: Review Phase
1. Present plan to user
2. Get approval before proceeding
3. Adjust based on feedback

---

## ️ When to Apply This Protocol

###  Apply Protocol
- New feature implementation
- Multi-file refactoring
- New quest/content development
- Significant testing methodology changes
- Project restructuring

###  Don't Apply
- Single file edits
- Small bug fixes
- Simple documentation updates
- Continuing existing task

---

## Supervisor Offload Protocol (Codex -> MiniMax)

Use Codex as the supervisor for precise edits and tool orchestration, and offload long-read analysis to cheaper workers (MiniMax by default). Default is a recommendation; agents can override if another worker is configured.

**Default sub-agent fanout (recommended for multi-step tasks):**
- Run **at least two** sub-agent passes for large tasks:
  1) **Synthesis pass** (what exists, key files, risks)
  2) **Plan pass** (priority actions + verification ideas)
- For long-running tasks, add a **third** pass for edge cases or regressions.
- Use parallel sub-agent calls when possible to reduce elapsed time.

**Offload when:**
- You need to digest many files or long logs
- The task is exploration, summarization, or idea generation
- The output can be compressed (e.g., short plan, risks, checklist)

**Keep in Codex:**
- Actual code edits, tool usage, and final decisions
- Diff verification and correctness checks

**Structured output (recommended):**
Use a compact base schema and add optional fields when needed. Keep fields short to limit Codex context. Example base schema:

```
{
  "summary": "<max 8 sentences>",
  "risks": ["<max 5 bullets>"],
  "actions": ["<max 7 bullets>"],
  "open_questions": ["<max 5 bullets>"]
}
```

**Delegation Request Template (recommended):**
Use a short, structured prompt to keep worker output compact.

```
Objective: <what to decide or produce>
Inputs: <files/logs pasted or summarized>
Constraints: <max tokens, avoid code edits, format>
Output: JSON with summary/risks/actions/open_questions
```

**Offload logging (lightweight):**
- If an offload result changes a decision, add a 1-line note in `docs/execution/DEVELOPMENT_ROADMAP.md`.
- For long-running tasks, keep a temp plan in `temp/plans/` and delete it after completion.
- For multi-pass offloads, log a compact record using the template below (include only the final synthesis in-roadmap).

**Sub-agent run log (template):**
```
Task: <short description>
Passes: <synthesis | plan | edge-case>
Inputs: <paths/logs summarized>
Output: <1-2 sentence summary>
Decision impact: <none | minor | major>
```

**Default delegation flow:**
1. Gather file paths or logs to send
2. Run sub-agent synthesis + plan (and optional edge-case pass)
3. Apply changes in Codex
4. Record outcomes in roadmap or todo

**Token guardrails (suggested, adjustable):**
- If you would read >10 files or >20k tokens, consider offloading first
- Cap worker output to <1,000 tokens
- Clip long tool outputs before bringing them back to Codex
- Adjust thresholds per task and budget (agent judgment; no fixed global cutoff)

---

##  Planning and Documentation Workflow

### Step 1: Try TodoWrite First

**For most multi-step tasks, use TodoWrite:**

gdscript
TodoWrite(todos=[
    {"content": "Task 1 description", "status": "pending", "activeForm": "Task 1"},
    {"content": "Task 2 description", "status": "pending", "activeForm": "Task 2"},
    {"content": "Task 3 description", "status": "pending", "activeForm": "Task 3"}
])


**Benefits:**
- Integrated with CLI (/todos command)
- Progress visible to user in real-time
- No extra files created
- Can be updated incrementally
- Automatically cleaned up after task

### Step 2: Consider Plan Documents

**Only create plan documents if:**
- Task is complex enough that a detailed plan is essential
- Plan will be a **canonical reference** for future agents
- You've tried TodoWrite and it's insufficient for complexity

**Long-running autonomous work (approved):**
- A temp plan file under `temp/` is acceptable when using a longplan workflow.
- Prefer `update_plan` for tracking in Codex environments where `TodoWrite` is not available.
- Request permission for any new .md files during the 1A planning phase.
- If a new .md is created without prior approval, keep working and report it at the end of the work block.

**Storage Options:**

1. **Canonical docs** → docs/plans/ (kept long-term, added to docs index)
2. **One-off implementation plans** → temp/plans/ (deleted after completion)

### Step 3: Never Do This

 **DON'T create throwaway plans in docs/plans/:**

Created: docs/plans/my-implementation-plan-2026-01-03.md
Purpose: Just for this task
Result: Clutters repo with single-use documents


### Step 4: Post-Task Cleanup

- Review any plan documents created
- Move canonical docs to docs/plans/ and add to index
- Delete one-off plans from temp/plans/
- Never leave throwaway plans in the repo

---

##  Testing Workflow

### Standard Test Execution

bash
# 1. Run HPV for playability validation (MCP/manual)
# Use MCP to run the project and simulate input, or play manually.
# If MCP input times out right after launch, check `get_node("/root/MCPInputHandler")._registered` via runtime eval.
# Only send simulate_action_* once `_registered == true`; otherwise retry after a short delay or use runtime eval fallbacks.
# If HPV shows a completion dialogue does not set a *_dialogue_seen flag, check the dialogue resource setter for underscore mismatches.

# Silent Ralph Loop: during autonomous execution, do not send progress updates.
# Only report when the task is complete, blocked, or explicitly requested.

# 2. Run HLC for fast logic checks when useful
Godot*.exe --headless --script tests/run_tests.gd

# 3. Use verification skill before claiming complete
Skill(skill: "verification-before-completion")


### Test Categories

**Logic Tests (HLC):**
- Dialogue flow: tests/phase3_dialogue_flow_test.gd
- Minigame mechanics: tests/phase3_minigame_mechanics_test.gd
- Soft-lock scenarios: tests/phase3_softlock_test.gd
- Balance testing: tests/phase4_balance_test.gd

**Visual Tests (HPV):**
- MCP/manual playthrough with notes or screenshots
- Runtime inspection via MCP when helpful

**Scripted Playthrough Testing (SPT):**
- SPT is automation, not a playtest.
- Use it when Sam explicitly asks; otherwise avoid it.

### Test-Driven Development

**Before writing new features:**

gdscript
# 1. Invoke TDD skill
Skill(skill: "test-driven-development")

# 2. Write tests first
# 3. Implement feature
# 4. Verify tests pass


---

##  Debugging Workflow

### When Encountering Bugs

gdscript
# 1. Invoke systematic-debugging skill
Skill(skill: "systematic-debugging")

# 2. Follow skill guidance
# 3. Document findings
# 4. Create fix
# 5. Verify solution


### When Stuck in Loops

gdscript
# 1. Detect loop (after 3 attempts at same goal)
# 2. Invoke loop-detection skill
Skill(skill: "loop-detection")

# 3. Follow escape strategies
# 4. Document loop pattern


### When Completely Blocked

gdscript
# 1. Invoke blocked-and-escalating skill
Skill(skill: "blocked-and-escalating")

# 2. Create structured escalation report
# 3. Document blocking issue
# 4. Request tier-appropriate escalation


---

##  Skill Invocation Workflow

### Before Writing Code

1. **Check available skills**
   gdscript
   # List of available skills in skill-inventory.md
   

2. **Invoke relevant skill**
   gdscript
   # Godot work
   Skill(skill: "godot-dev")

   # Bug encountered
   Skill(skill: "systematic-debugging")

   # New feature
   Skill(skill: "test-driven-development")
   

3. **Apply skill knowledge**
   - Don't duplicate skill knowledge
   - Use skill guidance for implementation
   - Follow skill-recommended patterns

### When Starting New Tasks

gdscript
# 1. Always run token-aware-planning first
Skill(skill: "token-aware-planning")

# 2. Check for relevant skills
# 3. Plan work using TodoWrite
# 4. Proceed with implementation


---

##  Git Workflow

### Standard Git Operations

bash
# Check status
git status

# Stage changes
git add .

# Create commit (use git-best-practices skill)
Skill(skill: "git-best-practices")

# Push changes
git push


### Commit Message Best Practices

**Use git-best-practices skill:**
gdscript
Skill(skill: "git-best-practices", args: "-m 'Your commit message'")


**Follow conventional format:**
- feat: New feature
- fix: Bug fix
- test: Test additions/updates
- docs: Documentation changes
- refactor: Code refactoring
- chore: Maintenance tasks

**Example:**

feat(quest): add quest 4 dialogue system

- Add new dialogue nodes for quest 4
- Implement quest flag progression
- Add automated tests for quest flow

 Generated with [Claude Code]


---

## Editor Auto-Artifacts (Godot)

Some editor actions can create noisy files or scene diffs. Handle these consistently to avoid repeated interruptions.

**Typical artifacts:**
- Temp plugin binaries (e.g., `addons/limboai/bin/~*`)
- Unintentional `.tscn` diffs when opening/saving scenes

**Recommended handling:**
- Ignore temp binaries via `.gitignore` (already configured).
- Only commit `.tscn` diffs when the change is intentional.
- If a scene loses a reference unexpectedly, restore it explicitly and record the reason.

---

##  Documentation Workflow

### Before Editing Documentation

1. **Tier 1 agents MUST invoke:**
   gdscript
   Skill(skill: "confident-language-guard")
   

2. **Use qualified language**
   - "typically", "often", "recommended"
   - NOT "always", "never", "must"

### Creating New Documentation

1. **Determine location:**
   - Canonical reference → docs/
   - One-off guide → temp/
   - Agent instructions → docs/agent-instructions/

2. **Check for existing docs**
   gdscript
   Grep(pattern: "topic", output_mode: "files_with_matches")
   

3. **Avoid duplicates**
   - Consolidate related information
   - Reference existing docs
   - Update rather than duplicate

---

##  Godot Development Workflow

### Working with Scenes

1. **Explore scene structure**
   gdscript
   # Use Glob to find scenes
   Glob(pattern: "**/*.tscn")

   # Read scene file
   Read(file_path: "game/features/world/world.tscn")
   

2. **Check for related scripts**
   gdscript
   # Find associated scripts
   Glob(pattern: "**/*world*.gd")
   

3. **Understand scene hierarchy**
   gdscript
   # Read external resources
   Read(file_path: "game/shared/resources/dialogues/quest3_start.tres")
   

### Working with GDScript

1. **Check for patterns**
   gdscript
   # Search for similar patterns
   Grep(pattern: "signal.*quest")
   Grep(pattern: "func.*_ready")
   

2. **Follow established patterns**
   - Use existing code as reference
   - Follow naming conventions
   - Maintain consistency

3. **Test changes**
   bash
   # Run relevant HLC tests
   Godot*.exe --headless --script tests/phase3_dialogue_flow_test.gd
   

---

##  Information Discovery Workflow

### Finding Information

1. **Search for keywords**
   gdscript
   # Use Grep to find relevant code
   Grep(pattern: "quest_.*_complete", output_mode: "content")

   # Find files by pattern
   Glob(pattern: "**/*quest*.gd")
   

2. **Read documentation**
   gdscript
   # Check agent instructions hub
   Read(file_path: "docs/agent-instructions/README.md")

   # Reference specific sections
   Read(file_path: "docs/agent-instructions/core-directives/project-rules.md")
   

3. **Check existing patterns**
   gdscript
   # Find similar implementations
   Grep(pattern: "func.*complete.*quest")
   

### Cross-Reference

1. **Check multiple sources**
   - Code files
   - Documentation
   - Test files
   - Skills inventory

2. **Validate understanding**
   - Confirm patterns with code
   - Check test expectations
   - Review documentation

---

## ️ Common Pitfalls to Avoid

### Planning Mistakes

 Creating throwaway plans in docs/plans/
 Using TodoWrite or temp/plans/ for one-off tasks

 Over-planning simple tasks
 Applying multi-step protocol only when appropriate

### Testing Mistakes

 Relying only on HLC for UX validation
 Using both HLC (logic) and HPV (visual) tests

 Skipping visual testing for speed
 Including visual validation in all test runs

### Documentation Mistakes

 Creating duplicate documentation
 Consolidating and referencing existing docs

 Using absolute language (Tier 1 agents)
 Using qualified language with confident-language-guard

### Skill Mistakes

 Not checking for relevant skills before coding
 Always check skill inventory first

 Manually implementing what skills already know
 Invoke skills and apply their knowledge

---

##  Additional Resources

**Core Directives:**
- **Project rules:** [../core-directives/project-rules.md](../core-directives/project-rules.md)
- **Role permissions:** [../core-directives/role-permissions.md](../core-directives/role-permissions.md)
- **Skills inventory:** [../core-directives/skill-inventory.md](../core-directives/skill-inventory.md)

**Setup Guides:**
- **MCP setup:** [../setup-guides/mcp-setup.md](../setup-guides/mcp-setup.md)
- **MiniMax integration:** [../setup-guides/minimax-integration/](../setup-guides/minimax-integration/)
- **Testing framework:** [../setup-guides/testing-framework.md](../setup-guides/testing-framework.md)

**Tools:**
- **Permissions:** [permissions.md](./permissions.md)

---

**Last Updated:** 2026-01-09
**Purpose:** Standard workflows and procedures for agents

[Codex - 2026-01-09]
[Codex - 2026-01-11]
