param(
  [Parameter(Mandatory=$true)]
  [string]$McpCommand,
  [int]$TimeoutSec = 30,
  [switch]$Quiet,
  [switch]$Verbose
)

$ErrorActionPreference = "Continue"

# Set required environment variables
$env:GODOT_PROJECT_PATH = "C:\Users\Sam\Documents\GitHub\v2_heras_garden"
$env:MCP_TRANSPORT = "stdio"

# Default to quiet mode unless verbose is specified
$Quiet = -not $Verbose

if (-not $Quiet) {
  Write-Host "MCP: $McpCommand" -ForegroundColor Cyan
}

# Helper function to read script file and convert to --code argument
function Expand-ScriptFile {
  param([string]$CommandInput)

  # Check if --script-file is in the command
  if ($CommandInput -match '--script-file\s+([^\s]+)') {
    $filePath = $matches[1]
    # Convert to absolute path if relative
    if (-not [System.IO.Path]::IsPathRooted($filePath)) {
      $filePath = Join-Path (Get-Location) $filePath
    }

    if (Test-Path $filePath) {
      # Read file contents
      $code = Get-Content $filePath -Raw -Encoding UTF8

      # Escape the code for command line use
      # We need to escape special characters for PowerShell
      $code = $code -replace '\\', '\\'
      $code = $code -replace '"', '\"'
      $code = $code -replace '`', '``'
      $code = $code -replace '\$', '`$'
      $code = $code.Trim()

      # Replace --script-file <path> with --code "<escaped_code>"
      $CommandInput = $CommandInput -replace '--script-file\s+[^\s]+', "--code `"$code`""
    } else {
      throw "Script file not found: $filePath"
    }
  }

  return $CommandInput
}

# Expand --script-file to --code with file contents
$McpCommand = Expand-ScriptFile -CommandInput $McpCommand

# Build full npx command (same pattern as health check)
$fullCommand = "npx -y godot-mcp-cli@latest $McpCommand 2>&1"

# Execute using Invoke-Expression (same as health check)
$output = Invoke-Expression -Command $fullCommand | Out-String

if (-not $Quiet) {
  Write-Host $output
}

# Return output for programmatic use
return $output.Trim()
