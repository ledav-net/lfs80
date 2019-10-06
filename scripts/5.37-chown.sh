#!/bin/sh
. ./2.00-environ.sh || exit 1

sudo chown -vR root:root $LFS/tools

cd $LFS
mv tools toolchain-$LFS_TGT
tar c toolchain-$LFS_TGT/ | pixz | pv --name toolchain-$LFS_TGT.tar.xz > toolchain-$LFS_TGT.tar.xz
mv toolchain-$LFS_TGT tools
