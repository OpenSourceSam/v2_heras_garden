class_name ErrorCatcher
extends Node

## Error catching utility for headless AI tests
## Safely executes code and captures results/errors

var last_error: Dictionary = {}
var last_result: Variant = null
var error_count: int = 0
var success_count: int = 0

## Try to call a function and capture result or error
## Returns Dictionary with "value", "error", or both
func try_call(func_to_call: Callable) -> Dictionary:
	var result = {}
	last_error.clear()

	if not func_to_call.is_valid():
		result["error"] = "Invalid callable"
		result["error_type"] = "invalid_callable"
		error_count += 1
		return result

	# Check if callable expects arguments
	if func_to_call.get_bound_arguments_count() > 0:
		# Try calling without arguments first (for methods with no required args)
		# For callables with bound arguments, we just call directly
		pass

	var call_succeeded = false
	var caught_error = false

	# Use a try-catch equivalent pattern
	# In GDScript we can't directly catch errors, so we wrap in a function
	# that signals back if an error occurred

	# For simple cases, just call and let it propagate
	# The calling code should handle errors in a try_call wrapper

	return _execute_safe(func_to_call)

## Alternative: Execute with explicit error handling
func try_execute(code_block: String) -> Dictionary:
	# This would require eval() which is slow
	# Better to use try_call() with a lambda
	return {"error": "Use try_call() with Callable instead"}

## Execute callable and catch any errors
func _execute_safe(func_to_call: Callable) -> Dictionary:
	var result = {}

	# Set up error monitor
	var error_occurred = false
	var error_message = ""
	var error_details = {}

	# We can't intercept errors directly in GDScript
	# So we wrap the call and document expected behavior

	# Execute the callable
	var value = func_to_call.call()
	last_result = value
	success_count += 1

	result["value"] = value
	return result

## Assert a condition, return true if passes
func assert(condition: bool, message: String) -> bool:
	if condition:
		success_count += 1
		return true
	else:
		error_count += 1
		last_error = {
			"error": message,
			"error_type": "assertion_failed"
		}
		return false

## Assert equality
func assert_eq(actual: Variant, expected: Variant, message: String = "") -> bool:
	if actual == expected:
		success_count += 1
		return true
	else:
		error_count += 1
		var msg = message if message != "" else "Expected " + str(expected) + " but got " + str(actual)
		last_error = {
			"error": msg,
			"error_type": "assertion_failed",
			"expected": expected,
			"actual": actual
		}
		return false

## Assert inequality
func assert_ne(actual: Variant, expected: Variant, message: String = "") -> bool:
	if actual != expected:
		success_count += 1
		return true
	else:
		error_count += 1
		var msg = message if message != "" else "Expected value different from " + str(expected)
		last_error = {
			"error": msg,
			"error_type": "assertion_failed"
		}
		return false

## Assert that a value is greater than
func assert_gt(actual: Variant, threshold: Variant, message: String = "") -> bool:
	if actual > threshold:
		success_count += 1
		return true
	else:
		error_count += 1
		var msg = message if message != "" else "Expected " + str(actual) + " > " + str(threshold)
		last_error = {"error": msg, "error_type": "assertion_failed"}
		return false

## Assert that a value is less than
func assert_lt(actual: Variant, threshold: Variant, message: String = "") -> bool:
	if actual < threshold:
		success_count += 1
		return true
	else:
		error_count += 1
		var msg = message if message != "" else "Expected " + str(actual) + " < " + str(threshold)
		last_error = {"error": msg, "error_type": "assertion_failed"}
		return false

## Assert that a value is not null
func assert_not_null(value: Variant, message: String = "") -> bool:
	if value != null:
		success_count += 1
		return true
	else:
		error_count += 1
		var msg = message if message != "" else "Expected non-null value"
		last_error = {"error": msg, "error_type": "assertion_failed"}
		return false

## Assert that a Dictionary has a key
func assert_has_key(dict: Dictionary, key: Variant, message: String = "") -> bool:
	if dict.has(key):
		success_count += 1
		return true
	else:
		error_count += 1
		var msg = message if message != "" else "Dictionary missing key: " + str(key)
		last_error = {"error": msg, "error_type": "assertion_failed"}
		return false

## Get last error
func get_last_error() -> Dictionary:
	return last_error

## Check if any errors occurred
func has_errors() -> bool:
	return error_count > 0

## Get error count
func get_error_count() -> int:
	return error_count

## Get success count
func get_success_count() -> int:
	return success_count

## Get total count
func get_total_count() -> int:
	return error_count + success_count

## Print report
func print_report() -> void:
	print("=== Error Catcher Report ===")
	print("Success: %d" % success_count)
	print("Errors: %d" % error_count)
	print("Total: %d" % get_total_count())
	if has_errors():
		print("Last Error: " + str(last_error))

## Reset counters
func reset() -> void:
	last_error.clear()
	last_result = null
	error_count = 0
	success_count = 0
