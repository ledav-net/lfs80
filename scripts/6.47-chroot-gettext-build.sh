#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis gettext-0.19.8.1.tar.xz || exit 2

sed -i.orig '/^TESTS =/d'            gettext-runtime/tests/Makefile.in && \
sed -i.orig 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.19.8.1

make || exit 3
[ $RUNCHECK == true ] && make check
make install

chmod -v 0755 /usr/lib/preloadable_libintl.so
