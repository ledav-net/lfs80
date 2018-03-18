#!/bin/sh

. ./2.00-environ.sh || exit 1

prerequis bash-4.4.tar.gz || exit 2

./configure --prefix=/tools --without-bash-malloc

make || exit 2
[ $RUNCHECK == true ] && make tests
make install

ln -svf bash /tools/bin/sh
