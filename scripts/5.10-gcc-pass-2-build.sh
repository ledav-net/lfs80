#!/bin/sh

. ./2.00-environ.sh || exit 1

prerequis gcc-6.3.0.tar.bz2 || exit 2

# Fix for an error in gcc/ubsan.c:
patch -p1 < $LFS_SRC/gcc-6.3.0-ledav-fix-1.patch

cat gcc/limitx.h gcc/glimits.h gcc/limity.h > `dirname \
  $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h

for file in gcc/config/{linux,i386/linux{,64}}.h
do
        cp -uv "$file" "$file.orig"

        sed -e 's|/lib\(64\)\?\(32\)\?/ld|/tools&|g' \
            -e 's|/usr|/tools|g' $file.orig > $file

        echo >> $file
        echo '#undef STANDARD_STARTFILE_PREFIX_1' >> $file
        echo '#undef STANDARD_STARTFILE_PREFIX_2' >> $file
        echo '#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"' >> $file
        echo '#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file

        touch $file.orig
done

[ "$(uname -m)" == "x86_64" ] && \
        sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64

tar xvf $LFS_SRC/mpfr-3.1.5.tar.xz && mv -v mpfr-3.1.5 mpfr
tar xvf $LFS_SRC/gmp-6.1.2.tar.xz  && mv -v gmp-6.1.2  gmp
tar xvf $LFS_SRC/mpc-1.0.3.tar.gz  && mv -v mpc-1.0.3  mpc

mkdir -vp build
cd build

CC=$LFS_TGT-gcc                                    \
CXX=$LFS_TGT-g++                                   \
AR=$LFS_TGT-ar                                     \
RANLIB=$LFS_TGT-ranlib                             \
../configure                                       \
    --prefix=/tools                                \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --enable-languages=c,c++                       \
    --disable-libstdcxx-pch                        \
    --disable-multilib                             \
    --disable-bootstrap                            \
    --disable-libgomp

make && make install
ln -sv gcc /tools/bin/cc

echo ">>> Checking gcc validity..."
echo 'int main(){}' > dummy.c
cc dummy.c
readelf -l a.out | grep ': /tools'
rm -f dummy.c a.out

if [ "$(uname -m)" == "x86_64" ]; then
	echo "CHECK=[Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]"
else
	echo "CHECK=[Requesting program interpreter: /tools/lib/ld-linux.so.2]"
fi

echo
pause "If it's not the same, hit CTRL+C now !"
