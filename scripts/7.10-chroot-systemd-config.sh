#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

# 7.10.2. Desactiver l'effacement de l'ecran durant le demarrage
create_path /etc/systemd/system/getty@tty1.service.d
create_file /etc/systemd/system/getty@tty1.service.d/noclear.conf <<EOF
[Service]
TTYVTDisallocate=no
EOF

# 7.10.3. Desactiver tmpfs pour /tmp
#create_link /dev/null /etc/systemd/system/tmp.mount
