---
description: Self-contained code review - main agent reviews own work, uses cheaper subagent for blind spot detection
argument-hint: <optional_commit_hash_or_pr_number>
allowed-tools: [Read, Bash, Glob, Grep, Task]
---

# Code Review (Self-Contained with Internal Back-and-Forth)

**Context:** `$ARGUMENTS` (commit hash, PR number, or current work)

## Power Dynamic

**Main Agent (Claude Opus) is MORE capable than the reviewer subagent.**

The reviewer's role is to surface *potential* blind spots - NOT to be an authority. Main Agent:
- Has full context (lived through the work)
- Makes all final decisions
- Should trust own judgment over reviewer when confident
- Uses reviewer insights as "things to consider", not directives

## Maximum Rounds: 2
Main Agent conducts primary review. Subagent provides one round of blind spot detection. Main Agent decides.

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

3. **Conduct Primary Review (YOU):**
   - Review the diff yourself
   - Identify issues, edge cases, consistency problems
   - Document findings

4. **Optional: Invoke Blind Spot Detector:**
   - Use Task tool with general-purpose agent (MiniMax - cheap)
   - Give summary of changes + your findings
   - Ask: "What did I miss?"
   - Treat response as suggestions, not authority

5. **Report to User:**
   - Your findings + any useful subagent insights
   - You make all final calls

### If Using Subagent for Blind Spot Detection:

The subagent is a **helper**, not an authority. They:
- Have LESS context and capability than you
- May surface useful things to consider
- Should NOT be treated as a gatekeeper
- Provide ONE round of input, then you decide

---

## Instructions for Blind Spot Subagent

**You are a cheap helper agent. Your role:**
- Surface potential blind spots the main agent might have missed
- You have LESS context and capability than them
- Your suggestions are OPTIONAL - they decide what to act on
- Be brief - one round only

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
