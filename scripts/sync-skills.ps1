param(
    [switch]$Prune,
    [switch]$DryRun
)

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$source = Join-Path $root ".claude\skills"
$dest = Join-Path $root ".codex\skills"

if (-not (Test-Path $source)) {
    Write-Error "Source skills folder not found: $source"
    exit 1
}

if (-not (Test-Path $dest)) {
    if ($DryRun) {
        Write-Host "[DryRun] Would create: $dest"
    } else {
        New-Item -ItemType Directory -Force -Path $dest | Out-Null
    }
}

$sourceSkills = Get-ChildItem -Path $source -Directory | Where-Object {
    Test-Path (Join-Path $_.FullName "SKILL.md")
}

$sourceNames = @()
foreach ($skill in $sourceSkills) {
    $sourceNames += $skill.Name
    $target = Join-Path $dest $skill.Name

    if ($DryRun) {
        Write-Host "[DryRun] Would sync: $($skill.Name) -> $target"
        continue
    }

    New-Item -ItemType Directory -Force -Path $target | Out-Null
    Copy-Item -Path $skill.FullName -Destination $target -Recurse -Force
    Write-Host "Synced: $($skill.Name)"
}

if ($Prune) {
    $destSkills = Get-ChildItem -Path $dest -Directory -ErrorAction SilentlyContinue
    foreach ($skill in $destSkills) {
        if ($sourceNames -notcontains $skill.Name) {
            if ($DryRun) {
                Write-Host "[DryRun] Would remove: $($skill.FullName)"
            } else {
                Remove-Item -Recurse -Force $skill.FullName
                Write-Host "Removed: $($skill.Name)"
            }
        }
    }
}
