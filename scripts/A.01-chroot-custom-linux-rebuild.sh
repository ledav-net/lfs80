#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

show "Uncompressing into /usr/src/linux-4.9.9 ..."
cd /usr/src
rm -rf linux-4.9.9
tar xvf $LFS_SRC/linux-4.9.9.tar.xz
cd linux-4.9.9 || exit 2

show "Cleaning up ..."
make mrproper

show "Starting from defconfig ..."
make defconfig

show "Patching config (customizing) ..."
patch -p1 < $LFS_SRC/linux-4.9.9-ledav-vbox-config.patch

create_file /sbin/installkernel << EOF
#!/bin/sh

rm -fv \$INSTALL_PATH/*-\$KERNELRELEASE

cp -av \$KBUILD_IMAGE \$INSTALL_PATH/vmlinuz-\$KERNELRELEASE
cp -av System.map    \$INSTALL_PATH/system.map-\$KERNELRELEASE
cp -av .config       \$INSTALL_PATH/config-\$KERNELRELEASE
EOF
chmod 755 /sbin/installkernel

show "Building ..."
make || exit 3

show "Installing new imges ..."
make install
make modules_install
