# Claude Code Directives

## CRITICAL: NO SUB-AGENTS

**NEVER use the Task tool to spawn sub-agents.** This is an absolute rule with no exceptions.

Sub-agents burned 70k+ tokens in under a minute. This is unacceptable.

### Use Direct Tools Only

- Glob, Grep, Read, Edit, Write, Bash
- No Task tool for research, exploration, or delegation
- Even if skills instruct agent spawning, DO NOT DO IT

### Token Efficiency

- Opus: Strategic planning and architecture decisions only
- Sonnet: All execution and editing work
- Keep responses concise
- Don't read entire large files unless necessary
