#!/bin/sh

. ./2.00-environ.sh || exit 1

prerequis linux-4.9.9.tar.xz || exit 2

make mrproper

make INSTALL_HDR_PATH=dest headers_install && \
	cp -rv dest/include/* /tools/include
