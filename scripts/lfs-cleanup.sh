#!/bin/sh

. ./2.00-environ.sh || exit 1

read -p "This will ERASE EVERYTHING built until now ! Hit CTRL+C to abord ..."

show "Unmounting vitual filestystems ..."
./lfs-umount-vfs.sh

show "Cleaning everything ..."
sudo rm -rf ../build/* ../build/.stamp* ../tools/*
folders=$(ls -1d ../* | grep -vE "build|sources|scripts|tools|toolchain")
sudo rm -rf /tools $folders
