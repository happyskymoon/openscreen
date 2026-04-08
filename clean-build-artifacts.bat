@echo off
setlocal EnableExtensions
chcp 65001 >nul

cd /d "%~dp0"

echo ========================================
echo OpenScreen Build Artifact Cleaner
echo ========================================
echo.
echo This script removes build artifacts created by build-exe.bat:
echo   - node_modules
echo   - dist
echo   - dist-electron
echo   - release
echo.
set /p CONFIRM=Type YES to continue: 

if /I not "%CONFIRM%"=="YES" (
    echo.
    echo Cancelled. No files were removed.
    echo.
    pause
    exit /b 0
)

call :remove_dir "node_modules"
call :remove_dir "dist"
call :remove_dir "dist-electron"
call :remove_dir "release"

echo.
echo Cleanup completed.
echo.
pause
exit /b 0

:remove_dir
set "TARGET=%~1"
if exist "%TARGET%" (
    echo Removing "%TARGET%"...
    rmdir /s /q "%TARGET%"
    if exist "%TARGET%" (
        echo [ERROR] Failed to remove "%TARGET%".
        exit /b 1
    ) else (
        echo Removed "%TARGET%".
    )
) else (
    echo Skipping "%TARGET%" because it does not exist.
)
exit /b 0
