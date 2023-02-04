---
title: "Docker多平台构建"
date: 2023-01-04T22:04:16+08:00
draft: false
tags: ["Linux","Docker"]
cover:
    image: "https://cn.bing.com/th?id=OHR.GroundhogThree_ZH-CN6720558481_1920x1080.jpg&rf=LaDigue_1920x1080.jpg&pid=hp"
    hidden: true # only hide on current single page
---
### 问题
今天遇到个问题，Mac m1 上拉取之前java构建的程序发现跑不起来，第一反应arm平台不兼容之前在x86架构下构建的镜像。
现如今云厂商好多服务器都是arm架构的，加上window11都支持arm架构了（Windows on ARM），arm以后会越来越频繁使用了。
这时就得祭出docker出的利器 buildx，可以一次构建多个平台的镜像。废话不多，开搞。。


####  buildx其实是个容器工具 moby/buildkit:buildx-stable-1
```
# Create a new builder
➜  ~ docker buildx create --name mybuilder --bootstrap --use

# 查看builder 
➜  ~ docker buildx inspect mybuilder
Name:   mybuilder
Driver: docker-container

Nodes:
Name:      mybuilder0
Endpoint:  unix:///var/run/docker.sock
Status:    running
Buildkit:  v0.11.2
Platforms: linux/arm64, linux/amd64, linux/amd64/v2, linux/riscv64, linux/ppc64le, linux/s390x, linux/386, linux/mips64le, linux/mips64, linux/arm/v7, linux/arm/v6
```

#### 构建

```
# 一条命令搞定，会pudh到registry 区别于常规build
➜  ~  docker buildx build --platform linux/arm64/v8,linux/amd64 -t registry.cn-hangzhou.aliyuncs.com/xiaoqioatq2/aa:0.2 --push  back

# 常规build 不push
➜  ~ docker build -t registry.cn-hangzhou.aliyuncs.com/xiaoqioatq2/aa:0.1 back
```

#### 查看registry构建成功

```
➜  ~ docker buildx imagetools inspect registry.cn-hangzhou.aliyuncs.com/xiaoqioatq2/aa:0.2

Name:      registry.cn-hangzhou.aliyuncs.com/xiaoqioatq2/aa:0.2
MediaType: application/vnd.docker.distribution.manifest.list.v2+json
Digest:    sha256:d1bce5ac3d722d5839417ba1524c6559db491569f900f20c8dd080f03e931bf9

Manifests:
  Name:      registry.cn-hangzhou.aliyuncs.com/xiaoqioatq2/aa:0.2@sha256:3e4d09f006d30c2644783a84abe99d22631930fb0a912bd291d4820d5eb328ac
  MediaType: application/vnd.docker.distribution.manifest.v2+json
  Platform:  linux/arm64

  Name:      registry.cn-hangzhou.aliyuncs.com/xiaoqioatq2/aa:0.2@sha256:f1e39a33c800f3aab5b2e9de497871ae1a5b3e1b918b57bd9724d2b795e8b49f
  MediaType: application/vnd.docker.distribution.manifest.v2+json
  Platform:  linux/amd64
  

```
#### 客户端测试 会自动拉取自己平台的镜像

##### Apple M1 （ARM64）
```
➜  ~ docker pull  registry.cn-hangzhou.aliyuncs.com/xiaoqioatq2/aa:0.2
0.2: Pulling from xiaoqioatq2/aa
0362ad1dd800: Already exists
571218f61883: Already exists
abe576d65b4c: Already exists
88e233291907: Pull complete
6f085c5d0e88: Pull complete
c740effa2ce7: Pull complete
Digest: sha256:d1bce5ac3d722d5839417ba1524c6559db491569f900f20c8dd080f03e931bf9
Status: Downloaded newer image for registry.cn-hangzhou.aliyuncs.com/xiaoqioatq2/aa:0.2
registry.cn-hangzhou.aliyuncs.com/xiaoqioatq2/aa:0.2

➜  ~ docker image inspect registry.cn-hangzhou.aliyuncs.com/xiaoqioatq2/aa:0.2 --format '{{.Os}}/{{.Architecture}}'
linux/arm64
```

##### Centos （AMD64）

```
[root@VM-4-3-centos ~]# docker pull registry.cn-hangzhou.aliyuncs.com/xiaoqioatq2/aa:0.2
0.2: Pulling from xiaoqioatq2/aa
e7c96db7181b: Already exists
f910a506b6cb: Already exists
c2274a1a0e27: Already exists
5023d05d0236: Pull complete
65e39c71f562: Pull complete
c740effa2ce7: Pull complete
Digest: sha256:d1bce5ac3d722d5839417ba1524c6559db491569f900f20c8dd080f03e931bf9
Status: Downloaded newer image for registry.cn-hangzhou.aliyuncs.com/xiaoqioatq2/aa:0.2
registry.cn-hangzhou.aliyuncs.com/xiaoqioatq2/aa:0.2

[root@VM-4-3-centos ~]# docker image inspect registry.cn-hangzhou.aliyuncs.com/xiaoqioatq2/aa:0.2 --format '{{.Os}}/{{.Architecture}}'
linux/amd64
```

#### 发现的问题
1. 镜像摘要混乱
   docker cli 拉取镜像时digest是manifest总的摘要，不是各自平台的digest，也有人提了[issue](https://github.com/docker/hub-feedback/issues/1925)，期待早日解决。
   
   Docker hub 只显示各个平台的digest，不显示总digest。
   ![WX20230204-152759.png](https://s2.loli.net/2023/02/04/K4qGaYjspwBmPnV.png)
   阿里云registry 只显示了amd64平台的digest 会误导。
   ![WX20230204-150540.png](https://s2.loli.net/2023/02/04/YDUH37KGRmN5cuV.png)

2. 多平台构建速度比较慢，后期考虑用github action来构建
3.




#### 参考：
1. https://www.thorsten-hans.com/how-to-build-multi-arch-docker-images-with-ease/
1. https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/