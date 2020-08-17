#!/bin/bash
set -e
vars='$PKGVER:$POLKADOT_SHA256:$POLKADOT_ASC_SHA256'
PKGVER="${1/#v/}" # Remove 'v' prefix
baseurl="https://github.com/paritytech/polkadot/releases/download/v$PKGVER"
POLKADOT_SHA256="$(curl -L "$baseurl/polkadot" | sha256sum -b | cut -d' ' -f 1)"
POLKADOT_ASC_SHA256="$(curl -L "$baseurl/polkadot.asc" | sha256sum | cut -d' ' -f 1)"
export PKGVER
export POLKADOT_SHA256
export POLKADOT_ASC_SHA256

# Receive security@parity.io pubkey
export GNUPGHOME=/tmp/gnupg-release
mkdir $GNUPGHOME
gpg --keyserver keyserver.ubuntu.com --recv-keys 9D4B2B6EB8F97156D19669A9FF0812D491B96798

# Update PKGBUILD file
envsubst $vars < PKGBUILD.template > PKGBUILD

# Test build
makepkg -C

makepkg --printsrcinfo > .SRCINFO
