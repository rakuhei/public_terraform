# About Docker Images
- CentOS 8 + Terraform の DockerImages File

## BaseImages

```shell
Images: centos8
```

## Install
```shell
git       : Latest
```

## 共通補足事項 - 実行方法

### Linux Dokcer 実行方法
docker run -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add=SYS_ADMIN --security-opt seccomp=unconfined -d -p 80:80 --name $NAME $DOCKER_IMAGES_ID /sbin/init &
docker exec -it --name $CONTAINER_ID /bin/bash

### MacBook Docker 実行方法
docker run --privileged -d -p 8080:8080 $DOCKER_IMAGES_ID /sbin/init &
docker exec -it --name $CONTAINER_ID /bin/bash

### Windows Docker 実行方法
