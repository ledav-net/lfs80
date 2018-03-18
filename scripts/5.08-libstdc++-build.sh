#!/bin/sh

. ./2.00-environ.sh || exit 1

prerequis gcc-6.3.0.tar.bz2 || exit 2

mkdir -vp build-stdc++
cd build-stdc++

../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --prefix=/tools                 \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-threads     \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/6.3.0

make && make install
