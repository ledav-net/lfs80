#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis findutils-4.6.0.tar.gz || exit 2

sed -i.orig 's/test-lock..EXEEXT.//' tests/Makefile.in

./configure --prefix=/usr --localstatedir=/var/lib/locate

make || exit 3
[ $RUNCHECK == true ] && make check
make install

mv -v /usr/bin/find /bin
sed -i.orig 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb
