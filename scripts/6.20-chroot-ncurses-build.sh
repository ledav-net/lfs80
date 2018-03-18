#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis ncurses-6.0.tar.gz || exit 2

sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in

./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec

make || exit 3
make install

mv -v /usr/lib/libncursesw.so.6* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so

for lib in ncurses form panel menu ; do
    rm -vf                    /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done

rm -vf                     /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so      /usr/lib/libcurses.so

mkdir -v       /usr/share/doc/ncurses-6.0
cp -v -R doc/* /usr/share/doc/ncurses-6.0

# Note
# Les instructions ci-dessus ne creent pas de bibliotheques Ncurses non-wide-
# character puisqu'aucun paquet installe par la compilation a partir des
# sources ne se lie a elles lors de l'execution. Pour le moment, les seules
# applications binaires sans sources connues qui se lient a Ncurses non-wide-
# character exigent la version 5. Si vous devez avoir de telles bibliotheques
# a cause d'une application disponible uniquement en binaire ou pour vous
# conformer a la LSB, compilez a nouveau le paquet avec les commandes suivan-
# tes (commentez la ligne ci-dessous):
exit 0

make distclean

./configure --prefix=/usr    \
            --with-shared    \
            --without-normal \
            --without-debug  \
            --without-cxx-binding \
            --with-abi-version=5 

make sources libs || exit 4

cp -av lib/lib*.so.5* /usr/lib
