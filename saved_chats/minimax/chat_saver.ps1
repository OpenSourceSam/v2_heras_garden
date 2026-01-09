# Minimax Chat Saver
# Saves chat conversations to the minimax folder with automatic timestamping

param(
    [string]$Topic = "Chat_Session",
    [string]$Model = "minimax"
)

# Get current timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$filename = "${timestamp}_${Topic}_${Model}.md"
$filepath = Join-Path $PSScriptRoot $filename

# Create the markdown file with header
$header = @"
# Minimax Chat Export

**Date:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
**Topic:** $Topic
**Model:** $Model

---

"@

# Try to get content from clipboard
$clipboardContent = Get-Clipboard -TextFormatType Text

if ($clipboardContent) {
    # Save clipboard content to file
    $header + $clipboardContent | Out-File -FilePath $filepath -Encoding UTF8
    Write-Host "Chat saved to: $filepath" -ForegroundColor Green
    Write-Host "File size: $((Get-Item $filepath).Length) bytes" -ForegroundColor Cyan
} else {
    # Create empty file with header
    $header | Out-File -FilePath $filepath -Encoding UTF8
    Write-Host "Created empty chat file: $filepath" -ForegroundColor Yellow
    Write-Host "Clipboard is empty. Copy your chat content and run again." -ForegroundColor Red
}

# Open the file location
Invoke-Item (Split-Path $filepath)
