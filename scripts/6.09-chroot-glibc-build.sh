#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis glibc-2.25.tar.xz

patch -Np1 -i $LFS_SRC/glibc-2.25-fhs-1.patch

case $(uname -m) in
    x86)	ln -vfs ld-linux.so.2 /lib/ld-lsb.so.3
		;;
    x86_64)	ln -vfs ../lib/ld-linux-x86-64.so.2 /lib64
		ln -vfs ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3
    		;;
esac

mkdir -v build
cd build

../configure --prefix=/usr                   \
             --enable-kernel=2.6.32          \
             --enable-obsolete-rpc           \
             --enable-stack-protector=strong \
             libc_cv_slibdir=/lib

make || exit 2
make check

show  "Some tests may fail ! Check the book to know what is ok or not..."
pause "Hit CTRL+C if needed and re-check everything... Or continue by pressing ENTER"

touch /etc/ld.so.conf

make install

cp -v ../nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd

install -v -Dm644 ../nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf
install -v -Dm644 ../nscd/nscd.service  /lib/systemd/system/nscd.service

mkdir -pv /usr/lib/locale
localedef -i cs_CZ      -f UTF-8        cs_CZ.UTF-8
localedef -i de_DE      -f ISO-8859-1   de_DE
localedef -i de_DE@euro -f ISO-8859-15  de_DE@euro
localedef -i de_DE      -f UTF-8        de_DE.UTF-8
localedef -i en_GB      -f UTF-8        en_GB.UTF-8
localedef -i en_HK      -f ISO-8859-1   en_HK
localedef -i en_PH      -f ISO-8859-1   en_PH
localedef -i en_US      -f ISO-8859-1   en_US
localedef -i en_US      -f UTF-8        en_US.UTF-8
localedef -i es_MX      -f ISO-8859-1   es_MX
localedef -i fa_IR      -f UTF-8        fa_IR
localedef -i fr_BE      -f ISO-8859-1   fr_BE
localedef -i fr_BE@euro -f ISO-8859-15  fr_BE@euro
localedef -i fr_BE      -f UTF-8        fr_BE.UTF-8
localedef -i fr_FR      -f ISO-8859-1   fr_FR
localedef -i fr_FR@euro -f ISO-8859-15  fr_FR@euro
localedef -i fr_FR      -f UTF-8        fr_FR.UTF-8
localedef -i it_IT      -f ISO-8859-1   it_IT
localedef -i it_IT      -f UTF-8        it_IT.UTF-8
localedef -i ja_JP      -f EUC-JP       ja_JP
localedef -i ru_RU      -f KOI8-R       ru_RU.KOI8-R
localedef -i ru_RU      -f UTF-8        ru_RU.UTF-8
localedef -i tr_TR      -f UTF-8        tr_TR.UTF-8
localedef -i zh_CN      -f GB18030      zh_CN.GB18030

# Alternatives to the above localedefs ...
# make localedata/install-locales

# 6.9.2. Configurer Glibc
# 6.9.2.1. Ajout de nsswitch.conf 

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

# 6.9.2.2. Ajout des donnees timezone

tar -xf $LFS_SRC/tzdata2016j.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward pacificnew systemv; do
    zic -L /dev/null   -d $ZONEINFO       -y "sh yearistype.sh" ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
    zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO

ln -sfv /usr/share/zoneinfo/Europe/Brussels /etc/localtime
echo "export TZ=Europe/Brussels" >> /etc/profile

# 6.9.2.3. Configurer le chargeur dynamique

mkdir -pv /etc/ld.so.conf.d

cat > /etc/ld.so.conf << EOF
# Start of /etc/ld.so.conf
/usr/local/lib
/opt/lib

# Ajout d'un répertoire include
include /etc/ld.so.conf.d/*.conf
EOF

ldconfig
