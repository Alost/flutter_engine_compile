

https://docs.github.com/en/packages/managing-github-packages-using-github-actions-workflows/publishing-and-installing-a-package-with-github-actions


docker build --build-arg FLUTTER_VERSION=3.22.3 -t ghcr.io/alost/flutter-engine-compile:3.22.3 .

df -h
df . -h
docker info | grep "Docker Root Dir"
df /var/lib/docker -h
docker system df

docker system prune -a --volumes

docker push ghcr.io/alost/flutter-engine-compile:3.22.3

docker run -it --rm ghcr.io/alost/flutter-engine-compile:3.22.3

docker images
docker inspect ghcr.io/alost/flutter-engine-compile:3.22.3

docker history --no-trunc ghcr.io/alost/flutter-engine-compile:3.22.3


echo xx | docker login ghcr.io -u Alost --password-stdin

DOCKER_BUILDKIT=0 docker build xxx

rm -rf flutter/engine/src/fuchsia

find . -type d -name ".git" -exec rm -rf {} +
DOCKER_BUILDKIT=0 docker build --build-arg FLUTTER_VERSION=3.22.3 -t ghcr.io/alost/flutter-engine-compile:latest -f Copy_Dockerfile .
docker push ghcr.io/alost/flutter-engine-compile:latest

docker system prune -a --volumes

du -sh .
du -h --max-depth=5 engine | sort -h

非自定义runner不能用自定义镜像.....

# 阶段1：下载和同步
FROM ubuntu:22.04 as downloader
RUN apt-get update && apt-get install -y git python3 curl
RUN git clone --depth 1 https://chromium.googlesource.com/depot_tools
ENV PATH=/depot_tools:$PATH
RUN gclient sync --nohooks

# 阶段2：仅保留运行时所需
FROM ubuntu:22.04
COPY --from=downloader /engine/src/flutter /app/flutter
WORKDIR /app/flutter
CMD ["bash"]
