@echo off
setlocal enabledelayedexpansion

set "REPO_DIR=E:\CS2 stuff\reev-cs2"
set "DLL_SRC=E:\CS2 stuff\Reev Main\build\x64\Release\protected\reev_release.dll"
set "LOADER_SRC=E:\CS2 stuff\Reev Main\src\ReevLoader\build\x64\Release\ReevLoader.exe"

cls
echo ========================================
echo          Reev GitHub Uploader
echo ========================================
echo.
echo   What do you want to upload?
echo.
echo   [1] reev_release.dll  (cheat DLL)
echo   [2] ReevLoader.exe    (loader)
echo   [3] Both
echo   [Q] Quit
echo.
set /p CHOICE="Choice: "

if /i "%CHOICE%"=="1" goto upload_dll
if /i "%CHOICE%"=="2" goto upload_loader
if /i "%CHOICE%"=="3" goto upload_both
goto end

:upload_dll
call :push_file "%DLL_SRC%" "reev_release.dll" "Update reev_release.dll"
goto end

:upload_loader
call :push_file "%LOADER_SRC%" "ReevLoader.exe" "Update ReevLoader.exe"
goto end

:upload_both
call :push_file "%DLL_SRC%" "reev_release.dll" "Update reev_release.dll"
call :push_file "%LOADER_SRC%" "ReevLoader.exe" "Update ReevLoader.exe"
goto end

:push_file
set "SRC=%~1"
set "NAME=%~2"
set "MSG=%~3"

echo.
echo Have you already rebuilt/replaced %NAME% with the new version?
echo Source: %SRC%
echo.
echo   [Y] Yes, it's ready
echo   [N] No, cancel
echo.
set /p CONFIRM="Choice: "
if /i not "%CONFIRM%"=="Y" (
    echo Cancelled.
    exit /b
)

if not exist "%SRC%" (
    echo ERROR: Source file not found: %SRC%
    exit /b
)

echo.
echo Copying %NAME% to repo...
copy /y "%SRC%" "%REPO_DIR%\%NAME%" > nul

echo Syncing with remote...
git -C "%REPO_DIR%" stash --include-untracked > nul 2>&1
git -C "%REPO_DIR%" pull origin main --strategy-option=ours
git -C "%REPO_DIR%" stash pop > nul 2>&1

echo Staging %NAME%...
git -C "%REPO_DIR%" add "%NAME%"

echo Committing...
git -C "%REPO_DIR%" commit -m "%MSG%"

echo Pushing...
git -C "%REPO_DIR%" push origin main
if errorlevel 1 (
    echo Push failed - trying force push...
    git -C "%REPO_DIR%" push origin main --force
)

echo.
echo Done! %NAME% pushed.
exit /b

:end
echo.
pause
