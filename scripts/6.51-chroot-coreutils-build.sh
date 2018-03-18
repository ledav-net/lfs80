#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis coreutils-8.26.tar.xz || exit 2

patch -Np1 < $LFS_SRC/coreutils-8.26-i18n-1.patch

sed -i.orig '/test.lock/s/^/#/' gnulib-tests/gnulib.mk

FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime

FORCE_UNSAFE_CONFIGURE=1 make || exit 3

[ $RUNCHECK == true ] && {
	make NON_ROOT_USERNAME=nobody check-root
	echo "dummy:x:1000:nobody" >> /etc/group
	chown -Rv nobody . 
	su nobody -s /bin/bash \
          -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
	sed -i.orig '/dummy/d' /etc/group
}

make install

mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8

sed -i.orig "s/\"1\"/\"8\"/1" /usr/share/man/man8/chroot.8

mv -v /usr/bin/{head,sleep,nice,test,[} /bin
