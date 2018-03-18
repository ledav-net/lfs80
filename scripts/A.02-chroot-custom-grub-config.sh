#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

cd /boot/grub || exit 1

show "Patching grub.cfg (customizing) ..."
patch -p1 < $LFS_SRC/grub-ledav-custom-vbox-1.patch
