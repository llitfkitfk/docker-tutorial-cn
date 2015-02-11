Docker Swarm入门（四）Demo

【编者的话】本文作者[Matt Bajor](https://github.com/technolo-g)热衷Docker及相关产品的研究，本文是他写的Docker Swarm入门系列的第四篇，通过一个demo让读者更好地了解Docker Swarm。

##[Vagrant up](https://www.vagrantup.com/)开启！

我的骇客周努力的主要方向是在Vagrant环境下的Docker Swarm集群。这篇文章将看看如何使它运行起来以及如何与它进行交互。

###它是什么？

这是包含在Vagrant环境里功能齐全的Docker Swarm集群。其包括4个节点：
* dockerhost01
* dockerhost02
* dockerhost03
* dockerswarm01

Docker节点（dockerhost01 - 3）正在运行的Docker守护进程，以及一些配套服务。对Docker主机感兴趣的主要过程是：

* **Docker daemon**：带着一组标签运行
* **Registrator daemon**：这个守护进程连接到Consul为了注册和注销有端口公开的容器。从这项服务中的条目可以在`/services`路径下的Consul的键/值存储中可以看到
* **Swarm client**：Swarm客户端是维护在Consul里地Swarm节点列表。此列表保存在`/swarm`下，包含集群中参与的Swarm节点`<ip>:<ports>`的列表

Docker Swarm节点（dockerswarm01）也运行了几个服务。由于这仅仅是一个例子，很多服务都总结成一个单一的机器。对于生产环境，我不推荐这样的布局。

* **Swarm daemon**：作为master以及监听在网络上Docker命令而代理他们到Docker主机
* **Consul**：单个节点Consul实例的运行。它的用户界面在[这里](http://dockerswarm01/ui/#/test/)
* **Nginx**：为UI代理其到Consul

##如何提供集群

###1.安装前提

* **GitHub Repo**：[docker-swarm-demo](https://github.com/technolo-g/docker-swarm-demo)
* **Vagrant（最新）**：[Vagrant下载](https://www.vagrantup.com/downloads.html)
* **Vagrant主机插件**：`vagrant plugin install vagrant-hosts`
* **VirtualBox**：[VirtualBox下载](https://www.virtualbox.org/wiki/Downloads)
* **Ansible**：`brew install ansible`
* **主机条目**：添加以下行到`/etc/hosts`文件：

{{{10.100.199.200 dockerswarm01
10.100.199.201 dockerhost01
10.100.199.202 dockerhost02
10.100.199.203 dockerhost03}}}

###2a. Clone && Vagrant up（无[TLS](http://www.wikiwand.com/en/Transport_Layer_Security)）
这个过程可能会耗费一些时间要下载几G的数据。这种情况是不使用TLS的。如果你想要Swarm使用TLS，去步骤2b。

{{{# Clone our repo
git clone https://github.com/technolo-g/docker-swarm-demo.git
cd docker-swarm-demo

# Bring up the cluster with Vagrant
vagrant up

# Provision the host files on the vagrant hosts
vagrant provision --provision-with hosts

# Activate your enviornment
source bin/env}}}

###2b. Clone && Vagrant up（有[TLS](http://www.wikiwand.com/en/Transport_Layer_Security)）
这种情况会生成证书而且集群会启用TLS。

{{{# Clone our repo
git clone https://github.com/technolo-g/docker-swarm-demo.git
cd docker-swarm-demo

# Generate Certs
./bin/gen_ssl.sh

# Enable TLS for the cluster
echo -e "use_tls: True\ndocker_port: 2376" > ansible/group_vars/all.yml

# Bring up the cluster with Vagrant
vagrant up

# Provision the host files on the vagrant hosts
vagrant provision --provision-with hosts

# Activate your TLS enabled enviornment
source bin/env_tls}}}

###3. 确认正常工作

现在，集群配置并运行，你应该能够确认。我们会做一些方法。首先看一下Docker 客户端：
{{{$ docker version
Client version: 1.4.1
Client API version: 1.16
Go version (client): go1.4
Git commit (client): 5bc2ff8
OS/Arch (client): darwin/amd64
Server version: swarm/0.0.1
Server API version: 1.16
Go version (server): go1.2.1
Git commit (server): n/a

$ docker info
Containers: 0
Nodes: 3
 dockerhost02: 10.100.199.202:2376
 dockerhost01: 10.100.199.201:2376
 dockerhost03: 10.100.199.203:2376}}}
 
然后在浏览器中浏览Consul：[http://dockerswarm01/ui/#/test/kv/swarm/](http://dockerswarm01/ui/#/test/kv/swarm/)，并确认Docker主机以及它的端口被列出如下：
![](http://technolo-g.com/images/consul_swarm_cluster.png)

集群好像可以正常工作了，因此让我们在上边配置一个应用！

##如何使用它
现在，您可以与Swarm集群交互来配置节点。在Vagrant配置期间这个演示中镜像已经下载完成，因此使这些命令应该可以使用为了加快2倍的外部代理容器和3倍的内部Web应用程序容器。关于命令有两件事情需要注意：

* 当Docker开启后，约束需要与被分配标签匹配。这就是Swarm的过滤器如何知道哪些Docker主机可供调度。
* SERVICE_NAME变量是为Registrator设置的。由于我们使用的是通用的容器（Nginx）我们以这种方式来代替指定服务名称。
{{{# Primary load balancer
docker run -d \
  -e constraint:zone==external \
  -e constraint:status==master \
  -e SERVICE_NAME=proxy \
  -p 80:80 \
  nginx:latest

# Secondary load balancer
docker run -d \
  -e constraint:zone==external \
  -e constraint:status==non-master \
  -e SERVICE_NAME=proxy \
  -p 80:80 \
  nginx:latest

# 3 Instances of the webapp
docker run -d \
  -e constraint:zone==internal \
  -e SERVICE_NAME=webapp \
  -p 80 \
  nginx:latest

docker run -d \
  -e constraint:zone==internal \
  -e SERVICE_NAME=webapp \
  -p 80 \
  nginx:latest

docker run -d \
  -e constraint:zone==internal \
  -e SERVICE_NAME=webapp \
  -p 80 \
  nginx:latest}}} 

现在你如果运行`docker ps` 或者 点[这里](http://dockerswarm01/ui/#/test/kv/services/)浏览Consul会得到如下：

![](http://technolo-g.com/images/consul_services.png)

你可以看到两项已注册服务！由于路由和服务发现部分是额外的，这个程序实际上不会工作，但我觉得你已经有了思路。

我希望你喜欢有关Docker Swarm的这个系列。我发现Docker Swarm是由一个伟大的且非常敏捷的团队开发的一个前景广阔的应用。我相信它将改变我们对待我们的Docker主机的方式以及当运行复杂的应用程序时，将大大简化所要做的事。

所有这些在博文背后的研究能成为可能归功于我工作的公司： [Rally Software in Boulder, CO.](https://www.rallydev.com/careers/open-positions)。每季度我们至少有一个骇客周，它使我们能够研究很棒的东西，像Docker Swarm。如果您想切入正题，直接开始Vagrant 例子，这里有一个repo，它是我在2014年Q1骇客周研究的成果：

* [https://github.com/technolo-g/docker-swarm-demo](https://github.com/technolo-g/docker-swarm-demo)

**原文链接：[Intro to Docker Swarm: Part 4 - Demo](http://technolo-g.com/intro-to-docker-swarm-pt4-demo/) （翻译：[田浩浩](https://github.com/llitfkitfk)）**

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
**译者介绍**
田浩浩，[悉尼大学USYD](http://sydney.edu.au/engineering/it/)硕士研究生，目前在珠海从事Android应用开发工作。业余时间专注Docker的学习与研究，希望通过[DockerOne](http://dockerone.com/)把最新最优秀的译文贡献给大家，与读者一起畅游Docker的海洋。

------------------------------------------
[Docker Swarm入门（一）概观](http://dockerone.com/article/168)
[Docker Swarm入门（二）配置选项与需求](http://dockerone.com/article/178)
[Docker Swarm入门（三）Swarm SOA举例](http://dockerone.com/article/192)
[Docker Swarm入门（四）Demo](http://dockerone.com/article/203)