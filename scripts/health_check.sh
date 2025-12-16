#!/bin/bash
## System Health Check
## Verifies all autoloads, resources, and critical files exist
## Usage: ./scripts/health_check.sh

set -e

echo "=== System Health Check ==="
echo ""

ERRORS=0

# Check autoloads
echo "[1/5] Checking autoloads..."
AUTOLOADS=(
    "src/autoloads/game_state.gd"
    "src/autoloads/audio_controller.gd"
    "src/autoloads/save_controller.gd"
    "src/autoloads/scene_manager.gd"
)

for autoload in "${AUTOLOADS[@]}"; do
    if [ ! -f "$autoload" ]; then
        echo "❌ MISSING: $autoload"
        ERRORS=$((ERRORS + 1))
    else
        echo "✅ $autoload"
    fi
done

# Check resource classes
echo ""
echo "[2/5] Checking resource classes..."
RESOURCES=(
    "src/resources/crop_data.gd"
    "src/resources/item_data.gd"
    "src/resources/dialogue_data.gd"
    "src/resources/npc_data.gd"
    "src/resources/recipe_data.gd"
    "src/resources/quest_data.gd"
)

for resource in "${RESOURCES[@]}"; do
    if [ ! -f "$resource" ]; then
        echo "❌ MISSING: $resource"
        ERRORS=$((ERRORS + 1))
    else
        # Check for class_name declaration
        if grep -q "class_name" "$resource"; then
            echo "✅ $resource"
        else
            echo "⚠️  WARNING: $resource missing class_name declaration"
        fi
    fi
done

# Check critical scenes
echo ""
echo "[3/5] Checking critical scenes..."
SCENES=(
    "scenes/ui/main_menu.tscn"
    "scenes/ui/debug_hud.tscn"
    "scenes/ui/day_indicator.tscn"
    "scenes/world.tscn"
)

for scene in "${SCENES[@]}"; do
    if [ ! -f "$scene" ]; then
        echo "❌ MISSING: $scene"
        ERRORS=$((ERRORS + 1))
    else
        echo "✅ $scene"
    fi
done

# Check constants file
echo ""
echo "[4/5] Checking Constants.gd..."
if [ ! -f "src/core/constants.gd" ]; then
    echo "❌ MISSING: src/core/constants.gd"
    ERRORS=$((ERRORS + 1))
else
    # Verify critical constants exist
    CRITICAL_CONSTANTS=(
        "TILE_SIZE"
        "PLAYER_SPEED"
        "SCENE_MAIN_MENU"
        "SCENE_WORLD"
    )

    for const in "${CRITICAL_CONSTANTS[@]}"; do
        if grep -q "const $const" src/core/constants.gd; then
            echo "✅ Constants.$const defined"
        else
            echo "❌ MISSING: Constants.$const"
            ERRORS=$((ERRORS + 1))
        fi
    done
fi

# Check documentation
echo ""
echo "[5/5] Checking documentation..."
DOCS=(
    "SCHEMA.md"
    "DEVELOPMENT_ROADMAP.md"
    "AGENT_PROTOCOL.md"
    "ANTIGRAVITY_FEEDBACK.md"
)

for doc in "${DOCS[@]}"; do
    if [ ! -f "$doc" ]; then
        echo "❌ MISSING: $doc"
        ERRORS=$((ERRORS + 1))
    else
        echo "✅ $doc"
    fi
done

echo ""
echo "=== Health Check Complete ==="

if [ $ERRORS -eq 0 ]; then
    echo "✅ PASS: All systems healthy"
    exit 0
else
    echo "❌ FAIL: $ERRORS error(s) found"
    echo ""
    echo "Fix missing files before continuing."
    exit 1
fi
