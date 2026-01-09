# Planning Approach - Updated Guidelines

**Date:** 2026-01-03
**Purpose:** Document the correct approach for planning to avoid repository clutter

---

## ✅ **What I Just Did**

1. **Moved the plan** from `docs/plans/2026-01-03-documentation-consolidation-plan.md` → `temp/plans/`
   - This is a one-off implementation plan for THIS task
   - Not needed by future agents
   - Will be deleted after completion

2. **Updated CLAUDE.md** with planning guidelines (lines 154-202)
   - Added "📝 Planning and Documentation Guidelines" section
   - Clear rules about when to use TodoWrite vs plan documents
   - Instructions for keeping `docs/` clean

---

## 📋 **The Correct Approach**

### **For Simple to Medium Tasks: Use TodoWrite**

**Example:**
```gdscript
TodoWrite(todos=[
    {"content": "Task 1 description", "status": "pending", "activeForm": "Task 1"},
    {"content": "Task 2 description", "status": "pending", "activeForm": "Task 2"},
    {"content": "Task 3 description", "status": "pending", "activeForm": "Task 3"}
])
```

**Benefits:**
- Integrated with CLI (`/todos` command)
- Progress visible to user in real-time
- No extra files created
- Can be updated incrementally
- Automatically cleaned up after task

### **For Complex Tasks: Use temp/plans/**

**Only if:**
- Task is very complex (like the documentation consolidation)
- You tried TodoWrite and it's insufficient
- The plan won't be needed by future agents

**Example:**
```
temp/plans/my-complex-implementation-plan.md
```
**After completion:** Delete it

### **For Canonical Documentation: Use docs/plans/**

**Only if:**
- The plan is a **canonical reference**
- Future agents will need to reference it
- It's part of the project's long-term documentation

**Example:**
```
docs/plans/2026-01-03-documentation-consolidation-plan.md
```
**But only if** it will be used by multiple agents in the future

---

## 🤔 **Why Not Just Always Use Plan Documents?**

You're right to question this! Here's why:

### **Problems with Plan Documents:**

1. **Clutter the repository**
   - Each task creates a new plan file
   - After 100 tasks, you have 100 plan documents
   - Most are never referenced again

2. **Hard to maintain**
   - Plans get outdated
   - No clear ownership
   - Difficult to know which ones are still relevant

3. **Misuse of docs/ directory**
   - `docs/plans/` should contain canonical project plans
   - Not task-specific implementation notes

### **Benefits of TodoWrite:**

1. **Built into the workflow**
   - User can check with `/todos`
   - Automatically cleaned up
   - No files to manage

2. **Just enough structure**
   - Clear, actionable tasks
   - Progress tracking
   - Easy to update

3. **Low overhead**
   - One command to create
   - No file management
   - Perfect for most tasks

---

## 📁 **Directory Structure**

```
repo/
├── docs/                          # CANONICAL DOCUMENTATION ONLY
│   ├── plans/                     # Long-term project plans
│   ├── execution/                 # How-to guides
│   ├── testing/                   # Testing procedures
│   └── README.md                  # Master index
│
├── temp/                          # TEMPORARY FILES
│   └── plans/                     # One-off implementation plans
│       └── [deleted after task]
│
├── .claude/                       # Claude Code configuration
│   ├── skills/                    # Project skills
│   └── settings.local.json        # Permissions
│
└── CLAUDE.md                      # Main project directives
```

---

## ✅ **The Rule**

**Before creating ANY plan document, ask:**

1. **Is this task complex enough to need a detailed plan?**
   - No → Use TodoWrite
   - Yes → Continue

2. **Will future agents need to reference this plan?**
   - Yes → Create in `docs/plans/` and add to index
   - No → Create in `temp/plans/` and delete after completion

3. **Have I tried TodoWrite and found it insufficient?**
   - No → Try TodoWrite first
   - Yes → Proceed with plan document

---

## 🎯 **For This Documentation Consolidation Task**

**What I did:**
- Created a plan in `temp/plans/` (moved from `docs/plans/`)
- Added guidelines to CLAUDE.md
- Will delete the plan after implementation

**Why this is correct:**
- This plan is ONLY for implementing the consolidation
- Future agents won't need this specific plan
- They will use the CONSOLIDATED documentation, not the plan to create it
- TodoWrite would have been insufficient for this complex task

**The RESULT (consolidated docs) goes in `docs/agent-instructions/`, not the plan**

---

## 💡 **Key Takeaway**

**TodoWrite is the default. Plan documents are the exception.**

- **80% of tasks** → TodoWrite
- **15% of tasks** → temp/plans/ (one-off plans)
- **5% of tasks** → docs/plans/ (canonical plans)

This keeps the repository clean and makes it easy for all agents to find what they need.

---

## ✅ **Action Items**

1. ✅ Moved plan to `temp/plans/`
2. ✅ Updated CLAUDE.md with guidelines
3. ❌ Will delete plan after implementation
4. ❌ Will NOT create plan documents for simple tasks
5. ✅ Will use TodoWrite as default

---

**Reference:**
- **CLAUDE.md:** Lines 154-202 (Planning and Documentation Guidelines)
- **This document:** temp/plans/PLANNING_APPROACH.md (will be deleted)
