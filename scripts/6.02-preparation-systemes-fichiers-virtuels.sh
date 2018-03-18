#!/bin/sh

. ./2.00-environ.sh || exit 1

if [ -e $LFS/proc/version ]; then
	show "${C_LR}LFS system already prepared !"
	exit 2
fi

# 6.2 Preparer les systemes de fichiers virtuels du noyau
sudo mkdir -vp $LFS/{dev,proc,sys,run}

# The /bin/sh is also needed by these scripts...
sudo mkdir -vp $LFS/bin

if [ ! -e $LFS/bin/bash -o -h $LFS/bin/bash ]; then
	sudo ln -svf /tools/bin/bash $LFS/bin
fi

sudo ln -svf bash $LFS/bin/sh

# 6.2.1 Creation des noeuds initiaux vers les peripheriques
[ -e $LFS/dev/console ] || sudo mknod -m 600 $LFS/dev/console c 5 1
[ -e $LFS/dev/console ] || sudo mknod -m 666 $LFS/dev/null    c 1 3

# 6.2.2 Monter et peupler /dev
sudo mount -v --bind /dev $LFS/dev

# 6.2.3 Monter les systemes de fichiers virtuels du noyau
sudo mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
sudo mount -vt proc   proc   $LFS/proc
sudo mount -vt sysfs  sysfs  $LFS/sys
sudo mount -vt tmpfs  tmpfs  $LFS/run

if [ -h $LFS/dev/shm ]; then
	sudo mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

# Needed by scripts to detect if in chroot'ed env...
touch $LFS/LFS_ROOT

echo
grep $(basename "$LFS") /proc/mounts  | column -t
