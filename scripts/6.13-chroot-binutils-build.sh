#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

expect -c "spawn ls"
echo
echo "CHECK:"
echo "spawn ls"
echo
pause "If it's not the same, hit CTRL+C now and recheck everything !"

prerequis binutils-2.27.tar.bz2 || exit 2

mkdir -v build
cd       build

../configure --prefix=/usr       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --with-system-zlib

make tooldir=/usr || exit 2
make -k check

echo
pause "If the above tests failed, hit CTRL+C and re-check everything !"

make tooldir=/usr install
