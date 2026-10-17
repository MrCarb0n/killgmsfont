#!/system/bin/sh
# SPDX-License-Identifier: GPL-3.0-only
# Copyright (c) 2022-present MrCarb0n <https://github.com/MrCarb0n/killgmsfont>
# build script: killgmsfont

set -x
set -e

VER="_$(sed -n 's/^version=\(.*\)/\1/p' module.prop)"
EXTZ="killgmsfont.zip"
OUTF="killgmsfont$VER.zip"

# Copy and modify extension script
cp extension/dev_killgmsfont.sh extension/89_killgmsfont.sh

# Remove existing signed file
[ -f extension/$EXTZ ] && rm -v extension/$EXTZ

# Package the extension script alongside the shared service script.
# No -m here: it would delete the sources, including the tracked service.sh.
zip -9 -j extension/$EXTZ extension/89_killgmsfont.sh service.sh

# Remove existing signed file from the parent directory
[ -f ../$OUTF ] && rm -v ../$OUTF

# Package only the files Magisk needs, so nothing new can leak into a release
zip -r9 ../$OUTF module.prop customize.sh uninstall.sh service.sh META-INF

# Sign the created zip file in place
zipsignerust sign --inplace ../$OUTF
