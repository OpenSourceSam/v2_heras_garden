param(
  [switch]$JSON,
  [switch]$Quiet
)

$ErrorActionPreference = 'SilentlyContinue'

# Result object
$result = @{
  status = 'healthy'
  godot_running = $false
  mcp_port_listening = $false
  mcp_cli_responsive = $false
  game_running = $false
  issues = @()
  recommendations = @()
}

# Function to add issue
function Add-Issue {
  param([string]$Issue, [string]$Recommendation)
  $result.issues += $Issue
  $result.recommendations += $Recommendation
  if ($result.status -eq 'healthy') { $result.status = 'degraded' }
}

# Check 1: Godot process running
$godotProcesses = Get-Process | Where-Object { $_.ProcessName -like '*Godot*' }
$result.godot_running = ($godotProcesses.Count -gt 0)
if (-not $result.godot_running) {
  Add-Issue 'Godot not running' 'Start Godot editor: use godot-mcp-dap-start skill or run Godot directly'
  $result.status = 'down'
}

# Check 2: MCP port 9080 listening
$port9080 = Get-NetTCPConnection -LocalPort 9080 -State Listen -ErrorAction SilentlyContinue
$result.mcp_port_listening = ($null -ne $port9080)
if (-not $result.mcp_port_listening) {
  Add-Issue 'MCP port 9080 not listening' 'Ensure MCP addon is enabled in Godot and Godot is running'
}

# Check 3: MCP CLI responsive (with timeout)
if ($result.mcp_port_listening) {
  $npxTest = $null
  try {
    $npxTest = npx -y godot-mcp-cli@latest get_project_info 2>&1
    if ($LASTEXITCODE -eq 0) {
      $result.mcp_cli_responsive = $true
    } else {
      Add-Issue "MCP CLI returned error code $LASTEXITCODE" 'Check MCP server logs in Godot console'
    }
  } catch {
    Add-Issue "MCP CLI test failed: $_" 'Verify npx and Node.js are installed correctly'
  }
} else {
  Add-Issue 'Cannot test MCP CLI - port not listening' 'Fix port 9080 issue first'
}

# Check 4: Game running (scene structure test)
if ($result.mcp_cli_responsive) {
  $sceneTest = $null
  try {
    $sceneTest = npx -y godot-mcp-cli@latest get_runtime_scene_structure 2>&1
    if ($LASTEXITCODE -eq 0 -and $sceneTest -match 'Scene|World|root') {
      $result.game_running = $true
    } else {
      Add-Issue 'Game not running or scene not loaded' 'Run: npx -y godot-mcp-cli@latest run_project --headed'
    }
  } catch {
    Add-Issue "Game check failed: $_" 'Manually start game from Godot'
  }
}

# Check 5: Multiple Godot instances
if ($godotProcesses.Count -gt 1) {
  Add-Issue "Multiple Godot processes detected ($($godotProcesses.Count))" 'Close duplicate Godot instances, keep only one'
  $result.status = 'degraded'
}

# Output
if ($JSON) {
  $result | ConvertTo-Json -Compress
} elseif (-not $Quiet) {
  Write-Host ''
  Write-Host '=== MCP Health Check ==='
  Write-Host ''
  Write-Host "Status: $($result.status.ToUpper())"
  Write-Host ''
  Write-Host 'Checks:'
  Write-Host "  Godot Running: $(if ($result.godot_running) { 'YES' } else { 'NO' })"
  Write-Host "  MCP Port 9080: $(if ($result.mcp_port_listening) { 'LISTENING' } else { 'NOT LISTENING' })"
  Write-Host "  MCP CLI: $(if ($result.mcp_cli_responsive) { 'RESPONSIVE' } else { 'NOT RESPONSIVE' })"
  Write-Host "  Game Running: $(if ($result.game_running) { 'YES' } else { 'NO' })"

  if ($result.issues.Count -gt 0) {
    Write-Host ''
    Write-Host 'Issues:'
    for ($i = 0; $i -lt $result.issues.Count; $i++) {
      Write-Host "  - $($result.issues[$i])"
      Write-Host "    → $($result.recommendations[$i])"
    }
  } else {
    Write-Host ''
    Write-Host '✓ All checks passed!'
  }
  Write-Host ''
}

# Exit code based on status
if ($result.status -eq 'healthy') { exit 0 }
elseif ($result.status -eq 'degraded') { exit 1 }
elseif ($result.status -eq 'down') { exit 2 }
else { exit 3 }
