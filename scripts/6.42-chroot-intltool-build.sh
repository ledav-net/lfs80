#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis intltool-0.51.0.tar.gz || exit 2

sed -i.orig 's:\\\${:\\\$\\{:' intltool-update.in

./configure --prefix=/usr

make || exit 3
[ $RUNCHECK == true ] && make check
make install

install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
