#!/bin/sh

. ./2.00-environ.sh || exit 1

prerequis binutils-2.27.tar.bz2 || exit 2

mkdir -vp build
cd build

$(which time) --format="\nSBU = %E (mm:ss.cc)" $(which bash) - <<EOT
../configure --prefix=/tools            \
             --with-sysroot=$LFS        \
             --with-lib-path=/tools/lib \
             --target=$LFS_TGT          \
             --disable-nls              \
             --disable-werror

make

[ "$(uname -m)" == "x86_64" ] && \
	mkdir -v /tools/lib && \
		ln -sv lib /tools/lib64

make install
EOT

echo
pause "Note this value and hit enter ..."
