#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-only
# Copyright (c) 2022-present MrCarb0n <https://github.com/MrCarb0n/killgmsfont>
# build script: killgmsfont

set -x
set -e

MODVER=$(sed -n 's/^version=//p' module.prop)
VER="_$MODVER"
EXTZ="killgmsfont.zip"
OUTF="killgmsfont$VER.zip"
EXTZIP="$PWD/extension/$EXTZ"

# ── OhMyFont extension ─────────────────────────────────────────────
# The extension zip is unpacked into OMF's own folder, and OMF sources
# every *.sh it finds at the top level of that folder. The payload
# therefore goes into a subfolder, so OMF only ever sources the script
# below and leaves the rest alone.
STAGE=$(mktemp -d)
mkdir -p "$STAGE/svc"
sed "s/@VERSION@/$MODVER/" extension/dev_killgmsfont.sh > "$STAGE/89_killgmsfont.sh"
cp service.sh action.sh uninstall.sh "$STAGE/svc/"

# Remove existing signed file
[ -f "$EXTZIP" ] && rm -v "$EXTZIP"

# Package the extension script alongside the shared scripts.
# No -m here: it would delete the sources, including the tracked service.sh.
(cd "$STAGE" && zip -9 -r "$EXTZIP" 89_killgmsfont.sh svc)
rm -rf "$STAGE"

# ── Magisk module ──────────────────────────────────────────────────
# Remove existing signed file from the parent directory
[ -f ../$OUTF ] && rm -v ../$OUTF

# Package only the files Magisk needs, so nothing new can leak into a
# release. LICENSE and NOTICE travel with the module so the attribution
# they carry cannot be stripped by whoever repackages it.
zip -r9 ../$OUTF module.prop customize.sh uninstall.sh service.sh action.sh LICENSE NOTICE META-INF

# Sign the created zip file in place
zipsignerust sign --inplace ../$OUTF
