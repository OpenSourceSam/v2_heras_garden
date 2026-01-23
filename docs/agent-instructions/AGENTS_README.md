# Agent Instructions Hub

**Centralized location for all agent instructions and documentation**

This hub consolidates scattered agent instructions into a single, discoverable location. All agents should start here to understand project directives, available skills, and workflows.

---

## 🚀 New Agent? Start Here (5 min)

**Step 1:** Read [TESTING_WORKFLOW.md](./TESTING_WORKFLOW.md) - How to test (2 min)

**Step 2:** Know your agent type and check [Role-Specific Quick Start](#role-specific-quick-starts) below (2 min)

**Step 3:** Before any task, check [Skills Inventory](./core-directives/skill-inventory.md) (1 min)

**Then:** Proceed with your task using [Standard Workflows](./tools/workflows.md)

---

## 📋 Project Context

**What is this project?**
- "Hera's Garden" - A 2D Godot game about Circe from Greek mythology
- Narrative farming sim with dialogue choices and consequences
- **Phase 7 COMPLETE**. Next: **Phase 8: Map Visual Development**

**Who is Sam?**
- Project owner and CEO
- Non-technical stakeholder who directs agent work

**Development Status:**
- All major features implemented
- Current focus: Map layout, art assets, visual polish
- See [DEVELOPMENT_ROADMAP.md](../../execution/DEVELOPMENT_ROADMAP.md) for full status

---

##  Quick Navigation

###  **Essential Reading**
1. **Testing Workflow**: [TESTING_WORKFLOW.md](./TESTING_WORKFLOW.md) - **NEW: Single source of truth for testing**
2. **Core Project Rules**: [core-directives/project-rules.md](./core-directives/project-rules.md)
3. **Skills Inventory**: [core-directives/skill-inventory.md](./core-directives/skill-inventory.md)

### ️ **Setup & Configuration**
- **MCP Setup**: [setup-guides/mcp-setup.md](./setup-guides/mcp-setup.md)
- **Testing Framework Choice**: [setup-guides/testing-framework-choice.md](./setup-guides/testing-framework-choice.md)

###  **Tools & Workflows**
- **Permissions**: [tools/permissions.md](./tools/permissions.md)
- **Standard Workflows**: [tools/workflows.md](./tools/workflows.md)
- **MCP Wrapper Usage**: [tools/mcp-wrapper-usage.md](./tools/mcp-wrapper-usage.md) - PowerShell wrapper for IDE agents
- **Slash Commands**: .claude/commands/ (/ground, /token-plan, /clarify, /finish, /explain)

###  **Reference**
- **Repository Document Index**: [reference/REPOSITORY_DOCUMENT_INDEX.md](./reference/REPOSITORY_DOCUMENT_INDEX.md)
- **Skills Catalog**: [reference/skills-catalog.md](./reference/skills-catalog.md)

---

##  Directory Structure


docs/agent-instructions/
├── README.md                    (THIS FILE - Master Index)
├── core-directives/             (What Agents Must Know)
│   ├── project-rules.md         (Core constraints from CLAUDE.md)
│   ├── role-permissions.md      (Role-based permissions)
│   └── skill-inventory.md       (Available skills catalog)
├── setup-guides/                (How to Configure)
│   ├── mcp-setup.md             (MCP server setup)
│   │   ├── setup-guide.md       (Complete setup guide)
│   │   ├── quick-start.md       (Quick start guide)
│   └── testing-framework-choice.md  (Testing framework choice)
├── tools/                       (How to Work)
│   ├── permissions.md           (Available permissions list)
│   ├── workflows.md             (Standard workflows)
│   └── mcp-wrapper-usage.md     (PowerShell wrapper for IDE agents)
└── reference/                   (Look Here For...)
    ├── REPOSITORY_DOCUMENT_INDEX.md  (File locations reference)
    └── skills-catalog.md        (Detailed skill descriptions)


---

##  Role-Specific Quick Starts

###  For IDE Extension Agents (Cursor, VS Code)
1. **MCP Access:** Use PowerShell wrapper - [tools/mcp-wrapper-usage.md](./tools/mcp-wrapper-usage.md)
2. **No Native Tools:** `mcp__godot__*` tools NOT available
3. **Debugger:** F5 works for breakpoints and Variables panel
4. **Testing:** Use `npx godot-mcp-cli` or PowerShell wrapper for MCP commands
5. **Check:** `.cursor/mcp.json` configuration

###  For Claude Desktop Agents
1. **MCP Access:** Native `mcp__godot__*` tools available
2. **DAP Debugger:** Full access to breakpoints, step debugging, call stacks
3. **Testing:** Use native MCP tools or DAP - [dap-integration.md](./dap-integration.md)
4. **Check:** `.claude/settings.local.json` configuration

###  For Terminal Agents (RooCode, GPT Codex)
1. **MCP Access:** Direct subprocess access to `npx godot-mcp-cli`
2. **Commands:** Use full npx CLI format: `npx -y godot-mcp-cli get_runtime_scene_structure`
3. **Testing:** All MCP tools available via CLI

---

---

##  Documentation Categories

### 1. Core Directives (What Agents Must Know)
- **Project Rules & Constraints**: Critical rules from CLAUDE.md
- **Role-Based Permissions**: Tier-based permissions system
- **Skills Inventory**: Available project skills and when to use them
- **Critical Workflows**: Multi-step project planning protocol

### 2. Setup Guides (How to Configure)
- **MCP Server Setup**: Model Context Protocol configuration
- **Testing Framework**: Testing procedures and best practices
- **Development Environment**: Getting started guide

### 3. Tools & Workflows (How to Work)
- **Available Permissions**: Complete list from settings.local.json
- **Standard Workflows**: Multi-step project planning protocol
- **Testing Procedures**: Godot testing best practices
- **Git Operations**: Project git workflow

### 4. Reference (Look Here For...)
- **Repository Structure**: Key file locations
- **Skills Catalog**: Detailed skill descriptions and usage
- **File Locations**: Where to find specific resources
- **Common Patterns**: Reusable patterns and examples

---

##  Finding Information

### By Task Type

**Starting a new task?**
→ [core-directives/project-rules.md](./core-directives/project-rules.md) → Multi-Step Project Planning Protocol

**Need to use a skill?**
→ [core-directives/skill-inventory.md](./core-directives/skill-inventory.md)


**Planning a complex task?**
→ [core-directives/project-rules.md#planning-and-documentation-guidelines](./core-directives/project-rules.md#planning-and-documentation-guidelines)

**Understanding permissions?**
→ [tools/permissions.md](./tools/permissions.md)

**Need MCP access from IDE?**
→ [tools/mcp-wrapper-usage.md](./tools/mcp-wrapper-usage.md)

**Looking for a file?**
→ [reference/REPOSITORY_DOCUMENT_INDEX.md](./reference/REPOSITORY_DOCUMENT_INDEX.md)

---

##  How to Use This Hub

### For New Agents
1. Read this README.md (you're here!)
2. Review [core-directives/project-rules.md](./core-directives/project-rules.md)
3. Check [core-directives/skill-inventory.md](./core-directives/skill-inventory.md)
4. Find relevant setup guides in [setup-guides/](./setup-guides/)

### For Updates
- When adding new skills → Update [core-directives/skill-inventory.md](./core-directives/skill-inventory.md)
- When creating new documentation → Place in appropriate category
- When updating procedures → Update relevant guide
- When changing permissions → Update [tools/permissions.md](./tools/permissions.md)

### For Maintenance
- Keep this README.md updated with new sections
- Ensure all links work correctly
- Add new categories as needed
- Remove outdated information

---

## ️ Important Notes

**Planning Guidelines:**
- Use TodoWrite as default for task tracking
- Create plan documents in temp/plans/ for one-off implementations
- Only use docs/plans/ for canonical references needed by future agents

**Critical Rules:**
- Use MiniMax MCP sub-agents only; avoid Codex/Claude sub-agents unless Sam explicitly requests otherwise
- ALWAYS use skills before manual implementation
- Use direct tools: Glob, Grep, Read, Edit, Write, Bash
- Check available skills before writing code
- Scripted Playthrough Testing (SPT) is automation, not a playtest. Use it when Sam explicitly asks; otherwise avoid it. Use MCP/manual for playability checks.
- Teleport-assisted HPV is the default unless a full walk is explicitly requested.

---

##  Cross-References

**Main Project Directives**: CLAUDE.md
**Complete Repository Catalog**: docs/REPOSITORY_STRUCTURE_CATALOG.md
**Project Roadmap**: docs/execution/DEVELOPMENT_ROADMAP.md
**Testing Guide**: docs/testing/GODOT_TOOLS_GUIDE.md

---

##  Last Updated

**Created**: 2026-01-03
**Status**: Phase 8 Active - Map visual development preparation complete
**Current Phase**: Phase 8 - Map Visual Development

**Note**: See commit 8380c4a for Phase 7 completion

**Recent Updates (2026-01-23):**
- Added TESTING_WORKFLOW.md as single source of truth for testing methods
- Enhanced HPV documentation with agent-specific guidance
- Consolidated testing workflow across all agent types (IDE, Desktop, Terminal)
- Completed autonomous code review with no blocking issues
- Phase 7 complete (commit 8380c4a): Documentation audit, dialogue fixes, endings testing completed

---

**Need help?** Check the relevant category above, see [TESTING_WORKFLOW.md](./TESTING_WORKFLOW.md), or refer to CLAUDE.md for core project directives.

[GLM-4.7 - 2026-01-23]


Edit Signoff: [Codex - 2026-01-17]

