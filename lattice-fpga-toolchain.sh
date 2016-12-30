#!/usr/bin/env bash

# See http://www.clifford.at/icestorm/

DIR=`dirname $0`
UNAME_STR=`uname`

echo "Installing dependencies..."
if [[ "$UNAME_STR" == "Darwin" ]] && hash brew 2>/dev/null; then
	brew update && brew install python3 libftdi0 libffi autoconf bison gawk gnu-sed graphviz xdot mercurial
fi
if [[ "$UNAME_STR" == "Linux" ]] && hash apt-get 2>/dev/null; then
	sudo apt-get install -y build-essential clang bison flex libreadline-dev gawk tcl-dev libffi-dev git mercurial graphviz xdot pkg-config python python3 libftdi-dev
fi

echo "┌──────────┐"
echo "│ icestorm │"
echo "└──────────┘"
$DIR/icestorm.sh

echo "┌─────────────┐"
echo "│ arachne-pnr │"
echo "└─────────────┘"
$DIR/arachne-pnr.sh

echo "┌───────┐"
echo "│ yosys │"
echo "└───────┘"
$DIR/yosys.sh

echo "┌──────────┐"
echo "│ iverilog │"
echo "└──────────┘"
$DIR/iverilog.sh
