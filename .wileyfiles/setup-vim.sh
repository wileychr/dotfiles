#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$THIS_DIR/global_vars.sh"

set -e
set -o verbose

if [[ "$(uname)" == "Darwin" ]]; then
  echo "Not installing dependencies, this is Darwin, you're on your own"
else
  sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
	libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
	libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
	python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git
fi

SRC_CHECKOUT="$REPOSITORY_DIR/vim"
mkdir -p $SRC_CHECKOUT

if [ ! -d $SRC_CHECKOUT/.git ] ; then
  git clone https://github.com/vim/vim.git $SRC_CHECKOUT
fi


VIM_CONFIG_FLAGS="--with-features=huge"
VIM_CONFIG_FLAGS+=" --enable-multibyte"
VIM_CONFIG_FLAGS+=" --enable-cscope"
VIM_CONFIG_FLAGS+=" --enable-rubyinterp=yes"
VIM_CONFIG_FLAGS+=" --enable-python3interp=yes"
VIM_CONFIG_FLAGS+=" --with-python3-config-dir=/usr/lib/python3.5/config"
VIM_CONFIG_FLAGS+=" --enable-perlinterp=yes"
VIM_CONFIG_FLAGS+=" --enable-luainterp=yes"

if [[ "$(uname)" == "Darwin" ]]; then
VIM_CONFIG_FLAGS+=" --with-lua-prefix=/usr/local"
fi

mkdir -p $LOCAL_BIN
if [ ! -e $LOCAL_BIN/vim ] ; then
  cd $SRC_CHECKOUT
  git checkout "v8.1.0000"
  ./configure ${VIM_CONFIG_FLAGS}
  make VIMRUNTIMEDIR=$SRC_CHECKOUT/runtime -j8
  ln -s $SRC_CHECKOUT/src/vim $LOCAL_BIN/vim
fi


vim_plugin_repos=(
  "https://github.com/Shougo/neocomplete.vim.git"
  "https://github.com/solarnz/thrift.vim.git"
  "https://github.com/moll/vim-node.git"
  "https://github.com/gabrielelana/vim-markdown"
)

for i in "${vim_plugin_repos[@]}" ; do
  install_path="$HOME/.vim/pack/plugins/start/$(basename $i)"
  if [ ! -d $install_path/.git ] ; then
    git clone $i $install_path
  fi
done
