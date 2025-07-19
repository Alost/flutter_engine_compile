#!/bin/bash

source ${ROOT_DIR:-$PWD}/scripts/set_env.sh

log "download source start"

# depot_tools 工具
mkdir -p $ROOT_DIR/flutter; cd $ROOT_DIR/flutter;
git clone --depth 1 https://chromium.googlesource.com/chromium/tools/depot_tools.git || true
export PATH=$ROOT_DIR/flutter/depot_tools:$PATH

# 下载代码和依赖
mkdir -p $ROOT_DIR/flutter/engine; cd $ROOT_DIR/flutter/engine;
cat <<EOL > .gclient
solutions = [
  {
    "custom_deps": {},
    "deps_file": "DEPS",
    "managed": False,
    "name": "src/flutter",
    "safesync_url": "",
    "url": "https://github.com/flutter/engine.git",
    'custom_vars': {
		'download_dart_sdk': False,
	},
  },
]
EOL
gclient sync --nohooks
# fetch --nohooks flutter
# --no-history --shallow

# 切换版本
cd $ROOT_DIR/flutter/engine/src/flutter
git checkout $VERSION

# 下载依赖
gclient sync -D --with_branch_heads --with_tags
git tag --points-at HEAD

log "download source finish"
