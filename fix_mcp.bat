@echo off
REM Quick fix script for MCP Server issues
REM Run this if MCP won't connect

echo.
echo ================================================
echo   MCP Server Quick Fix Script
echo ================================================
echo.

echo Step 1: Closing Godot...
taskkill /IM Godot_v4.3-stable_win64.exe /F 2>nul
if %ERRORLEVEL% EQU 0 (
    echo   - Godot closed successfully
) else (
    echo   - Godot was not running
)

echo.
echo Step 2: Checking port 3000...
netstat -ano | findstr :3000 >nul
if %ERRORLEVEL% EQU 0 (
    echo   - WARNING: Port 3000 is still in use
    echo   - You may need to restart Windows if this persists
) else (
    echo   - Port 3000 is available
)

echo.
echo Step 3: Waiting 3 seconds for cleanup...
timeout /t 3 /nobreak >nul
echo   - Done

echo.
echo ================================================
echo   MCP Server should be reset now
echo ================================================
echo.
echo Next steps:
echo 1. Open Godot
echo 2. Click "MCP Server" tab at bottom
echo 3. Click "Start" button
echo 4. Try connecting again
echo.
echo If still broken, see: docs/MCP_TROUBLESHOOTING.md
echo.

pause
