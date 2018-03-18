#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis psmisc-22.21.tar.gz || exit 2

./configure --prefix=/usr

make || exit 3
make install

mv -v /usr/bin/fuser   /bin
mv -v /usr/bin/killall /bin
