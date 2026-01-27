# Compound Engineering Guide

**Philosophy:** Each unit of work should make future work easier.

This guide documents how AI agents work effectively in this project, covering autonomous work patterns, delegation strategies, and documentation practices that compound value over time.

## Table of Contents
- [Core Philosophy](#core-philosophy)
- [The Work Loop](#the-work-loop)
- [Autonomous Work (2A Phase)](#autonomous-work-2a-phase)
- [Parallel Delegation](#parallel-delegation)
- [Skip-Around Pattern](#skip-around-pattern)
- [Documentation Patterns](#documentation-patterns)
- [Skill Integration](#skill-integration)
- [Real-World Example](#real-world-example)

---

## Core Philosophy

**Compound engineering** means every piece of work should:
1. Solve the immediate problem
2. Make similar future problems easier to solve
3. Leave behind documentation, patterns, or tools that accelerate subsequent work

This is the opposite of "technical debt accumulation" - instead of leaving mess for future agents to clean up, each unit of work reduces friction for everyone who comes after.

### Example

**Bad (Debt):**
- Fix a bug by adding a special case that no one understands
- Leave no documentation about why it was needed
- Future agents have to reverse-engineer the fix

**Good (Compound):**
- Fix the bug
- Document the root cause in `CLAUDE.md` Common Solutions
- Add a comment explaining the pattern
- Future agents recognize and apply the same solution immediately

---

## The Work Loop

All compound engineering follows this cycle:

### 1. Plan (Confirm Scope)
- Read relevant docs (`ROADMAP.md`, `AGENTS_README.md`)
- Use TodoWrite or the built-in plan tool
- Get clear on constraints and success criteria
- Identify which tasks can be done in parallel

### 2. Delegate (Leverage Subagents)
- Use MiniMax for research and image analysis
- Use MCP for game state inspection
- Parallelize independent work across 5-10+ agents
- Keep the main agent orchestrating, not doing everything sequentially

### 3. Assess (Verify It Worked)
- Run a quick headed smoke test (HPV or targeted inspection)
- Use MCP tools to verify runtime state
- Check that the change actually solves the problem
- Don't assume - verify

### 4. Codify (Record for Future)
- Update `DEVELOPMENT_ROADMAP.md` with findings
- If HPV-related, update `PLAYTESTING_ROADMAP.md`
- Add new patterns to `CLAUDE.md` Common Solutions
- Keep docs living, not stale

---

## Autonomous Work (2A Phase)

The "2A phase" refers to autonomous execution where agents work continuously without stopping for status updates, check-ins, or summaries.

### Core Rules

**DO:**
- Work continuously through tasks
- Try 2-3 alternatives when one approach fails
- Document uncertainty and move forward
- Update plan files with quick notes
- Skip blocked items, circle back later

**DO NOT:**
- Stop to provide progress summaries
- Stop when work is slow or challenging
- Stop when uncertain - document and pick a reasonable path
- Ask "should I continue?" unless at a HARD STOP
- Stop for minor issues that can be worked around

### HARD STOPS (Only Stop For These)

1. **Creating NEW .md files** (not edits to existing ones)
2. **Editing .cursor/ directory**
3. **Git push, force push, or branch operations**
4. **Editing CONSTITUTION.md**
5. **Actions outside approved scope**
6. **Explicit user request to stop/pause**

### CHALLENGES ≠ BLOCKS

These are **NOT** reasons to stop:
- Slow operations (time is not a blocker)
- One approach failing (try alternatives)
- Uncertainty about the next step (make reasonable assumption, document, continue)
- Sequential advancement taking time (skip ahead, come back)

### Planning Artifacts

During 2A autonomous work:
- A temp plan file under `temp/` is acceptable for tracking
- `update_plan` (from longplan skill) is a valid substitute for TodoWrite
- Keep notes brief and actionable
- Delete temp files when work completes

### Finish-Game Requests

When asked to "finish the game" or "finish the roadmap":
- Default to full local-beta scope unless user narrows it
- Include explicit success criteria
- Break into multi-phase steps
- Avoid scope reduction without explicit approval

---

## Parallel Delegation

The key to velocity is parallelizing work across multiple subagents rather than doing everything sequentially.

### When to Delegate

**Use MiniMax MCP for:**
- Web search (especially latest docs, APIs, patterns)
- Image analysis (screenshots, sprites, visual references)
- Research tasks (finding best practices, examples)
- Any task where you'd reach for Grep/Glob for research

**Use MCP for:**
- Runtime game state inspection
- Teleport-assisted HPV (fastest validation)
- Scene tree analysis
- Variable inspection

**Direct Execution (No Delegation):**
- File edits (use Edit/Write tools directly)
- Code reading (use Read tool)
- Simple searches (use Grep/Glob)

### Parallelization Example

Instead of:
```
Agent 1: Generate asset 1 → wait → Generate asset 2 → wait → Generate asset 3
```

Do this:
```
Main Agent:
  → Launch 5 parallel MiniMax agents for assets 1-5
  → While they work, start assets 6-10
  → Review results as they complete
  → Implement all changes in batch
```

### Real-World Example: Visual Polish Pass

During the Seed Phase 8 props polish:
- **22 placeholder assets** needed regeneration
- Launched **10+ parallel agents** via MiniMax MCP
- Each agent handled 2-3 related assets
- All completed in ~15 minutes vs. 2+ hours sequential
- Main agent orchestrated and integrated results

**Key insight:** The main agent's job is orchestration, not execution.

---

## Skip-Around Pattern

When working through a todo list, getting stuck on one item should not block all progress.

### The Pattern

1. **Try 2-3 alternatives** for the stuck task
2. **Document the challenge** (1-2 lines in plan file)
3. **Move to next todo item**
4. **Circle back later** after making progress elsewhere
5. **Document as pending** only after exhausting alternatives

### Example

```
Todo List:
1. Fix dialogue advancement (stuck - MCP eval not working)
2. Implement Quest 3 (move here)
3. Add quest tracking (move here)
4. [Later] Return to dialogue with different approach
```

### Why This Works

- Unblocks progress on other tasks
- Often gives new perspective on the stuck task
- Maintains momentum (stopping kills velocity)
- Some problems become easier after other work is done

### TodoWrite Quote for 2A Mode

Append this to every todo task (except final "keep working" task):

> "Remember: Skip around stuck tasks. Try 2-3 alternatives. Move to next todo. Circle back. Keep working. Do not make major repo changes unless approved."

---

## Documentation Patterns

Good documentation is how work compounds. Future agents should be able to stand on your shoulders.

### Where to Document

**CLAUDE.md (Common Solutions):**
- New patterns you discovered
- Gotchas and pitfalls
- Reusable solutions
- Template: See CLAUDE.md for format

**DEVELOPMENT_ROADMAP.md:**
- What you did and why
- Test findings
- Risks and uncertainties
- Link to commits if relevant

**PLAYTESTING_ROADMAP.md (if HPV-related):**
- What you tested
- What worked / didn't work
- Bugs found
- UX observations

**todos/ directory (for unresolved work):**
- Use `todos/template.md` as a starting point
- Keep entries actionable
- Manual process (no automation)
- Delete when resolved

### Documentation Anti-Patterns

**Don't:**
- Create redundant .md files (edit existing ones instead)
- Document the obvious (code comments are enough)
- Sprawl docs across too many files (causes drift)
- Copy-paste generic documentation

**Do:**
- Capture decisions and rationale
- Note patterns for reuse
- Keep it concise
- Link related docs

### Repo Rules for Docs

- Ask before creating new .md files
- Editing existing .md files is OK (preferred)
- Prefer updating existing docs over creating new ones
- Exception: `temp/` and `temp/plans/` are OK for long-running tasks
- Delete temp files when work completes

---

## Skill Integration

The project uses skills to codify common workflows and ensure consistency across agents.

### Key Skills for Compound Engineering

**create-plan:**
- For 1A (Planning Phase)
- Interactive, waits for user feedback
- Use when scoping new features or designing architecture
- Documentation: `.claude/skills/create-plan/SKILL.md`

**longplan:**
- For 2A (Autonomous Execution)
- Continuous work, no stopping
- Built-in todo tracking with skip-around pattern
- Documentation: `.claude/skills/longplan/SKILL.md`

**minimax-mcp:**
- For delegation to subagents
- Web search, image analysis, research
- Documentation: `.claude/skills/minimax-mcp/SKILL.md`
- Terminal scripts available for direct API usage

**review:**
- Self-contained code review
- MiniMax as reviewer instead of Task tool
- Use when quality check is needed before commit

### Skill Sync

- Source of truth: `.claude/skills/`
- Codex mirror: `.codex/skills/`
- Preferred sync: `scripts/sync-skills.ps1` (supports `-DryRun`, `-Prune`)
- Keep both in sync for Cursor/Codex compatibility

---

## Real-World Example

### Seed Phase 8 Props Polish (22 Assets)

**Problem:** Map layout needed visual guidance; placeholder assets were low-quality and inconsistent.

**Approach (Compound Engineering):**

1. **Plan:**
   - Identified 22 placeholder assets across sprites/placeholders/
   - Categorized by type (NPCs, items, crafting materials, UI)
   - Determined all could be regenerated in parallel

2. **Delegate:**
   - Launched 10+ parallel MiniMax agents via MCP
   - Each agent handled 2-3 related assets
   - Used consistent prompts for visual cohesion
   - Main agent monitored progress and integrated results

3. **Assess:**
   - Used MCP to verify assets loaded in game
   - Checked sprite properties and references
   - Confirmed no broken resource paths
   - Ran quick HPV to verify visual quality in context

4. **Codify:**
   - Updated DEVELOPMENT_ROADMAP.md with polish findings
   - Documented prompt patterns for future asset generation
   - Noted which assets still need final polish (vs. placeholders)

**Results:**
- 22 assets regenerated in ~15 minutes (vs. 2+ hours sequential)
- Consistent visual style across all assets
- No broken references or resource errors
- Clear documentation for future polish phases

**Compound Value:**
- Prompt patterns reusable for future asset passes
- Parallel delegation pattern proven for 20+ tasks
- Documentation helps next agent pick up where this left off
- No technical debt - assets are production-ready placeholders

---

## Quick Reference

### When You're Stuck

1. **Try 2-3 alternatives** - don't stop on first failure
2. **Document and move on** - skip around the stuck task
3. **Delegate more** - can MiniMax or another subagent help?
4. **Check docs** - has this been solved before? (CLAUDE.md Common Solutions)
5. **Make reasonable assumption** - document uncertainty, continue

### Before You Ask

- Did you check the relevant docs?
- Did you try 2-3 alternatives?
- Can you delegate this instead of doing it sequentially?
- Can you skip this and circle back later?
- Is this actually a HARD STOP or just a challenge?

### After You Finish

1. **Verify it worked** - headed check or targeted inspection
2. **Update ROADMAP** - what you did, what you found
3. **Add to Common Solutions** - if it's a new pattern
4. **Clean up temp files** - delete temp/plans/ when done
5. **Commit** - ask if you should commit (or if unsure)

---

## Related Documentation

- `CLAUDE.md` - Project context and Common Solutions
- `docs/agent-instructions/AGENTS_README.md` - Agent onboarding
- `docs/execution/DEVELOPMENT_ROADMAP.md` - Development progress log
- `docs/playtesting/PLAYTESTING_ROADMAP.md` - HPV findings log
- `.claude/skills/` - Skill documentation (create-plan, longplan, minimax-mcp)

---

**Remember:** The goal is to leave the codebase in better shape than you found it - not just to complete tasks. Every file you edit, every pattern you document, every test you run should make the next agent's job easier. That's compound engineering.
