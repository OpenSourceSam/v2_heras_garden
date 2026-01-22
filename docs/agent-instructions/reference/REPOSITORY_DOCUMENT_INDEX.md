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
| **`.claude/`** | Claude configuration | Skills, commands, roles, settings, learnings |
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
- `playtesting/` - Playtesting procedures and guides (HPV walkthroughs, quest flow)
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
│   │   ├── setup-guide.md
│   │   ├── quick-start.md
│   └── testing-framework.md     (DELETED - Use docs/playtesting/)
├── tools/
│   ├── permissions.md           (Available permissions)
│   ├── workflows.md             (Standard workflows)
│   └── mcp-wrapper-usage.md     (PowerShell wrapper for IDE agents)
└── reference/
    ├── repository-structure.md  (This file)
    └── skills-catalog.md        (Detailed skill descriptions)
```

**Start here:** [`README.md`](../README.md)

### 📁 `.claude/` - Claude Configuration

**Purpose:** Claude-specific configurations, skills, and learning materials

**Key Subdirectories:**
- `agents/` - Agent definitions
- `commands/` - Slash commands (onboarding and workflows)
- `learnings/` - Learning database
  - `bugs/` - Bug patterns and templates
  - `loops/` - Loop detection patterns
  - `patterns/` - Code patterns
- `roles/` - Role definitions (Tier 1/2/3)
- `settings.local.json` - **Permissions configuration**
- `skills/` - **Skill packages** (see skill-inventory.md)

### 📁 `game/` - Game Source Code

**Purpose:** All game-related source code

**Structure:**
```
game/
├── features/              # Game features
│   ├── cutscenes/         # Cutscene scenes and scripts
│   │   ├── sailing_first.tscn/gd (Quest 3 sailing)
│   │   ├── sailing_final.tscn/gd (Quest 11 sailing)
│   │   ├── calming_draught_failed.tscn/gd (Quest 5 failure)
│   │   ├── reversal_elixir_failed.tscn/gd (Quest 6 failure)
│   │   ├── binding_ward_failed.tscn/gd (Quest 8 failure)
│   │   └── epilogue.tscn/gd (Epilogue cutscene)
│   ├── locations/         # Location scenes
│   │   ├── aiaia_shore.tscn/gd (Shore location - Quest 3)
│   │   ├── titan_battlefield.tscn/gd (Divine blood collection)
│   │   ├── daedalus_workshop.tscn/gd (Daedalus crafting area)
│   │   ├── sacred_grove.tscn/gd (Moon tears location)
│   │   └── scylla_cove.tscn/gd (Scylla confrontation)
│   ├── minigames/         # Minigame implementations
│   ├── npcs/              # NPC definitions
│   │   ├── circe.tscn (Circe NPC)
│   │   ├── npc_spawner.gd (Location-specific spawning)
│   │   └── npc_base.gd (Dialogue routing)
│   └── world/             # World scenes
│       ├── boat.gd (Travel system)
│       ├── shore_path.gd (Shore access trigger)
│       └── workshop_path.gd (Workshop access trigger)
├── shared/                # Shared resources
│   ├── resources/         # Game resources (dialogues, quests)
│   │   └── dialogues/
│   │       ├── quest3_confrontation.tres (Shore dialogue)
│   │       ├── epilogue_circe.tres (Epilogue dialogue)
│   │       └── quest1_choice_*.tres (Hermes choices)
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

### Cursor Configuration
- **`.cursor/settings.json`** - Workspace settings
- **`.cursor/mcp.json`** - MCP server configuration

---

## 📚 Documentation Locations

### Agent Instructions (START HERE)
- **Central Hub:** [`docs/agent-instructions/README.md`](../README.md)
- **Core Rules:** [`docs/agent-instructions/core-directives/project-rules.md`](../core-directives/project-rules.md)
- **Skills:** [`docs/agent-instructions/core-directives/skill-inventory.md`](../core-directives/skill-inventory.md)
- **Planning:** [`docs/agent-instructions/core-directives/project-rules.md#planning-and-documentation-guidelines`](../core-directives/project-rules.md#planning-and-documentation-guidelines)

### Setup Guides
- **MCP Setup:** [`docs/agent-instructions/setup-guides/mcp-setup.md`](../setup-guides/mcp-setup.md)
- **MCP Wrapper Usage:** [`docs/agent-instructions/tools/mcp-wrapper-usage.md`](../tools/mcp-wrapper-usage.md) - PowerShell wrapper for IDE extension agents


### Project Documentation
- **Repository Catalog:** `docs/REPOSITORY_STRUCTURE_CATALOG.md` - **Complete analysis**
- **Roadmap:** `docs/execution/DEVELOPMENT_ROADMAP.md`
- **Testing Guide:** `docs/playtesting/HPV_GUIDE.md` (canonical HPV guide)

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

### Skills Locations (Dual Source of Truth)
- `.claude/skills/` - Claude Code skills (source of truth for Claude).
- `.github/skills/` - Codex extension skills (source of truth for Codex).
- Skills may differ by tool capability; keep each set accurate for its tool.

**Action:** Maintain both locations and document tool-specific differences when needed.

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

**Want to test something?**`n  ? [ [`docs/playtesting/HPV_GUIDE.md`](../../playtesting/HPV_GUIDE.md) (HPV walkthrough)`n  ? [ [`docs/playtesting/PLAYTESTING_ROADMAP.md`](../../playtesting/PLAYTESTING_ROADMAP.md) (quest flow)
→ [`docs/agent-instructions/setup-guides/testing-framework.md`](../setup-guides/testing-framework.md)

**Understanding permissions?**
→ [`docs/agent-instructions/tools/permissions.md`](../tools/permissions.md)

**Need MCP wrapper for IDE?**
→ [`docs/agent-instructions/tools/mcp-wrapper-usage.md`](../tools/mcp-wrapper-usage.md)

**Looking for a file?**
→ Use Glob or Grep tools as shown above

---

**Last Updated:** 2026-01-18
**Source:** `docs/REPOSITORY_STRUCTURE_CATALOG.md` (simplified)
**Purpose:** Quick reference for key file locations

[Codex - 2026-01-17]




Edit Signoff: [Codex - 2026-01-18]





