#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis iproute2-4.9.0.tar.xz || exit 2

sed -i.orig /ARPD/d Makefile
sed -i.orig 's/arpd.8//' man/man8/Makefile
rm -v doc/arpd.sgml

sed -i.orig 's/m_ipt.o//' tc/Makefile

make -j1 || exit 3
make DOCDIR=/usr/share/doc/iproute2-4.9.0 install
