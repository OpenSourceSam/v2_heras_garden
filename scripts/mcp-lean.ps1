# MCP Lean Commands for HPV (Context-Efficient)
# Use this instead of mcp-wrapper.ps1 for long HPV sessions
# Minimizes token usage by suppressing verbose output

param(
    [Parameter(Mandatory=$true)]
    [string]$Command,
    [string[]$Args
)

# Suppress context safety hooks message
$env:CONTEXT_SAFETY_QUIET = "1"

# Map short commands to full MCP commands
$commandMap = @{
    "tap"      = "simulate_action_tap"
    "move"     = "simulate_direction"
    "scene"    = "get_runtime_scene_structure"
    "vars"     = "get_global_variables"
    "eval"     = "evaluate_code"
    "tp"       = "evaluate_code"  # Teleport helper
}

# Resolve command alias
$mcpCommand = if ($commandMap.ContainsKey($Command)) {
    $commandMap[$Command]
} else {
    $Command
}

# Build argument string
if ($Args) {
    $mcpCommand = "$mcpCommand $($Args -join ' ')"
}

# Execute with minimal output (quiet mode by default)
$fullCommand = "npx -y godot-mcp-cli@latest $mcpCommand 2>&1"

# Suppress npx progress output
$env:NPM_CONFIG_PROGRESS = "false"
$env:NPM_CONFIG_SILENT = "true"

# Execute and return ONLY the essential output
$output = Invoke-Expression -Command $fullCommand 2>&1 | Where-Object {
    $_ -notmatch "npm WARN" -and
    $_ -notmatch "trying to" -and
    $_ -notmatch "downloaded" -and
    $_ -notmatch "^$" -and
    $_ -notmatch "Looking up" -and
    $_ -notmatch "http fetch"
}

# Return output without extra formatting
$output
