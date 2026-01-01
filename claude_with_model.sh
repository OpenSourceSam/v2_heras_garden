#!/bin/bash
# Helper script to easily start Claude CLI with different models

show_usage() {
    echo "Usage: $0 [MODEL]"
    echo ""
    echo "Available models:"
    echo "  sonnet     - Claude Sonnet 4.5 (DEFAULT)"
    echo "  opus       - Claude Opus 4.5"
    echo "  haiku      - Claude Haiku 4"
    echo "  minimax    - MiniMax M21"
    echo ""
    echo "Examples:"
    echo "  $0              # Uses default model (sonnet)"
    echo "  $0 minimax      # Starts Claude with MiniMax M21"
    echo "  $0 opus         # Starts Claude with Opus"
    exit 1
}

# Parse arguments
MODEL=""
if [ $# -eq 0 ]; then
    # No arguments, use default from config
    echo "Starting Claude CLI with default model (sonnet)..."
    exec claude
elif [ $# -eq 1 ]; then
    case "$1" in
        sonnet)
            MODEL="claude-sonnet-4-5"
            ;;
        opus)
            MODEL="claude-opus-4-5"
            ;;
        haiku)
            MODEL="claude-haiku-4"
            ;;
        minimax)
            MODEL="minimax-m21"
            ;;
        -h|--help)
            show_usage
            ;;
        *)
            # Allow direct model names too
            MODEL="$1"
            ;;
    esac

    echo "Starting Claude CLI with model: $MODEL..."
    exec claude --model "$MODEL"
else
    echo "Error: Too many arguments"
    show_usage
fi
