#!/bin/sh

. ./2.00-environ.sh || exit 1

prerequis gettext-0.19.8.1.tar.xz || exit 2

cd gettext-tools

EMACS="no" ./configure --prefix=/tools --disable-shared

make -C gnulib-lib
make -C intl pluralx.c
make -C src msgfmt
make -C src msgmerge
make -C src xgettext

cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
