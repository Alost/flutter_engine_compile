

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

docker run -it --rm ghcr.io/alost/flutter-engine-compile:latest

docker system prune -a --volumes

du -sh .
du -h --max-depth=5 engine | sort -h

非自定义runner不能用自定义镜像.....
直接docker run, 挂载docker目录呢

/home/runner/work/flutter_engine_compile/flutter_engine_compile/flutter

job跑在container上:
    runs-on: ubuntu-22.04
    container:
      image: ghcr.io/alost/flutter-engine-compile:latest


docker run -d --name flutter \
    ghcr.io/alost/flutter-engine-compile:latest

docker ps -a
docker stop flutter
docker rm -f flutter
docker logs -f flutter 
docker exec -it flutter bash
docker inspect flutter

docker cp flutter:/home/runner/work/flutter_engine_compile/flutter_engine_compile/flutter /home/runner/work/flutter_engine_compile/flutter_engine_compile/

docker run -v /host/tmpfs:/flutter --tmpfs /host/tmpfs your_image

docker create --name temp_flutter \
  -v /home/runner/work/flutter_engine_compile/flutter_engine_compile/flutter \
  ghcr.io/alost/flutter-engine-compile:latest
docker run -d --name flutter \
  --volumes-from temp_flutter \
  -v /home/runner/work/flutter_engine_compile/flutter_engine_compile/flutter:/home/runner/work/flutter_engine_compile/flutter_engine_compile/flutter \
  ghcr.io/alost/flutter-engine-compile:latest

都不行

容器内优化不了磁盘空间

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
