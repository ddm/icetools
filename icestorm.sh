#!/usr/bin/env bash

# See http://www.clifford.at/icestorm/

pushd `dirname $0` > /dev/null
DIR=`pwd -P`
popd > /dev/null

PYTHONVERSION=$(python3 --version 2>&1 | egrep -o '3\.[0-9]+')
UNAME_STR=`uname`

if [ ! -d $DIR/icestorm ]; then
	echo "Checking out icestorm..."
	git clone https://github.com/cliffordwolf/icestorm.git $DIR/icestorm
	cd $DIR/icestorm/
else
	cd $DIR/icestorm
	echo "Updating icestorm..."
	git reset HEAD --hard
	git pull origin master
fi

cd $DIR/icestorm

echo "Building icestorm..."
if [[ "$UNAME_STR" == "Darwin" ]] && hash brew 2>/dev/null; then
	PYTHONPATH=$(brew --prefix)/lib/python$PYTHONVERSION/site-packages/ make clean
	PYTHONPATH=$(brew --prefix)/lib/python$PYTHONVERSION/site-packages/ make
else
	make clean
	make
fi

echo "Installing icestorm..."
if [[ "$UNAME_STR" == "Darwin" ]]; then
	make install
else
	sudo make install
fi
