#!/usr/bin/env bash

pushd `dirname $0` > /dev/null
DIR=`pwd -P`
popd > /dev/null

UNAME_STR=`uname`

if [ ! -d $DIR/iverilog ]; then
	echo "Checking out iverilog..."
	git clone git@github.com:steveicarus/iverilog.git $DIR/iverilog
else
	cd $DIR/iverilog
	echo "Updating iverilog..."
	git pull origin master || exit 1
fi

cd $DIR/iverilog

echo "Building iverilog..."
autoconf
./configure
make clean
make

echo "Installing iverilog..."
if [[ "$UNAME_STR" == "Darwin" ]]; then
	make install
else
	sudo make install
fi
