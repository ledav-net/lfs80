#!/bin/sh

### CONFIG START

# Set the path where you want to install LFS (the futur 'root' partition)
# (the /script and /sources directories must be inside it:
# /foo/bar/{scripts,sources})
LFS_HOME=".."

# Set RUNCHECK to true if you want the scripts to execute all the tests the
# packages provides. Otherwise, only the mandatory ones are executed.
RUNCHECK=false

# Set NOQUESTION to true to trust everything and go from the begining to the
# end without asking anything (except for the root password when chroot'ing)
NOQUESTION=true

# If you don't set the following variables, you will be asked to fill them
# during the runtime
LFS_HOSTNAME=lfs
LFS_DOMAIN=lfsdomain
LFS_IPADDR=192.168.0.2
LFS_NETMASK=255.255.255.0
LFS_NETMASKB=24
LFS_GATEWAY=192.168.0.1
LFS_DNS=8.8.8.8

# If you prefer to use systemd's dhcp feature, set the following to true.
# (Note: If you do so, some of the above ip config become useless)
LFS_USE_DHCP=true

### CONFIG END

C_NO="\e[0m"
C_LW="\e[1;37m"
C_LR="\e[1;31m"
C_LG="\e[1;32m"

LFS=$(readlink -f "$LFS_HOME")

function show {
	local msg=$1
	echo -e "${C_LW}>>> ${C_NO}${msg}${C_NO}"
}

if [ ! -f /LFS_ROOT ]; then
	# Environment needed OUTSIDE chroot'ed env
	set +h
	umask 022
	export PATH=/tools/bin:/bin:/usr/bin
else
	# Environment needed INSIDE the chroot's end
	if [ ! -e /proc/version ]; then
		show "Virtual filesystems not mounted !!"
		show "Please start 6.02 first !"
		show "${C_LR}Aborting..."
		exit 10
	fi
	show "Setting ${C_LG}INSIDE${C_NO} chroot environment"
	umask 022
	export HOME=/root
	export PS1='\u@\s-\v \W \$ '
	export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin
	LFS=""
fi

export LFS_TGT=$(uname -m)-lfs-linux-gnu
export MAKEFLAGS="-j$(grep ^processor /proc/cpuinfo | wc -l)"
export LC_ALL=POSIX
export LFS_SRC=$LFS/sources
export LFS_BLD=$LFS/build
export LFS=${LFS:-/}

if [ "${0##*/}" != "2.02-prerequis.sh" ] && [ ! -e $LFS_BLD/.stamp_prepared ]; then
	show "${C_LR}Please run the prerequis first !!"
	exit 10
fi

function chroot_exec {
	local script=${1##/*/}
	shift
	sudo chroot "$LFS" /tools/bin/env -i \
		HOME=/root \
		TERM=$TERM \
		PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
		/tools/bin/bash -c "set +h; cd /scripts; exec ./$script ${@}"
	echo -e "${C_LR}<<<${C_LW} Leaving${C_NO} chroot env"
	exit
}

function pause {
	local msg=${1:-Waiting for key press (CTRL+C to abord) ...}
	if [ $NOQUESTION == true ]; then
		echo -e "$msg" "${C_LW}<< CONSIDERED OK >>${C_NO}"
	else
		read -p "$msg" || true
	fi
}

function create_path {
	local d=$1
	show "Creating directory ${C_LG}$d"
	mkdir -p "$d" || true
}

function create_file {
	local f=$1
	show "Generating ${C_LG}$f"
	rm -f "$f"
	cat > "$f"
}

function create_link {
	local dest=$1
	local link=$2
	show "Creating link ${C_LG}$link${C_NO} -> ${C_LW}$dest"
	rm -f "$link"
	ln -sf "$dest" "$link"
}

function prerequis {
	local pkg=$1
	local dir=${pkg%.tar.*}
	local dir=${dir%.src}

	cd $LFS_BLD
	rm -rf $dir
	tar xvf $LFS_SRC/$pkg
	cd $dir
}

[ -f /LFS_ROOT ] && unset chroot_exec || true

echo
echo "==========================================="
echo $0
echo "==========================================="
echo
