#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis man-db-2.7.6.1.tar.xz || exit 2

./configure --prefix=/usr                        \
            --docdir=/usr/share/doc/man-db-2.7.6.1 \
            --sysconfdir=/etc                    \
            --disable-setuid                     \
            --enable-cache-owner=bin             \
            --with-browser=/usr/bin/lynx         \
            --with-vgrind=/usr/bin/vgrind        \
            --with-grap=/usr/bin/grap

make || exit 3
[ $RUNCHECK == true ] && make check
make install

sed -i.orig "s:man man:root root:g" /usr/lib/tmpfiles.d/man-db.conf
