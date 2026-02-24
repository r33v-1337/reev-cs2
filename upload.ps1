# Reev GitHub Upload Script
# Handles pull-before-push automatically

$RepoDir   = "E:\CS2 stuff\reev-cs2"
$DllSrc    = "E:\CS2 stuff\Reev Main\build\x64\Release\protected\reev_release.dll"
$LoaderSrc = "E:\CS2 stuff\Reev Main\src\ReevLoader\build\x64\Release\ReevLoader.exe"

function Write-Header {
    Clear-Host
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "         Reev GitHub Uploader           " -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
}

function Sync-Repo {
    Write-Host ">> Syncing with remote..." -ForegroundColor Yellow
    git -C $RepoDir stash --include-untracked 2>&1 | Out-Null
    git -C $RepoDir pull origin main --strategy-option=ours 2>&1 | ForEach-Object { Write-Host $_ }
    git -C $RepoDir stash pop 2>&1 | Out-Null
}

function Push-File {
    param([string]$FilePath, [string]$FileName, [string]$CommitMsg)

    Write-Host ""
    Write-Host ">> Have you already rebuilt/replaced $FileName with the new version?" -ForegroundColor Yellow
    Write-Host "   Source: $FilePath" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  [Y] Yes, it's ready" -ForegroundColor Green
    Write-Host "  [N] No, cancel"      -ForegroundColor Red
    Write-Host ""
    $confirm = Read-Host "Choice"

    if ($confirm -notmatch "^[Yy]$") {
        Write-Host ">> Cancelled." -ForegroundColor Red
        return
    }

    if (-not (Test-Path $FilePath)) {
        Write-Host ">> ERROR: Source file not found: $FilePath" -ForegroundColor Red
        return
    }

    Write-Host ""
    Write-Host ">> Copying $FileName to repo..." -ForegroundColor Yellow
    Copy-Item $FilePath "$RepoDir\$FileName" -Force

    Sync-Repo

    Write-Host ""
    Write-Host ">> Staging $FileName..." -ForegroundColor Yellow
    git -C $RepoDir add $FileName

    Write-Host ">> Committing..." -ForegroundColor Yellow
    git -C $RepoDir commit -m $CommitMsg

    Write-Host ">> Pushing..." -ForegroundColor Yellow
    $push = git -C $RepoDir push origin main 2>&1
    Write-Host $push

    if ($LASTEXITCODE -eq 0 -or ($push -match "main -> main")) {
        Write-Host ""
        Write-Host ">> $FileName pushed successfully!" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host ">> Push may have failed. Check output above." -ForegroundColor Red
    }
}

# ---- Main Menu ----
Write-Header

Write-Host "  What do you want to upload?" -ForegroundColor White
Write-Host ""
Write-Host "  [1] reev_release.dll  (cheat DLL)"   -ForegroundColor Cyan
Write-Host "  [2] ReevLoader.exe    (loader)"       -ForegroundColor Cyan
Write-Host "  [3] Both"                             -ForegroundColor Cyan
Write-Host "  [Q] Quit"                             -ForegroundColor DarkGray
Write-Host ""
$choice = Read-Host "Choice"

switch ($choice) {
    "1" {
        Push-File $DllSrc    "reev_release.dll" "Update reev_release.dll"
    }
    "2" {
        Push-File $LoaderSrc "ReevLoader.exe"   "Update ReevLoader.exe"
    }
    "3" {
        Push-File $DllSrc    "reev_release.dll" "Update reev_release.dll"
        Push-File $LoaderSrc "ReevLoader.exe"   "Update ReevLoader.exe"
    }
    default {
        Write-Host ">> Exiting." -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
