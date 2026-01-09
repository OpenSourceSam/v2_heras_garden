# Documentation Index

**Master index for all project documentation**

This index provides quick access to all documentation in the project, organized by category and purpose.

---

## 🚀 Quick Start

### For Agents
**START HERE:** [`agent-instructions/README.md`](agent-instructions/README.md)
- Centralized hub for all agent instructions
- Skills inventory
- Planning guidelines
- Workflows and procedures

### For Developers
- **Project Rules:** [`agent-instructions/core-directives/project-rules.md`](agent-instructions/core-directives/project-rules.md)
- **Testing Guide:** [`testing/GODOT_TOOLS_GUIDE.md`](testing/GODOT_TOOLS_GUIDE.md)
- **Repository Structure:** [`agent-instructions/reference/repository-structure.md`](agent-instructions/reference/repository-structure.md)

---

## 📁 Documentation Categories

### 🎯 Agent Instructions Hub
**Location:** `docs/agent-instructions/`
**Purpose:** Centralized location for all agent instructions

**Core Directives:**
- [`agent-instructions/core-directives/project-rules.md`](agent-instructions/core-directives/project-rules.md) - Core project rules and constraints
- [`agent-instructions/core-directives/role-permissions.md`](agent-instructions/core-directives/role-permissions.md) - Tier-based permissions
- [`agent-instructions/core-directives/skill-inventory.md`](agent-instructions/core-directives/skill-inventory.md) - Available skills catalog

**Setup Guides:**
- [`agent-instructions/setup-guides/mcp-setup.md`](agent-instructions/setup-guides/mcp-setup.md) - MCP server configuration
- [`agent-instructions/setup-guides/minimax-integration/`](agent-instructions/setup-guides/minimax-integration/) - MiniMax AI integration
- [`agent-instructions/setup-guides/testing-framework.md`](agent-instructions/setup-guides/testing-framework.md) - Testing procedures

**Tools & Workflows:**
- [`agent-instructions/tools/permissions.md`](agent-instructions/tools/permissions.md) - Available permissions
- [`agent-instructions/tools/workflows.md`](agent-instructions/tools/workflows.md) - Standard workflows

**Reference:**
- [`agent-instructions/reference/repository-structure.md`](agent-instructions/reference/repository-structure.md) - File locations reference
- [`agent-instructions/reference/skills-catalog.md`](agent-instructions/reference/skills-catalog.md) - Detailed skill descriptions

### 📋 Execution & Planning
**Location:** `docs/execution/`
**Purpose:** Project execution roadmap and current state

**Key Files:**
- [`execution/ROADMAP.md`](execution/ROADMAP.md) - Complete project roadmap (93KB)
- [`execution/CURRENT_STATE_ASSESSMENT.md`](execution/CURRENT_STATE_ASSESSMENT.md) - Current project state

### 🧪 Testing Documentation
**Location:** `docs/testing/`
**Purpose:** Testing procedures and methodologies

**Key Files:**
- [`testing/GODOT_TOOLS_GUIDE.md`](testing/GODOT_TOOLS_GUIDE.md) - Godot testing tools guide
- Testing procedures and best practices

### 📚 Project Plans
**Location:** `docs/plans/`
**Purpose:** Canonical project plans (long-term references)

**Contents:**
- Implementation plans
- Strategic planning documents
- Only plans that future agents will need

**Note:** One-off implementation plans are in `temp/plans/` and deleted after completion

### 🏗️ Architecture & Structure
**Location:** `docs/`
**Purpose:** Project structure and architecture documentation

**Key Files:**
- [`REPOSITORY_STRUCTURE_CATALOG.md`](REPOSITORY_STRUCTURE_CATALOG.md) - Complete repository analysis (592 lines)

---

## 🎯 Documentation by Task

### Starting a New Task
1. **Read Agent Hub:** [`agent-instructions/README.md`](agent-instructions/README.md)
2. **Check Project Rules:** [`agent-instructions/core-directives/project-rules.md`](agent-instructions/core-directives/project-rules.md)
3. **Find Relevant Skills:** [`agent-instructions/core-directives/skill-inventory.md`](agent-instructions/core-directives/skill-inventory.md)
4. **Understand Planning:** [`agent-instructions/core-directives/project-rules.md#planning-and-documentation-guidelines`](agent-instructions/core-directives/project-rules.md#planning-and-documentation-guidelines)

### Working with Godot
1. **Godot Rules:** [`agent-instructions/core-directives/project-rules.md#testing-best-practices-for-godot`](agent-instructions/core-directives/project-rules.md#testing-best-practices-for-godot)
2. **Testing Framework:** [`agent-instructions/setup-guides/testing-framework.md`](agent-instructions/setup-guides/testing-framework.md)
3. **Testing Tools:** [`testing/GODOT_TOOLS_GUIDE.md`](testing/GODOT_TOOLS_GUIDE.md)

### Debugging Issues
1. **Use Systematic Debugging:** [`agent-instructions/core-directives/skill-inventory.md#systematic-debugging`](agent-instructions/core-directives/skill-inventory.md#systematic-debugging)
2. **Check Test Results:** `tests/` directory
3. **Review Learnings:** `.claude/learnings/`

### Planning Complex Work
1. **Planning Guidelines:** [`agent-instructions/core-directives/project-rules.md#planning-and-documentation-guidelines`](agent-instructions/core-directives/project-rules.md#planning-and-documentation-guidelines)
2. **Workflows:** [`agent-instructions/tools/workflows.md`](agent-instructions/tools/workflows.md)
3. **Standard Protocols:** [`agent-instructions/core-directives/project-rules.md#multi-step-project-planning-protocol`](agent-instructions/core-directives/project-rules.md#multi-step-project-planning-protocol)

### Understanding Permissions
1. **Available Permissions:** [`agent-instructions/tools/permissions.md`](agent-instructions/tools/permissions.md)
2. **Role-Based Access:** [`agent-instructions/core-directives/role-permissions.md`](agent-instructions/core-directives/role-permissions.md)

### Finding Files
1. **Repository Structure:** [`agent-instructions/reference/repository-structure.md`](agent-instructions/reference/repository-structure.md)
2. **Complete Catalog:** [`REPOSITORY_STRUCTURE_CATALOG.md`](REPOSITORY_STRUCTURE_CATALOG.md)

---

## 📖 Documentation Standards

### For New Documentation

**Ask First:**
1. Does this information already exist?
2. Will future agents need this?
3. Should it be canonical or temporary?

**Placement Guidelines:**
- **Agent instructions** → `docs/agent-instructions/`
- **Canonical plans** → `docs/plans/`
- **One-off guides** → `temp/`
- **Setup guides** → `docs/agent-instructions/setup-guides/`

### Updating Documentation

**When updating:**
- Keep information centralized (avoid duplicates)
- Update relevant index entries
- Check for broken links
- Verify cross-references

**Agent Instructions Updates:**
- Update [`agent-instructions/README.md`](agent-instructions/README.md) navigation
- Add new sections to appropriate categories
- Update relevant sub-indexes

### Avoiding Clutter

**DO NOT create:**
- One-off plans in `docs/plans/`
- Duplicate documentation
- Throwaway guides in `docs/`

**DO use:**
- `TodoWrite` for task tracking
- `temp/plans/` for one-off implementation plans
- Centralized hub in `docs/agent-instructions/`

---

## 🔗 Cross-References

### Essential Links
- **Main Project Directives:** `CLAUDE.md`
- **Agent Instructions Hub:** [`agent-instructions/README.md`](agent-instructions/README.md)
- **Repository Structure:** [`agent-instructions/reference/repository-structure.md`](agent-instructions/reference/repository-structure.md)
- **Complete Catalog:** [`REPOSITORY_STRUCTURE_CATALOG.md`](REPOSITORY_STRUCTURE_CATALOG.md)

### Testing
- **Testing Framework:** [`agent-instructions/setup-guides/testing-framework.md`](agent-instructions/setup-guides/testing-framework.md)
- **Testing Guide:** [`testing/GODOT_TOOLS_GUIDE.md`](testing/GODOT_TOOLS_GUIDE.md)
- **Test Directory:** `tests/`

### Skills
- **Skills Inventory:** [`agent-instructions/core-directives/skill-inventory.md`](agent-instructions/core-directives/skill-inventory.md)
- **Skills Catalog:** [`agent-instructions/reference/skills-catalog.md`](agent-instructions/reference/skills-catalog.md)
- **Skill Directories:** `.claude/skills/`

### Configuration
- **Permissions:** [`agent-instructions/tools/permissions.md`](agent-instructions/tools/permissions.md)
- **Settings:** `.claude/settings.local.json`
- **Roles:** `.claude/roles/ROLES.md`

---

## 📅 Documentation History

### Recent Updates

**2026-01-03: Documentation Consolidation**
- ✅ Created agent-instructions hub
- ✅ Consolidated scattered instructions
- ✅ Updated CLAUDE.md references
- ✅ Removed duplicate skills directory
- ✅ All 8 phases executed

**Previous Updates:**
- Testing methodology documentation
- Planning guidelines
- MCP setup guides
- Repository structure analysis

### Maintenance Schedule

**Regular Maintenance:**
- Update agent-instructions hub when adding new skills
- Verify links quarterly
- Review for outdated information
- Archive old test reports

**Before Major Changes:**
- Update relevant documentation
- Test all links
- Verify cross-references
- Update indexes

---

## 🆘 Finding Help

### Can't Find Something?
1. Check [`agent-instructions/reference/repository-structure.md`](agent-instructions/reference/repository-structure.md)
2. Search the repository: `Grep(pattern: "keyword")`
3. Check [`REPOSITORY_STRUCTURE_CATALOG.md`](REPOSITORY_STRUCTURE_CATALOG.md)

### Need to Know What to Do?
1. Start with [`agent-instructions/README.md`](agent-instructions/README.md)
2. Check [`agent-instructions/core-directives/project-rules.md`](agent-instructions/core-directives/project-rules.md)
3. Review workflows in [`agent-instructions/tools/workflows.md`](agent-instructions/tools/workflows.md)

### New to the Project?
1. Read this README.md
2. Explore [`agent-instructions/`](agent-instructions/)
3. Check the roadmap in [`execution/ROADMAP.md`](execution/ROADMAP.md)
4. Review repository structure

---

## ✅ Checklist for Documentation Updates

Before finalizing any documentation changes:

- [ ] Information is centralized (not duplicated)
- [ ] Links work correctly
- [ ] Cross-references are valid
- [ ] Appropriate category chosen
- [ ] Indexes updated
- [ ] No throwaway docs in `docs/`
- [ ] Planning guidelines followed
- [ ] Skills inventory updated (if applicable)

---

**Last Updated:** 2026-01-03
**Purpose:** Master documentation index
**Maintained by:** All agents per update guidelines above
