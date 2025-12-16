#!/bin/bash
## SCHEMA.md Property Name Validator
## Checks all .gd files for property names that don't match SCHEMA.md
## Usage: ./scripts/validate_schema.sh

set -e

echo "=== SCHEMA.md Property Name Validation ==="
echo ""

ERRORS=0

# Known wrong property names (SCHEMA.md violations)
WRONG_NAMES=(
    "growth_time"      # Should be: days_to_mature
    "sprites"          # Should be: growth_stages
    "items"            # Should be: ingredients (for recipes)
    "materials"        # Should be: ingredients
    "components"       # Should be: ingredients
    "time"             # Should be: crafting_time (for recipes)
    "duration"         # Should be: crafting_time
    "tasks"            # Should be: objectives (for quests)
    "goals"            # Should be: objectives
    "requirements"     # Should be: objectives
    "required_flags"   # Should be: prerequisite_flags
    "dependencies"     # Should be: prerequisite_flags
)

echo "Checking for common property name violations..."

for wrong_name in "${WRONG_NAMES[@]}"; do
    # Search in src/ and scenes/ for @export var declarations
    MATCHES=$(grep -rn "@export var $wrong_name" src/ scenes/ 2>/dev/null || true)

    if [ -n "$MATCHES" ]; then
        echo "❌ VIOLATION FOUND: @export var $wrong_name"
        echo "$MATCHES"
        echo ""
        ERRORS=$((ERRORS + 1))
    fi
done

# Check for magic numbers (hardcoded tile sizes, speeds)
echo "Checking for magic numbers..."

# Check for hardcoded tile size (should use Constants.TILE_SIZE)
TILE_HARDCODED=$(grep -rn "Vector2(16, 16)\|Vector2(32, 32)\|Vector2(64, 64)" src/ scenes/ --include="*.gd" 2>/dev/null | grep -v "Constants.gd" || true)
if [ -n "$TILE_HARDCODED" ]; then
    echo "⚠️  WARNING: Hardcoded tile sizes found (use Constants.TILE_SIZE)"
    echo "$TILE_HARDCODED"
    echo ""
fi

# Check for scene path hardcoding (should use Constants.SCENE_*)
SCENE_HARDCODED=$(grep -rn '"res://scenes/' src/ --include="*.gd" 2>/dev/null | grep -v "Constants.gd" | grep -v "# TODO" || true)
if [ -n "$SCENE_HARDCODED" ]; then
    echo "⚠️  WARNING: Hardcoded scene paths found (use Constants.SCENE_*)"
    echo "$SCENE_HARDCODED"
    echo ""
fi

echo "=== Validation Complete ==="

if [ $ERRORS -eq 0 ]; then
    echo "✅ PASS: No SCHEMA.md violations found"
    exit 0
else
    echo "❌ FAIL: $ERRORS violation(s) found"
    echo ""
    echo "Fix these violations before committing."
    echo "See SCHEMA.md for correct property names."
    exit 1
fi
