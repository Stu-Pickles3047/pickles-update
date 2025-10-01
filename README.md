# Pickles Update

## NO CURRENT BETA -- SEE MAIN or DEV


A user-friendly wrapper script for `paru` to manage system updates on Arch Linux-based distributions like Pickles Linux. This tool simplifies the update process, includes an optional mirror rating feature, and prompts for a reboot after a successful update.

## 🚀 Features

- **Automated Updates**: Runs `paru -Syu` to update all packages.
- **Mirror Rating**: Optionally finds and uses the fastest mirrors for your system using `rate-mirrors`.
- **Reboot Prompt**: Asks for a reboot after the update to ensure all changes, especially kernel updates, are applied correctly.

## 📦 Installation

To install `pickles-update`, you can use `paru` directly from this Git repository. This is the recommended method as it handles all dependencies automatically.

```bash
wget https://raw.githubusercontent.com/Stu-Pickles3047/pickles-update/main/download_latest.sh
chmod +x download_latest.sh
./download_latest.sh

```

 
## 📜 License

This project is licensed under the Unlicense
