#!/usr/bin/env python3
import sys
from pathlib import Path

EXPECTED_KEY = "MCPInputHandler"
EXPECTED_VALUE = "\"*res://addons/godot_mcp/mcp_input_handler.gd\""


def find_repo_root(start: Path) -> Path:
	for parent in [start] + list(start.parents):
		if (parent / "project.godot").exists():
			return parent
	return None


def parse_autoload_section(text: str) -> dict:
	entries = {}
	in_autoload = False
	for line in text.splitlines():
		stripped = line.strip()
		if stripped.startswith("[") and stripped.endswith("]"):
			in_autoload = stripped.lower() == "[autoload]"
			continue
		if not in_autoload or not stripped or stripped.startswith(";"):
			continue
		if "=" in line:
			key, value = line.split("=", 1)
			entries[key.strip()] = value.strip()
	return entries


def main() -> int:
	start = Path(__file__).resolve()
	root = find_repo_root(start)
	if root is None:
		print("ERROR: Could not locate project.godot from script path.")
		return 2

	project_file = root / "project.godot"
	text = project_file.read_text(encoding="utf-8")
	autoloads = parse_autoload_section(text)
	actual_value = autoloads.get(EXPECTED_KEY)

	if actual_value != EXPECTED_VALUE:
		print("ERROR: project.godot autoload guard failed.")
		print(f"Expected {EXPECTED_KEY}={EXPECTED_VALUE}")
		print(f"Actual   {EXPECTED_KEY}={actual_value}")
		return 1

	print("OK: project.godot autoload guard passed.")
	return 0


if __name__ == "__main__":
	sys.exit(main())
