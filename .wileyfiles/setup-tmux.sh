#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$THIS_DIR/global_vars.sh"

set -e
set -o verbose

SRC_CHECKOUT="$REPOSITORY_DIR/tmux"
mkdir -p $SRC_CHECKOUT

if [ ! -d $SRC_CHECKOUT/.git ] ; then
  git clone https://github.com/tmux/tmux.git $SRC_CHECKOUT
fi

sudo apt-get install build-essential automake libevent-dev

cd $SRC_CHECKOUT

git checkout 2.3
./autogen.sh
./configure
make -j8

mkdir -p $LOCAL_BIN
ln -s $SRC_CHECKOUT/tmux $LOCAL_BIN/tmux
