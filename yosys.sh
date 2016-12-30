#!/usr/bin/env bash

PYTHONVERSION=3.5
LIBFTDIVERSION=1.1

DIR=`dirname $0`
UNAME_STR=`uname`

if [ ! -d $DIR/yosys ]; then
	echo "Checking out yosys..."
	git clone https://github.com/cliffordwolf/yosys.git $DIR/yosys
else
	cd $DIR/yosys
	echo "Updating yosys..."
	git pull origin master
fi

cd $DIR/yosys

if [[ "$UNAME_STR" == "Darwin" ]]; then
	OLDPATH=$PATH
	PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
fi

echo "Building yosys-abc..."
make clean
make yosys-abc

echo "Building yosys..."
if [[ "$UNAME_STR" == "Darwin" ]] && hash brew 2>/dev/null; then
	PYTHONPATH=$(brew --prefix)/lib/python$PYTHONVERSION/site-packages/ make
else
	make
fi

echo "Installing yosys..."
if [[ "$UNAME_STR" == "Darwin" ]] && hash brew 2>/dev/null; then
	PYTHONPATH=$(brew --prefix)/lib/python$PYTHONVERSION/site-packages/ make install
else
	sudo make install
fi

if [[ "$UNAME_STR" == "Darwin" ]]; then
	PATH=$OLDPATH
fi
