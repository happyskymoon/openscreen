@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul

cd /d "%~dp0"

echo ========================================
echo OpenScreen Windows Build Helper
echo ========================================
echo.

if not exist "package.json" (
    echo [ERROR] package.json was not found.
    echo Please place this script in the project root folder.
    echo.
    pause
    exit /b 1
)

where node >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Node.js was not found in PATH.
    echo Install Node.js 22.x first, then run this script again.
    echo.
    pause
    exit /b 1
)

where npm >nul 2>nul
if errorlevel 1 (
    echo [ERROR] npm was not found in PATH.
    echo Install Node.js and ensure npm is available in PATH.
    echo.
    pause
    exit /b 1
)

echo [1/3] Checking dependencies...
if not exist "node_modules" (
    echo node_modules was not found. Running npm install...
    call npm install
    if errorlevel 1 (
        echo.
        echo [ERROR] npm install failed.
        pause
        exit /b 1
    )
) else (
    echo node_modules already exists. Skipping npm install.
)

echo.
echo [2/3] Building Windows package...
call npm run build:win
if errorlevel 1 (
    echo.
    echo [ERROR] Windows build failed.
    pause
    exit /b 1
)

echo.
echo [3/3] Searching for generated EXE files...
set "FOUND_EXE="

if exist "release" (
    for /f "delims=" %%F in ('dir /b /s "release\*.exe" 2^>nul') do (
        if not defined FOUND_EXE set "FOUND_EXE=1"
        echo %%F
    )
)

echo.
if defined FOUND_EXE (
    echo Build completed successfully.
    echo The generated EXE file(s) are listed above.
) else (
    echo Build completed, but no EXE file was found under the release folder.
    echo Please inspect the build output above for details.
)

echo.
pause
