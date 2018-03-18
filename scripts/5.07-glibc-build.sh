#!/bin/sh

. ./2.00-environ.sh || exit 1

prerequis glibc-2.25.tar.xz || exit 2

mkdir -vp build
cd build

../configure                             \
      --prefix=/tools                    \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=2.6.32             \
      --with-headers=/tools/include      \
      libc_cv_forced_unwind=yes          \
      libc_cv_c_cleanup=yes

make && make install

echo ">>> Checking tools ..."
echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep ': /tools'
rm -f dummy.c a.out

if [ "$(uname -m)" == "x86_64" ]; then
	echo "CHECK=[Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]"
else
	echo "CHECK=[Requesting program interpreter: /tools/lib/ld-linux.so.2]"
fi

echo
pause "If it's not the same, hit CTRL+C now !"
