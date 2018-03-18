#!/bin/sh

if [ "$1" == "--chroot" ]; then
	# Already logged by lfs-build outside chroot
	log=/dev/null
else
	log=../build/lfs-build.log
fi

(
echo
echo "***" $(date)
echo

[ -e ../build/.stamp_prepared   ] || ./2.02-prerequis.sh || exit 1
[ -e ../build/.stamp_downloaded ] || ./3.01-source-packages-download.sh || exit 2

. ./2.00-environ.sh

if [ "$1" == "--chroot" ]; then
	files=$(ls {5..9}.* | grep -- '-chroot-' | sort)
else
	files=$(ls {5..9}.* | sort)
fi

for script in $files
do
	stamp="$LFS_BLD/.stamp_$script"

	if [ ! -e $stamp ]
	then
		if [ "$1" != "--chroot" ] && [[ $script =~ .*-chroot-.* ]]
		then
			show "Switching to ${C_LR}chroot ${C_NO}environment ..."
			# catchsegv is needed for the script 6.71-* who makes the process
			# crashing without any reasons...
			catchsegv sudo chroot "$LFS" /tools/bin/env -i \
				HOME=/root \
				TERM=$TERM \
				PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
				/tools/bin/bash -c "set +h; cd /scripts; exec ./${0##/*/} --chroot"
			echo -e "${C_LR}<<<${C_LW} Leaving${C_NO} chroot env"
			continue
		fi
		pause ">>> execute $script ? CTRL+C to abord ... <<< "
		./$script; ret=$?
		if [ $ret -ne 0 ]
		then
			show "${C_LR}$script error $ret !"
			show "${C_LW}Please check before continuing ..."
			exit 3
		fi
		# If using touch here, it crashes script 6.71-*
		echo -n > $stamp
	else
		[ "$1" == "--chroot" ] || show "${C_LG}$script ${C_NO}already done. Skipping ..."
	fi
done

) | tee -a $log
