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

envsubst $vars < PKGBUILD.template > PKGBUILD

# Test build
makepkg -C

makepkg --printsrcinfo > .SRCINFO

git add PKGBUILD .SRCINFO
git commit -S -m "Update version to v$PKGVER"
GIT_SSH_COMMAND='ssh -i ../id_rsa_release' git push
