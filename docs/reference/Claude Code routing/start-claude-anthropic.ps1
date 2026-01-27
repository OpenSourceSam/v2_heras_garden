# start-claude-anthropic.ps1
# Launches Claude Code with real Anthropic Claude models
# Usage: claude [arguments]

param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$PassthroughArgs
)

$ErrorActionPreference = "Stop"

# === CONFIG PATHS ===
$SettingsPath = "$env:USERPROFILE\.claude\settings.json"
$ClaudeConfig = "$env:USERPROFILE\.claude\settings-claude.json"
$BackupPath = "$env:USERPROFILE\.claude\settings-backup.json"

# === ENVIRONMENT CLEANUP ===
# Remove any GLM/MiniMax environment overrides
$envVarsToClean = @(
    "ANTHROPIC_BASE_URL",
    "ANTHROPIC_AUTH_TOKEN",
    "ANTHROPIC_DEFAULT_OPUS_MODEL",
    "ANTHROPIC_DEFAULT_SONNET_MODEL", 
    "ANTHROPIC_DEFAULT_HAIKU_MODEL",
    "CLAUDE_MODEL",
    "CLAUDE_CODE_USE_BEDROCK"
)

foreach ($var in $envVarsToClean) {
    Remove-Item "Env:$var" -ErrorAction SilentlyContinue
}

# === CONFIG FILE SWAP ===
# Check if Claude config exists
if (-not (Test-Path $ClaudeConfig)) {
    Write-Host "Creating default Anthropic config at $ClaudeConfig" -ForegroundColor Yellow
    
    # Create minimal Anthropic config (no overrides = uses real Anthropic API)
    $defaultConfig = @{
        permissions = @{
            allow = @()
            deny = @()
        }
        env = @{}
    }
    $defaultConfig | ConvertTo-Json -Depth 10 | Set-Content $ClaudeConfig -Encoding UTF8
}

# Backup current settings if different from Claude config
if (Test-Path $SettingsPath) {
    $currentContent = Get-Content $SettingsPath -Raw -ErrorAction SilentlyContinue
    $claudeContent = Get-Content $ClaudeConfig -Raw
    
    if ($currentContent -ne $claudeContent) {
        Copy-Item $SettingsPath $BackupPath -Force
        Write-Host "Backed up current settings to settings-backup.json" -ForegroundColor DarkGray
    }
}

# Copy Claude config to active settings
Copy-Item $ClaudeConfig $SettingsPath -Force
Write-Host "Loaded Anthropic Claude configuration" -ForegroundColor Green

# === VERIFY API KEY ===
if (-not $env:ANTHROPIC_API_KEY) {
    Write-Host "Warning: ANTHROPIC_API_KEY not set in environment" -ForegroundColor Yellow
    Write-Host "Set it with: `$env:ANTHROPIC_API_KEY = 'sk-ant-...'" -ForegroundColor Yellow
}

# === LAUNCH CLAUDE ===
Write-Host "Starting Claude Code with Anthropic models..." -ForegroundColor Cyan
& claude.exe @PassthroughArgs
