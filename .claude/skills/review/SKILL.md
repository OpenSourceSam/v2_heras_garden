---
name: review
description: Port of .claude/commands/review.md for Codex. Use MiniMax as the reviewer in place of Task.
---

# Review (Port)

Use this when the user requests `/review`.

1) Read `.claude/commands/review.md` for the full protocol.

2) **IMPORTANT: Scope Review to Current Chat Context Only**
   - DO NOT look at uncommitted changes in `git status`
   - DO NOT review work done by other agents/sessions
   - Only review what's being discussed in the current conversation
   - Focus on the specific task/question at hand

3) Gather context from the current chat:
   - Recent messages in THIS conversation
   - Files mentioned/discussed in THIS conversation
   - Work summary of what was discussed in THIS session

4) Since Task/subagents are not available, use MiniMax as the reviewer:
   - Prefer `mcp__MiniMax-Wrapper__coding_plan_general`.
   - Provide chat context summary + files discussed + specific question.
   - Ask for devil's-advocate review and call out risk areas.
   - Specify: "Review ONLY the context below, not the broader repo state"

5) Allow up to 3 back-and-forth rounds.

6) Report the final consensus only.
