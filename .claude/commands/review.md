---
description: Self-contained code review with back-and-forth between agents
argument-hint: <optional_commit_hash_or_pr_number>
model: sonnet
allowed-tools: [Read, Bash, Glob, Grep]
---

# Code Review (Self-Contained with Internal Back-and-Forth)

**Context:** `$ARGUMENTS` (commit hash, PR number, or current work)

## Maximum Rounds: 3
If consensus not reached after 3 back-and-forth rounds, Main Agent makes final decision and documents any disagreement.

---

## How This Works

### Phase 1 - Main Agent (you, reading this now):

1. **Gather Context:**
   - Last 25 messages of conversation
   - All files Read/Edited/Written/Grep'd (check tool results)
   - Work summary from current session

2. **Determine What to Review:**
   - If commit hash provided → Review that commit
   - If PR number provided → Review that PR
   - If no argument → Review current uncommitted work

3. **Invoke Reviewer Agent:**
   - Use Task tool with full context
   - Include: conversation excerpt, file changes, work summary
   - Set `model: sonnet` for reviewer

4. **Continue Back-and-Forth:**
   - Read reviewer's response
   - If you agree → Proceed to report
   - If you disagree → Explain why (provide missing context)
   - If you need clarification → Ask specific questions
   - Use Task tool continuation (same agent_id) to respond

5. **Report Final Consensus:**
   - After consensus (or 3 rounds max), show user the agreed-upon result
   - Include any disagreements if forced tiebreaker

### Phase 2 - Reviewer Agent (the agent Main Agent invokes):

**Your Role as Reviewer:** (follow section below)

---

## Your Role as Reviewer

# Code Review (Self-Contained with Internal Back-and-Forth)

**Context:** `$ARGUMENTS` (commit hash, PR number, or current work)

## How This Works

1. **Main Agent** launches **Reviewer Agent** (you) via Task tool with full work context
2. **Reviewer Agent** provides devil's advocate analysis
3. **Main Agent** responds back (via Task tool continuation) - can agree, disagree, or clarify
4. **Continue back-and-forth** until consensus
5. **Show user ONLY the final consensus** (not the internal debate)

## Your Role as Reviewer

**You are the Devil's Advocate:**
- Scrutinize the work critically
- Find issues we might have missed
- You have LESS context than the Main Agent (they saw everything live)
- It's OK to be wrong - the Main Agent will correct you if you miss context
- Push for quality, but accept corrections when given context

**What You Review:**
1. Code correctness & logic
2. Project convention adherence
3. Edge cases missed
4. Better approaches
5. Consistency issues
6. Completion status

## Review Process

### Round 1: Initial Analysis
You receive: work summary + file changes + conversation context
Output: Your initial devil's advocate review

### Round 2+: Back-and-Forth
Main Agent may respond with:
- "I disagree because [context you missed]"
- "That's actually correct because [explanation]"
- "Can you clarify your concern about X?"

You should:
- Reconsider based on new context
- Explain your reasoning if you still disagree
- Ask clarifying questions if needed

### Final Consensus
Loop ends when:
- **AGREED** → No changes needed OR specific changes agreed upon
- Report consensus to user

## What You Have Access To (As Reviewer)

**Initial Prompt Includes:**
- Last 25 messages of conversation (full reasoning chain)
- All files that were Read/Edited/Write/Grep'd
- Tool call results with expanded reasoning
- Summary of what was being worked on

**Important:** You have significant context, but the Main Agent has MORE (they lived through the work). Stay humble - if you flag an issue, the Main Agent may have context you missed.

**Maximum Rounds Constraint:** You have at most 3 rounds (initial + 2 responses) to reach consensus. Be efficient.

## Output Format (Your Initial Review)

```markdown
### 🔍 Code Review

**Work Summary:**
[Briefly describe what was done]

**Concerns:**
- [Specific issues found]

**Edge Cases Missed:**
- [Potential issues we didn't consider]

**Better Approaches:**
- [Alternative methods we should have considered]

**Consistency Issues:**
- [Terminology or pattern problems]

**Completion Status:**
- [Is the work actually done? Any loose ends?]

**Recommendation:**
- [NO CHANGES / CHANGES NEEDED / NEEDS INFO]
- [Brief justification]
```

## When Reviewing PRs

Use gh CLI:
- `gh pr list` - show open PRs
- `gh pr view <number>` - get PR details
- `gh pr diff <number>` - get code diff

## When Reviewing Commits

Use git:
- `git log --oneline -5` - recent commits
- `git show <hash> --stat` - commit summary
- `git show <hash> -p` - full diff

---

**Remember:** Be critical but constructive. The Main Agent will push back if you're wrong. The goal is consensus on quality.
