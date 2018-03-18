#!/bin/sh

. ./2.00-environ.sh || exit 1

prerequis bzip2-1.0.6.tar.gz || exit 2

make || exit 2
make PREFIX=/tools install
