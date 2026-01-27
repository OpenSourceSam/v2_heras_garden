# ============================================
# CLAUDE CODE LAUNCHER FUNCTIONS
# Add this to your PowerShell profile:
# notepad $PROFILE
# ============================================

# --- CLAUDE (Real Anthropic API) ---
function claude {
    param([Parameter(ValueFromRemainingArguments=$true)][string[]]$Args)
    & "$env:USERPROFILE\scripts\start-claude-anthropic.ps1" @Args
}

# --- GLM (Z.AI / GLM-4.7) ---
function glm {
    param([Parameter(ValueFromRemainingArguments=$true)][string[]]$Args)
    & "$env:USERPROFILE\scripts\start-claude-glm.ps1" @Args
}

# --- MINIMAX (MiniMax API) ---
function minimax {
    param([Parameter(ValueFromRemainingArguments=$true)][string[]]$Args)
    & "$env:USERPROFILE\scripts\start-claude-minimax.ps1" @Args
}

# --- UTILITY: Show which config is active ---
function which-claude {
    $settings = Get-Content "$env:USERPROFILE\.claude\settings.json" -Raw | ConvertFrom-Json
    
    if ($settings.env.ANTHROPIC_BASE_URL -match "z\.ai") {
        Write-Host "Active: GLM-4.7 (Z.AI)" -ForegroundColor Yellow
    }
    elseif ($settings.env.ANTHROPIC_BASE_URL -match "minimax") {
        Write-Host "Active: MiniMax" -ForegroundColor Magenta
    }
    elseif (-not $settings.env.ANTHROPIC_BASE_URL) {
        Write-Host "Active: Anthropic Claude (default)" -ForegroundColor Green
    }
    else {
        Write-Host "Active: Unknown ($($settings.env.ANTHROPIC_BASE_URL))" -ForegroundColor Red
    }
}

# --- UTILITY: Reset to default Anthropic ---
function reset-claude {
    $defaultConfig = @{
        permissions = @{ allow = @(); deny = @() }
        env = @{}
    }
    $defaultConfig | ConvertTo-Json -Depth 10 | Set-Content "$env:USERPROFILE\.claude\settings.json" -Encoding UTF8
    
    # Clear environment variables
    @("ANTHROPIC_BASE_URL", "ANTHROPIC_AUTH_TOKEN", "ANTHROPIC_DEFAULT_OPUS_MODEL",
      "ANTHROPIC_DEFAULT_SONNET_MODEL", "ANTHROPIC_DEFAULT_HAIKU_MODEL") | ForEach-Object {
        Remove-Item "Env:$_" -ErrorAction SilentlyContinue
    }
    
    Write-Host "Reset to Anthropic Claude defaults" -ForegroundColor Green
}
