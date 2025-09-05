# Maintainer of the package.
# Your username and email.
# The user's username is Pickles3407
# The user's email is not provided, so a generic example is used.
maintainer="Stu-Pickles3407 <stu.pickles.stu@gmail.com>"
# The name of the package.
pkgname="pickles-update"
# The version of the package. This should be updated for each release.
pkgver=b2.0.0
# The release number of the package. Increment this for changes that don't affect the version.
pkgrel=2
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
source=("update.sh" "update.1.gz")
# The checksums to verify the integrity of the source files.
# You will generate these later with 'makepkg -g'.
#sha256sums=('SKIP' 'SKIP')
# Dependencies required at runtime.
# 'paru' is the main dependency for the script.
# 'lsb-release' is used to get the OS name.
# 'rate-mirrors' is for the mirror rating feature.
# 'sudo' is used within the script.
# 'man-db' is required for the man page functionality.
depends=('paru' 'lsb-release' 'rate-mirrors' 'sudo' 'man-db')
# This function is where the package is assembled.
# The files are copied into the correct directory structure.
package() {
  # Create the directory for the executable script.
  install -D -m755 "update.sh" "${pkgdir}/usr/bin/update"
  # Create the directory for the man page.
  install -D -m644 "update.1.gz" "${pkgdir}/usr/share/man/man1/update.1.gz"
}

sha256sums=('44885f5ee682ad647c92a192813186c8250bba45bce2cb252715314d578e7d00'
            '0c887263ca49da621ea2a51f18322aeef4719ebe6a2c76eb255677653f925113')
sha256sums=('44885f5ee682ad647c92a192813186c8250bba45bce2cb252715314d578e7d00'
            '0c887263ca49da621ea2a51f18322aeef4719ebe6a2c76eb255677653f925113')
