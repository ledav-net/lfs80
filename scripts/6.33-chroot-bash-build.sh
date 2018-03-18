#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis bash-4.4.tar.gz || exit 2

patch -Np1 -i $LFS_SRC/bash-4.4-upstream_fixes-1.patch

./configure --prefix=/usr                    \
            --docdir=/usr/share/doc/bash-4.4 \
            --without-bash-malloc            \
            --with-installed-readline

make || exit 3

chown -Rv nobody .
su nobody -s /bin/bash -c "PATH=$PATH make tests"

make install
mv -vf /usr/bin/bash /bin

#exec /bin/bash --login +h
