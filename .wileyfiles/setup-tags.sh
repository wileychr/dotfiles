#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$THIS_DIR/global_vars.sh"

set -e
set -o verbose

mkdir -p $LOCAL_BIN
ln -s $THIS_DIR/build_tags $LOCAL_BIN/build_tags
