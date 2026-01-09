# Saved Chats

This folder contains exported chat logs from various LLM sessions.

## Structure

- `minimax/` - Chat logs from minimax Claude sessions
- `claude/` - Chat logs from Claude web/Claude Code sessions
- `other/` - Chat logs from other LLMs or tools

## Naming Convention

Use the following format for saved chat files:
```
YYYY-MM-DD_HH-MM-SS_[Topic]_[Model].md
```

Example:
```
2026-01-03_14-30-00_Game_Development_Opus.md
```

## Usage

### Option 1: Manual Save (Easy)
1. Copy your entire chat conversation from minimax (Ctrl+A, Ctrl+C)
2. Double-click `Save_Chat.bat`
3. Chat is automatically saved with timestamp!

### Option 2: Auto-Save (Monitors Clipboard)
1. Double-click `Start_AutoSaver.bat`
2. Keep the window open
3. Copy chat content → it auto-saves every 2 seconds when new content detected
4. Press Ctrl+C to stop

### Option 3: Manual PowerShell
```powershell
.\chat_saver.ps1 -Topic "Your_Topic" -Model "Opus"
```

### File Naming
All files are automatically named with timestamp:
- Format: `YYYY-MM-DD_HH-MM-SS_topic_model.md`
- Example: `2026-01-03_14-30-00_Game_Development_Opus.md`

## Tools Included

- `chat_saver.ps1` - Manual save script
- `auto_saver.ps1` - Clipboard monitoring script
- `Save_Chat.bat` - Easy launcher for manual save
- `Start_AutoSaver.bat` - Easy launcher for auto-save
