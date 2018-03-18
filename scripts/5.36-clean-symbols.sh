#!/bin/sh
. ./2.00-environ.sh || exit 1

strip --strip-debug /tools/lib/*
/usr/bin/strip --strip-unneeded /tools/{,s}bin/*
sudo rm -rvf /tools/{,share}/{info,man,doc}
