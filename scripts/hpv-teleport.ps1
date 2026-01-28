# HPV Teleport Helper - Context-Efficient Movement
# Use GDScript eval to teleport instead of walking (saves 100+ token calls)

param(
    [Parameter(Mandatory=$true)]
    [string]$Location
)

# Common locations mapped to coordinates
$locations = @{
    "beach"       = "Vector2(384, 1120)"
    "house"       = "Vector2(576, 544)"
    "garden"      = "Vector2(192, 416)"
    "boat"        = "Vector2(640, 320)"
    "cave"        = "Vector2(-160, 640)"
    "cliff"       = "Vector2(-640, 480)"
    "titan"       = "Vector2(-864, 576)"
    "home"        = "Vector2(384, 96)"
}

# Resolve location
$coords = if ($locations.ContainsKey($Location)) {
    $locations[$Location]
} elseif ($Location -match "^\d+,\s*\d+$") {
    "Vector2($($Location -replace ', ', ','))"
} else {
    Write-Error "Unknown location: $Location"
    Write-Host "Available locations: $($locations.Keys -join ', ')"
    exit 1
}

# Build GDScript teleport command
$teleportScript = "get_tree().root.get_child(3).get_node('Player').set_global_position($coords)"

# Execute via MCP lean
& "$PSScriptRoot/mcp-lean.ps1" "evaluate_code" "--code" $teleportScript
