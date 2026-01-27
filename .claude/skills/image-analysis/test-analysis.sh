#!/bin/bash
# Test script for image analysis subagent
# Usage: ./test-analysis.sh [image_path]

IMAGE_PATH="${1:-temp/screenshots/world_main_map.png}"

echo "Testing Image Analysis Subagent"
echo "================================"
echo "Image: $IMAGE_PATH"
echo ""

# Convert to absolute path if relative
if [[ "$IMAGE_PATH" != /* ]]; then
  IMAGE_PATH="$(pwd)/$IMAGE_PATH"
fi

echo "Absolute path: $IMAGE_PATH"
echo ""

# Check if file exists
if [ ! -f "$IMAGE_PATH" ]; then
  echo "ERROR: File not found: $IMAGE_PATH"
  exit 1
fi

echo "File exists. Ready for analysis."
echo ""
echo "To analyze this image, use:"
echo ""
echo "mcp__4_5v_mcp__analyze_image \\"
echo "  --imageSource \"$IMAGE_PATH\" \\"
echo "  --prompt \"Analyze this game screenshot for visual quality. Check for: blocky backgrounds, tiling seams, sprite transparency issues, pixel art scaling problems, overall Harvest Moon SNES readability. Provide specific, actionable feedback.\""
echo ""
echo "Or invoke the skill:"
echo ""
echo "/skill image-analysis"
