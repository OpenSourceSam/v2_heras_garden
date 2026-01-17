# Available Permissions

**Complete list of allowed tools and commands**

This document lists all permissions granted to agents through `.claude/settings.local.json`.

---

## 📋 Permission Categories

### 🔍 System Inspection
- `Bash(netstat:*)` - Network statistics
- `Bash(findstr:*)` - String search in files
- `Bash(find:*)` - File and directory search
- `Bash(ls:*)` - List directory contents
- `Bash(tree:*)` - Directory tree display
- `Bash(dir:*)` - Windows directory listing
- `Bash(where:*)` - Locate executables
- `Bash(echo:*)` - Display text
- `Bash(env:*)` - Environment variables
- `Bash(jobs:*)` - Background jobs

### 🔧 Development Tools
- `Bash(python:*)` - Python execution
- `Bash(node:*)` - Node.js execution
- `Bash(npm:*)` - Node package manager
- `Bash(npx:*)` - NPX package runner
- `Bash(pip:*)` - Python package installer
- `Bash(cmd:*)` - Windows command prompt
- `Bash(powershell:*)` - PowerShell execution
- `Bash(test:*)` - Test execution
- `Bash(git:*)` - Git operations
- `Bash(code:*)` - VS Code execution

### 🎮 Game Development
- `Bash(godot:*)` - Godot engine execution
- `Bash(godot-mcp:*)` - Godot MCP server
- `Bash(.Godot*.exe:*)` - Godot executable commands
- `Bash(.\\Godot*.exe\\Godot*.exe:*)` - Godot runner scripts

### 🌐 Web Operations
- `WebFetch(domain:github.com)` - GitHub content fetching
- `WebFetch(domain:code.visualstudio.com)` - VS Code docs
- `WebFetch(domain:claude.ai)` - Claude documentation
- `WebFetch(domain:claude.com)` - Claude API docs
- `WebFetch(domain:marketplace.visualstudio.com)` - VS Code marketplace
- `WebFetch(domain:docs.anthropic.com)` - Anthropic docs
- `WebFetch(domain:docs.claude.com)` - Claude docs
- `WebFetch(domain:www.minimaxi.com)` - MiniMax website
- `WebFetch(domain:platform.minimaxi.com)` - MiniMax platform
- `WebFetch(domain:mcp.so)` - MCP documentation
- `WebFetch(domain:qwenlm.github.io)` - Qwen documentation
- `WebFetch(domain:godotengine.org)` - Godot documentation
- `WebSearch` - Web search capability

### 🔑 File Operations
- `Bash(mkdir:*)` - Create directories
- `Bash(rm:*)` - Remove files/directories
- `Bash(mv:*)` - Move/rename files
- `Bash(copy:*)` - Copy files
- `Bash(cat:*)` - Display file contents
- `Bash(head:*)` - Display file beginning
- `Bash(fold:*)` - Text wrapping
- `Bash(tee:*)` - Write to files
- `Bash(grep:*)` - Pattern matching
- `Bash(identify:*)` - File identification

### 🐧 Linux/Unix Tools
- `Bash(apt:*)` - APT package manager
- `Bash(chmod:*)` - Change file permissions
- `Bash(choco:*)` - Chocolatey package manager
- `Bash(curl:*)` - Data transfer tool
- `Bash(sh:*)` - Shell execution
- `Bash(unzip:*)` - Extract archives
- `Bash(pacman:*)` - Pacman package manager
- `Bash(export:*)` - Export environment variables

### 🐳 Container Tools
- `Bash(docker:*)` - Docker containerization
- `Bash(wsl:*)` - Windows Subsystem for Linux

### 📦 Package Management
- `Bash(.venv/Scripts/pip:*)` - Virtual environment pip
- `Bash(npm view:*)` - View npm packages
- `Bash(npm search:*)` - Search npm packages
- `Bash(npm install:*)` - Install npm packages
- `Bash(npm uninstall:*)` - Uninstall npm packages
- `Bash(npm info:*)` - Get package information
- `Bash(uvx minimax-mcp:*)` - UVX MiniMax MCP

### ⚙️ System Configuration
- `Bash(set GODOT_PROJECT_PATH:*)` - Set Godot project path
- `Bash(echo "Model: $env:ANTHROPIC_MODEL")` - Display model info
- `Bash(echo $env:APPDATA)` - Display app data path

### 🔌 Special Operations
- `Bash(if not exist:*)` - Conditional file checks
- `Bash(.:*)` - Current directory operations
- `Bash(claude:*)` - Claude CLI commands

---

## 🛠️ Skill Permissions

All agents can invoke these skills:

### Core Skills
- `Skill(systematic-debugging)` - Debug workflow
- `Skill(create-plan)` - Implementation planning
- `Skill(token-aware-planning)` - Model-task matching
- `Skill(git-best-practices)` - Git workflow
- `Skill(git-best-practices:*)` - Git operations with args
- `Skill(godot-dev)` - Godot expertise
- `Skill(verification-before-completion)` - Work verification
- `Skill(pixel-art-professional)` - Pixel art techniques
- `Skill(godot-gdscript-patterns)` - GDScript patterns
- `Skill(skill-creator)` - Create new skills
- `Skill(token-aware-planning:*)` - Planning with args

### Workflow Skills
- `Bash(git checkout:*)` - Git branch operations (avoid unless Sam explicitly asks)
- `Bash(git add:*)` - Git staging
- `Bash(git commit:*)` - Git commits
- `Bash(git push:*)` - Git push
- `Bash(git worktree:*)` - Git worktree management
- `Bash(git reset:*)` - Git reset operations
- `Bash(git rm:*)` - Git remove files
- `Bash(git restore:*)` - Git restore files
- `Bash(git clone:*)` - Git clone

---

## 🎮 Godot-Specific Permissions

### Godot Test Execution
```bash
# HLC (headless logic checks)
Bash("Godot*.exe --headless --script tests/run_tests.gd")
Bash("Godot*.exe --headless --script tests/phase3_dialogue_flow_test.gd")
Bash("Godot*.exe --headless --script tests/phase3_minigame_mechanics_test.gd")
Bash("Godot*.exe --headless --script tests/phase3_softlock_test.gd")
Bash("Godot*.exe --headless --script tests/phase4_balance_test.gd")
Bash("Godot*.exe --headless --script tests/phase3_save_load_test.gd")

# HPV (headed playability validation) is done via MCP/manual playthrough.
# Scripted Playthrough Testing (SPT) is not used unless Sam explicitly asks.

# Game execution
Bash("Godot*.exe --headless --path . --scene "res://game/features/world/world.tscn" --quit-after 5")
```

### Godot Scene Loading
```bash
Bash("Godot*.exe --headless --path "C:\Users\Sam\Documents\GitHub\v2_heras_garden" --script "tests/cutscene_tree_debug.gd"")
Bash("Godot*.exe --path "C:\Users\Sam\Documents\GitHub\v2_heras_garden" --quit-after 15")
```

### Godot AI Testing
```bash
Bash("Godot*.exe --headless --script tests/ai/test_basic.gd")
Bash("Godot*.exe --headless --script tests/ai/test_map_size_shape.gd")
```

### GdUnit4 Testing
```bash
Bash("Godot*.exe --headless --script tests/gdunit4/quest_trigger_signal_test.gd")
```

### Godot Plugin Testing
```bash
Bash("Godot*.exe --script-expr "print('MiniMax API syntax check'); load('res://addons/ai_autonomous_agent/llm_apis/minimax_api.gd'); print('✓ MiniMax API loaded successfully')" --quit-after 2")
Bash("Godot*.exe --script "debug_plugin.gd"")
Bash("Godot*.exe --script "restart_plugin.gd" --quit-after 5")
Bash("Godot*.exe --script "test_minimax_fuku.gd" --quit-after 5")
```

### Godot Version Execution
```bash
Bash("Godot*.exe --version")
Bash("./Godot*.exe/Godot*.exe:*")
Bash(".Godot*.exeGodot*.exe:*")
Bash("Godot*.exe/Godot*.exe --headless --script tests/run_tests.gd")
```

---

## 🔐 Security Considerations

### What These Permissions Enable

**Full Access:**
- Read/write any file in the repository
- Execute any of the listed commands
- Run tests and modify code
- Install packages and dependencies
- Access external websites for documentation

**Git Operations:**
- Stage, commit, and push changes
- Branch operations are possible; avoid creating or switching branches unless Sam explicitly asks
- Reset and restore files
- Clone repositories

**Godot Integration:**
- Run the game in various modes
- Execute test suites
- Debug and inspect game state
- Modify scenes and scripts

### Security Best Practices

1. **Review Agent Actions**
   - Agents have significant access to your system
   - Review before confirming destructive operations
   - Use version control (git) to track changes

2. **API Keys**
   - MiniMax API key is configured: `sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c`
   - Stored in configuration for the project
   - Consider rotating keys periodically

3. **Network Access**
   - Agents can fetch from specific domains
   - Web search capability enabled
   - Monitor for unusual network activity

4. **File System Access**
   - Agents can read/write files
   - Be cautious with sensitive data
   - Use `.gitignore` for sensitive files

---

## 📚 Additional Resources

**Project Rules:**
- **Core directives:** [`../core-directives/project-rules.md`](../core-directives/project-rules.md)
- **Role permissions:** [`../core-directives/role-permissions.md`](../core-directives/role-permissions.md)

**Workflows:**
- **Standard workflows:** [`workflows.md`](./workflows.md)
- **Testing framework:** [`../setup-guides/testing-framework.md`](../setup-guides/testing-framework.md)

---

**Last Updated:** 2026-01-17
**Source:** `.claude/settings.local.json`
**Purpose:** Complete permissions reference for agents

[Codex - 2026-01-17]
