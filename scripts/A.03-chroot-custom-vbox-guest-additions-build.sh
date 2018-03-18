#!/bin/sh

. ./2.00-environ.sh || exit 1

VBOX_GUEST_ADDITIONS="/usr/share/virtualbox/VBoxGuestAdditions.iso"

# chroot detection
if [ ! -f /LFS_ROOT ]
then
	if [ ! -e $VBOX_GUEST_ADDITIONS ]
	then
		show "Cannot find VirtualBox Guest Additions ($VBOX_GUEST_ADDITIONS) ..."
		exit 2
	fi
	cdromdev=$(sudo losetup --show -f /usr/share/virtualbox/VBoxGuestAdditions.iso)
	chroot_exec $0 cdromdev=$cdromdev
else
	cdromdev=${1#cdromdev=}
	[ -z "$cdromdev" ] && { show "cdromdev[$cdromdev]'"; exit 3; }

	arch=$(uname -m)
	cdtmp=/tmp/cdrom.$$
	vbtmp=/tmp/vbox.$$
	dstdir="/opt/VBoxGuestAdditions-$arch"

	show "Cleaning old installation (if any) ..."
	rm -rf /usr/src/vboxguest-$arch \
		$dstdir \
		/lib/modules/4.9.9-lfs-custom-vbox-1/extra/vbox*

	show "Installing vbox guest additions ..."
	mkdir -vp $cdtmp $vbtmp
	mount $cdromdev $cdtmp || exit 4
	bash $cdtmp/VBoxLinuxAdditions.run --noexec --target $vbtmp || exit 5
	umount $cdtmp

	[ "$arch" == "x86_64" ] && targz=$(ls $vbtmp/*-amd64.*) || targz=$(ls $vbtmp/*-x86.*)

	echo "targz[$targz]"

	if [ ! -f "$targz" ]
	then
		show "Cannot find the sources of the VBox kernel modules !"
		show "Abording !!"
		exit 1
	fi

	show "Extracting kernel modules for $arch ..."
	mkdir -p $dstdir || exit 6
	cd $dstdir || exit 7
	tar xf $targz

	show "Building ..."
	cd src/*/ || exit 8
	make -C /usr/src/linux-4.9.9 M=$PWD modules

	show "Copying vbox modules ..."
	mkdir /lib/modules/4.9.9-lfs-custom-vbox-1/extra
	cp -v vboxguest/vboxguest.ko vboxsf/vboxsf.ko vboxvideo/vboxvideo.ko /lib/modules/4.9.9-lfs-custom-vbox-1/extra

	show "Resolving modules dependencies ..."
	depmod -a 4.9.9-lfs-custom-vbox-1
	ln -sf $dstdir/src/* /usr/src/vboxguest-$arch
fi

show "Cleaning up ..."
rm -rf $vbtmp $cdtmp
losetup -d $cdromdev
