#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis sed-4.4.tar.xz || exit 2

sed -i.orig 's/usr/tools/'       build-aux/help2man
sed -i.orig 's/panic-tests.sh//' Makefile.in

./configure --prefix=/usr --bindir=/bin

make || exit 3
make html

[ $RUNCHECK == true ] && make check

make install
install -d -m755           /usr/share/doc/sed-4.4
install -m644 doc/sed.html /usr/share/doc/sed-4.4
