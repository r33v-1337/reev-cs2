@echo off
setlocal enabledelayedexpansion

set "REPO=E:\CS2 stuff\reev-cs2"
set "DLL_SRC=E:\CS2 stuff\Reev Main\build\x64\Release\protected\reev_release.dll"
set "LOADER_SRC=E:\CS2 stuff\Reev Main\src\ReevLoader\build\x64\Release\ReevLoader.exe"
set "HASH_SRC=E:\CS2 stuff\Reev Main\src\ReevLoader\build\x64\Release\build_hash.txt"

cls
echo ========================================
echo          Reev GitHub Uploader
echo ========================================
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
goto done

:upload_dll
call :push "reev_release.dll" "%DLL_SRC%"
goto done

:upload_loader
call :push "ReevLoader.exe" "%LOADER_SRC%"
call :push_hash
goto done

:upload_both
call :push "reev_release.dll" "%DLL_SRC%"
call :push "ReevLoader.exe" "%LOADER_SRC%"
call :push_hash
goto done

:push
set "NAME=%~1"
set "SRC=%~2"

echo.
echo Have you replaced %NAME% with the new build? [Y/N]
set /p OK=">> "
if /i not "%OK%"=="Y" ( echo Skipped. & exit /b )

if not exist "%SRC%" ( echo ERROR: %SRC% not found! & exit /b )

echo Copying %NAME%...
copy /y "%SRC%" "%REPO%\%NAME%" >nul

echo Staging...
git -C "%REPO%" add "%NAME%"

echo Committing...
git -C "%REPO%" commit -m "Update %NAME%"

echo Pushing...
git -C "%REPO%" push origin main
if errorlevel 1 (
    echo Retrying with force push...
    git -C "%REPO%" push origin main --force
)

echo %NAME% done!
exit /b

:push_hash
if exist "%HASH_SRC%" (
    echo Updating build_hash.txt + loader-version-check.txt...
    copy /y "%HASH_SRC%" "%REPO%\build_hash.txt" >nul
    copy /y "%HASH_SRC%" "%REPO%\loader-version-check.txt" >nul
    git -C "%REPO%" add build_hash.txt loader-version-check.txt
    git -C "%REPO%" commit -m "Update build hash"
    git -C "%REPO%" push origin main
    if errorlevel 1 git -C "%REPO%" push origin main --force
)
exit /b

:done
echo.
echo All done!
pause
