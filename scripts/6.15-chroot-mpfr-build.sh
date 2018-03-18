#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis mpfr-3.1.5.tar.xz || exit 2

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-3.1.5

make || exit 3
make html
make check
echo
pause "If this test suite doesn't succeed, hit CTRL+C now and recheck everything !"

make install
make install-html
