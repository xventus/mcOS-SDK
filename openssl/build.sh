#!/bin/sh
set -e


VERSIONDIR="openssl-1.1.1d"
VERSION="$VERSIONDIR.tar.gz"
# create directory
make_dir () {
    if [[ ! -e $1 ]]; then
        mkdir $1
    fi
}

# remove direcoty
rm_dir () {
    if [[ -e $1 ]]; then
        rm -Rf $1
    fi
}

# required system variable
if [ -z ${MacSdkRoot+x} ]; then 
    echo "***** VARIABLE MacSdkRoot NOT SET !!!! ***** "
    echo "touch .zshrc"
    echo "export MacSdkRoot=/Users/username/Documents/mcOS-SDK"
    exit 0 
fi


rm_dir "./lib"
rm_dir "./include"

rm_dir "./$VERSION"
curl -LO https://www.openssl.org/source/$VERSION
tar -xzvf $VERSION
cd $VERSIONDIR

perl ./Configure --prefix=$MacSdkRoot/openssl --openssldir=$MacSdkRoot/openssl no-ssl3 no-ssl3-method no-zlib darwin64-x86_64-cc enable-ec_nistp_64_gcc_128

make
make test
make install

cd ..


make_dir "./lib"
make_dir "./include"
make_dir "./include/openssl"


cp -a ./$VERSIONDIR/*.a lib/
cp -a ./$VERSIONDIR/*.dylib lib/
cp -a ./$VERSIONDIR/include/openssl/. include/openssl/

echo "***** DONE ***** "