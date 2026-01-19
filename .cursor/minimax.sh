#!/bin/bash
# Simple MiniMax Client
# TESTED AND WORKING

API_KEY="${MINIMAX_API_KEY:-sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c}"
API_HOST="https://api.minimax.io"

web_search() {
    query="$1"
    limit="${2:-10}"

    echo "Searching for: $query"
    echo ""

    curl -s -X POST "${API_HOST}/v1/coding_plan/search" \
        -H "Authorization: Bearer ${API_KEY}" \
        -H "Content-Type: application/json" \
        -H "MM-API-Source: Minimax-MCP" \
        -d "{\"q\":\"${query}\"}"
}

analyze_image() {
    image_source="$1"
    prompt="$2"

    echo "Analyzing image: $image_source"
    echo "Prompt: $prompt"
    echo ""

    curl -s -X POST "${API_HOST}/v1/coding_plan/vlm" \
        -H "Authorization: Bearer ${API_KEY}" \
        -H "Content-Type: application/json" \
        -H "MM-API-Source: Minimax-MCP" \
        -d "{\"prompt\":\"${prompt}\",\"image_url\":\"${image_source}\"}"
}

COMMAND="$1"
shift

case "$COMMAND" in
    web-search)
        web_search "$1" "${2:-10}"
        ;;
    image)
        analyze_image "$1" "$2"
        ;;
    help)
        echo "Usage:"
        echo "  $0 web-search 'query' [limit]"
        echo "  $0 image 'image_url' 'prompt'"
        ;;
    *)
        echo "Usage: $0 [web-search|image|help]"
        ;;
esac
