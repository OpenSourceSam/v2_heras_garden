#!/usr/bin/env -S "godot" --headless --script
## Quick verification test for new scenes created in gameplay buildout

extends SceneTree

func _init() -> void:
	print("=== NEW SCENES VERIFICATION ===")

	var test_scenes = [
		"res://game/features/npcs/circe.tscn",
		"res://game/features/locations/aiaia_shore.tscn",
		"res://game/features/cutscenes/sailing_first.tscn",
		"res://game/features/cutscenes/sailing_final.tscn",
		"res://game/features/cutscenes/calming_draught_failed.tscn",
		"res://game/features/cutscenes/reversal_elixir_failed.tscn",
		"res://game/features/cutscenes/binding_ward_failed.tscn",
		"res://game/features/cutscenes/epilogue.tscn",
		"res://game/features/locations/titan_battlefield.tscn",
		"res://game/features/locations/daedalus_workshop.tscn",
	]

	var passed = 0
	var failed = 0

	for scene_path in test_scenes:
		if ResourceLoader.exists(scene_path):
			var result = load(scene_path)
			if result and result is PackedScene:
				print("[PASS] Scene loads: %s" % scene_path)
				passed += 1
			else:
				print("[FAIL] Scene not PackedScene: %s" % scene_path)
				failed += 1
		else:
			print("[FAIL] Scene not found: %s" % scene_path)
			failed += 1

	# Check constants are defined
	if Constants.SCENE_SHORE == "res://game/features/locations/aiaia_shore.tscn":
		print("[PASS] Constants.SCENE_SHORE defined")
		passed += 1
	else:
		print("[FAIL] Constants.SCENE_SHORE incorrect")
		failed += 1

	if Constants.SCENE_TITAN_BATTLEFIELD == "res://game/features/locations/titan_battlefield.tscn":
		print("[PASS] Constants.SCENE_TITAN_BATTLEFIELD defined")
		passed += 1
	else:
		print("[FAIL] Constants.SCENE_TITAN_BATTLEFIELD incorrect")
		failed += 1

	if Constants.SCENE_DAEDALUS_WORKSHOP == "res://game/features/locations/daedalus_workshop.tscn":
		print("[PASS] Constants.SCENE_DAEDALUS_WORKSHOP defined")
		passed += 1
	else:
		print("[FAIL] Constants.SCENE_DAEDALUS_WORKSHOP incorrect")
		failed += 1

	print("\n=== SUMMARY ===")
	print("Passed: %d" % passed)
	print("Failed: %d" % failed)

	if failed == 0:
		print("[OK] ALL NEW SCENES VERIFIED")
		quit(0)
	else:
		print("[ERROR] SOME SCENES FAILED")
		quit(1)
