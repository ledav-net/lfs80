#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis gmp-6.1.2.tar.xz || exit 2

./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.1.2

make || exit 3
make html

make check 2>&1 | tee gmp-check-log

awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log

echo
echo "CHECK:"
echo "190"
echo
pause "If it's not the same, hit CTRL+C now and recheck everything !"

make install
make install-html
