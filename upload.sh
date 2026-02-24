#!/bin/bash

REPO_DIR="E:/CS2 stuff/reev-cs2"
DLL_SRC="E:/CS2 stuff/Reev Main/build/x64/Release/protected/reev_release.dll"
LOADER_SRC="E:/CS2 stuff/Reev Main/src/ReevLoader/build/x64/Release/ReevLoader.exe"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m'

sync_repo() {
    echo -e "${YELLOW}>> Syncing with remote...${NC}"
    git -C "$REPO_DIR" stash --include-untracked > /dev/null 2>&1
    git -C "$REPO_DIR" pull origin main --strategy-option=ours
    git -C "$REPO_DIR" stash pop > /dev/null 2>&1
}

push_file() {
    local src="$1"
    local name="$2"
    local msg="$3"

    echo ""
    echo -e "${YELLOW}>> Have you already rebuilt/replaced ${name} with the new version?${NC}"
    echo -e "${GRAY}   Source: ${src}${NC}"
    echo ""
    echo -e "  ${GREEN}[Y]${NC} Yes, it's ready"
    echo -e "  ${RED}[N]${NC} No, cancel"
    echo ""
    read -rp "Choice: " confirm

    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "${RED}>> Cancelled.${NC}"
        return
    fi

    if [ ! -f "$src" ]; then
        echo -e "${RED}>> ERROR: Source file not found: ${src}${NC}"
        return
    fi

    echo ""
    echo -e "${YELLOW}>> Copying ${name} to repo...${NC}"
    cp "$src" "$REPO_DIR/$name"

    sync_repo

    echo -e "${YELLOW}>> Staging ${name}...${NC}"
    git -C "$REPO_DIR" add "$name"

    echo -e "${YELLOW}>> Committing...${NC}"
    git -C "$REPO_DIR" commit -m "$msg"

    echo -e "${YELLOW}>> Pushing...${NC}"
    git -C "$REPO_DIR" push origin main

    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}>> ${name} pushed successfully!${NC}"
    else
        echo ""
        echo -e "${RED}>> Push failed - trying force push...${NC}"
        git -C "$REPO_DIR" push origin main --force
    fi
}

# ---- Main Menu ----
clear
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}         Reev GitHub Uploader           ${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo "  What do you want to upload?"
echo ""
echo -e "  ${CYAN}[1]${NC} reev_release.dll  (cheat DLL)"
echo -e "  ${CYAN}[2]${NC} ReevLoader.exe    (loader)"
echo -e "  ${CYAN}[3]${NC} Both"
echo -e "  ${GRAY}[Q]${NC} Quit"
echo ""
read -rp "Choice: " choice

case "$choice" in
    1) push_file "$DLL_SRC"    "reev_release.dll" "Update reev_release.dll" ;;
    2) push_file "$LOADER_SRC" "ReevLoader.exe"   "Update ReevLoader.exe"   ;;
    3)
        push_file "$DLL_SRC"    "reev_release.dll" "Update reev_release.dll"
        push_file "$LOADER_SRC" "ReevLoader.exe"   "Update ReevLoader.exe"
        ;;
    *) echo -e "${GRAY}>> Exiting.${NC}" ;;
esac

echo ""
read -rp "Press Enter to exit..."
