# Antigravity Stability Review (Dec 2025)

## Quick Take
- The project identity is split between **Hera's Garden** and **Hera's Garden**, which creates context drift for agents and test scripts that expect different names. 【README.md†L1-L13】【PROJECT_STATUS.md†L1-L20】
- Phase 1 gameplay is still unimplemented: the player, farm plot, and NPC scripts are stubs with TODOs, so any branch that assumes movement or farming will keep breaking. 【src/entities/player.gd†L1-L59】【src/entities/farm_plot.gd†L1-L114】【src/entities/npc.gd†L1-L71】
- The validation scripts mainly check for file presence and include noisy warnings (e.g., flagging the canonical scene paths in `Constants.gd`), which can give a false sense of completion or distract from real issues. 【scripts/health_check.sh†L13-L118】【scripts/validate_schema.sh†L43-L60】

## What This Means
- When Antigravity “passes” the health and schema checks, it only proves that files exist—**not** that the required Phase 1 behaviors work. Merging those branches keeps propagating non-functional stubs.
- Context drift (Hera vs. Circe) plus permissive checks makes agents guess or improvise, which leads to divergent implementations and repeated regressions.
- Branch churn from partially implemented stubs increases the chance that later agents “fix” symptoms instead of completing the roadmap tasks.

## Recommendations
1. **Align identity first:** pick “Hera's Garden” (matches `PROJECT_STATUS.md`) and update visible entry points (README, main menu text) so every agent shares the same context before coding.
2. **Gate branches on functionality, not presence:** treat `scripts/health_check.sh` and `scripts/validate_schema.sh` as preflight only; require evidence of working movement/interaction/planting before merging (follow the templates in `DEVELOPMENT_WORKFLOW.md`).
3. **Work one roadmap subsection at a time:** implement 1.1.2 movement → commit → then 1.1.3 interaction, etc. This keeps breakage localized and makes failures traceable.
4. **Reduce validator noise:** adjust or ignore the “hardcoded scene paths” warning when it refers to `Constants.gd`, so agents don't chase false positives while the core systems are still unbuilt.
