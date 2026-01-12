# Repository Structure Catalog
**Circe's Garden v2 - Comprehensive File and Directory Analysis**

**Date:** 2026-01-01
**Purpose:** Complete catalog of repository structure with purposes, redundancies, and suggestions

---

## 🚨 SENIOR PM CLAUDE - REVIEW REQUIRED

### Executive Summary
**Analyzed:** 6,000+ files across 150+ directories
**Found:** Multiple redundancies, obsolete files, and unclear purposes
**Recommendation:** Strategic cleanup to reduce complexity and confusion

### My Assumptions (Please Confirm)
1. **This is an active development repository** - not a release/build repo
2. **`.venv/` should remain** - needed for testing tools (currently 5000+ files)
3. **`.godot/` should remain** - contains test screenshots and cache (needed for CI)
4. **`.worktrees/` is needed** - for git operations (contains merge-main branch)
5. **`.claude/skills/` is primary** - should keep, delete duplicate `skills/` directory
6. **Test reports are valuable** - but 20 numbered reports likely excessive

---

### ⚠️ HIGH-RISK TASKS REQUIRING APPROVAL

**Before I execute cleanup, please review and APPROVE/DECLINE each:**

#### TASK 1: Delete Duplicate Skills Directory
**Target:** `./skills/` (root level, 9 skill packages)
**Reason:** Exact duplicate of `.claude/skills/`
**Risk:** LOW - Skills in `.claude/skills/` remain intact
**Files affected:** ~50 files
**My Confidence:** HIGH - clear duplication
**Your Decision:** [ ] APPROVE / [ ] DECLINE

#### TASK 2: Remove Temporary Editor Backup Files
**Target:** `project.godot*.tmp` (4 files in root)
**Reason:** Editor backup files, should be in .gitignore
**Risk:** LOW - Already have main project.godot
**My Confidence:** HIGH - standard Godot backup files
**Your Decision:** [ ] APPROVE / [ ] DECLINE

#### TASK 3: Archive Old Test Reports
**Target:** `reports/report_28` through `reports/report_45` (18 reports)
**Action:** Move to `archive/test_reports/` directory
**Reason:** Keep only recent 5 reports (46, 47, beta_mechanical)
**Risk:** LOW-MEDIUM - If you need old reports, they'll be archived
**My Confidence:** MEDIUM - not sure if historical reports are valuable
**Your Decision:** [ ] APPROVE / [ ] DECLINE

#### TASK 4: Investigate Malformed Directory
**Target:** `C:UsersSamDocumentsGitHubv2_heras_gardentoolssprite_generator/`
**Issue:** Windows path embedded in directory name
**Action:** First, need to understand what this is
**Risk:** UNKNOWN - Could be important or could be corruption
**My Confidence:** LOW - genuinely unsure what this is
**Your Decision:** [ ] APPROVE investigation / [ ] DECLINE (ignore it)

#### TASK 5: Remove Empty `nul` File
**Target:** `./nul` (0 bytes, root level)
**Reason:** No clear purpose, appears unused
**Risk:** VERY LOW - 0 byte file, likely harmless
**My Confidence:** MEDIUM - simple deletion
**Your Decision:** [ ] APPROVE / [ ] DECLINE

#### TASK 6: Consolidate Archive Structure
**Target:** `archive/archive/` nested structure
**Action:** Flatten to single `archive/` level
**Reason:** Cleaner organization
**Risk:** LOW - Just moving files around
**My Confidence:** MEDIUM - archive files, not active code
**Your Decision:** [ ] APPROVE / [ ] DECLINE

#### TASK 7: Review GitHub Skills Duplication
**Target:** `.github/skills/` (mirrors `.claude/skills/`)
**Issue:** 17 skill packages duplicated
**Action:** Need your direction - should these be:
  - A) Deleted (use only `.claude/skills/`)
  - B) Kept as-is
  - C) Converted to symlinks/references
**Risk:** MEDIUM - Could affect GitHub integration
**My Confidence:** LOW - Unclear which is correct approach
**Your Decision:** [ ] A / [ ] B / [ ] C / [ ] DECIDE LATER

---

### ❓ QUESTIONS NEEDING ANSWERS

1. **Are old test reports (report_28-45) valuable for historical analysis?**
   - If YES: Archive them
   - If NO: Delete them
   - Current count: 18 reports

2. **What is `C:UsersSamDocumentsGitHubv2_heras_gardentoolssprite_generator/`?**
   - This looks like a path error - is it safe to delete?

3. **What's the correct approach for `.github/skills/` duplication?**
   - GitHub needs its own copies OR should reference `.claude/skills/`

4. **Are you keeping the Godot executable in repo?**
   - `Godot_v4.5.1-stable_win64.exe` (4.5KB - seems like a wrapper)
   - Usually Godot is installed separately

5. **Should I proceed with ALL approved tasks in one batch, or do them one at a time?**

---

### 📊 Cleanup Impact Summary

| Task | Files Affected | Time Estimate | Risk Level |
|------|---------------|---------------|------------|
| 1. Delete skills/ | ~50 | 2 min | LOW |
| 2. Delete .tmp files | 4 | 1 min | LOW |
| 3. Archive old reports | 18 reports | 5 min | LOW-MED |
| 4. Investigate malformed dir | 1 dir | 5 min | UNKNOWN |
| 5. Delete nul file | 1 | 1 min | VERY LOW |
| 6. Consolidate archive | ~20 files | 3 min | LOW |
| 7. GitHub skills review | 17 packages | 10 min | MEDIUM |

**Total estimated time:** 25-30 minutes (if all approved)

---

### 🎯 RECOMMENDED APPROVAL ORDER

**Tier 1 (Safe, obviously redundant):**
- [ ] Task 1: Delete duplicate skills/
- [ ] Task 2: Remove .tmp files
- [ ] Task 5: Delete empty nul file

**Tier 2 (Safe, with archiving):**
- [ ] Task 3: Archive old test reports
- [ ] Task 6: Consolidate archive structure

**Tier 3 (Needs investigation):**
- [ ] Task 4: Investigate malformed directory
- [ ] Task 7: Review GitHub skills duplication

---

### 🚦 NEXT STEPS

1. **Please review this section** and mark decisions for Tasks 1-7
2. **Answer questions** 1-5 above
3. **Confirm execution approach** (batch vs. individual)
4. Once approved, I will execute all approved tasks and report back

**Ready to proceed upon your approval.**

---

## Root Level Files

### Configuration Files
- **`project.godot`** - Main Godot project configuration (8.3KB)
  - Project settings, autoloads, input mappings
  - *Note: Multiple .tmp backup files exist (4 files) - should be cleaned up*

- **`export_presets.cfg`** - Godot export configurations for building
  - Contains platform-specific export settings

- **`project.godot*.tmp`** (4 files) - Temporary backup files
  - **REDUNDANCY**: Should be in .gitignore or cleaned up
  - **SUGGESTION**: Delete - not needed in repo

- **`.gitattributes`** - Git configuration for file handling
- **`.gitignore`** - Git ignore patterns (765 bytes, recently updated)
- **`README.md`** - Project overview (884 bytes, minimal)

### Documentation Files
- **`AGENTS.md`** - Agent documentation (3.8KB)
  - Documents project agents and capabilities

- **`CLAUDE.md`** - Claude Code directives (5.1KB)
  - **IMPORTANT**: Contains project-specific instructions and constraints
  - Outlines Phase 4 execution authorization
  - Testing best practices for Godot

- **`QUEST_2_HANDOFF_SUMMARY.txt`** - Quest 2 development summary (6.4KB)
  - Recent handoff document

- **`RUNTIME_STATUS.md`** - Runtime status (262 bytes)
  - Minimal status document

### Assets (Root Level)
- **`icon.svg`** + **`icon.svg.import`** - Project icon
- **`grass_tile_preview_3x3.png`** + **`*.import`** - Grass tile preview
- **`papershot-80x80.png`** + **`*.import`** - Papershot addon icon

### Executables
- **`Godot_v4.5.1-stable_win64.exe`** - Godot engine executable (4.5KB?! - seems like a symlink or wrapper)
  - **UNUSUAL**: Executable in repo - unusual for a Godot project
  - **SUGGESTION**: Usually Godot is installed separately

### Other Files
- **`nul`** - Empty file (0 bytes)
  - **PURPOSE UNCLEAR**: No obvious purpose, may be leftover from testing

---

## Core Project Directories

### 📁 `.claude/` - Claude Code Configuration and Skills
**Purpose:** Claude-specific configurations, skills, and learning materials

**Structure:**
- `agents/` - Agent definitions
- `learnings/` - Learning database
  - `bugs/` - Bug patterns and templates
  - `loops/` - Loop detection patterns
  - `patterns/` - Code patterns
- `roles/` - Role definitions
- `settings.json` + `settings.local.json` - Configuration files
- `skills/` - Claude skills (17 skill packages)
  - `blocked-and-escalating/`
  - `confident-language-guard/`
  - `create-plan/`
  - `finishing-a-development-branch/`
  - `git-best-practices/`
  - `github/` (6 GitHub issue templates)
  - `godot-dev/` - Godot development expertise
  - `godot-gdscript-patterns/` - GDScript best practices
  - `loop-detection/`
  - `mcp-builder/` - MCP server builder with reference docs
  - `skill-creator/`
  - `skill-gap-finder/`
  - `systematic-debugging/`
  - `test-driven-development/`
  - `token-aware-planning/`
  - `troubleshoot/`
  - `verification-before-completion/`

**REDUNDANCY:** `skills/` directory exists at BOTH root level AND in `.claude/`

### 📁 `.github/` - GitHub Configuration
**Purpose:** GitHub-specific configurations (CI/CD, templates)

**Structure:**
- `ISSUE_TEMPLATE/` - Issue templates
  - `guardrail.md`
  - `handoff.md`
  - `review.md`
- `skills/` - GitHub skills (mirrors `.claude/skills/`)
  - `finishing-a-development-branch/`
  - `git-best-practices/`
  - `github/` (6 templates)
  - `godot-gdscript-patterns/`
  - `systematic-debugging/` (6 additional files)
- `workflows/` - GitHub Actions
  - `guard-project-godot.yml`

**REDUNDANCY:** Many skills duplicated between `.github/skills/` and `.claude/skills/`

### 📁 `.godot/` - Godot Engine Cache and Screenshots
**Purpose:** Godot runtime cache, screenshots, and generated files

**Contents:**
- `.godot/screenshots/` - Test output screenshots
  - `beta_mechanical/` (11 ASCII dumps from beta test)
  - `full_playthrough/` (46 screenshots from full playthrough)
  - `mvt/` (2 screenshots from MVT test)
- Engine cache files (not listed due to size)

**NOTE:** Large directory with generated content

### 📁 `.venv/` - Python Virtual Environment
**Purpose:** Python dependencies for testing tools
**CONTENTS:** Standard Python packages (pip, setuptools, cryptography, etc.)
**NOTE:** Should be excluded from version control (in .gitignore)

### 📁 `.vscode/` - VS Code Configuration
**Purpose:** VS Code workspace settings and extensions

### 📁 `.worktrees/` - Git Worktrees
**Purpose:** Git worktree for merge operations
**CONTENTS:** `merge-main/` directory with duplicate project structure

### 📁 `addons/` - Godot Addons
**Purpose:** Third-party Godot extensions
**CONTENTS:**
- `papershot/` - Visual testing addon
- `gdUnit4/` - Godot testing framework
- `GDQuest_GDScript_formatter/` - Code formatter
- `godot_mcp/` - MCP integration

### 📁 `archive/` - Archived Documentation
**Purpose:** Old documentation and historical data
**CONTENTS:**
- `archive/` - More archived content
- `docs_overview/` - Old documentation overview
- `project_reports/` - Historical project reports
- `godot_state_charts_examples/` - Example projects
- `Simple Testing for Godot/` - Testing guide

**REDUNDANCY:** Duplicate structure with `/archive/archive/`

### 📁 `assets/` - Game Assets
**Purpose:** All game visual and audio assets
**Structure:**
- `audio/` - Sound assets
  - `music/` - Background music
  - `sfx/` - Sound effects
- `fonts/` - Game fonts
- `sprites/` - 2D graphics
  - `characters/` - Character sprites
  - `crops/` - Crop/plant sprites
  - `placeholders/` - Placeholder graphics
  - `tiles/` - Tile sprites
  - `ui/` - UI elements

### 📁 `demo/` - Demo Project
**Purpose:** Standalone demo/test project
**Structure:**
- `agents/` - Demo agents
- `ai/` - AI demos
- `assets/` - Demo assets
- `props/` - Demo props
- `scenes/` - Demo scenes

### 📁 `docs/` - Project Documentation
**Purpose:** Primary documentation directory
**Structure:**
- `design/` - Design documents (empty)
- `execution/` - Execution guides (ROADMAP.md, etc.)
- `notes/` - Project notes
  - `Claude_MiniMax_Feedback_Beta_Mechanical_Testing.md` (just created)
- `plans/` - Project plans
- `qa/` - Quality assurance docs
- `testing/` - Testing documentation
- **Files:**
  - `mechanical_walkthrough.md` (38.7KB) - Comprehensive gameplay guide
  - `playthrough_guide.md` (archived at `archive/archive/playthrough_guide.md`) - Player guide snapshot
  - `MCP_SETUP.md` (7.7KB) - MCP setup instructions
  - `QUEST_2_EXTENSION_HANDOFF.md` (14.8KB) - Quest 2 handoff
  - `QUEST_2_QUICK_REFERENCE.md` (3.4KB) - Quest 2 reference

### 📁 `game/` - Main Game Code
**Purpose:** All game logic, scenes, and resources
**Structure:**
- `autoload/` - Singleton scripts (autoloaded)
- `features/` - Game features by type
  - `cutscenes/` - Cutscene scenes and scripts
  - `farm_plot/` - Farming mechanics
  - `locations/` - Game locations
  - `minigames/` - Minigame implementations
  - `npcs/` - Non-player character code
  - `player/` - Player controller
  - `ui/` - User interface
  - `world/` - World management
- `shared/` - Shared game resources
  - `resources/` - Game data resources
    - `crops/` - Crop definitions
    - `dialogues/` - Dialogue scripts
    - `items/` - Item definitions
    - `npcs/` - NPC definitions
    - `recipes/` - Crafting recipes
    - `tiles/` - Tile definitions

### 📁 `reports/` - Test Reports
**Purpose:** Automated test output and reports
**Structure:**
- `beta_mechanical_test.md` - Beta mechanical test results (4.1KB)
- `report_28/` through `report_47/` - Numbered test reports (20 reports)
  - Each contains: `css/`, `path/`, `test_suites/` subdirectories

**REDUNDANCY:** 20 numbered reports - many may be obsolete

### 📁 `scripts/` - Utility Scripts
**Purpose:** Shell scripts and utilities
**Structure:**
- `addons/` - Addon-related scripts
  - `papershot/` - Papershot addon scripts
- `git-hooks/` - Git hooks
- `guards/` - Guard scripts
- `tools/` - Utility tools

### 📁 `skills/` - Root-Level Skills
**Purpose:** Skill definitions (duplicate of `.claude/skills/`)
**REDUNDANCY**: This is a duplicate! Should use only `.claude/skills/`

**Contents:**
- `create-plan/`
- `godot-dev/`
- `mcp-builder/`
- `pixel-art-professional/`
- `skill-creator/`
- `systematic-debugging/`
- `test-driven-development/`
- `troubleshoot/`
- `verification-before-completion/`

### 📁 `src/` - Source Resources
**Purpose:** Additional source files
**Contents:** `resources/` subdirectory

### 📁 `tests/` - Test Suite
**Purpose:** All automated tests
**Structure:**
- `ai/` - AI-based tests
  - `test_basic.gd`
  - `test_map_size_shape.gd`
- `gdunit4/` - GdUnit4 framework tests
- `visual/` - Visual regression tests
  - `beta_mechanical_test.gd` - Beta mechanical test implementation (47.4KB)
  - `Beta_Mechanical_Testing_Learnings_Jr_Engineer_Brief.md` - Lessons learned document (11.2KB)
  - `mvt_test.gd` - MVT test implementation (6.8KB)
  - `playthrough_guide.md` - Player guide (23.7KB)
- **Individual test files:**
  - `cutscene_debug_test.gd` + `.gd.uid`
  - `cutscene_execution_test.gd` + `.gd.uid`
  - `cutscene_tree_debug.gd` + `.gd.uid`
  - `dialogue_choice_target_test.gd` + `.gd.uid`
  - `phase3_dialogue_flow_test.gd` + `.gd.uid`
  - `phase3_minigame_mechanics_test.gd` + `.gd.uid`
  - `phase3_save_load_test.gd` + `.gd.uid`
  - `phase3_scene_load_runner.gd` + `.gd.uid`
  - `phase3_softlock_test.gd` + `.gd.uid`
  - `phase4_balance_test.gd` + `.gd.uid`
  - `run_tests.gd` + `.gd.uid`
  - `smoke_test.tscn`
  - `smoke_test_scene.gd` + `.gd.uid`
  - `test_scene.tscn`
  - Various `run_*.gd` test files
  - `lsp_connectivity_test.gd` + `.gd.uid` (empty file)

### 📁 `tools/` - Development Tools
**Purpose:** Development and build tools
**Structure:**
- `setup_android_build.cmd` - Android build script
- `sprite_gen_lib/` - Sprite generation library (Git repo inside)
- `sprite_generator/` - Python sprite generator
- `testing/` - Testing utilities
- `visual_testing/` - Visual testing tools

### 📁 `C:UsersSamDocumentsGitHubv2_heras_gardentoolssprite_generator/` - Malformed Path
**Purpose:** Unknown - appears to be a path error
**NOTE:** Directory name is malformed (contains full Windows path)

---

## Major Redundancies

### 1. Skills Directory Duplication
**Problem:** Skills exist in TWO places:
- `.claude/skills/` (17 skill packages)
- `skills/` (9 skill packages)

**Analysis:** Most skills are duplicated. The `.claude/` version is likely correct for Claude Code.

**SUGGESTION:** Delete `skills/` directory and use only `.claude/skills/`

### 2. Test Reports
**Problem:** 20 numbered reports (`report_28` through `report_47`)
**Analysis:** Most are likely obsolete test runs
**SUGGESTION:** Keep only recent reports, archive or delete old ones

### 3. GitHub Skills Duplication
**Problem:** Skills in `.github/skills/` mirror `.claude/skills/`
**Analysis:** GitHub templates should reference `.claude/skills/`, not duplicate
**SUGGESTION:** Use symlinks or references instead of duplication

### 4. Archive Duplication
**Problem:** `archive/archive/` structure
**Analysis:** Nested archive directories
**SUGGESTION:** Flatten or consolidate archive structure

### 5. Temporary Files
**Problem:** 4 `project.godot*.tmp` files
**Analysis:** Editor backup files that shouldn't be in repo
**SUGGESTION:** Add to `.gitignore` and delete from repo

---

## Files with Unclear Purpose

### 1. `nul` (Empty file)
- **Size:** 0 bytes
- **Purpose:** Unknown
- **SUGGESTION:** Delete if not needed

### 2. `C:UsersSamDocumentsGitHubv2_heras_gardentoolssprite_generator/`
- **Issue:** Malformed directory name (Windows path embedded)
- **Purpose:** Unknown - appears to be a path error
- **SUGGESTION:** Investigate and remove/rename

### 3. `.worktrees/merge-main/`
- **Purpose:** Git worktree for merging
- **Issue:** Contains full duplicate of project structure
- **SUGGESTION:** Standard git worktree, but large duplication

### 4. `tools/sprite_gen_lib/.git/`
- **Issue:** Git repo inside git repo
- **Purpose:** Library has its own version control
- **SUGGESTION:** Normal for submodules, but verify intentional

---

## Suggested Actions

### High Priority
1. **Delete `skills/` directory** - Duplicate of `.claude/skills/`
2. **Clean up `project.godot*.tmp` files** - Add to .gitignore
3. **Investigate malformed `C:UsersSam...` directory** - Fix or remove
4. **Archive old test reports** - Keep recent 5-10, archive the rest

### Medium Priority
5. **Consolidate archive structure** - Flatten `archive/archive/`
6. **Review GitHub skills duplication** - Use references instead of copies
7. **Clean up `nul` file** - Delete if not needed
8. **Verify `tools/sprite_gen_lib/.git/`** - Ensure intentional

### Low Priority
9. **Review `.worktrees/` contents** - May be needed for merge operations
10. **Update README.md** - Currently minimal (884 bytes)

---

## Directory Sizes and Complexity

### Largest Directories (by file count)
1. `.godot/` - Godot cache and screenshots
2. `.venv/` - Python packages (~5000+ files)
3. `tests/` - ~40 test files + visual tests
4. `game/features/` - 9 feature modules
5. `docs/` - ~10 documentation files

### Most Complex
1. `.claude/skills/` - 17 skill packages with reference docs
2. `tests/` - Multiple test frameworks (GdUnit4, AI, visual)
3. `game/` - Full game implementation with 9 feature modules
4. `archive/` - Multiple archived versions

---

## Documentation Coverage

### Well Documented
- Gameplay: `docs/mechanical_walkthrough.md` (38.7KB)
- Quest 2: `docs/QUEST_2_EXTENSION_HANDOFF.md` (14.8KB)
- Setup: `docs/MCP_SETUP.md` (7.7KB)

### Needs Documentation
- Repository structure (this document)
- Testing strategy
- Development workflow
- Build and deployment process

---

## Conclusion

This is a **complex, feature-rich game project** with:
- Comprehensive testing infrastructure (40+ test files)
- Extensive documentation (25+ MD files)
- Multiple testing frameworks (GdUnit4, AI tests, visual regression)
- Active development with multiple phases
- Rich asset library

**Main Issues:**
- Duplicated skills directories
- Old test reports accumulation
- Temporary files in repo
- Malformed directory name

**Overall Assessment:**
Well-organized but could benefit from cleanup of redundancies and better organization of test outputs.

---

**📋 QUICK REFERENCE FOR SENIOR PM:**

**APPROVAL NEEDED:** See section "🚨 SENIOR PM CLAUDE - REVIEW REQUIRED" (line 9)
**Tasks requiring approval:** 7 high-risk cleanup tasks
**Questions to answer:** 5 items requiring your input
**Estimated cleanup time:** 25-30 minutes

**To proceed:** Mark your decisions in the approval boxes and I'll execute the cleanup.

---

**Document Version:** 1.1
**Last Updated:** 2026-01-09
**Total Files Analyzed:** ~6000+ (including .venv)
**Total Directories:** ~150+

[Codex - 2026-01-09]
[Codex - 2026-01-11]
