#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

create_file /etc/fstab <<EOF
# file system  mount-point  type     options             dump  fsck
#                                                              order
LABEL=root     /            ext4     defaults            1     1
LABEL=boot     /boot        ext4     defaults            1     1
LABEL=swap     swap         swap     pri=1               0     0
EOF
