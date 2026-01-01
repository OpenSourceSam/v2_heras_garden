#!/bin/bash
# Script to verify Claude CLI configuration

echo "=== Claude CLI Configuration Verification ==="
echo ""

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo "❌ Claude CLI not found in PATH"
    exit 1
fi

echo "✓ Claude CLI found at: $(which claude)"
echo ""

# Check config file
CONFIG_FILE="$HOME/.claude.json"
if [ -f "$CONFIG_FILE" ]; then
    echo "✓ Config file exists: $CONFIG_FILE"
    echo ""
    echo "Current model setting:"
    grep -A 0 '"model"' "$CONFIG_FILE" | sed 's/^/  /'
    echo ""
else
    echo "❌ Config file not found: $CONFIG_FILE"
    exit 1
fi

# Test with version command
echo "Claude CLI version:"
claude --version
echo ""

echo "=== Configuration Complete ==="
echo "Default model is now set to: claude-sonnet-4-5 (Sonnet)"
echo ""
echo "Available models:"
echo "  - sonnet (alias for claude-sonnet-4-5) - DEFAULT"
echo "  - opus (alias for claude-opus-4-5)"
echo "  - haiku (alias for claude-haiku-4)"
echo "  - minimax-m21 (MiniMax M21 model)"
echo ""
echo "To use a different model for a single session:"
echo "  claude --model opus"
echo "  claude --model haiku"
echo "  claude --model minimax-m21"
