# Circe's Garden: Playtesting Roadmap (Streamlined)

## Purpose
This file tracks what has been validated, what is still pending, and what to do next.
Detailed walkthrough steps live in the references below to avoid duplication.

## References
- docs/execution/DEVELOPMENT_ROADMAP.md
- docs/design/Storyline.md
- tests/visual/playthrough_guide.md (detailed steps)
- docs/playtesting/HPV_GUIDE.md (MCP usage)

---

## Status Summary (2026-01-17)

| Area | Status | Notes |
| --- | --- | --- |
| Quest 0 (arrival + house) | Not revalidated | House exit/return placement still needs HPV check. |
| Quests 1-3 | Shortcut coverage only | Quest wiring covered in HPV snapshot (2026-01-11); human-like run pending. |
| Quests 4-8 | Shortcut coverage only | Quest wiring covered in HPV snapshot (2026-01-11); minigames skipped. |
| Quests 9-10 | Partial HPV | Quest 10 dialogue advanced in 2026-01-17 run; full Quest 9-10 flow still pending. |
| Quest 11 + endings | Blocked in HPV | Quest 11 choices/cutscene not reached in 2026-01-17 run. |
| Prologue dialogue advance | Reported blocker | 2026-01-14 report: dialogue stuck after NEW GAME (not rechecked yet). |
| Prologue skip input | Implemented | `ui_cancel` skips the prologue cutscene for faster HPV starts. |
| Scylla world spawn | Not observed | Marker visible, NPC spawn not observed after Quest 8-10 flags. |
| World staging/spawns | Not checked | NPC spacing, spawn points, and interactable spacing need review. |

---

## Done vs Not Done

**Done (shortcut coverage)**
- Quest wiring through Quest 11 (HPV snapshot 2026-01-11; shortcuts used, minigames skipped).

**Not Done / Pending HPV**
- Human-like playthrough for Quests 1-10.
- Quest 11 choices and petrification cutscene to completion.
- Epilogue + endings + free play unlock.
- World staging and spawn placement review.
- House exit return/spawn placement check.

---

## Blockers
- Dialogue stuck after NEW GAME (reported 2026-01-14). Needs recheck.
- Quest 11 progression did not reach choices/cutscene in 2026-01-17 run.
- Quest 11 currently resolves to `quest11_inprogress` (no choices/next id), so the final confrontation dialogue and cutscene do not trigger.

---

## Next Steps (Ordered)
1. Recheck the NEW GAME dialogue advance issue.
2. Re-validate Quest 10 -> Quest 11 gating and Scylla spawn in world.
3. Continue HPV through Quest 11, epilogue, and endings.
4. Verify spawn placements and interactable spacing in world and locations.

---

## Recent HPV Coverage (2026-01-11)
The MCP/manual HPV snapshot exercised quest wiring through Quest 11 using shortcuts; minigames were skipped. This indicates Quests 1-10 have wiring coverage, but not a full human-like playthrough.

---

## HPV Session Log (2026-01-17)

**Scope:** Quest 10+ (Phase 7), teleport-assisted, minigames skipped.

**What worked:**
- Teleport + trigger calls opened Quest 10/11 dialogue quickly.
- Reading DialogueBox text confirmed progress without extra input loops.

**What did not work:**
- Prologue/cutscene advance is slow; repeated ui_accept is inefficient.
- World NPC spawn for Scylla did not appear after Quest 8-10 flags.
- Quest 11 did not surface choices or cutscene; quest_11_complete and scylla_petrified stayed false.

**Notes:**
- Quest 10 trigger dialogue appeared and advanced via ui_accept; DialogueBox closed normally.
- Quest 11 dialogue in world and Scylla's Cove advanced, but no choices/cutscene were observed.
- During Quest 11, Scylla resolves to `quest11_inprogress`, which contains no choices or next dialogue; `act3_final_confrontation` is not reached.
