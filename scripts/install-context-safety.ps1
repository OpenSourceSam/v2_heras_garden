# Install Context Safety Hooks to PowerShell Profile
# Run this script once to set up context safety

# Get the path to the current script directory
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Find PowerShell profile paths
$ProfilePaths = @(
    $PROFILE.CurrentUserCurrentHost,
    $PROFILE.CurrentUserAllHosts,
    $PROFILE.AllUsersCurrentHost,
    $PROFILE.AllUsersAllHosts
)

# Use the first available profile
$TargetProfile = $ProfilePaths | Where-Object { $_ } | Select-Object -First 1

if (-not $TargetProfile) {
    Write-Warning "No PowerShell profile found. Creating one..."
    $ProfileDir = Split-Path -Parent $PROFILE.CurrentUserCurrentHost
    if (-not (Test-Path $ProfileDir)) {
        New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
    }
    $TargetProfile = $PROFILE.CurrentUserCurrentHost
}

Write-Host "Installing context safety hooks to: $TargetProfile" -ForegroundColor Cyan

# Create backup of existing profile if it exists
if (Test-Path $TargetProfile) {
    $BackupPath = "$TargetProfile.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Copy-Item -Path $TargetProfile -Destination $BackupPath
    Write-Host "Created backup: $BackupPath" -ForegroundColor Yellow
}

# Add context safety hooks to profile
$HookContent = @"

# Load Context Safety Hooks
# This prevents context overflow by auto-truncating large command outputs
try {
    `"$ScriptPath\context-safety-hooks.ps1`"
    Write-Host `"Context safety hooks loaded!`" -ForegroundColor Green
} catch {
    Write-Warning `"Failed to load context safety hooks: `$_`"
}

"@

# Add to profile (don't overwrite existing content)
if (Test-Path $TargetProfile) {
    $ExistingContent = Get-Content -Path $TargetProfile -Raw
    if ($ExistingContent -notmatch "context-safety-hooks.ps1") {
        Add-Content -Path $TargetProfile -Value $HookContent
        Write-Host "Context safety hooks added to existing profile." -ForegroundColor Green
    } else {
        Write-Host "Context safety hooks already present in profile." -ForegroundColor Yellow
    }
} else {
    # Create new profile with content
    Set-Content -Path $TargetProfile -Value $HookContent
    Write-Host "Created new PowerShell profile with context safety hooks." -ForegroundColor Green
}

Write-Host ""
Write-Host "Context safety installation complete!" -ForegroundColor Green
Write-Host "Restart PowerShell to load the new aliases: lss, cats, finds" -ForegroundColor Yellow
Write-Host ""
Write-Host "Usage examples:" -ForegroundColor Cyan
Write-Host "  lss - Recursively list files (limited to 50 items)" -ForegroundColor White
Write-Host "  cats file.txt - Safe cat that limits large files" -ForegroundColor White
Write-Host "  finds . -pattern 'TODO' - Safe find with limits" -ForegroundColor White