# Context Safety Implementation

This folder contains scripts to prevent context window overflow in AI coding agents.

## Problem
Context overflow occurs when too many file operations (Read/Write) happen in rapid succession. Each file operation dumps ~1,500-2,000 tokens to context without auto-compaction.

**Danger Zone:** 5+ file operations in quick succession

## Solution

### 1. PowerShell Aliases (Safety Net)
Safe alternatives to common commands:
- `lss` - Safe `ls` that limits output to 50 items
- `cats` - Safe `cat` that limits files to 500 lines
- `finds` - Safe `find` that limits results to 100 matches

### 2. CLAUDE.md Protocol
Updated with context safety rules:
- Checkpoint after 3 writes or 5 total file operations
- Use safe aliases when available
- Batch work into small groups

## Installation

```bash
# Install context safety hooks
cd scripts
.\install-context-safety.ps1
```

Then restart PowerShell to load the aliases.

## Usage

### Before:
```bash
# Risk - could cause overflow
cat large_file.txt
ls -r
find . -name "*.md"
```

### After:
```bash
# Safe - automatic limits applied
cats large_file.txt
lss -r
finds . -pattern "*.md"
```

### Checkpoint Strategy
- After editing 3+ files, checkpoint
- Before starting new task groups, checkpoint
- Mark todos IMMEDIATELY after each file write

## Files Modified
- `CLAUDE.md` - Added context safety protocol
- `scripts/context-safety-hooks.ps1` - PowerShell aliases implementation
- `scripts/install-context-safety.ps1` - Installation script
- `scripts/README_CONTEXT_SAFETY.md` - This documentation

The MCP server approach was deemed overengineered and removed. Manual protocol following is sufficient.