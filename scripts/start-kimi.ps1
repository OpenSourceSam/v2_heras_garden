# Start Claude Code with Kimi K2.5 model
# OPT-IN ONLY: Run this script when you want Kimi K2.5
# Kimi K2.5 = Most capable subagent (256K context, vision, advanced reasoning)

param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ClaudeArgs
)

# Clear any existing model settings to avoid conflicts
Remove-Item Env:ANTHROPIC_DEFAULT_SONNET_MODEL -ErrorAction SilentlyContinue
Remove-Item Env:ANTHROPIC_DEFAULT_OPUS_MODEL -ErrorAction SilentlyContinue
Remove-Item Env:ANTHROPIC_DEFAULT_HAIKU_MODEL -ErrorAction SilentlyContinue
Remove-Item Env:ANTHROPIC_AUTH_TOKEN -ErrorAction SilentlyContinue

# Set Kimi K2.5 configuration
$env:ANTHROPIC_BASE_URL = "https://api.moonshot.cn/anthropic/"
$env:ANTHROPIC_API_KEY = "sk-kimi-EpYxHXd4Y0P4pCgjqJUXGmqN1DtwzdQkjMW3LxAleWGPozfXwXibfKSQ2uLZDisd"
$env:API_TIMEOUT_MS = "3000000"
$env:CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1"
$env:ANTHROPIC_MODEL = "kimi-k2.5-thinking"
$env:ANTHROPIC_SMALL_FAST_MODEL = "kimi-k2-turbo-preview"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Kimi K2.5 MODE (OPT-IN)" -ForegroundColor Magenta
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Provider: Moonshot AI (256K context, vision capable)" -ForegroundColor Gray
Write-Host "Models: kimi-k2.5-thinking (main), kimi-k2-turbo-preview (fast)" -ForegroundColor Gray
Write-Host "" -ForegroundColor Gray
Write-Host "Strengths:" -ForegroundColor Yellow
Write-Host "  - Most intelligent subagent for complex reasoning" -ForegroundColor Gray
Write-Host "  - Built-in vision for image analysis" -ForegroundColor Gray
Write-Host "  - 256K context window" -ForegroundColor Gray
Write-Host "" -ForegroundColor Gray
Write-Host "To return to default, close session or run:" -ForegroundColor Gray
Write-Host "  Remove-Item Env:ANTHROPIC_MODEL" -ForegroundColor Gray
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Launch Claude with explicit model override
if ($ClaudeArgs -and $ClaudeArgs.Count -gt 0) {
    claude --model "kimi-k2.5-thinking" @ClaudeArgs
} else {
    claude --model "kimi-k2.5-thinking"
}
