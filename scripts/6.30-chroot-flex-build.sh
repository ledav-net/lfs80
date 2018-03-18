#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis flex-2.6.3.tar.gz || exit 2

HELP2MAN=/tools/bin/true \
./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.3

make || exit 3
[ $RUNCHECK == true ] && make check
make install

ln -s flex /usr/bin/lex
