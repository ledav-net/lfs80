#!/bin/sh

. ./2.00-environ.sh || exit 1

stamp="$LFS_BLD/.stamp_prepared"
[ -e $stamp ] && exit 0

rmdir $LFS/tools &> /dev/null
mkdir -pv $LFS_SRC $LFS_BLD $LFS/tools
sudo ln -sfv $LFS/tools /

# Packages needed for building LFS on the host system
sudo dnf install binutils bzip2 coreutils diffutils findutils \
	gawk gcc glibc grep gzip m4 make patch perl sed tar \
	texinfo xz

touch $stamp
