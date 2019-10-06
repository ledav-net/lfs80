Linux From Scratch 8.0 - Build Scripts.

David De Grave <david@ledav.net>

This series of scripts can be started one by one or all at once.
The result is the complete LFS 8.0 built and can be converted to a fully
functional VirtualBox image ready to boot.

Well tested on Fedora 26 & 29.

To start the whole build, first double check the top lines of
"scripts/2.00-environ.sh" and change what you need. Normally, no changes
are needed... Then start the build by doing:

cd scripts && ./lfs-build

And see how far it builds ...

The most common problem are the dead links from the 3.01 script...
I usually have to change the patch

sources/3.01-wget-list-ledav-dead-urls.patch

to fix the urls... If it's the case for you, and fix some,
thanks to submit your changes ;-)
