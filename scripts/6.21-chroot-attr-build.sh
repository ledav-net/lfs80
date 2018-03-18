#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis attr-2.4.47.src.tar.gz || exit 2

sed -i.orig -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
sed -i.orig -e "/SUBDIRS/s|man[25]||g"          man/Makefile

./configure --prefix=/usr \
            --disable-static

make || exit 3

[ $RUNCHECK == true ] && make -j1 tests root-tests

make install install-dev install-lib
chmod -v 755 /usr/lib/libattr.so
mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so
