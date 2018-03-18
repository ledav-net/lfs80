#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis systemd-232.tar.xz || exit 2

sed -i.orig "s:blkid/::" $(grep -rl "blkid/blkid.h")

sed -i.orig \
    -e 's@test/udev-test.pl @@'  \
    -e 's@test-copy$(EXEEXT) @@' \
    Makefile.in

create_file config.cache <<EOF
KILL=/bin/kill
MOUNT_PATH=/bin/mount
UMOUNT_PATH=/bin/umount
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include/blkid"
HAVE_LIBMOUNT=1
MOUNT_LIBS="-lmount"
MOUNT_CFLAGS="-I/tools/include/libmount"
cc_cv_CFLAGS__flto=no
SULOGIN="/sbin/sulogin"
XSLTPROC="/usr/bin/xsltproc"
EOF

./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var     \
            --config-cache           \
            --with-rootprefix=       \
            --with-rootlibdir=/lib   \
            --enable-split-usr       \
            --disable-firstboot      \
            --disable-ldconfig       \
            --disable-sysusers       \
            --without-python         \
            --with-default-dnssec=no \
            --docdir=/usr/share/doc/systemd-232

make LIBRARY_PATH=/tools/lib || exit 3
make LD_LIBRARY_PATH=/tools/lib install

rm -rfv /usr/lib/rpm

for tool in runlevel reboot shutdown poweroff halt telinit; do
    ln -sfv ../bin/systemctl /sbin/${tool}
done
ln -sfv ../lib/systemd/systemd /sbin/init

systemd-machine-id-setup

sed -i.orig "s:minix:ext4:g" src/test/test-path-util.c
[ $RUNCHECK == true ] && make LD_LIBRARY_PATH=/tools/lib -k check

exit 0
