#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis linux-4.9.9.tar.xz || exit 2

make mrproper
make defconfig

patch -p1 < $LFS_SRC/linux-4.9.9-ledav-config.patch

make || exit 3
make modules_install

cp -v arch/x86/boot/bzImage /boot/vmlinuz-4.9.9-lfs-8.0-systemd
cp -v System.map            /boot/system.map-4.9.9-lfs-8.0-systemd
cp -v .config               /boot/config-4.9.9-lfs-8.0-systemd

create_path /usr/share/doc/linux-4.9.9
cp -r Documentation/* /usr/share/doc/linux-4.9.9

create_path /etc/modprobe.d
chmod 755 /etc/modprobe.d

create_file /etc/modprobe.d/usb.conf <<EOF
install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true
EOF
