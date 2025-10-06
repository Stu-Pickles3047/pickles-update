#!/bin/bash
#PICKLES UPDATE
#Created by Stu-Pickles3407 for Pickles Linux
# Script Name: pacman-update.sh
# Description: This script updates official pacman packages within pickles-update
# Author: Stu-Pickles3407  <stu.pickles.stu@gmail.com>
# Package Website: <https://github.com/Stu-Pickles3047/pickles-update>
# Created for Pickles Linux <https://stu-pickles3407.github.io/pickles-linux/>
# Usage: see pickles-update -h
# Dependencies
# - pacman
# - sudo
#
# License: unlicensed <https://unlicense.org/UNLICENSE>
#

# Prevent running as root or with sudo
if [[ "$EUID" -eq 0 ]]; then
    echo "$(tput setaf 1)ERROR:$(tput sgr0) Do not run pacman-update.sh as root or with sudo."
    exit 1
fi

LOG_FILE="$log_file_save_location/pickles-update.log"

CONFIRM=""
if [[ "$NOCONFIRM" == "true" ]]; then
    CONFIRM="--noconfirm"
fi

echo "$(date): Starting pacman update with options: $* $CONFIRM" >> "$LOG_FILE"

echo "$(tput setaf 5)::>> $(tput sgr0)Syncing official package databases..."

if sudo pacman "$@" $CONFIRM 2>&1 | tee -a "$LOG_FILE"; then
    echo "$(date): Pacman update successful" >> "$LOG_FILE"
    exit 0
else
    echo "$(date): Pacman update failed" >> "$LOG_FILE"
    exit 1
fi