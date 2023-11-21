# build script: killgmsfont

KGF=killgmsfont.zip

cp extension/dev_killgmsfont.sh extension/89_killgmsfont.sh
[ -f extension/$KGF ] && rm -v extension/$KGF
zip -m9 -j extension/$KGF extension/89_killgmsfont.sh

[ -f ../$KGF ] && rm -v ../$KGF
zip -r9 ../$KGF * -x "extension/*" build.sh
zipsigner ~/x509.pem ~/pk8 ../$KGF
