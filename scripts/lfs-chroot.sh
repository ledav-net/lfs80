#!/bin/sh

. ./2.00-environ.sh || exit 1

if [ ! -e $LFS/proc/version ]; then
	./6.02-preparation-systemes-fichiers-virtuels.sh || exit 2
fi

exec sudo chroot "$LFS" /tools/bin/env -i \
    HOME=/root               \
    TERM="$TERM"             \
    PS1='\u:\w \$ '          \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h

exit 3
