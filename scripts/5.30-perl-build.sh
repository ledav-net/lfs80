#!/bin/sh
. ./2.00-environ.sh || exit 1

prerequis perl-5.24.1.tar.bz2 || exit 2

sh Configure -des -Dprefix=/tools -Dlibs=-lm

make || exit 3

cp -v perl cpan/podlators/scripts/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/5.24.1
cp -Rv lib/* /tools/lib/perl5/5.24.1
