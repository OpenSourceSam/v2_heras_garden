# Repository Structure Reference

**Key file locations for agents**

This reference guide provides quick access to important directories and files that agents need to know about.

---

## 🎯 Quick Reference

### Essential Directories

| Directory | Purpose | Key Contents |
|-----------|---------|--------------|
| **`docs/`** | Documentation hub | All project documentation |
| **`docs/agent-instructions/`** | Agent instructions | Centralized agent instructions |
| **`.claude/`** | Claude configuration | Skills, roles, settings, learnings |
| **`game/`** | Game source code | Scenes, scripts, resources |
| **`tests/`** | Test suites | HLC and HPV tests |
| **`addons/`** | Godot addons | Third-party extensions |
| **`assets/`** | Game assets | Art, audio, textures |

---

## 📁 Core Directories

### 📁 `docs/` - Documentation Hub

**Purpose:** All project documentation

**Key Subdirectories:**
- `agent-instructions/` - **START HERE** for agent instructions
- `execution/` - Project execution roadmap
- `testing/` - Testing procedures and guides
- `plans/` - Canonical project plans (long-term)

**Key Files:**
- `README.md` - Documentation index (to be created in Phase 8)
- `REPOSITORY_STRUCTURE_CATALOG.md` - **Complete catalog** of all files
- `MCP_SETUP.md` - MCP server configuration (moved to agent-instructions)

### 📁 `docs/agent-instructions/` - Agent Instructions Hub

**Purpose:** Centralized location for all agent instructions

**Structure:**
```
docs/agent-instructions/
├── README.md                    (Master Index)
├── core-directives/
│   ├── project-rules.md         (Core constraints)
│   ├── role-permissions.md      (Tier-based permissions)
│   └── skill-inventory.md       (Available skills)
├── setup-guides/
│   ├── mcp-setup.md             (MCP configuration)
│   ├── minimax-integration/     (MiniMax AI setup)
│   │   ├── setup-guide.md
│   │   ├── quick-start.md
│   │   └── test_minimax_fuku.gd
│   └── testing-framework.md     (Testing procedures)
├── tools/
│   ├── permissions.md           (Available permissions)
│   └── workflows.md             (Standard workflows)
└── reference/
    ├── repository-structure.md  (This file)
    └── skills-catalog.md        (Detailed skill descriptions)
```

**Start here:** [`README.md`](../README.md)

### 📁 `.claude/` - Claude Configuration

**Purpose:** Claude-specific configurations, skills, and learning materials

**Key Subdirectories:**
- `agents/` - Agent definitions
- `learnings/` - Learning database
  - `bugs/` - Bug patterns and templates
  - `loops/` - Loop detection patterns
  - `patterns/` - Code patterns
- `roles/` - Role definitions (Tier 1/2/3)
- `settings.local.json` - **Permissions configuration**
- `skills/` - **17 skill packages** (see skill-inventory.md)

### 📁 `game/` - Game Source Code

**Purpose:** All game-related source code

**Structure:**
```
game/
├── features/              # Game features
│   ├── cutscenes/         # Cutscene scenes and scripts
│   ├── minigames/         # Minigame implementations
│   ├── npcs/              # NPC definitions
│   └── world/             # World scenes
├── shared/                # Shared resources
│   ├── resources/         # Game resources (dialogues, quests)
│   └── scripts/           # Shared GDScript
└── ui/                    # User interface
```

### 📁 `tests/` - Test Suites

**Purpose:** Automated tests for game functionality

**Structure:**
```
tests/
├── phase3_dialogue_flow_test.gd        # Dialogue system tests
├── phase3_minigame_mechanics_test.gd   # Minigame logic tests
├── phase3_softlock_test.gd             # Soft-lock scenario tests
├── phase4_balance_test.gd              # Game balance tests
├── run_tests.gd                        # Run all tests
├── visual/                              # HPV references/logs
│   └── playthrough_guide.md
├── ai/                                 # AI-powered tests
│   ├── test_basic.gd
│   ├── test_map_size_shape.gd
└── gdunit4/                            # GdUnit4 tests
    └── quest_trigger_signal_test.gd
```

### 📁 `addons/` - Godot Addons

**Purpose:** Third-party Godot extensions

**Contents:**
- `fuku/` - AI assistant plugin (with MiniMax integration)
- `godot_mcp/` - MCP server integration
- `gdUnit4/` - Godot testing framework
- `papershot/` - Visual testing addon
- `ai_autonomous_agent/` - AI Autonomous Agent plugin

### 📁 `assets/` - Game Assets

**Purpose:** Art, audio, textures, and other game resources

**Contents:**
- Graphics and sprites
- Audio files
- Textures
- UI elements

---

## 🔧 Configuration Files

### Project Configuration
- **`project.godot`** - Main Godot project file
- **`project.godot.*.tmp`** - Editor backup files (can be deleted)

### Claude Configuration
- **`.claude/settings.json`** - Base configuration
- **`.claude/settings.local.json`** - **Local permissions and overrides**
- **`.claude/roles/ROLES.md`** - Tier-based permissions

### VS Code Configuration
- **`.vscode/settings.json`** - Workspace settings
- **`.vscode/mcp.json`** - MCP server configuration

---

## 📚 Documentation Locations

### Agent Instructions (START HERE)
- **Central Hub:** [`docs/agent-instructions/README.md`](../README.md)
- **Core Rules:** [`docs/agent-instructions/core-directives/project-rules.md`](../core-directives/project-rules.md)
- **Skills:** [`docs/agent-instructions/core-directives/skill-inventory.md`](../core-directives/skill-inventory.md)
- **Planning:** [`docs/agent-instructions/core-directives/project-rules.md#planning-and-documentation-guidelines`](../core-directives/project-rules.md#planning-and-documentation-guidelines)

### Setup Guides
- **MCP Setup:** [`docs/agent-instructions/setup-guides/mcp-setup.md`](../setup-guides/mcp-setup.md)
- **MiniMax Integration:** [`docs/agent-instructions/setup-guides/minimax-integration/`](../../setup-guides/minimax-integration/)
- **Testing:** [`docs/agent-instructions/setup-guides/testing-framework.md`](../setup-guides/testing-framework.md)

### Project Documentation
- **Repository Catalog:** `docs/REPOSITORY_STRUCTURE_CATALOG.md` - **Complete analysis**
- **Roadmap:** `docs/execution/ROADMAP.md`
- **Testing Guide:** `docs/testing/GODOT_TOOLS_GUIDE.md`

---

## 🗂️ Temporary and Archive

### Temporary Directories
- **`temp/plans/`** - One-off implementation plans (deleted after completion)
- **`.godot/`** - Godot cache and generated files
- **`.venv/`** - Python virtual environment

### Archive Directories
- **`archive/`** - Archived documentation and historical data
- **`archive/archive/`** - Nested archive (can be flattened)
- **`reports/`** - Test reports (recent 5 kept, older ones archived)

---

## ⚠️ Redundancies to Be Aware Of

### Skills Duplication
- `.claude/skills/` - **Primary location** (17 skills)
- `.github/skills/` - Duplicated (GitHub integration)
- `skills/` (root) - Duplicated (should be deleted)

**Action:** Use `.claude/skills/` as primary source

### Documentation Duplication
- Multiple locations for similar information
- Agent instructions now consolidated in `docs/agent-instructions/`

**Action:** Use `docs/agent-instructions/` as source of truth

### Test Reports
- 20+ numbered test reports
- Only recent 5 needed (46, 47, beta_mechanical)

**Action:** Old reports archived to `archive/test_reports/`

---

## 🔍 Finding Files

### By Pattern

**Find GDScript files:**
```gdscript
Glob(pattern: "**/*.gd")
```

**Find scene files:**
```gdscript
Glob(pattern: "**/*.tscn")
```

**Find test files:**
```gdscript
Glob(pattern: "tests/**/*.gd")
```

**Find documentation:**
```gdscript
Glob(pattern: "docs/**/*.md")
```

### By Content

**Search for quest-related code:**
```gdscript
Grep(pattern: "quest_.*_complete")
```

**Search for signals:**
```gdscript
Grep(pattern: "signal.*quest")
```

**Search for test patterns:**
```gdscript
Grep(pattern: "func test_")
```

### By Directory

**List all directories:**
```gdscript
Bash(command: "find . -type d -name '*' | head -50")
```

**List test directories:**
```gdscript
Bash(command: "ls -la tests/")
```

---

## 📖 Complete Reference

**For complete directory analysis (592 lines), see:**
`docs/REPOSITORY_STRUCTURE_CATALOG.md`

This comprehensive catalog includes:
- Analysis of 6,000+ files across 150+ directories
- Identification of redundancies and obsolete files
- Cleanup recommendations
- Detailed file listings

---

## 🎯 Quick Navigation

**Starting a task?**
→ [`docs/agent-instructions/README.md`](../README.md)

**Need project rules?**
→ [`docs/agent-instructions/core-directives/project-rules.md`](../core-directives/project-rules.md)

**Looking for skills?**
→ [`docs/agent-instructions/core-directives/skill-inventory.md`](../core-directives/skill-inventory.md)

**Want to test something?**
→ [`docs/agent-instructions/setup-guides/testing-framework.md`](../setup-guides/testing-framework.md)

**Understanding permissions?**
→ [`docs/agent-instructions/tools/permissions.md`](../tools/permissions.md)

**Looking for a file?**
→ Use Glob or Grep tools as shown above

---

**Last Updated:** 2026-01-09
**Source:** `docs/REPOSITORY_STRUCTURE_CATALOG.md` (simplified)
**Purpose:** Quick reference for key file locations

[Codex - 2026-01-09]


