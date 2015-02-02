Docker Swarm入门(一) 概观

【编者的话】本文作者[Matt Bajor](https://github.com/technolo-g)热衷Docker及相关产品的研究，本文是他写的Docker Swarm入门系列的第一篇，主要介绍了Docker Swarm的概念以及它是如何工作的。

###什么是Docker Swarm

[Docker Swarm](https://github.com/docker/swarm)是用于创建Docker主机集群的工具，它可以与之就像是与一台主机交互的。在前几天我参加的[Docker全球骇客日](http://www.meetup.com/Docker-meetups/events/148163592/ )的[DockerCon EU](http://blog.docker.com/2015/01/dockercon-eu-introducing-docker-swarm/)上有人给我介绍了它。在介绍骇客日的期间，[宣布了一些非常酷的新技术](http://blog.docker.com/2014/12/announcing-docker-machine-swarm-and-compose-for-orchestrating-distributed-apps/)包括Docker Swarm（译注：Docker集群工具）、Docker Machine（译注：Docker管理工具）以及Docker Compose（译注：Docker编排工具，类似于[Fig](http://dockerone.com/article/119)）。由于Ansible填补了Machine与Compose的角色，Swarm的异军突起是我比较感兴趣的。

在大会介绍期间，Victor Vieux与Andrea Luzzardi公布了有关Swarm的基本运作的概念与论证，并提出了我认为非常有趣的声明。他们说虽然POC （概念验证）是功能齐全的以及能够演示的，但是他们要扔掉所有的代码而且要从头开始。我认为这是伟大的并且在POC一项新技术时要牢记这一点。

演示程序是用Go语言写的，Alpha软件绝对是在[最新的提交a0901ce8d6](https://github.com/docker/swarm/commit/a0901ce8d679e3ff0e13eee61e99407b4436bebd)这个时间点上。事情正在非常迅猛及时地发展以及功能特性几乎每天都有所不同。话虽这么说， [@vieux](https://github.com/vieux)对添加的功能以及通过[GitHub的问理](https://github.com/docker/swarm/issues)来修复bug都极为敏感。我不推荐它用于生产，但是它是一个非常有前途的技术。

###它是如何工作的

与Swarm的交互操作（通过设计）与对付单个Docker主机非常相似。它用现有的工具链使得有团队协作的能力，而无需作太多的修改（其中主要的有分裂构建的Swarm集群）。Swarm是运行在Linux机器上的守护程序，它绑定到与独立Docker实例相同的网络接口（http/2375或https/2376）。Swarm守护进程接受来自标准的Docker客户端`>=1.4.0`的连接以及代理他们回到Swarm背后的Docker守护进程，这也被标准的Docker端口监听。它可以基于Docker守护进程启动时几个不同的打包算法的结合以及标签来分发`create`命令。这使得由于单一Docker的endpoint而暴露的混乱Docker主机的分段集群的创建极其的简单。

与Swarm的交互“或多或少”与一个非集群的Docker实例交互是一样的，但是也有一些注意事项。不是所有的Docker命令都有1对1的支持。这是由于这两种体系结构与时间的根本原因。有些命令只是尚未实现，我想有些可能永远不会。眼下几乎一切需要运行容器的命令都是可用的，包括（还有其他的）：

* `docker run`
* `docker create`
* `docker inspect`
* `docker kill`
* `docker logs`
* `docker start`

这些是运行该工具时所需的重要组成部分。这里是在最基本的配置中如何使用这些技术的概述：

* Docker主机被`--label key=value`引入并网络监听。
* Swarm守护进程被引入并被指向一个含有构成集群以及他们所监听的端口的Docker主机的列表文件。
* Swarm联络每个Docker主机并确定他们的标记、健康以及资源量，来维护后端和它们元数据的列表。
* 客户端通过它的网络端口（2375）与Swarm交互。你与Swarm的交互与你与Docker交互的方式相同：创建、销毁、运行、依附并获得运行容器的日志以及其他的一些东西。
* 当一个命令发出给Swarm，Swarm会：
	* 基于提供的`constraint`标签、终端的健康程度以及调度算法来决定把命令发送到哪里。
	* 对适当的Docker守护进程执行命令
	* 返回结果跟Docker是同样的格式

![](http://technolo-g.com/images/Swarm_Diagram_Omnigraffle.jpg)
	
Swarm守护程序本身只是一个调度器和路由器。它实际上并没有运行容器也就是说，如果Swarm停止了，它在终端Docker主机已置备容器仍是开启状态。另外，由于它不处理任何网络路由（网络连接需要被直接发送到终端Docker主机），运行的容器仍然可用即使Swarm守护程序关闭。当Swarm从这样的崩溃中恢复，它依然能够查询终端以重建其元数据的列表。

由于Swarm的设计，与Swarm的所有活动的交互都与其他Docker守护进程是几乎相同的：Docker 客户端、docker-py、docker-api gem等。构建命令至今尚未想通，但今天你可以在运行时得到。不幸的是，在这个时候Ansible似乎在[TLS 模式](https://github.com/ansible/ansible/issues/10032)下不能与Swarm合作，但它似乎也影响Docker守护程序本身不只是Swarm。

这是有关Docker Swarm博文的第一个篇。对于缺少技术细节我表示抱歉，但在随后的文章中会有的包括架构、代码片段以及一些实践活动 :) 留意[第二篇：Docker Swarm的配置选项与需求]()，即将推出。

所有这些在博文背后的研究能成为可能归功于我工作的公司： [Rally Software in Boulder, CO.](https://www.rallydev.com/careers/open-positions)。每季度我们至少有一个骇客周，它使我们能够研究很棒的东西，像Docker Swarm。如果您想切入正题，直接开始Vagrant 例子，这里有一个repo，它是我在2014年Q1骇客周研究的成果：

* [https://github.com/technolo-g/docker-swarm-demo](https://github.com/technolo-g/docker-swarm-demo)


**原文链接：[Intro to Docker Swarm: Part 1 - Overview](https://github.com/docker/swarm) （翻译：[田浩浩](https://github.com/llitfkitfk)）**

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
**译者介绍**
田浩浩，[悉尼大学USYD](http://sydney.edu.au/engineering/it/)硕士研究生，目前在珠海从事Android应用开发工作。业余时间专注Docker的学习与研究，希望通过[DockerOne](http://dockerone.com/)把最新最优秀的译文贡献给大家，与读者一起畅游Docker的海洋。

