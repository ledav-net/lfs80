#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

# Workaround: The last find command "core dump" I don't know why...
#  This is to avoid an infinite loop if started from the lfs-build script.
#  As far as I can see, this have no impacts except maybe some files not
#  stripped as expected...
touch $LFS_BLD/.stamp_$(basename $0)
#
/tools/bin/find /usr/lib -type f -name \*.a \
   -exec /tools/bin/strip --strip-debug {} \+

/tools/bin/find {,/usr}/lib -type f -name \*.so* \
   -exec /tools/bin/strip --strip-unneeded {} \+

/tools/bin/find /{bin,sbin} /usr/{bin,sbin,libexec} -type f \
   -exec /tools/bin/strip --strip-all {} \+

exit 0
