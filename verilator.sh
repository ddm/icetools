#!/usr/bin/env bash

pushd `dirname $0` > /dev/null
DIR=`pwd -P`
popd > /dev/null

UNAME_STR=`uname`

VERILATOR_VERSION="3.910"
ARCHIVE="verilator-$VERILATOR_VERSION.tgz"
DOWNLOAD_URL="https://www.veripool.org/ftp/$ARCHIVE"

if [ ! -d $DIR/verilator ]; then
  echo "Checking out verilator..."
  git clone git://github.com/ddm/verilator.git $DIR/verilator
else
  cd $DIR/verilator
  echo "Updating verilator..."
  git pull origin master || exit 1
fi

cd $DIR/verilator

echo "Building verilator..."
autoconf
./configure
make clean
make

echo "Installing verilator..."
if [[ "$UNAME_STR" == "Darwin" ]]; then
  make install
else
  sudo make install
fi
