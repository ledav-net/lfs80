#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

create_file /etc/shells <<EOF
/bin/sh
/bin/bash
EOF

cat >> /etc/profile << EOF
export PS1="\[\e[32m\][\[\e[01;${col}m\]\u\[\e[00;32m\]@\h \[\e[01;32m\]\W\[\e[00;32m\]]\$\[\e[m\] "
export PS2='> '
export PS4='+ '

loadkeys be-latin1
EOF
