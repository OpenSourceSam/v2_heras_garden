# Agent Instructions Hub

**Centralized location for all agent instructions and documentation**

This hub consolidates scattered agent instructions into a single, discoverable location. All agents should start here to understand project directives, available skills, and workflows.

---

## 📋 Quick Navigation

### 🚀 **Start Here for New Agents**
1. **Core Project Rules**: [`core-directives/project-rules.md`](./core-directives/project-rules.md)
2. **Skills Inventory**: [`core-directives/skill-inventory.md`](./core-directives/skill-inventory.md)
3. **Planning Guidelines**: [`core-directives/project-rules.md#planning-and-documentation-guidelines`](./core-directives/project-rules.md#planning-and-documentation-guidelines)

### 🛠️ **Setup & Configuration**
- **MCP Setup**: [`setup-guides/mcp-setup.md`](./setup-guides/mcp-setup.md)
- **MiniMax Integration**: [`setup-guides/minimax-integration/`](./setup-guides/minimax-integration/)
- **Testing Framework**: [`setup-guides/testing-framework.md`](./setup-guides/testing-framework.md)

### 🔧 **Tools & Workflows**
- **Permissions**: [`tools/permissions.md`](./tools/permissions.md)
- **Standard Workflows**: [`tools/workflows.md`](./tools/workflows.md)

### 📚 **Reference**
- **Repository Structure**: [`reference/repository-structure.md`](./reference/repository-structure.md)
- **Skills Catalog**: [`reference/skills-catalog.md`](./reference/skills-catalog.md)

---

## 📁 Directory Structure

```
docs/agent-instructions/
├── README.md                    (THIS FILE - Master Index)
├── core-directives/             (What Agents Must Know)
│   ├── project-rules.md         (Core constraints from CLAUDE.md)
│   ├── role-permissions.md      (Role-based permissions)
│   └── skill-inventory.md       (Available skills catalog)
├── setup-guides/                (How to Configure)
│   ├── mcp-setup.md             (MCP server setup)
│   ├── minimax-integration/     (MiniMax AI integration)
│   │   ├── setup-guide.md       (Complete setup guide)
│   │   ├── quick-start.md       (Quick start guide)
│   │   └── test_minimax_fuku.gd (Test script)
│   └── testing-framework.md     (Testing procedures)
├── tools/                       (How to Work)
│   ├── permissions.md           (Available permissions list)
│   └── workflows.md             (Standard workflows)
└── reference/                   (Look Here For...)
    ├── repository-structure.md  (File locations reference)
    └── skills-catalog.md        (Detailed skill descriptions)
```

---

## 🎯 Documentation Categories

### 1. Core Directives (What Agents Must Know)
- **Project Rules & Constraints**: Critical rules from CLAUDE.md
- **Role-Based Permissions**: Tier-based permissions system
- **Skills Inventory**: Available project skills and when to use them
- **Critical Workflows**: Multi-step project planning protocol

### 2. Setup Guides (How to Configure)
- **MCP Server Setup**: Model Context Protocol configuration
- **MiniMax Integration**: AI provider setup for Godot plugin
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

## 🔍 Finding Information

### By Task Type

**Starting a new task?**
→ [`core-directives/project-rules.md`](./core-directives/project-rules.md) → Multi-Step Project Planning Protocol

**Need to use a skill?**
→ [`core-directives/skill-inventory.md`](./core-directives/skill-inventory.md)

**Setting up MiniMax?**
→ [`setup-guides/minimax-integration/`](./setup-guides/minimax-integration/)

**Planning a complex task?**
→ [`core-directives/project-rules.md#planning-and-documentation-guidelines`](./core-directives/project-rules.md#planning-and-documentation-guidelines)

**Understanding permissions?**
→ [`tools/permissions.md`](./tools/permissions.md)

**Looking for a file?**
→ [`reference/repository-structure.md`](./reference/repository-structure.md)

---

## 📖 How to Use This Hub

### For New Agents
1. Read this README.md (you're here!)
2. Review [`core-directives/project-rules.md`](./core-directives/project-rules.md)
3. Check [`core-directives/skill-inventory.md`](./core-directives/skill-inventory.md)
4. Find relevant setup guides in [`setup-guides/`](./setup-guides/)

### For Updates
- When adding new skills → Update [`core-directives/skill-inventory.md`](./core-directives/skill-inventory.md)
- When creating new documentation → Place in appropriate category
- When updating procedures → Update relevant guide
- When changing permissions → Update [`tools/permissions.md`](./tools/permissions.md)

### For Maintenance
- Keep this README.md updated with new sections
- Ensure all links work correctly
- Add new categories as needed
- Remove outdated information

---

## ⚠️ Important Notes

**Planning Guidelines:**
- Use `TodoWrite` as default for task tracking
- Create plan documents in `temp/plans/` for one-off implementations
- Only use `docs/plans/` for canonical references needed by future agents

**Critical Rules:**
- NEVER use the Task tool to spawn sub-agents (token efficiency)
- ALWAYS use skills before manual implementation
- Use direct tools: Glob, Grep, Read, Edit, Write, Bash
- Check available skills before writing code

---

## 🔗 Cross-References

**Main Project Directives**: `CLAUDE.md`
**Complete Repository Catalog**: `docs/REPOSITORY_STRUCTURE_CATALOG.md`
**Project Roadmap**: `docs/execution/ROADMAP.md`
**Testing Guide**: `docs/testing/GODOT_TOOLS_GUIDE.md`

---

## 📅 Last Updated

**Created**: 2026-01-03
**Status**: Phase 1 Complete - Hub structure created
**Next**: Continue with Phase 2 (Consolidate Core Directives)

---

**Need help?** Check the relevant category above or refer to `CLAUDE.md` for core project directives.
