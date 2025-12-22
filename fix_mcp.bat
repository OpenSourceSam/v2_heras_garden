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
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3000') do (
    set PID=%%a
)

if defined PID (
    echo   - WARNING: Port 3000 in use by PID %PID%
    echo   - Killing process...
    taskkill /PID %PID% /F >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo   - Process killed successfully
    ) else (
        echo   - Could not kill process (may need admin rights)
    )
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
