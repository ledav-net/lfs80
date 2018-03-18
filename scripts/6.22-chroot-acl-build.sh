#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis acl-2.2.52.src.tar.gz || exit 2

sed -i.orig -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
sed -i.orig    "s:| sed.*::g" test/{sbits-restore,cp,misc}.test
sed -i.orig -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" libacl/__acl_to_any_text.c

./configure --prefix=/usr    \
            --disable-static \
            --libexecdir=/usr/lib

make || exit 3

make install install-dev install-lib
chmod -v 755 /usr/lib/libacl.so
mv -v /usr/lib/libacl.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so
