#!/bin/bash
#PICKLES UPDATE
#Created by Stu-Pickles3407 for Pickles Linux
# Script Name: query-updates.sh
# Description: This script queries for available updates within pickles-update
# Author: Stu-Pickles3407  <stu.pickles.stu@gmail.com>
# Package Website: <https://github.com/Stu-Pickles3047/pickles-update>
# Created for Pickles Linux <https://stu-pickles3407.github.io/pickles-linux/>
# Usage: see pickles-update -h
# Dependencies
# - pacman
# - curl
# - jq (optional)
#
# License: unlicensed <https://unlicense.org/UNLICENSE>
#

LOG_FILE="$log_file_save_location/pickles-update.log"

# Get OS info
os_pretty_name=$(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '"')

echo "$(date): Querying for available updates" >> "$LOG_FILE"

echo "$(date): Starting database sync" >> "$LOG_FILE"
echo "$(tput setaf 5)::>> $(tput sgr0)Syncing package databases..."
sudo pacman -Sy
echo "$(date): Database sync completed" >> "$LOG_FILE"

echo "$(tput setaf 5)::>> $(tput sgr0)Checking for available updates..."

# Official updates
official_updates=$(pacman -Qu | wc -l)
if [[ $official_updates -gt 0 ]]; then
    echo "$(tput setaf 5)::>> $(tput sgr0)$official_updates official package updates available."
    pacman -Qu
else
    echo "$(tput setaf 5)::>> $(tput sgr0)No official package updates available."
fi

# AUR updates
if ! command -v curl >/dev/null 2>&1; then
    echo "$(tput setaf 3)WARNING:$(tput sgr0) curl not found, skipping AUR update check."
else
    aur_packages=$(pacman -Qm | awk '{print $1}')
    aur_count=$(echo "$aur_packages" | wc -w)
    aur_updates=0
    if [[ -n "$aur_packages" ]]; then
        echo "$(tput setaf 5)::>> $(tput sgr0)Checking $aur_count AUR packages for updates..."
        # Build batch URL
        url="https://aur.archlinux.org/rpc/v5/info"
        for pkg in $aur_packages; do
            url="${url}&arg[]=$pkg"
        done
        aur_info=$(curl -# --max-time 10 "$url" 2>/dev/null)
        if command -v jq >/dev/null 2>&1 && echo "$aur_info" | jq empty >/dev/null 2>&1; then
            # Use jq for parsing
            updates=$(echo "$aur_info" | jq -r '.results[] | select(.Name and .Version) | "\(.Name) \(.Version)"')
            for update in $updates; do
                name=$(echo "$update" | awk '{print $1}')
                aur_ver=$(echo "$update" | awk '{print $2}')
                local_ver=$(pacman -Q "$name" 2>/dev/null | awk '{print $2}')
                if [[ -n "$local_ver" && "$local_ver" != "$aur_ver" ]]; then
                    echo "$name: $local_ver -> $aur_ver"
                    ((aur_updates++))
                fi
            done
        else
            # Fallback to individual queries if jq not available or JSON invalid
            echo "$(tput setaf 3)WARNING:$(tput sgr0) jq not available or JSON error, using slower method."
            for pkg in $aur_packages; do
                local_ver=$(pacman -Q "$pkg" 2>/dev/null | awk '{print $2}')
                if [[ -z "$local_ver" ]]; then
                    continue
                fi
                aur_info_single=$(curl -# --max-time 5 "https://aur.archlinux.org/rpc/v5/info?arg=$pkg" 2>/dev/null)
                aur_ver=$(echo "$aur_info_single" | grep -o '"Version":"[^"]*"' | head -1 | cut -d'"' -f4)
                if [[ -n "$aur_ver" && "$local_ver" != "$aur_ver" ]]; then
                    echo "$pkg: $local_ver -> $aur_ver"
                    ((aur_updates++))
                fi
            done
        fi
        if [[ $aur_updates -gt 0 ]]; then
            echo "$(tput setaf 5)::>> $(tput sgr0)$aur_updates AUR package updates available."
        else
            echo "$(tput setaf 5)::>> $(tput sgr0)No AUR package updates available."
        fi
    else
        echo "$(tput setaf 5)::>> $(tput sgr0)No AUR packages installed."
    fi
fi

# Check if any updates available
if [[ $official_updates -eq 0 && $aur_updates -eq 0 ]]; then
    echo "$(tput setaf 5)::>> $(tput sgr0)No updates available for $(tput setaf 5)$os_pretty_name$(tput sgr0)"
    echo "$(date): No updates available" >> "$LOG_FILE"
    exit 1
fi

echo "$(date): Query complete" >> "$LOG_FILE"