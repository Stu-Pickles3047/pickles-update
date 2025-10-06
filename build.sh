#!/bin/bash

#PICKLES UPDATE
#Created by Stu-Pickles3407 for Pickles Linux
# Script Name: build.sh
# Description: This script automates package building for pickles-update
# Author: Stu-Pickles3407  <stu.pickles.stu@gmail.com>
# Package Website: <https://github.com/Stu-Pickles3047/pickles-update>
# Created for Pickles Linux <https://stu-pickles3407.github.io/pickles-linux/>
# Usage: see pickles-update -h
# Dependencies
# - makepkg
#
# License: unlicensed <https://unlicense.org/UNLICENSE>
#

set -e  # Exit on any error

echo "Starting automated build process for pickles-update..."

# Function to increment PKGREL in PKGBUILD
increment_pkgrel() {
    echo "Incrementing PKGREL in PKGBUILD..."
    if grep -q '^pkgrel=' PKGBUILD; then
        current_rel=$(grep '^pkgrel=' PKGBUILD | sed 's/pkgrel=//')
        new_rel=$(( current_rel + 1 ))
        sed -i "s/^pkgrel=.*/pkgrel=$new_rel/" PKGBUILD
        echo "PKGREL incremented to $new_rel."
    else
        echo "Error: PKGREL not found in PKGBUILD."
        exit 1
    fi
}

# Function to generate checksums
generate_checksums() {
    echo "Generating checksums with makepkg -g..."
    makepkg -g > /dev/null 2>&1
    echo "Checksums verified."
}

# Function to revert checksums to SKIP
revert_checksums() {
    echo "Reverting checksums to SKIP in PKGBUILD..."
    sed -i "/^sha256sums=/,/)/c\sha256sums=('SKIP'\n            'SKIP'\n            'SKIP'\n            'SKIP'\n            'SKIP'\n            'SKIP'\n            'SKIP')" PKGBUILD
    echo "Checksums reverted."
}

# Function to build the package
build_package() {
    echo "Building package with makepkg -s..."
    makepkg -s
    echo "Package built successfully."
}

# Function to clean up old packages
cleanup_old_packages() {
    echo "Cleaning up old package files..."
    rm -f *.pkg.tar.zst
    echo "Old packages cleaned up."
}

# Main process
cleanup_old_packages
increment_pkgrel
generate_checksums
build_package
revert_checksums

echo "Build process completed successfully!"
echo "New package files:"
ls -la *.pkg.tar.zst
