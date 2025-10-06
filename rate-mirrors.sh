#!/bin/bash
#PICKLES UPDATE
#Created by Stu-Pickles3407 for Pickles Linux
# Script Name: rate-mirrors.sh
# Description: This script rates mirrors for pacman within pickles-update
# Author: Stu-Pickles3407  <stu.pickles.stu@gmail.com>
# Package Website: <https://github.com/Stu-Pickles3047/pickles-update>
# Created for Pickles Linux <https://stu-pickles3407.github.io/pickles-linux/>
# Usage: see pickles-update -h
# Dependencies
# - rate-mirrors
# - sudo
#
# License: unlicensed <https://unlicense.org/UNLICENSE>
#

# Prevent running as root or with sudo
if [[ "$EUID" -eq 0 ]]; then
    echo "$(tput setaf 1)ERROR:$(tput sgr0) Do not run rate-mirrors.sh as root or with sudo."
    exit 1
fi

# Get OS info
os_name_raw=$(lsb_release -i | awk -F: '{print $2}' | xargs)
os_name=${os_name_raw,,} # Convert to lowercase
os_pretty_name=$(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '"')

# Function to backup mirrorlist
backup_mirrorlist() {
    echo "$(tput sgr0)Backing up Mirrorlist for $(tput setaf 5)$os_pretty_name$(tput sgr0)"

    if [ -f /etc/pacman.d/mirrorlist.bak ]; then
        sudo rm /etc/pacman.d/mirrorlist.bak
    fi

    sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
}

# Function to rate mirrors
rate_mirrors() {
    chaotic_available=false
    if grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
        chaotic_available=true
    fi

    if $chaotic_available; then
        echo "Rating $os_name & Chaotic mirrors for $(tput setaf 5)$os_pretty_name $(tput sgr0) "
    else
        echo "Rating $os_name mirrors for $(tput setaf 5)$os_pretty_name $(tput sgr0) "
    fi
    backup_mirrorlist
    # Note: Using 'tee >(command)' requires bash and the `rate-mirrors` tool to be installed.
    rate-mirrors "$os_name" | tee >(grep "Server =" | { echo "#Pickles Update "; echo "#Mirrorlist"; echo "#for $os_pretty_name "; echo ""; cat; } | sudo tee /etc/pacman.d/mirrorlist) &
    if $chaotic_available; then
        rate-mirrors "chaotic-aur" | tee >(grep "Server =" | { echo "#Pickles Update "; echo "#Chaotic Mirrorlist"; echo "#for $os_pretty_name "; echo ""; cat; } | sudo tee /etc/pacman.d/chaotic-mirrorlist) &
    fi
    wait
    echo "$(tput setaf 5)::>> $(tput sgr0)Mirror rating complete."
}

# Run the function
rate_mirrors