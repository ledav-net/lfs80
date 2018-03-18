#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

create_path /boot/grub
create_file /boot/grub/grub.cfg << "EOF"

set default=0
set timeout=10

insmod ext2
insmod ext4

menuentry "GNU/Linux, Linux 4.9.9-lfs-8.0-systemd" {
	set root=(hd0,1)
        linux /vmlinuz-4.9.9-lfs-8.0-systemd root=/dev/sda3 ro
}
EOF
