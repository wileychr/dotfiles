#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$THIS_DIR/global_vars.sh"

set -e
set -o verbose

SRC_CHECKOUT="$REPOSITORY_DIR/st"
mkdir -p $SRC_CHECKOUT

if [ ! -d $SRC_CHECKOUT/.git ] ; then
  git clone git://git.suckless.org/st $SRC_CHECKOUT
fi

sudo apt-get install libfreetype6-dev libx11-dev libfontconfig1-dev libxft-dev


cd $SRC_CHECKOUT
git reset --hard HEAD
make clean
rm -f config.h

git checkout 0.8.2
cp "$THIS_DIR/st-0.8.2-config.h" config.h
make

mkdir -p $LOCAL_BIN
ln -s $SRC_CHECKOUT/st $LOCAL_BIN/st
