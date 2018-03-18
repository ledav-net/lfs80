#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

cd $LFS_BLD
rm -rf vim80
tar xvf $LFS_SRC/vim-8.0.069.tar.bz2
cd vim80 || exit 2

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

./configure --prefix=/usr

make || exit 3
[ $RUNCHECK == true ] && make -j1 test
make install

ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done

ln -sv ../vim/vim80/doc /usr/share/doc/vim-8.0.069

# 6.69.2. Configuration de Vim

create_file /etc/vimrc << EOF
" Begin /etc/vimrc

set nocompatible
set backspace=2
set mouse=r
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif


" End /etc/vimrc
EOF
