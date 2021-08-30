#!/bin/sh
set -e


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


rm_dir "./lib"
rm_dir "./include"
rm_dir "./bin"
rm_dir "./jsoncpp"
rm_dir "./jsoncpp-build"


#json dir exists?
if [ -d "./jsoncpp" ] ; then
    echo "***** jsoncpp already exists ***** " 
else
    echo " ***** jsoncpp does not exists, try to clone *****"
    git clone https://github.com/open-source-parsers/jsoncpp

    echo " ***** try to build  *****"
fi

#cmake test
command -v cmake &> /dev/null

if [ $? -eq 0 ] ; then
   echo " ***** use CMAKE*****"  
else
    echo " ***** CMAKE not installed *****"
    echo " brew  install cmake "
    exit
fi

make_dir "./jsoncpp-build"

cd jsoncpp-build

echo " ***** building *****"
export MACOSX_DEPLOYMENT_TARGET=11.5
cmake cmake -DCMAKE_CXX_FLAGS="-stdlib=libc++" ../jsoncpp
make

cd ..

make_dir "./lib"
make_dir "./include"
make_dir "./include/json"


cp -a ./jsoncpp-build/lib/. lib/
cp -a ./jsoncpp/include/json/. include/json/

rm_dir "./jsoncpp"
rm_dir "./jsoncpp-build"

echo "***** DONE ***** "