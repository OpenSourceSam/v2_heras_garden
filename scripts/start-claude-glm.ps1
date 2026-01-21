# Start Claude Code with GLM via Z.AI (terminal only)
# OPT-IN ONLY: Run this script when you want GLM in Claude Code CLI

param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ClaudeArgs
)

# Clear any existing model overrides to avoid conflicts
Remove-Item Env:ANTHROPIC_MODEL -ErrorAction SilentlyContinue
Remove-Item Env:ANTHROPIC_SMALL_FAST_MODEL -ErrorAction SilentlyContinue
Remove-Item Env:ANTHROPIC_DEFAULT_SONNET_MODEL -ErrorAction SilentlyContinue
Remove-Item Env:ANTHROPIC_DEFAULT_OPUS_MODEL -ErrorAction SilentlyContinue
Remove-Item Env:ANTHROPIC_DEFAULT_HAIKU_MODEL -ErrorAction SilentlyContinue

# Set GLM (Z.AI) configuration
$env:ANTHROPIC_BASE_URL = "https://api.z.ai/api/anthropic"
$env:ANTHROPIC_AUTH_TOKEN = "dda9b03b0a6f410383ef0fc58251dbaf.ThUX5qkMmqJ5kFj0"
$env:API_TIMEOUT_MS = "3000000"
$env:CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1"
# Map Claude Code model slots to GLM models (per Z.AI docs)
$env:ANTHROPIC_DEFAULT_OPUS_MODEL = "GLM-4.7"
$env:ANTHROPIC_DEFAULT_SONNET_MODEL = "GLM-4.7"
$env:ANTHROPIC_DEFAULT_HAIKU_MODEL = "GLM-4.5-Air"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  GLM MODE (Z.AI) - Claude Code CLI" -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "To return to default Claude, close this session and reopen terminal." -ForegroundColor Gray
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Launch Claude with standard model name (mapped to GLM by Z.AI)
if ($ClaudeArgs -and $ClaudeArgs.Count -gt 0) {
    claude --model "sonnet" @ClaudeArgs
} else {
    claude --model "sonnet"
}
