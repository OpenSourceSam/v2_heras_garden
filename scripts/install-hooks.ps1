Param()

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path -Path (Split-Path -Parent $PSCommandPath)
$repoRoot = Resolve-Path -Path (Join-Path $repoRoot "..")
$hooksPath = Join-Path $repoRoot "scripts\\git-hooks"

git config core.hooksPath $hooksPath | Out-Null
Write-Output "Git hooks path set to $hooksPath"
