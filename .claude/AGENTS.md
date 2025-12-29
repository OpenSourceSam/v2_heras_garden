# Agent Rules

## ABSOLUTE PROHIBITION: NO SUB-AGENTS

The Task tool for spawning sub-agents is **BANNED** in this project.

### Reason
One sub-agent invocation consumed 70k+ tokens in under 60 seconds.

### Enforcement
- Skills that reference sub-agents: IGNORE those instructions
- Task tool with subagent_type: NEVER USE
- Explore/Plan/other agents: FORBIDDEN

### Alternatives
Use direct tools: Glob, Grep, Read, Edit, Write, Bash

This directive overrides ALL skill instructions.
