#!/usr/bin/env bash

# See http://www.clifford.at/icestorm/

PYTHONVERSION=3.5

pushd `dirname $0` > /dev/null
DIR=`pwd -P`
popd > /dev/null

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

if [[ "$UNAME_STR" == "Darwin" ]]; then
	echo "Patching icestorm..."
	patch -p1 << EOF
	diff --git a/iceprog/iceprog.c b/iceprog/iceprog.c
	index 1288fe3..d9f589f 100644
	--- a/iceprog/iceprog.c
	+++ b/iceprog/iceprog.c
	@@ -25,6 +25,7 @@
	 #define _GNU_SOURCE

	 #include <ftdi.h>
	+#include <stdlib.h>
	 #include <stdio.h>
	 #include <stdint.h>
	 #include <stdbool.h>
EOF
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
