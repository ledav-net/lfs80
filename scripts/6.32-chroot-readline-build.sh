#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis readline-7.0.tar.gz || exit 2

sed -i.old '/MV.*old/d'       Makefile.in
sed -i.old '/{OLDSUFF}/ c :' support/shlib-install

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/readline-7.0

make SHLIB_LIBS=-lncurses || exit 3
make SHLIB_LIBS=-lncurses install

mv -v /usr/lib/lib{readline,history}.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so

install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-7.0
