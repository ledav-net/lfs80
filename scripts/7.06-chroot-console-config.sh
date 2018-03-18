#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

create_file /etc/vconsole.conf <<EOF
KEYMAP="be"
FONT="be"
EOF

# ledav.net: Makes root access passwordless from the console
passwd -d root
