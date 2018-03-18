#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

create_file /etc/inputrc <<EOF
# Modifie par Chris Lynn <roryo@roryo.dynup.net>

# Permettre al'invite de commande d'aller a la ligne
set horizontal-scroll-mode Off

# Activer l'entree sur 8 bits
set meta-flag On
set input-meta On

# Ne pas supprimer le 8eme bit
set convert-meta Off

# Conserver le 8eme bit a l'affichage
set output-meta On

# none, visible ou audible
set bell-style visible

# Toutes les indications qui suivent font correspondre la sequence
# d'echappement contenue dans le 1er argument a la fonction
# specifique de readline
"\eOd": backward-word
"\eOc": forward-word

# Pour la console linux
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# pour xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# pour Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line
EOF
