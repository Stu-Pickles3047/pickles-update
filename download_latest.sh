#!/bin/bash

# This script fetches the URL of the latest .zst file from the specified GitHub repository's releases and downloads it.

# Set the GitHub repository API URL
REPO_API_URL="https://api.github.com/repos/Stu-Pickles3047/pickles-update/releases/latest"

echo "Fetching latest release information from GitHub..."

# Fetch the release information. The -s flag makes curl silent.
release_info=$(curl -s "$REPO_API_URL")

# Check if the curl command was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch release information. Please check your internet connection or the repository URL."
    exit 1
fi

# Use grep to find the line with "browser_download_url" and filter for the URL ending with ".zst".
# Then, use sed to extract just the URL string.
DOWNLOAD_URL=$(echo "$release_info" | grep '"browser_download_url":' | grep '.zst"' | head -n 1 | sed -e 's/.*"browser_download_url": "//' -e 's/".*//')

# Check if a download URL was found
if [ -z "$DOWNLOAD_URL" ]; then
    echo "Error: Could not find a .zst file in the latest release."
    exit 1
fi

# Extract the filename from the URL to use for the saved file.
FILENAME=$(basename "$DOWNLOAD_URL")

echo "Found latest .zst file: $FILENAME"
echo "Starting download..."

# Use wget to download the file, saving it with the correct filename.
wget -O "$FILENAME" "$DOWNLOAD_URL"

# Check if the download was successful
if [ $? -eq 0 ]; then
    echo "Download completed successfully! File saved as $FILENAME."
    echo "Installing Pickles Update"

    # Check if pickles-update is already installed using pacman's query command.
    # We redirect output to /dev/null because we only care about the exit code.
    if pacman -Q pickles-update > /dev/null 2>&1; then
        echo "Existing installation found. Removing..."
        # Remove the existing package using pacman -R (remove).
        sudo pacman -R pickles-update
    fi

    # Install the new package using pacman -U (upgrade/install local file).
    sudo pacman -U "$FILENAME"
    echo "Installation complete!"
else
    echo "Error: Download failed."
    exit 1
fi

exit 0