@echo off
echo Starting Minimax Auto Chat Saver...
echo Copy your chat content and it will be automatically saved!
echo Press Ctrl+C to stop.
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0auto_saver.ps1"
pause
