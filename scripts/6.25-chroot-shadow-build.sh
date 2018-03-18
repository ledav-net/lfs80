#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis shadow-4.4.tar.xz || exit 2

sed -i.orig 's/groups$(EXEEXT) //' src/Makefile.in

find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

sed -i.orig -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
            -e 's@/var/spool/mail@/var/mail@' etc/login.defs

patch -p1 < $LFS_SRC/shadow-4.4-useradd-shell-buffix.patch

sed -i.orig 's/1000/999/'          etc/useradd
sed -i.orig -e '47 d' -e '60,65 d' libmisc/myname.c

./configure --sysconfdir=/etc --with-group-name-max-length=32

make || exit 3
make install

mv -v /usr/bin/passwd /bin

# 6.25.2. Configuration de Shadow 
pwconv
grpconv

cat /etc/default/useradd
echo
pause ">>> If something have to be change here, please do it when the script is finished..."
