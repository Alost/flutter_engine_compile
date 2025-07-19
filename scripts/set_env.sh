#!/bin/bash

set -euvx
set -o pipefail

sudo timedatectl set-timezone Asia/Shanghai

export ROOT_DIR="${ROOT_DIR:-$PWD}"
echo "ROOT_DIR=$ROOT_DIR" >> $GITHUB_ENV

export PATH=$ROOT_DIR/flutter/depot_tools:$PATH

export GN_OPTS="--no-goma --no-build-embedder-examples --no-build-glfw-shell --disable-desktop-embeddings --no-enable-unittests --no-dart-version-git-info --no-clang-static-analyzer"

export VERSION=3.22.3
echo "VERSION=$VERSION" >> $GITHUB_ENV

mkdir -p $ROOT_DIR/tmp
log_file="$ROOT_DIR/tmp/script.log"
log() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $1" | tee -a "$log_file"
}
