##Docker教程系列 1 Introduction

Docker，容器技术的新趋势，其轻巧，便携深得人心，“只需一次构建＋配置，就可以随处运行”的功能。
这是Flux7的Docker教程系列的第一部分。随着我们一起前进，我们将学习和理解Docker有什么不同，以及如何物尽其用。

让我们一起来学习Docker。

这部分涉及Docker的基础知识：它的特征，理念以及如何安装，让你与Docker同在。

###Docker 特征

Docker有不少有趣的功能，通过此教程系列你会更好地理解他们。

Docker特性主要包括以下几点：
- 速度飞快以及优雅的隔离框架
- 物美价来
- CPU/内存的低消耗
- 快速开/关机
- 跨云计算基础架构

###Docker 组件与要素

Docker有三个组件和三个基本要素:

组件：
 
- ```Docker Client``` 是用户界面，其允许用户与```Docker Daemon```之间通信。

- ```Docker Daemon```是服务主机的应答请求。

- ```Docker Index```是中央registry，允许带有公有与私有访问权限Docker container images备份。

要素：

- ```Docker Containers```是负责实际应用程序的运行，而且包括操作系统，用户添加的文件以及元数据。

- ```Docker Images```来帮助开启Docker containers的只读模板。

- ```DockerFile``` 是说明如何自动创建```Docker Image```的文件。

![](http://cdn2.hubspot.net/hub/411552/file-1222264954-png/blog-files/image-1.png?t=1419682672898)

在讨论Docker组件和要素如何交互之前，让我们来谈谈是什么构成了Docker的支柱。

Docker使用以下操作系统的功能来提高容器技术效率：

- ```Namespaces``` 充当隔离的第一级。确保一个容器中运行一个进程而且不能看到或影响容器外其他进程。

- ```Control Groups``` LXC的重要组成部分，具有资源核算与限制的关键功能。

- ```UnionFS``` (文件系统) 作为容器的构建块。为了Docker的轻量级以及速度快的特点，它创建层与用户。


###如何把他们放在一起

运行任何应用程序，有两个基本步骤：

1. 构建一个镜像。
2. 运行容器。

这些步骤的是从```Docker Client```的命令开始的。```Docker Client```使用的是docker二进制文件。在基础层面上，```Docker Client```命令```Docker Daemon```根据需要创建的镜象和要需要在容器内运行的命令。
此后创建的镜像的信号由Daemon捕获，这些步骤必须遵循：

####第1步：构建镜像

如前面所述，```Docker Image```构建容器的只读模板。一个镜像持有所需的所有信息来引导一个容器，包括运行哪些进程和配置数据。
每个镜像开始于一个基本镜像，并且模板是通过使用存储在DockerFile说明创建的。对于每个指令，一个新的层将会在镜像上创建。

一旦镜像被创建，可以将它们推送到中央registry：```Docker Index```，以供他人使用。然而，```Docker Index```为镜像提供了两个级别的访问权限：公有和私有访问。您可以储存镜像在私有仓库。Docker官网有私有仓库的套餐可以参考。总之，公有库是可搜索和可重复使用的，而私有库只能给拥有权限的成员访问。```Docker Client```可用于```Docker Index```内的镜像搜索。

####第2步：运行容器

运行容器源于我们在第一步中创建的镜像。当一个容器被启动后，一个读写层会被添加到镜像的顶层。经过合适的网络和IP地址分配，最终所期望的应用程序就可以在容器内运行了。

如果你还是有点不解，坐稳了，然后看这个实际的例子，在未来几周内我们将与您分享本教程系列。

目前为止一个基本的了解足够了。因此，让我们继续前进，安装Docker！

###安装Docker: 快速指南


下面让我们来讨论如何在Ubuntu 12.04 LTS安装Docker:
(译注:在centos 6.5安装可以参考[这里](https://github.com/llitfkitfk/docker-tutorial-cn))

1. 检查APT系统的HTTPS兼容性。
	安装apt-transport-https 包，如果usr/lib//apt/methods/https文件不存在

2. 在本地钥匙链添加Docker Repository key。
```Repository key: hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
```

3. 添加Docker Repository到APT源列表。
```sudo sh -c "echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
```

4. 安装lxc-Docker包。
```sudo apt-get update
sudo apt-get install lxc-docker
```

5. 验证安装。
```sudo docker run -i -t ubuntu /bin/bash
```

这样介绍就完成了。关注更多教程系列尽在[www.dockerone.com](http://dockerone.com/topic/Docker%20Tutorial)

