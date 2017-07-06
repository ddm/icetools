#!/usr/bin/env bash

pushd `dirname $0` > /dev/null
DIR=`pwd -P`
popd > /dev/null

UNAME_STR=`uname`

if [ ! -d $DIR/arachne-pnr ]; then
	echo "Checking out arachne-pnr..."
	git clone https://github.com/cseed/arachne-pnr.git $DIR/arachne-pnr
else
	cd $DIR/arachne-pnr
	echo "Updating arachne-pnr..."
	git pull origin master || exit 1
fi

cd $DIR/arachne-pnr

echo "Building arachne-pnr..."
make clean
make

echo "Installing arachne-pnr..."
if [[ "$UNAME_STR" == "Darwin" ]]; then
	make install
fi
if [[ "$UNAME_STR" == "Linux" ]]; then
	sudo make install
fi
