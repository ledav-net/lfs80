#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

mv -v   /tools/bin/{ld,ld-old}
mv -v   /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
mv -v   /tools/bin/{ld-new,ld}
ln -svf /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld

gcc -dumpspecs | sed -e 's@/tools@@g'                   \
    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
    `dirname $(gcc --print-libgcc-file-name)`/specs

echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
rm -f dummy.c a.out

if [ "$(uname -m)" == "x86_64" ]; then
	echo "CHECK=[Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]"
else
	echo "CHECK=[Requesting program interpreter: /lib/ld-linux.so.2]"
fi

echo
pause "If it's not the same, hit CTRL+C now and recheck everything !"

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
echo
echo "CHECK:"
echo "/usr/lib/../lib/crt1.o succeeded"
echo "/usr/lib/../lib/crti.o succeeded"
echo "/usr/lib/../lib/crtn.o succeeded"
echo
pause "If it's not the same, hit CTRL+C now and recheck everything !"

grep -B1 '^ /usr/include' dummy.log
echo
echo "CHECK:"
echo "#include <...> search starts here:"
echo " /usr/include"
echo
pause "If it's not the same, hit CTRL+C now and recheck everything !"

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
echo
echo "CHECK:"
echo "SEARCH_DIR(\"=/tools/x86_64-pc-linux-gnu/lib64\")"
echo "SEARCH_DIR(\"/usr/lib\")                           <--- Must be correct"
echo "SEARCH_DIR(\"/lib\")                               <--- Must be correct"
echo "SEARCH_DIR(\"=/tools/x86_64-pc-linux-gnu/lib\");"
echo
pause "If it's not the same, hit CTRL+C now and recheck everything !"

grep "/lib.*/libc.so.6 " dummy.log
echo
echo "CHECK:"
echo "attempt to open /lib/libc.so.6 succeeded"
echo
pause "If it's not the same, hit CTRL+C now and recheck everything !"

grep found dummy.log
echo
echo "CHECK:"
echo "found ld-linux-x86-64.so.2 at /lib/ld-linux-x86-64.so.2"
echo
pause "If it's not the same, hit CTRL+C now and recheck everything !"

rm -f dummy.log
