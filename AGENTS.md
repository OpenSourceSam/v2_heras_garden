# Agent Notes

- Phase 2 strict resource integrity checks skip `TEMPLATE_*.tres` entries.
- TEMPLATE resources should remain loadable and use `template_`-prefixed IDs.

## Testing (Godot 4.5.1)

### Fast, low-impact checks (preferred during iteration)
- Baseline unit checks: `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd`
- Smoke scene wiring: `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --scene res://tests/smoke_test.tscn --quit-after 30`
- Phase 3 scene-load smoke: `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --script tests/phase3_scene_load_runner.gd`

### GdUnit4 suite (avoid “slow machine” mistakes)
- Prefer a single suite run over per-file loops. Per-file loops spawn many Godot processes and will thrash CPU/GPU.
- Avoid `-d/--debug` when running GdUnit from the CLI; debug-mode + ANSI output + repeated launches can severely slow the machine.

### Hard rules
- Never run multiple Godot instances concurrently for tests.
- Always use `--quit-after` when launching a scene for smoke checks to avoid accidental “runs forever” loops.
- If the machine gets slow, immediately stop test runs and kill stray `Godot_v4.5.1-stable_win64.exe` processes before retrying.
