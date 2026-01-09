# Start Claude Code with MiniMax M2.1 model
# OPT-IN ONLY: Run this script when you want MiniMax
# Default behavior (just running 'claude') uses Sonnet 4.5 via settings.env.ps1

param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ClaudeArgs
)

# Clear any existing Sonnet settings to avoid conflicts
Remove-Item Env:ANTHROPIC_DEFAULT_SONNET_MODEL -ErrorAction SilentlyContinue
Remove-Item Env:ANTHROPIC_DEFAULT_OPUS_MODEL -ErrorAction SilentlyContinue
Remove-Item Env:ANTHROPIC_DEFAULT_HAIKU_MODEL -ErrorAction SilentlyContinue

# Set MiniMax configuration
$env:ANTHROPIC_BASE_URL = "https://api.minimax.io/anthropic"
$env:ANTHROPIC_AUTH_TOKEN = "sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c"
$env:API_TIMEOUT_MS = "3000000"
$env:CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1"
$env:ANTHROPIC_MODEL = "minimax:m2.1"
$env:ANTHROPIC_SMALL_FAST_MODEL = "minimax:m2.1"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  MiniMax M2.1 MODE (OPT-IN)" -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "To return to Sonnet 4.5 default, close this session and reopen terminal" -ForegroundColor Gray
Write-Host "Or run: Remove-Item Env:ANTHROPIC_MODEL" -ForegroundColor Gray
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# ========================================
# AUTO-START CHAT SAVER
# ========================================
Write-Host "Starting MiniMax Auto Chat Saver..." -ForegroundColor Green
$saverScript = "$env:USERPROFILE\Documents\GitHub\v2_heras_garden\saved_chats\minimax\auto_saver.ps1"
Start-Process powershell -ArgumentList "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$saverScript`""

# Give the saver a moment to initialize
Start-Sleep -Seconds 1
Write-Host "✓ Auto Chat Saver started!" -ForegroundColor Green
Write-Host "  Copy chat content → automatically saves every 2 seconds" -ForegroundColor Gray
Write-Host "  Press Ctrl+C in the saver window to stop it" -ForegroundColor Gray
Write-Host ""

# Launch Claude with explicit model override to avoid user settings
if ($ClaudeArgs -and $ClaudeArgs.Count -gt 0) {
    claude --model "minimax:m2.1" @ClaudeArgs
} else {
    claude --model "minimax:m2.1"
}
