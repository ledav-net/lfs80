#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis kbd-2.0.4.tar.xz || exit 2

patch -Np1 < $LFS_SRC/kbd-2.0.4-backspace-1.patch

sed -i.orig 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
sed -i.orig 's/resizecons.8 //' docs/man/man8/Makefile.in

PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr --disable-vlock

make || exit 3
[ $RUNCHECK == true ] && make check
make install

mkdir -v            /usr/share/doc/kbd-2.0.4 
cp -R -v docs/doc/* /usr/share/doc/kbd-2.0.4
