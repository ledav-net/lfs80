#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

mkdir -pv /{boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/libexec
mkdir -pv /usr/{,local/}share/man/man{1..8}

[ "$(uname -m)" == "x86_64" ] && mkdir -v /lib64

mkdir -v /var/{log,mail,spool}
ln -svf /run /var/run
ln -svf /run/lock /var/lock
mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}
