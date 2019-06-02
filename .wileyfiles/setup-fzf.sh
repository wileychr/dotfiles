#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$THIS_DIR/global_vars.sh"

set -e
set -o verbose


SRC_SUFFIX="github.com/junegunn/fzf"
SRC_CHECKOUT="${REPOSITORY_DIR}/${SRC_SUFFIX}"
PINNED_VERSION="0.18.0"
BINARY_NAME="fzf"

if [ ! -d "${SRC_CHECKOUT}/.git" ] ; then
  mkdir -p "${SRC_CHECKOUT}"
  git clone https://${SRC_SUFFIX} $SRC_CHECKOUT
fi

if [ ! -e "$LOCAL_BIN/$BINARY_NAME" ] ; then
  mkdir -p $LOCAL_BIN
  cd $SRC_CHECKOUT
  git checkout "$PINNED_VERSION"
  make
  ln -s $SRC_CHECKOUT/target/fzf-* $LOCAL_BIN/$BINARY_NAME
fi
