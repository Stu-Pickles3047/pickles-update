# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.1.0] - 2025-10-06

### Added
- Modular script architecture: Split functionality into separate scripts (`pickles-update.sh`, `aur-update.sh`, `pacman-update.sh`, `query-updates.sh`, `rate-mirrors.sh`) for better maintainability and flexibility.
- Configuration file `pupdate.conf` for customizable settings.
- New installation structure: Scripts installed in `/etc/pickles-linux/pickles-update/` with symlinks in `/usr/bin` for `pickles-update` and `pupdate` commands.
- Build function in PKGBUILD to compress man page.
- Support for git and curl dependencies instead of paru.
- Updated man page with new options and descriptions.
- `build.sh` script to automate package building, including PKGREL increment, checksum generation, package building, cleanup of old packages, and reversion of checksums to 'SKIP' for development.

### Changed
- Removed dependency on `paru`; now uses `git` and `curl` for AUR operations.
- Restructured package installation: No longer installs single `update` command, replaced with modular scripts and symlinks.
- Updated PKGBUILD to handle multiple source files with SKIP checksums for development.
- Modified man page to reflect new script functionality and options.
- Changed package description to remove reference to paru wrapper.

### Removed
- Single `update.sh` script replaced by modular scripts.
- `download_latest.sh` script.
- `update-man.install` file.
- Direct installation of `update` command in `/usr/bin`.
- Dependency on `paru`.

### Fixed
- Improved error handling and OS detection in scripts.