---
description: Review entire chat history with Devil's Advocate critical analysis
argument-hint: <context_description>
allowed-tools: [Read, Glob, Bash, Grep]
model: sonnet
---

# Chat History Review (Devil's Advocate)

**Context:** `$ARGUMENTS`

## You Are Now the Devil's Advocate Reviewer

Your role is to critically review the ENTIRE chat session for potential issues before committing/pushing code.

---

## Load Chat History

Find the most recent session and read the last 50 messages (to avoid huge files):

```powershell
# Find most recent JSONL chat file
$SessionFile = Get-ChildItem "C:\Users\Sam\.claude\projects\C--Users-Sam-Documents-GitHub-v2-heras-garden\*.jsonl" |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1 -ExpandProperty FullName

# Read last 50 messages with JSON parsing
$Lines = Get-Content $SessionFile | Select-Object -Last 50
$Lines | ForEach-Object {
    $msg = $_ | ConvertFrom-Json
    $msg.message.content | Where-Object { $_.type -eq 'text' } | Select-Object -ExpandProperty text
}
```

**Note:** Chat files can be large (10MB+). We only need the recent conversation context for effective review. If JSON parsing fails, fall back to analyzing the current in-memory conversation.

---

## What to Review

Analyze the ENTIRE conversation for:

### 1. Mistakes & Oversights
- Did we miss something obvious?
- Were there wrong assumptions?
- Did we skip verification steps?

### 2. Edge Cases Missed
- What happens if X occurs?
- Did we consider Y scenario?
- Are there unhandled paths?

### 3. Better Approaches
- Should we have done Z differently?
- Is there a simpler way?
- Did we overcomplicate something?

### 4. Consistency Issues
- Is terminology aligned?
- Cross-references correct?
- Follows established patterns?

### 5. Completion Status
- Is the work actually done?
- Are all todos complete?
- Any loose ends?

---

## Output Format

Provide your review in this structure:

```markdown
### 🔍 Devil's Advocate Review

**Session Context:**
[What we were working on]

**Concerns:**
- [List specific concerns found]

**Edge Cases Missed:**
- [Potential issues we didn't consider]

**Better Approaches:**
- [Alternative methods we should have considered]

**Consistency Issues:**
- [Terminology or pattern problems]

**Completion Status:**
- [Is the work ready to commit/push?]

**Recommendation:**
- [PROCEED / REVISE / ABORT]
- [Brief justification]
```

---

## When to Use

Use `/review-work` before:
- Git commits
- Git push
- Closing terminal after significant work

---

**Remember:** You're playing devil's advocate - be critical but constructive. Find the issues we missed.
