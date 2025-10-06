#! /bin/bash
#PICKLES UPDATE
#Created by Stu-Pickles3407 for Pickles Linux
# Script Name: pickles-update.sh
# Description: This script manages package updates and installations within pickles-update
# Author: Stu-Pickles3407  <stu.pickles.stu@gmail.com>
# Package Website: <https://github.com/Stu-Pickles3047/pickles-update>
# Created for Pickles Linux <https://stu-pickles3407.github.io/pickles-linux/>
# Usage: see pickles-update -h
# Dependencies
# - pacman
# - git
# - curl
# - makepkg
#
# License: unlicensed <https://unlicense.org/UNLICENSE>
#
# Prevent running as root or with sudo
if [[ "$EUID" -eq 0 ]]; then
    echo "$(tput setaf 1)ERROR:$(tput sgr0) Do not run $(tput setaf 5)Pickles Update$(tput sgr0) as root or with sudo."
    exit 1
fi

# Load configuration
DEFAULT_CONFIG="/etc/pickles-linux/pickles-update/pupdate.conf"
USER_CONFIG="$HOME/.config/pickles-linux/pickles-update/pupdate.conf"

# Source default config
if [[ -f "$DEFAULT_CONFIG" ]]; then
    source "$DEFAULT_CONFIG"
fi

# Source user config if exists
if [[ -f "$USER_CONFIG" ]]; then
    source "$USER_CONFIG"
fi

# Set directories
mkdir -p "$aur_build_dir"
mkdir -p "$log_file_save_location"

# Script directory
SCRIPT_DIR="/etc/pickles-linux/pickles-update"

# Export for sub-scripts
export aur_build_dir
export log_file_save_location
export keep_aur_build_cache

# Clean old logs if enabled
if [[ "$keep_log" == "true" ]]; then
    find "$log_file_save_location" -name "pickles-update.log*" -mtime +$keep_log_length -delete 2>/dev/null || true
fi

# --- Function to display version ---
show_version() {
    version=$(pacman -Qi pickles-update | grep Version | awk '{print $3}')
    echo "$(tput setaf 5)Pickles Update$(tput sgr0) Version: $(tput setaf 2)$version$(tput sgr0)"
}

# --- Function to display help ---
show_help() {
cat << EOF
Usage:
    pickles-update [OPTIONS]
    pickles-update -S <packages>
    pupdate [OPTIONS]
    pupdate -S <packages>

Update or install packages on Pickles Linux, similar to pacman/paru.

Options:
    -v, --version      Display the script version.
    -h, --help         Display this help message.
    -m, -mirrors       Rate mirrors before updating.
    -S <packages>      Install packages (official or AUR).
    -y                 Refresh package databases.
    -u                 Upgrade packages.
    -q                 Quiet mode.
    --noconfirm        Do not ask for confirmation.

If no options are provided, defaults to -Syu (update).

Aliases:
    pickles-update, pupdate

See also: man pickles-update, man pupdate
EOF
}

# --- Function to backup mirrorlist ---
backup_mirrorlist() {
    echo "$(tput sgr0)Backing up Mirrorlist for $(tput setaf 5)$os_pretty_name$(tput sgr0)"

    if [ -f /etc/pacman.d/mirrorlist.bak ]; then
        sudo rm /etc/pacman.d/mirrorlist.bak
    fi

    sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
}

#Function To rate mirrors
rate_mirrors() {
if [[ "$RATE_MIRRORS" == "true" ]]; then
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
else
    echo "$(tput setaf 5)::>> $(tput sgr0)Mirror rating skipped. Run with -mirrors or -m to rate mirrors."
    echo ""
fi
}


# --- Main script logic ---

# Parse options
RATE_MIRRORS=false
PACMAN_OPTS=""
QUIET=false
NOCONFIRM=false
PACKAGES=""

while [[ $# -gt 0 ]]; do
    # Handle combined options
    if [[ "$1" == "-Syu" ]]; then
        MODE="update"
        PACMAN_OPTS="-S -y -u"
        shift
        continue
    fi
    case $1 in
        -v|--version) show_version; exit 0 ;;
        -h|--help) show_help; exit 0 ;;
        -m|--mirrors) RATE_MIRRORS=true ;;
        --noconfirm) NOCONFIRM=true ;;
        -S) shift; PACKAGES="$*"; break ;;
        -y) PACMAN_OPTS="${PACMAN_OPTS}-y " ;;
        -u) PACMAN_OPTS="${PACMAN_OPTS}-u " ;;
        -q) QUIET=true ;;
        *) show_help; exit 1 ;;
    esac
    shift
done

# If packages specified, install mode, else update mode
if [[ -n "$PACKAGES" ]]; then
    MODE="install"
    # Sync database for install
    PACMAN_OPTS="-y"
else
    MODE="update"
    # Default to -Syu for update
    PACMAN_OPTS="-S -y -u"
fi

# Set quiet flag for pacman if -q used
if $QUIET; then
    PACMAN_OPTS="${PACMAN_OPTS}-q "
fi

# Export NOCONFIRM for sub-scripts
export NOCONFIRM

# Clear screen after parsing (not for help/version)
clear

#Get OS and Save as Variable
os_name_raw=$(lsb_release -i | awk -F: '{print $2}' | xargs)
os_name=${os_name_raw,,} # Convert to lowercase
os_pretty_name=$(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '"')
export os_pretty_name

echo "       Welcome to $(tput setaf 5)Pickles Update$(tput sgr0)"
echo "       $(tput setaf 5)::>> $(tput sgr0)Updating: $os_pretty_name"
echo ""
sleep 2

if [[ "$MODE" == "install" ]]; then
    # Install mode
    echo "$(tput setaf 5)::>> $(tput sgr0)Installing packages: $PACKAGES"

    official=""
    aur=""
    for pkg in $PACKAGES; do
        if pacman -Si "$pkg" >/dev/null 2>&1; then
            official="$official $pkg"
        else
            aur="$aur $pkg"
        fi
    done

    CONFIRM=""
    if [[ "$NOCONFIRM" == "true" ]]; then
        CONFIRM="--noconfirm"
    fi

    if [[ -n "$official" ]]; then
        echo "$(tput setaf 5)::>> $(tput sgr0)Installing official packages: $official"
        if ! sudo pacman -S $CONFIRM $official; then
            echo "$(tput setaf 1)ERROR:$(tput sgr0) Failed to install official packages."
            exit 1
        fi
    fi

    if [[ -n "$aur" ]]; then
        echo "$(tput setaf 5)::>> $(tput sgr0)Installing AUR packages: $aur"
        mkdir -p "$aur_build_dir" || { echo "$(tput setaf 1)ERROR:$(tput sgr0) Failed to create AUR build directory."; exit 1; }
        LOG_FILE="$log_file_save_location/pickles-update.log"
        for pkg in $aur; do
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
            if makepkg -si $CONFIRM >> "$LOG_FILE" 2>&1; then
                echo "$(tput setaf 5)::>> $(tput sgr0)$pkg installed successfully."
                echo "$(date): Installed $pkg" >> "$LOG_FILE"
            else
                echo "$(tput setaf 1)ERROR:$(tput sgr0) Failed to build/install $pkg."
                echo "$(date): Failed to install $pkg" >> "$LOG_FILE"
            fi
        done
    fi

    echo "$(tput setaf 5)::>> $(tput sgr0)Installation complete."

else
    # Update mode
    # Check for -mirrors or -m argument and run mirror rating
    if [[ "$RATE_MIRRORS" == "true" ]]; then
        "$SCRIPT_DIR/rate-mirrors.sh"
    fi

    "$SCRIPT_DIR/query-updates.sh"

    if [[ $? -ne 0 ]]; then
        exit 0
    fi

    if ! $NOCONFIRM; then
        read -p "$(tput setaf 5)::>> $(tput sgr0)Proceed with update? [Y/n] " choice
        if [[ "$choice" == "n" || "$choice" == "N" ]]; then
            echo "$(tput setaf 5)::>> $(tput sgr0)Aborted."
            exit 0
        fi
    fi

    echo ""
    echo "$(tput setaf 5)::>> $(tput sgr0)Starting system update (Official Repositories only)... "
    echo ""
    sleep 2

    # Run pacman update and AUR update
    if "$SCRIPT_DIR/pacman-update.sh" $PACMAN_OPTS && "$SCRIPT_DIR/aur-update.sh"
    then
        echo "-------------------------------------------"
        echo "$(tput setaf 5)::>> $(tput sgr0)Done"
        echo "$(tput setaf 5)::>> $(tput sgr0)Total of $(tput setaf 5)$(pacman -Qq | wc -l)$(tput sgr0) Packages installed"
        echo ""
        read -p "$(tput setaf 5)::>> $(tput sgr0)Do you wish to reboot? (y/N) " choice
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            # Use a safer, more standard shutdown command
            echo "$(tput setaf 5)::>> $(tput sgr0)Rebooting now..."
            sleep 2
            sudo systemctl reboot
        else
            echo "$(tput setaf 5)::>> $(tput sgr0)Exiting without reboot."
            exit 0
        fi
    else
        echo "-------------------------------------------"
        echo "$(tput setaf 1)ERROR:$(tput sgr0) The update failed for $os_pretty_name."
        echo "Please check the log at $HOME/.cache/pickles-update.log for details."
        exit 1
    fi
fi
