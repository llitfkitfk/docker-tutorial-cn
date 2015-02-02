Docker Swarm入门（一）配置选项与需求

【编者的话】本文作者[Matt Bajor](https://github.com/technolo-g)热衷Docker及相关产品的研究，本文是他写的Docker Swarm入门系列的第二篇，主要介绍了Docker Swarm的最低需求配置。

##运行Docker Swarm集群的最低要求

创建一个Docker Swarm集群的最低要求确实很小。事实上，这绝对是可行的（虽然也许不是最好的做法）将Swarm运行在现有的Docker主机使其能够执行它而不用添加任何更多的硬件或虚拟资源。此外，在运行基于文件或[nodes](https://github.com/docker/swarm/tree/master/discovery#using-a-static-list-of-ips)发现机制时，并不需要其他的基础设施（当然除Docker）来运行一个基本Docker Swarm集群。

我个人认为在另一台机器上运行Swarm主控本身是一个不错的点子。该机器不需要沉重的资源，但它确实需要有很多的文件描述符来处理所有的TCP连接来来往往。在下面例子中，我会使用`dockerswarm01`来作为专用的Swarm主控。

##配置选项

在默认情况下Swarm有各种各样的配置设置，当涉及到运行守护程序及其配套的基础设置时，却给了它太多的灵活性。下面列出了不同类别的配置选项以及它们是如何进行配置的。

###发现

发现是群使用，以保持该集群的状态的机制。它可以与各种后端的工作，但是这一切都几乎是相同的概念：

后端保持多克尔节点应该是这样的集群的一部分的列表。
使用节点的列表，群healtchecks每一个和跟踪是在集群的进出节点

####节点发现

节点发现需要一切可以在命令行上传递。这是发现机制最基本的类型，因为它不需要维护的配置文件之类的东西。使用节点发现会是什么样子虫群守护进程的一个例子启动命令：
{{{swarm manage \
  --discovery dockerhost01:2375,dockerhost02:2375,dockerhost03:2375 \
  -H=0.0.0.0:2375}}}

###文件发现

###发现