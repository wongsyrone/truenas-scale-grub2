#!/bin/bash -ex
. ./version.sh

# from origin get signing templates
mkdir -p my-debian-orig
wget http://deb.debian.org/debian/pool/main/g/grub2/grub2_$VERSION-$REVISION.debian.tar.xz
tar xf grub2_$VERSION-$REVISION.debian.tar.xz -C my-debian-orig
rm grub2_$VERSION-$REVISION.debian.tar.xz

# source structure
GRUB_EFI_AMD64_SIGNED_REVISION=1
wget http://deb.debian.org/debian/pool/main/g/grub-efi-amd64-signed/grub-efi-amd64-signed_$GRUB_EFI_AMD64_SIGNED_REVISION+$VERSION+$REVISION.tar.xz
tar xvf grub-efi-amd64-signed_$GRUB_EFI_AMD64_SIGNED_REVISION+$VERSION+$REVISION.tar.xz
rm grub-efi-amd64-signed_$GRUB_EFI_AMD64_SIGNED_REVISION+$VERSION+$REVISION.tar.xz
mv source-template/debian .
rm -rf source-template

# increment version as already built grub2 incremented it
# source (2.99-8) -> deb (2.99-9)
# scale_build/packages/build.py
dch -D unstable -c changelog -b -M "align version with already built grub2"

# modify debian/changelog and debian/rules
mkdir -p my-sign-template
cp my-debian-orig/debian/signing-template/*.in my-sign-template
# read info from truenas changelog
./my-sign.generate grub-efi-amd64 changelog
