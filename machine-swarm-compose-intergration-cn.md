【教程】如何从零开始搭建Docker Swarm集群

【编者的话】本文主要介绍了如何从头搭建Docker Swarm集群，参照了Youtube视频[Demo of Machine + Swarm + compose integration](https://www.youtube.com/watch?v=M4PFY6RZQHQ)与[Demo of Docker Swarm Beta](https://www.youtube.com/watch?v=VlZnVC-91Y0)以及官方的[Docker Swarm文档](https://docs.docker.com/swarm/)，借以给读者朋友提供更为直观地Swarm演示示例。

###两台节点主机：
1. A：192.168.20.1
2. B：192.168.20.2

###检查节点Docker配置

* 打开Docker配置文件（示例是centos 7）
```
vim /etc/sysconfig/docker
```

* 添加`-H tcp://0.0.0.0:2375`到`OPTIONS`
```
OPTIONS='-g /cutome-path/docker -H tcp://0.0.0.0:2375'
```

* 某些需要另外添加`-H unix:///var/run/docker.sock`
```
OPTIONS='-g /mnt/docker -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock'
```

###分别给A、B节点安装swarm
```
$ docker pull swarm
```

###生成集群token（一次）

```
$ docker run --rm swarm create
6856663cdefdec325839a4b7e1de38e8

```
其中`6856663cdefdec325839a4b7e1de38e8`就是我们将要创建集群的token

###添加节点A、B到集群
```
$ docker run -d swarm join --addr=192.168.20.1:2375 token://6856663cdefdec325839a4b7e1de38e8

$ docker run -d swarm join --addr=192.168.20.2:2375 token://6856663cdefdec325839a4b7e1de38e8
```
* 列出集群A、B节点

```
$ docker run --rm swarm list token://6856663cdefdec325839a4b7e1de38e8

192.168.20.1:2375
192.168.20.2:2375
```

###集群管理：
* 在任何一台主机A、B或者C（C：192.168.20.3）上开启管理程序。例如在C主机开启：

```
$ docker run -d -p 8888:2375 swarm manage token://6856663cdefdec325839a4b7e1de38e8
```

* 现在你就可以在主机C上管理集群A、B：

```
$ docker -H 192.168.20.3:8888 info
$ docker -H 192.168.20.3:8888 ps
$ docker -H 192.168.20.3:8888 logs ...
```

###在集群上运行容器

```
$ docker -H 192.168.20.3:8888 run -d --name web1 nginx
$ docker -H 192.168.20.3:8888 run -d --name web2 nginx
$ docker -H 192.168.20.3:8888 run -d --name web3 nginx
$ docker -H 192.168.20.3:8888 run -d --name web4 nginx
$ docker -H 192.168.20.3:8888 run -d --name web5 nginx
```

* 查看集群A、B内的容器

```
$ docker -H 192.168.20.3:8888 ps -a
```

* 结果如下：

```
CONTAINER ID        IMAGE                       COMMAND                CREATED             STATUS                    PORTS               NAMES
4cc1f232fb18        nginx:latest                "nginx -g 'daemon of   16 hours ago        Up 16 hours               80/tcp, 443/tcp     Host-A/web5
e8327939721a        nginx:latest                "nginx -g 'daemon of   16 hours ago        Up 16 hours               443/tcp, 80/tcp     Host-A/web3
35e08c4a1b43        nginx:1                     "nginx -g 'daemon of   23 hours ago        Up 16 hours               443/tcp, 80/tcp     Host-B/web4
9bd07067620d        nginx:1                     "nginx -g 'daemon of   23 hours ago        Up 16 hours               443/tcp, 80/tcp     Host-B/web2
626fe5b1dcfa        nginx:1                     "nginx -g 'daemon of   23 hours ago        Up 16 hours               80/tcp, 443/tcp     Host-B/web1

```
* 其中`NAMES`列里面：`/`前边是节点名字，后边是在节点内创建的容器名字

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
**译者介绍**
田浩浩，[悉尼大学USYD](http://sydney.edu.au/engineering/it/)硕士研究生，目前在珠海从事Android应用开发工作。业余时间专注Docker的学习与研究，希望通过[DockerOne](http://dockerone.com/)把最新最优秀的译文贡献给大家，与读者一起畅游Docker的海洋。







