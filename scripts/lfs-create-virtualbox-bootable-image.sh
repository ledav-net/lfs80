#!/bin/sh

[ $UID -eq 0 ] || exec sudo -s $0 "$@"

. ./2.00-environ.sh || exit 1

show "Switched to ${C_LR}ROOT ACCESS"

[ -z "$LFS_HOSTNAME" ] && read -p "Host name: " LFS_HOSTNAME

export PATH+=":/usr/sbin"

for tool in VBoxManage rsync sfdisk partprobe mkfs.ext2 mkfs.ext4 mkswap losetup
do
	if ! which $tool &> /dev/null
	then
		show "Sorry but the '${C_LR}$tool${C_NO}' tool is required !"
		exit 1
	fi
done

disk="disk0-${LFS_HOSTNAME}.vdi"
disksz=0
[ -e "$disk.raw" ] && disksz=$(du -k --apparent-size "$disk.raw" | cut -f1)

if [ $disksz -eq 0 ]; then
	show "Creating a ${C_LW}20 Gb ${C_NO}bootable disk image ${C_LW}$disk.raw${C_NO} ..."
	dd if=/dev/zero of="$disk.raw" bs=2MiB count=10000 status=progress
elif [ $disksz -lt 5242880 ]; then
	show "File $disk.raw already exist and is too small to be used !"
	show "Remove it or create a new one with at least 5 GiB."
	exit 1
else
	show "Reusing the existing raw image file ${C_LW}$disk.raw${C_NO} ..."
fi

show "Partitioning ..."
dev=$(losetup -f --show "$disk.raw")

if [ -z "$dev" ]; then
	show "$C_LR Loop device creation error !"
	exit 2
fi

# Reset the MBR & Partitions
for d in $(ls $dev* | sort -r); do
	dd if=/dev/zero of=$d bs=1MiB count=4 &> /dev/null
done

sfdisk "$dev" <<EOF
label: dos
- +1GiB L *
- +1GiB S -
- -     L -
EOF

show "Done. Re-reading partitions ..."
partprobe "$dev"

if [ ! -e "${dev}p1" -o ! -e "${dev}p2" -o ! -e "${dev}p3" ]
then
	show "$C_LR Something went wrong when partitioning !"
	exit 2
fi

show "Formatting ..."
mkfs.ext2 -m0 -L boot "${dev}p1"
mkfs.ext4     -L root "${dev}p3"
mkswap        -L swap "${dev}p2"

show "Mounting ${dev}p3 as root partition ..."
mkdir -pv root
if ! mount "${dev}p3" root
then
	show "Error mounting root !"
	exit 2
fi

show "Mounting ${dev}p1 as boot partition ..."
mkdir -pv root/boot
if ! mount "${dev}p1" root/boot
then
	show "Error mounting root/boot !"
	exit 2
fi

show "Populating root image with $LFS ..."
rsync -ax --stats \
	--exclude=/build \
	--exclude=/scripts \
	--exclude=/sources \
	--exclude=/tools \
	--exclude=/LFS_ROOT \
	$LFS/ root/

show "Installing grub into Master Boot Record of ${C_LW}$dev${C_NO} ..."
set -e

mount -v --bind  /dev   root/dev
mount -vt proc   proc   root/proc
mount -vt sysfs  sysfs  root/sys

chroot root /sbin/grub-install --boot-directory=/boot "$dev"

show "Unmounting everything ..."
umount -v root/sys
umount -v root/proc
umount -v root/dev

umount root/boot
umount root

rmdir root

losetup -d "$dev"

set +e

show "Syncing disks ..."
sync

show "Creating virtual disk (vdi) from raw image ..."
VBoxManage convertfromraw --format VDI "$disk.raw" "$disk"

chmod 666 $disk*

#[ $? -eq 0 ] && rm -f "$disk.raw"
show "Successfully created ${C_LG}$disk${C_NO} !"
