#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis XML-Parser-2.44.tar.gz || exit 2

perl Makefile.PL

make || exit 3
[ $RUNCHECK == true ] && make test
make install
