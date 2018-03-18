#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis gcc-6.3.0.tar.bz2 || exit 2

patch -p1 < $LFS_SRC/gcc-6.3.0-ledav-fix-1.patch

[ "$(uname -m)" == "x86_64" ] && \
	sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64

mkdir -v build
cd       build

SED=sed                               \
../configure --prefix=/usr            \
             --enable-languages=c,c++ \
             --disable-multilib       \
             --disable-bootstrap      \
             --with-system-zlib

make || exit 3
ulimit -s 32768
make -k check
../contrib/test_summary

make install
ln -sv ../usr/bin/cpp /lib
ln -sv gcc /usr/bin/cc

install -v -dm755 /usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/6.3.0/liblto_plugin.so /usr/lib/bfd-plugins/

echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log

readelf -l a.out | grep ': /lib'
echo "CHECK:"
echo "      [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]"
echo
pause "If it's not the same, hit CTRL+C now !"

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
echo "CHECK:"
echo "/usr/lib/gcc/x86_64-pc-linux-gnu/6.3.0/../../../../lib/crt1.o succeeded"
echo "/usr/lib/gcc/x86_64-pc-linux-gnu/6.3.0/../../../../lib/crti.o succeeded"
echo "/usr/lib/gcc/x86_64-pc-linux-gnu/6.3.0/../../../../lib/crtn.o succeeded"
echo
pause "If it's not the same, hit CTRL+C now and recheck everything !"

grep -B4 '^ /usr/include' dummy.log
echo "CHECK:"
echo "#include <...> search starts here:"
echo " /usr/lib/gcc/x86_64-pc-linux-gnu/6.3.0/include"
echo " /usr/local/include"
echo " /usr/lib/gcc/x86_64-pc-linux-gnu/6.3.0/include-fixed"
echo " /usr/include"
echo
pause "If it's not the same, hit CTRL+C now and recheck everything !"

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
echo "CHECK:"
echo "SEARCH_DIR(\"/usr/x86_64-pc-linux-gnu/lib64\")"
echo "SEARCH_DIR(\"/usr/local/lib64\")"
echo "SEARCH_DIR(\"/lib64\")"
echo "SEARCH_DIR(\"/usr/lib64\")"
echo "SEARCH_DIR(\"/usr/x86_64-pc-linux-gnu/lib\")"
echo "SEARCH_DIR(\"/usr/local/lib\")"
echo "SEARCH_DIR(\"/lib\")"
echo "SEARCH_DIR(\"/usr/lib\");"
echo
pause "If it's not the same, hit CTRL+C now and recheck everything !"

grep "/lib.*/libc.so.6 " dummy.log
echo "CHECK:"
echo "attempt to open /lib/libc.so.6 succeeded"
echo
pause "If it's not the same, hit CTRL+C now and recheck everything !"

grep found dummy.log
echo "CHECK:"
echo "found ld-linux-x86-64.so.2 at /lib/ld-linux-x86-64.so.2"
echo
pause "If it's not the same, hit CTRL+C now and recheck everything !"

rm -v dummy.c a.out dummy.log

mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
