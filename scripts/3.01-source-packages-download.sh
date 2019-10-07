#!/bin/sh

. ./2.00-environ.sh || exit 1

stamp="$LFS_BLD/.stamp_downloaded"
[ -e $stamp ] && exit 0

[ -s $LFS_SRC/3.01-wget-list ] || {
	wget http://www.fr.linuxfromscratch.org/view/lfs-8.0-systemd-fr/wget-list -O $LFS_SRC/3.01-wget-list
	cd $LFS_SRC
	show "Patching 3.01-wget-list to fix dead urls ..."
	patch -b < $LFS_SRC/3.01-wget-list-ledav-dead-urls.patch
}
[ -s $LFS_SRC/3.01-md5sums ]   || wget http://www.fr.linuxfromscratch.org/view/lfs-8.0-systemd-fr/md5sums   -O $LFS_SRC/3.01-md5sums

wget -N --input-file=$LFS_SRC/3.01-wget-list --continue --directory-prefix=$LFS_SRC

cd $LFS_SRC
md5sum -c 3.01-md5sums && touch $stamp
