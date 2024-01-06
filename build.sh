#!/system/bin/sh
# build script: killgmsfont

set -x

VER="_$(sed -n 's/^version=\(.*\)/\1/p' module.prop)"
EXTZ="killgmsfont.zip"
OUTF="killgmsfont$VER.zip"
OUTZ="killgmsfont$VER-signed.zip"

# Copy and modify extension script
cp extension/dev_killgmsfont.sh extension/89_killgmsfont.sh

# Remove existing signed file
[ -f extension/$EXTZ ] && rm -v extension/$EXTZ

# Create and sign the zip file
zip -m9 -j extension/$EXTZ extension/89_killgmsfont.sh

# Remove existing signed file from the parent directory
[ -f ../$OUTF ] && rm -v ../$OUTF

# Create a zip file excluding the extension directory and the build script
zip -r9 ../$OUTF * -x "extension/*" "build.sh"

# Sign the created zip file
zipsigner ~/x509.pem ~/pk8 ../$OUTF ../$OUTZ

# Rename the signed file back to the original filename
[ -f ../$OUTF ] && rm ../$OUTF; mv ../$OUTZ ../$OUTF
