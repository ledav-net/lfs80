#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

# 7.2.1.1. Configuration en IP statique
[ -z $LFS_HOSTNAME ] && read -p "Host name:    " LFS_HOSTNAME
[ -z $LFS_DOMAIN   ] && read -p "Domain name:  " LFS_DOMAIN
[ -z $LFS_IPADDR   ] && read -p "Ip address:   " LFS_IPADDR
[ -z $LFS_NETMASKB ] && read -p "Netmask bits: " LFS_NETMASKB
[ -z $LFS_GATEWAY  ] && read -p "Gateway IP:   " LFS_GATEWAY
[ -z $LFS_DNS      ] && read -p "DNS:          " LFS_DNS

if [ $LFS_USE_DHCP == true ]; then
	create_file /etc/systemd/network/10-eth0-dhcp.network << EOF
[Match]
Name=e*

[Network]
DHCP=yes
EOF
else
	create_file /etc/systemd/network/10-eth0-static.network << EOF
[Match]
Name=e*

[Network]
Address=$LFS_IPADDR/$LFS_NETMASKB
Gateway=$LFS_GATEWAY
DNS=$LFS_DNS
Domains=$LFS_DOMAIN
EOF
fi

# 7.2.2.2. Configuration de resolv.conf statique
if [ $LFS_USE_DHCP == true ]; then
	# Use the dhcp config
	create_link /run/systemd/resolve/resolv.conf /etc/resolv.conf
else
	create_file /etc/resolv.conf << EOF
domain     $LFS_DOMAIN
nameserver $LFS_DNS
EOF
fi

# 7.2.3. Configurer le nom d'hote du systeme
create_file /etc/hostname << EOF
$LFS_HOSTNAME
EOF

# 7.2.4. Personnaliser le fichier /etc/hosts
create_file /etc/hosts << EOF
127.0.0.1	localhost.localdomain localhost
::1		localhost.localdomain localhost

127.0.0.1	$LFS_HOSTNAME.$LFS_DOMAIN $LFS_HOSTNAME
EOF
