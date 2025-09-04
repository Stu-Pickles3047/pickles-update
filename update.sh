#! /bin/bash
#PICKLES UPDATE
#Created by Stu-Pickles3407 for Pickles Linux
#Add website
#Add repo


#clear screen
clear

#Get OS and Save as Variable
os_name_raw=$(lsb_release -i | awk -F: '{print $2}' | xargs)
os_name=${os_name_raw,,} # Convert to lowercase

echo "      Welcome to $(tput setaf 5)Pickles Update$(tput sgr0)"
echo "      $(tput setaf 5)::>> $(tput sgr0)Updating: $os_name"
echo ""
sleep 2

# Check for -mirrors or -m argument
if [[ "$1" == "-mirrors" || "$1" == "-m" ]]; then
    echo "Rating mirrors..."
    rate-mirrors "$os_name" | sudo tee /etc/pacman.d/$os_name-mirrorlist
else
    echo "$(tput setaf 5)::>> $(tput sgr0)Mirror rating skipped. Run with -mirrors or -m to rate mirrors."
    echo ""
fi

echo "$(tput setaf 5)::>> $(tput sgr0)Running Paru to update $os_name"
echo ""
sleep 2
paru --skipreview --sudoloop -Syu

#FINISH
echo "-------------------------------------------"
echo "$(tput setaf 5)::>> $(tput sgr0)Done"
read -p "$(tput setaf 5)::>> $(tput sgr0)Do you wish to reboot? (y/N) " choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "$(tput setaf 5)::>> $(tput sgr0)Rebooting now..."
    reboot
else
    echo "$(tput setaf 5)::>> $(tput sgr0)Exiting without reboot."
    exit 0
fi
