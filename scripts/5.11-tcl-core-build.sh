#!/bin/sh

. ./2.00-environ.sh || exit 1

cd $LFS_BLD
rm -rf tcl8.6.6
tar xvf $LFS_SRC/tcl-core8.6.6-src.tar.gz
cd tcl8.6.6/unix

./configure --prefix=/tools

make || exit 2
TZ=UTC make test
make install

chmod -v u+w /tools/lib/libtcl8.6.so
make install-private-headers

ln -sv tclsh8.6 /tools/bin/tclsh
