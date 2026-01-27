# Claude Code Multi-Model Launcher Setup

## Problem Solved
When typing `claude` in terminal, GLM-4.7 was loading instead of real Claude models because `~/.claude/settings.json` was configured for Z.AI API.

## Solution: Config File Swapping
Each command swaps in the correct config file before launching.

## Installation Steps

### 1. Create Config Files

Copy these to `C:\Users\Sam\.claude\`:

```
settings-claude.json   ← Clean config (uses Anthropic API)
settings-glm.json      ← Your existing GLM config
settings-minimax.json  ← Your existing MiniMax config
```

**settings-claude.json** (minimal - no overrides):
```json
{
  "permissions": { "allow": [], "deny": [] },
  "env": {}
}
```

### 2. Copy Launcher Script

Copy `start-claude-anthropic.ps1` to `C:\Users\Sam\scripts\`

### 3. Update PowerShell Profile

Open your profile:
```powershell
notepad $PROFILE
```

Add the contents of `profile-snippet.ps1`

### 4. Set Anthropic API Key

Add to your profile or environment:
```powershell
$env:ANTHROPIC_API_KEY = "sk-ant-api03-YOUR-KEY-HERE"
```

### 5. Restart Terminal

Close and reopen PowerShell/terminal.

## Usage

| Command | Loads | API |
|---------|-------|-----|
| `claude` | Claude Sonnet/Opus | api.anthropic.com |
| `glm` | GLM-4.7 | api.z.ai |
| `minimax` | MiniMax-M2.1 | api.minimax.chat |

### Utility Commands

```powershell
which-claude    # Shows which config is currently active
reset-claude    # Resets to default Anthropic config
```

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│  You type: claude                                           │
│      ↓                                                      │
│  start-claude-anthropic.ps1 runs                            │
│      ↓                                                      │
│  1. Clears GLM/MiniMax environment variables                │
│  2. Copies settings-claude.json → settings.json             │
│  3. Launches claude.exe                                     │
│      ↓                                                      │
│  Claude Code reads clean settings.json → Uses Anthropic API │
└─────────────────────────────────────────────────────────────┘
```

## Troubleshooting

### "claude still loads GLM"
1. Run `which-claude` to check active config
2. Run `reset-claude` to force reset
3. Verify `ANTHROPIC_API_KEY` is set: `echo $env:ANTHROPIC_API_KEY`

### "API key not found"
Add to your PowerShell profile:
```powershell
$env:ANTHROPIC_API_KEY = "sk-ant-api03-..."
```

### "Permission denied on settings.json"
Close all Claude Code instances before switching configs.
