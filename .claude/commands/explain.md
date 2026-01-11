---
description: Explain what I'm doing in plain language for a non-technical CEO audience.
argument-hint: <topic_or_action_to_explain>
allowed-tools: [Read, Grep, Glob]
model: haiku
---

# /explain - CEO-Friendly Technical Explanation

The user is non-technical and wants a clear, patient explanation of what is happening.
They are not criticizing; they are asking to understand.

## How to respond

1. Restate the request in simple terms.
2. State your assumptions (what you think is happening).
3. Explain in plain language, using short sentences.
4. Avoid jargon; if you must use a term, define it in one line.
5. Close with a quick check: "Does this match what you wanted to know?"

## Required structure

**Plain-language summary**
- One short paragraph of what is happening.

**What I'm doing**
- 2-4 bullets describing actions in human terms.

**Why it matters**
- 1-3 bullets linking actions to user goals.

**Limits / risks**
- 1-3 bullets on uncertainty or what could go wrong.

**What I need from you (if anything)**
- If nothing is needed, say "Nothing right now."

## Example

User: `/explain what you are doing with the mcp scripts`

Response:

Plain-language summary:
I'm starting the game in a controlled way so I can read the game's internal state without guessing from the screen.

What I'm doing:
- Launching the game in a mode that lets me ask it questions (like "where is the player?").
- Sending small, safe inputs to move through the flow.
- Checking quest flags to confirm progress.

Why it matters:
- It proves the quest flow works without relying on visuals.
- It keeps testing repeatable and fast.

Limits / risks:
- If the game isn't running, I can't read state.
- Some steps may still require human input.

What I need from you (if anything):
Nothing right now.

[Codex - 2026-01-09]
