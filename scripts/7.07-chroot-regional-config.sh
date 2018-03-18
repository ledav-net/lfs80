#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

create_file /etc/locale.conf <<EOF
LANG="fr_BE.iso88591@euro"
EOF
