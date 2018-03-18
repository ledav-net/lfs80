#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

[ -z $LFS_HOSTNAME ] && read -p "Host name: " LFS_HOSTNAME

create_file /etc/os-release << "EOF"
NAME="Linux From Scratch"
VERSION="8.0-systemd"
ID=lfs
PRETTY_NAME="Linux From Scratch 8.0-systemd"
VERSION_CODENAME="$LFS_DOMAIN"
EOF

echo 8.0-systemd > /etc/lfs-release

create_file /etc/lsb-release << "EOF"
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="8.0-systemd"
DISTRIB_CODENAME="$LFS_DOMAIN"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF
