---
description: Determine optimal model and role for current task
argument-hint: <task_description>
allowed-tools: [Read, Grep, Glob]
model: haiku
---

# Token-Aware Planning

Analyze the task: `$ARGUMENTS`

## 4-Role System for v2_heras_garden

### 1. Play Tester
**Model:** Kimi Code CLI Vision
**Use for:** Visual validation, HPV, screenshots, UI checks
**Cost:** Cheapest for visual tasks

### 2. General Engineer
**Model:** MiniMax/Sonnet
**Use for:** Writing code, fixing bugs, creating tests, implementing features
**Cost:** Balanced - good for most implementation work

### 3. Admin
**Model:** MiniMax/Sonnet
**Use for:** Organizing docs, maintaining file structure, updating READMEs
**Cost:** Balanced - prevents documentation debt

### 4. Senior Reviewer
**Model:** Kimi k1.6 ⚠️
**Use for:** Code review, architectural feedback, complex debugging
**Cost:** Most expensive - severely limit token use

## Recommendation

Recommend role and model based on task type. Provide cost estimate and reasoning.

[Kimi Code CLI - 2026-01-28]
