#!/bin/bash
#PICKLES UPDATE
#Created by Stu-Pickles3407 for Pickles Linux
# Script Name: aur-update.sh
# Description: This script updates AUR packages within pickles-update
# Author: Stu-Pickles3407  <stu.pickles.stu@gmail.com>
# Package Website: <https://github.com/Stu-Pickles3047/pickles-update>
# Created for Pickles Linux <https://stu-pickles3407.github.io/pickles-linux/>
# Usage: see pickles-update -h
# Dependencies
# - git
# - makepkg
# - curl
#
# License: unlicensed <https://unlicense.org/UNLICENSE>
#

# Prevent running as root or with sudo
if [[ "$EUID" -eq 0 ]]; then
    echo "$(tput setaf 1)ERROR:$(tput sgr0) Do not run aur-update.sh as root or with sudo."
    exit 1
fi

# Check dependencies
if ! command -v git >/dev/null 2>&1; then
    echo "$(tput setaf 1)ERROR:$(tput sgr0) git not found. Install git to update AUR packages."
    exit 1
fi

if ! command -v makepkg >/dev/null 2>&1; then
    echo "$(tput setaf 1)ERROR:$(tput sgr0) makepkg not found. Cannot build AUR packages."
    exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
    echo "$(tput setaf 1)ERROR:$(tput sgr0) curl not found. Cannot check AUR versions."
    exit 1
fi

AUR_BUILD_DIR="$aur_build_dir"
LOG_FILE="$log_file_save_location/pickles-update.log"

mkdir -p "$AUR_BUILD_DIR" || { echo "$(tput setaf 1)ERROR:$(tput sgr0) Failed to create AUR build directory."; exit 1; }

echo "$(date): Starting AUR update" >> "$LOG_FILE"

echo "$(tput setaf 5)::>> $(tput sgr0)Checking for and updating AUR packages..."

# Get list of AUR packages
aur_packages=$(pacman -Qm | awk '{print $1}')

if [[ -z "$aur_packages" ]]; then
    echo "$(tput setaf 5)::>> $(tput sgr0)No AUR packages installed."
    echo "$(date): No AUR packages" >> "$LOG_FILE"
    exit 0
fi

# Get list of packages needing update using batch query
packages_to_update=""
url="https://aur.archlinux.org/rpc/v5/info"
for pkg in $aur_packages; do
    url="${url}&arg[]=$pkg"
done
aur_info=$(curl -# --max-time 10 "$url" 2>/dev/null)
if command -v jq >/dev/null 2>&1 && echo "$aur_info" | jq empty >/dev/null 2>&1; then
    updates=$(echo "$aur_info" | jq -r '.results[] | select(.Name and .Version) | "\(.Name) \(.Version)"')
    for update in $updates; do
        name=$(echo "$update" | awk '{print $1}')
        aur_ver=$(echo "$update" | awk '{print $2}')
        local_ver=$(pacman -Q "$name" 2>/dev/null | awk '{print $2}')
        if [[ -n "$local_ver" && "$local_ver" != "$aur_ver" ]]; then
            packages_to_update="$packages_to_update $name"
        fi
    done
else
    # Fallback
    for pkg in $aur_packages; do
        local_ver=$(pacman -Q "$pkg" 2>/dev/null | awk '{print $2}')
        if [[ -z "$local_ver" ]]; then
            continue
        fi
        aur_info_single=$(curl -# --max-time 5 "https://aur.archlinux.org/rpc/v5/info?arg=$pkg" 2>/dev/null)
        aur_ver=$(echo "$aur_info_single" | grep -o '"Version":"[^"]*"' | head -1 | cut -d'"' -f4)
        if [[ -n "$aur_ver" && "$local_ver" != "$aur_ver" ]]; then
            packages_to_update="$packages_to_update $pkg"
        fi
    done
fi

# Now update only the packages that need it
for pkg in $packages_to_update; do
    echo "$(tput setaf 5)::>> $(tput sgr0)Updating $pkg..."
    pkg_dir="$AUR_BUILD_DIR/$pkg"
    if [[ -d "$pkg_dir" ]]; then
        cd "$pkg_dir" || { echo "$(tput setaf 1)ERROR:$(tput sgr0) Failed to cd to $pkg_dir."; continue; }
        if git pull >> "$LOG_FILE" 2>&1; then
            echo "Git pull successful for $pkg" >> "$LOG_FILE"
        else
            echo "$(tput setaf 1)ERROR:$(tput sgr0) Git pull failed for $pkg."
            echo "$(date): Git pull failed for $pkg" >> "$LOG_FILE"
            continue
        fi
    else
        if git clone "https://aur.archlinux.org/$pkg.git" "$pkg_dir" >> "$LOG_FILE" 2>&1; then
            cd "$pkg_dir" || { echo "$(tput setaf 1)ERROR:$(tput sgr0) Failed to cd after clone for $pkg."; continue; }
            echo "Git clone successful for $pkg" >> "$LOG_FILE"
        else
            echo "$(tput setaf 1)ERROR:$(tput sgr0) Git clone failed for $pkg."
            echo "$(date): Git clone failed for $pkg" >> "$LOG_FILE"
            continue
        fi
    fi
    CONFIRM=""
    if [[ "$NOCONFIRM" == "true" ]]; then
        CONFIRM="--noconfirm"
    fi
    if makepkg -si $CONFIRM >> "$LOG_FILE" 2>&1; then
        echo "$(tput setaf 5)::>> $(tput sgr0)$pkg updated successfully."
        echo "$(date): Updated $pkg" >> "$LOG_FILE"
    else
        echo "$(tput setaf 1)ERROR:$(tput sgr0) Failed to build/install $pkg."
        echo "$(date): Failed to update $pkg" >> "$LOG_FILE"
    fi
done

if [[ -z "$packages_to_update" ]]; then
    echo "$(tput setaf 5)::>> $(tput sgr0)All AUR packages are up to date."
fi

# Clean AUR build cache if not keeping
if [[ "$keep_aur_build_cache" != "true" ]]; then
    rm -rf "$AUR_BUILD_DIR"/*
fi

echo "$(date): AUR update complete" >> "$LOG_FILE"