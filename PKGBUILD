#PICKLES UPDATE
#Created by Stu-Pickles3407 for Pickles Linux
# Script Name: PKGBUILD
# Description: This PKGBUILD builds the pickles-update package for Arch Linux
# Author: Stu-Pickles3407  <stu.pickles.stu@gmail.com>
# Package Website: <https://github.com/Stu-Pickles3047/pickles-update>
# Created for Pickles Linux <https://stu-pickles3407.github.io/pickles-linux/>
# Usage: see pickles-update -h
# Dependencies
# - lsb-release
# - rate-mirrors
# - sudo
# - git
# - curl
# - man-db
#
# License: unlicensed <https://unlicense.org/UNLICENSE>
#
maintainer="Stu-Pickles3407 <stu.pickles.stu@gmail.com>"
# The name of the package.
pkgname="pickles-update"
# The version of the package. This should be updated for each release.
pkgver=4.0.0.dev1
# The release number of the package. Increment this for changes that don't affect the version.
pkgrel=0
# A brief description of the package.
pkgdesc="A wrapper for paru to update Pickles Linux distros"
# The URL for the project's homepage or repository.
url="https://github.com/Stu-Pickles3047/pickles-update"
# The license under which the package is distributed.
license=('Unlicense license')
# An array of architecture types that the package is compatible with.
# As this is a shell script, it's architecture independent.
arch=('any')
# The source files needed to build the package.
source=("pickles-update.sh" "rate-mirrors.sh" "query-updates.sh" "pacman-update.sh" "aur-update.sh" "pickles-update.1" "pupdate.conf")
# The checksums to verify the integrity of the source files.
sha256sums=('SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP')
# Dependencies required at runtime.
# 'paru' is the main dependency for the script.
# 'lsb-release' is used to get the OS name.
# 'rate-mirrors' is for the mirror rating feature.
# 'sudo' is used within the script.
# 'man-db' is required for the man page functionality.
depends=('lsb-release' 'rate-mirrors' 'sudo' 'git' 'curl' 'man-db')
# Build function to prepare the man page
build() {
  gzip pickles-update.1 -c > update.1.gz
}
# This function is where the package is assembled.
# The files are copied into the correct directory structure.
package() {
  # Create the directory for the scripts
  install -d "${pkgdir}/etc/pickles-linux/${pkgname}/"
  # Install the scripts
  install -m755 "pickles-update.sh" "${pkgdir}/etc/pickles-linux/${pkgname}/"
  install -m755 "rate-mirrors.sh" "${pkgdir}/etc/pickles-linux/${pkgname}/"
  install -m755 "query-updates.sh" "${pkgdir}/etc/pickles-linux/${pkgname}/"
  install -m755 "pacman-update.sh" "${pkgdir}/etc/pickles-linux/${pkgname}/"
  install -m755 "aur-update.sh" "${pkgdir}/etc/pickles-linux/${pkgname}/"
  # Install the config
  install -m644 "pupdate.conf" "${pkgdir}/etc/pickles-linux/${pkgname}/"
  # Install the man page
  install -D -m644 "update.1.gz" "${pkgdir}/usr/share/man/man1/pickles-update.1.gz"
  # Install symlinks for commands
  install -d "${pkgdir}/usr/bin"
  ln -s "/etc/pickles-linux/${pkgname}/pickles-update.sh" "${pkgdir}/usr/bin/pickles-update"
  ln -s "/etc/pickles-linux/${pkgname}/pickles-update.sh" "${pkgdir}/usr/bin/pupdate"
}
