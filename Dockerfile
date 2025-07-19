FROM ubuntu:22.04

ARG FLUTTER_VERSION=3.22.3

ENV DEBIAN_FRONTEND=noninteractive \
    ROOT_DIR=/home/runner/work/flutter_engine_compile/flutter_engine_compile \
    FLUTTER_VERSION=${FLUTTER_VERSION}

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    python3 \
    python-is-python3 \
    curl \
    unzip \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    openjdk-21-jdk \
    && rm -rf /var/lib/apt/lists/*

WORKDIR ${ROOT_DIR}

RUN mkdir -p ${ROOT_DIR}/flutter && cd ${ROOT_DIR}/flutter && \
    git clone --depth 1 https://chromium.googlesource.com/chromium/tools/depot_tools.git || true
ENV PATH=${ROOT_DIR}/flutter/depot_tools:${PATH}

RUN mkdir -p ${ROOT_DIR}/flutter/engine && cd ${ROOT_DIR}/flutter/engine && \
    cat <<'EOL' > .gclient
solutions = [
  {
    "custom_deps": {},
    "deps_file": "DEPS",
    "managed": False,
    "name": "src/flutter",
    "safesync_url": "",
    "url": "https://github.com/flutter/engine.git",
    "custom_vars": {
		"download_dart_sdk": False,
	},
  },
]
EOL

RUN cd ${ROOT_DIR}/flutter/engine && \
    gclient sync --nohooks && \
    cd ${ROOT_DIR}/flutter/engine/src/flutter && \
    git checkout ${FLUTTER_VERSION} && \
    gclient sync -D --with_branch_heads --with_tags && \
    find . -type d -name ".git" -exec rm -rf {} +

CMD ["bash"]
