
extends SceneTree

const StateQuery = preload("res://tools/testing/state_query.gd")

func _init():
	call_deferred("_run_test")

func _run_test():
	print("=== Basic AI Test ===")
	
	var day = StateQuery.get_day()
	print("Day: " + str(day))
	
	var gold = StateQuery.get_gold()
	print("Gold: " + str(gold))
	
	var inv = StateQuery.get_inventory()
	print("Inventory: " + str(inv))
	
	var summary = StateQuery.get_summary()
	print("Summary: " + str(summary))
	
	print("=== Test Complete ===")
	quit(0)
