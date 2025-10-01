#! /bin/bash
#PICKLES UPDATE
#Created by Stu-Pickles3407 for Pickles Linux
#Add https://github.com/Stu-Pickles3047/pickles-update

variable=$1

#clear screen
clear
#!/bin/bash

# --- Function to display version ---
show_version() {
    version=$(pacman -Qi pickles-update | grep Version | awk '{print $3}')
    echo "$(tput setaf 5)Pickles Update$(tput sgr0) Version: $(tput setaf 2)$version$(tput sgr0)"
}

# --- Function to display help ---
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

This script performs pickles-related updates.

Options:
  -v, --version  Display the script version.
  -h, --help     Display this help message.

man update also provides help
EOF
}

# --- Function to backup mirrorlist ---
backup_mirrorlist() {
    echo "$(tput sgr0)Backing up Mirrorlist for $(tput setaf 5)$os_pretty_name$(tput sgr0)"

    if [ -f /etc/pacman.d/mirrorlist.bak ]; then
        sudo rm /etc/pacman.d/mirrorlist.bak
    fi
    if [ -f /etc/pacman.d/chaotic-mirrorlist.bak ]; then
        sudo rm /etc/pacman.d/chaotic-mirrorlist.bak
    fi

    sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
    sudo cp /etc/pacman.d/chaotic-mirrorlist /etc/pacman.d/chaotic-mirrorlist.bak
}


# --- Function to rate mirrors ---
rate_mirrors() {
# Check for -mirrors or -m argument
if [[ "$variable" == "-mirrors" || "$variable" == "-m" ]]; then

    echo "$(tput setaf 5)::>> $(tput sgr0)Rating $os_name and Chaotic-aur mirrors for $(tput setaf 5)$os_pretty_name $(tput sgr0) "
    backup_mirrorlist
    sleep 2
    rate-mirrors "$os_name" | tee >(grep "Server =" | { echo "#Pickles Update "; echo "#Mirrorlist"; echo "#for $os_pretty_name "; echo ""; cat; } | sudo tee /etc/pacman.d/mirrorlist) &
    rate-mirrors "chaotic-aur" | tee >(grep "Server =" | { echo "#Pickles Update "; echo "#Chaotic Mirrorlist"; echo "#for $os_pretty_name "; echo ""; cat; } | sudo tee /etc/pacman.d/chaotic-mirrorlist) &
    wait
    echo "$(tput setaf 5)::>> $(tput sgr0)Mirror rating complete."
    echo ""
else
    echo "$(tput setaf 5)::>> $(tput sgr0)Mirror rating skipped. Run with -mirrors or -m to rate mirrors."
    echo ""
fi
}
# --- Main script logic ---

# Check for arguments and handle them
if [[ "$variable" == "-v" || "$variable" == "--version" ]]; then
    show_version
    exit 0
elif [[ "$variable" == "-h" || "$variable" == "--help" ]]; then
    show_help
    exit 0
fi


#Get OS and Save as Variable
os_name_raw=$(lsb_release -i | awk -F: '{print $2}' | xargs)
os_name=${os_name_raw,,} # Convert to lowercase
os_pretty_name=$(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '"')

echo "      Welcome to $(tput setaf 5)Pickles Update$(tput sgr0)"
echo "      $(tput setaf 5)::>> $(tput sgr0)Updating: $os_pretty_name"
echo ""
sleep 2

rate_mirrors

echo ""
echo "$(tput setaf 5)::>> $(tput sgr0)Running Paru to update $os_pretty_name "
echo ""
sleep 2
paru --skipreview --sudoloop -Syu

#FINISH

echo "-------------------------------------------"
echo "$(tput setaf 5)::>> $(tput sgr0)Done"
echo "$(tput setaf 5)::>> $(tput sgr0)Total of $(tput setaf 5)$(pacman -Qq | wc -l)$(tput sgr0) Packages installed"
echo ""
read -p "$(tput setaf 5)::>> $(tput sgr0)Do you wish to reboot? (y/N) " choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "$(tput setaf 5)::>> $(tput sgr0)Rebooting now..."
    sleep 2
    reboot
else
    echo "$(tput setaf 5)::>> $(tput sgr0)Exiting without reboot."
    exit 0
fi
