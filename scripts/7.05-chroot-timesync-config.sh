#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

# 7.5.1. Synchronisation reseau du temps
[ -z $LFS_GATEWAY ] && read -p "Gateway IP: " LFS_GATEWAY

create_link /dev/null /etc/systemd/system/systemd-timedated.service

GW=$(echo $LFS_GATEWAY | sed "s/\./\\\./g")
sed -E "s/#(NTP.*)/\1${GW}/; s/#(FallbackNTP=.*)/\1/" -i.orig /etc/systemd/timesyncd.conf
