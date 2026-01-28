# Context Safety Hooks for PowerShell
# Automatically truncates dangerous commands that could cause context overflow
# Add this to your PowerShell profile: .\path\to\context-safety-hooks.ps1

# Import safety aliases that auto-truncate large outputs
Set-Alias -Name lss -Value Get-ChildItemSafe
Set-Alias -Name cats -Value Get-ContentSafe
Set-Alias -Name finds -Value Find-StringSafe

# Safe versions of common commands that prevent context overflow
function Get-ChildItemSafe {
    param(
        [string]$Path = ".",
        [switch]$Recurse,
        [switch]$Force
    )

    # Get items but limit output to prevent context explosion
    $items = Get-ChildItem -Path $Path -Recurse:$Recurse -Force:$Force

    # If too many items, show limited output
    if ($items.Count -gt 50) {
        Write-Warning "Showing first 50 of $($items.Count) items to prevent context overflow"
        return $items | Select-Object -First 50
    }

    return $items
}

function Get-ContentSafe {
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$Path
    )

    process {
        # Check file size first
        $fileInfo = Get-Item -Path $Path -ErrorAction SilentlyContinue
        if (-not $fileInfo) {
            Write-Error "File not found: $Path"
            return
        }

        # If file is large, show warning and limit content
        if ($fileInfo.Length -gt 100KB) {
            Write-Warning "File is large ($([math]::Round($fileInfo.Length/1KB, 1))KB). Showing first 500 lines to prevent context overflow."
            return Get-Content -Path $Path | Select-Object -First 500
        }

        return Get-Content -Path $Path
    }
}

function Find-StringSafe {
    param(
        [string]$Path = ".",
        [string]$Pattern,
        [switch]$Recurse
    )

    # Check if search would be too broad
    $fileCount = @(Get-ChildItem -Path $Path -Recurse:$Recurse -File).Count

    if ($fileCount -gt 100) {
        Write-Warning "Search would scan $fileCount files. This could cause context overflow."
        Write-Host "Use a more specific path pattern to limit the search."
        return
    }

    # Perform the search but limit results
    $results = Select-String -Path $Path -Pattern $Pattern -Recurse:$Recurse

    if ($results.Count -gt 100) {
        Write-Warning "Found $($results.Count) matches. Showing first 100 to prevent context overflow."
        return $results | Select-Object -First 100
    }

    return $results
}

# Utility function to count file operations (for debugging)
$global:FileOpCount = 0
$global:WriteOpCount = 0

function Show-ContextStats {
    Write-Host "Context Safety Stats:"
    Write-Host "  Total File Operations: $($global:FileOpCount)"
    Write-Host "  Write Operations: $($global:WriteOpCount)"
    Write-Host "  Risk Level: $(if ($global:FileOpCount -ge 5) { "HIGH" } elseif ($global:FileOpCount -ge 3) { "MEDIUM" } else { "LOW" })"
}

# Export functions for external use
Export-ModuleMember -Function @(
    'Get-ChildItemSafe',
    'Get-ContentSafe',
    'Find-StringSafe',
    'Show-ContextStats'
) -Alias @('lss', 'cats', 'finds')

# Only show message if not in quiet mode
if (-not $env:CONTEXT_SAFETY_QUIET) {
    Write-Host "Context safety hooks loaded!" -ForegroundColor Green
}