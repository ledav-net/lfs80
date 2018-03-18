#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis bc-1.06.95.tar.bz2 || exit 2

patch -Np1 -i $LFS_SRC/bc-1.06.95-memory_leak-1.patch

./configure --prefix=/usr           \
            --with-readline         \
            --mandir=/usr/share/man \
            --infodir=/usr/share/info

make || exit 3

if [ $RUNCHECK == true ]; then
	echo "quit" | ./bc/bc -l Test/checklib.b
fi

make install
