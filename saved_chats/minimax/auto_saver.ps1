# Minimax Auto Chat Saver
# Monitors clipboard and automatically saves chat content when detected

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$lastClipHash = ""

Write-Host "=== Minimax Auto Chat Saver ===" -ForegroundColor Cyan
Write-Host "Monitoring clipboard for changes..." -ForegroundColor Yellow
Write-Host "Press Ctrl+C to exit" -ForegroundColor Yellow
Write-Host ""

while ($true) {
    try {
        $clipboard = Get-Clipboard -TextFormatType Text -ErrorAction SilentlyContinue

        if ($clipboard -and $clipboard.Length -gt 100) {
            $clipHash = (Get-Checksum -InputObject $clipboard -Algorithm MD5)

            if ($clipHash -ne $lastClipHash) {
                $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
                $filename = "${timestamp}_minimax_chat.md"
                $filepath = Join-Path $scriptPath $filename

                $header = @"
# Minimax Chat Export

**Date:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
**Model:** minimax

---

"@

                $header + $clipboard | Out-File -FilePath $filepath -Encoding UTF8

                Write-Host "✓ Chat saved: $filename" -ForegroundColor Green
                Write-Host "  Size: $((Get-Item $filepath).Length) bytes" -ForegroundColor Gray
                Write-Host ""

                $lastClipHash = $clipHash
            }
        }
    } catch {
        # Silently continue on errors
    }

    Start-Sleep -Seconds 2
}
