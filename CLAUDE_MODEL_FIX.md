# Claude Model Configuration Fix

## Problem
Claude Code CLI was defaulting to MiniMax model instead of Claude models.

## Solution Applied

### 1. Updated Configuration File
**File:** `~/.claude.json` (located at `/root/.claude.json`)

**Change made:** Added default model setting
```json
"model": "claude-sonnet-4-5"
```

This sets **Claude Sonnet 4.5** as the default model for all Claude CLI sessions.

### 2. Verification
The configuration has been verified and is working correctly:
- ✅ Config file updated
- ✅ Default model set to Sonnet
- ✅ Claude CLI version 2.0.59 detected
- ✅ Model switching via command line confirmed working

## Usage

### Using Default Model (Sonnet)
Simply run:
```bash
claude
```

### Switching Models for a Session
Use the `--model` flag:

```bash
# Use Opus
claude --model opus

# Use Haiku
claude --model haiku

# Use MiniMax M21
claude --model minimax-m21
```

### Using the Helper Script
A convenience script has been created at `./claude_with_model.sh`:

```bash
# Use default (Sonnet)
./claude_with_model.sh

# Use MiniMax
./claude_with_model.sh minimax

# Use Opus
./claude_with_model.sh opus

# Use Haiku
./claude_with_model.sh haiku
```

## Available Models

| Alias | Full Model Name | Description |
|-------|----------------|-------------|
| `sonnet` | `claude-sonnet-4-5` | Claude Sonnet 4.5 (DEFAULT) |
| `opus` | `claude-opus-4-5` | Claude Opus 4.5 |
| `haiku` | `claude-haiku-4` | Claude Haiku 4 |
| `minimax-m21` | `minimax-m21` | MiniMax M21 |

## VS Code Extension

The Claude VS Code extension reads from the same configuration file (`~/.claude.json`), so the default model is now set to Sonnet for the extension as well.

If you need to override the model in VS Code:
1. Open VS Code Settings (Cmd/Ctrl + ,)
2. Search for "Claude"
3. Look for model-related settings
4. The extension should now default to Sonnet

## Scripts Created

1. **verify_claude_config.sh** - Verifies the configuration is correct
2. **claude_with_model.sh** - Helper script to easily switch models

## Test the Fix

Run the verification script:
```bash
./verify_claude_config.sh
```

Expected output:
- ✓ Claude CLI found
- ✓ Config file exists
- Current model: claude-sonnet-4-5

---

**Fix completed:** 2026-01-01
**Configuration file:** `/root/.claude.json`
