#!/bin/sh
. ./2.00-environ.sh || exit 1

sudo chown -vR root:root $LFS/tools

cd $LFS
mv tools toolchain-$LFS_TGT
tar cvjf toolchain-$LFS_TGT.tar.bz toolchain-$LFS_TGT
mv toolchain-$LFS_TGT tools
