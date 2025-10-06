# Pickles Update

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![project_license][license-shield]][license-url]

A modular script suite for managing system updates on Arch Linux-based distributions like Pickles Linux. This tool automates the update process, includes mirror rating, package querying, and separate handling for pacman and AUR updates, with a reboot prompt after successful updates.

## 🚀 Features

- **Modular Design**: Separate scripts for different operations (`pickles-update.sh`, `pacman-update.sh`, `aur-update.sh`, `query-updates.sh`, `rate-mirrors.sh`).
- **Automated Updates**: Updates packages from official repositories and AUR.
- **Mirror Rating**: Finds and uses the fastest mirrors for improved download speeds.
- **Configuration**: Customizable settings via `pupdate.conf`.
- **Reboot Prompt**: Asks for a reboot after updates to apply changes.

## 🛠 Built With

* ![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)

## 📦 Installation

To install `pickles-update`, build and install the package using `makepkg`:

```bash
git clone https://github.com/Stu-Pickles3047/pickles-update.git
cd pickles-update
makepkg -si
```

This will install the scripts to `/etc/pickles-linux/pickles-update/` and create symlinks in `/usr/bin`.

## 🛠 Usage

Once installed, use the `pickles-update` or `pupdate` commands.

- To run a standard system update:
  ```bash
  pickles-update
  # or
  pupdate
  ```

- To update and rate mirrors first:
  ```bash
  pickles-update -m
  # or
  pupdate --mirrors
  ```

- To install specific packages:
  ```bash
  pickles-update -S package1 package2
  ```

- Other options: See `pickles-update --help` for full usage.

## 📄 Man Page

A man page is included. View it with:

```bash
man pickles-update
```

## 📜 License

This project is licensed under the Unlicense.

<!-- MARKDOWN LINKS & IMAGES -->
[contributors-shield]: https://img.shields.io/github/contributors/Stu-Pickles3047/pickles-update.svg?style=for-the-badge
[contributors-url]: https://github.com/Stu-Pickles3047/pickles-update/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Stu-Pickles3047/pickles-update.svg?style=for-the-badge
[forks-url]: https://github.com/Stu-Pickles3047/pickles-update/network/members
[stars-shield]: https://img.shields.io/github/stars/Stu-Pickles3047/pickles-update.svg?style=for-the-badge
[stars-url]: https://github.com/Stu-Pickles3047/pickles-update/stargazers
[issues-shield]: https://img.shields.io/github/issues/Stu-Pickles3047/pickles-update.svg?style=for-the-badge
[issues-url]: https://github.com/Stu-Pickles3047/pickles-update/issues
[license-shield]: https://img.shields.io/github/license/Stu-Pickles3047/pickles-update.svg?style=for-the-badge
[license-url]: https://github.com/Stu-Pickles3047/pickles-update/blob/main/LICENSE
