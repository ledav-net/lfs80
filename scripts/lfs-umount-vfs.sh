#!/bin/sh

. ./2.00-environ.sh || exit 1 

grep -E "^[a-z]+ $LFS.*" /proc/mounts | cut -f 2 -d' ' | sort -r | xargs -r -- sudo umount -v
