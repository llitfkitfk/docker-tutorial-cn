Docker Swarm入门（二）配置选项与需求

【编者的话】本文作者[Matt Bajor](https://github.com/technolo-g)热衷Docker及相关产品的研究，本文是他写的Docker Swarm入门系列的第二篇，主要介绍了Docker Swarm的最低需求配置。


##运行Docker Swarm集群的最低要求

创建一个Docker Swarm集群的最低要求确实很小。事实上，这绝对是可行的（虽然也许不是最好的做法）将Swarm运行在现有的Docker主机使其能够执行它而不用添加任何更多的硬件或虚拟资源。此外，在运行基于文件或[nodes（节点）](https://github.com/docker/swarm/tree/master/discovery#using-a-static-list-of-ips)发现机制时，并不需要其他的基础设施（当然除Docker）来运行一个基本Docker Swarm集群。

我个人认为在另一台机器上运行Swarm主控本身是一个不错的点子。该机器不需要沉重的资源，但它确实需要有很多的文件描述符来处理所有的TCP连接来来往往。在下面例子中，我会使用`dockerswarm01`来作为专用的Swarm主控。

##配置选项

在默认情况下Swarm有各种各样的配置设置，当涉及到运行守护程序及其配套的基础设置时，却给了它太多的灵活性。下面列出了不同类别的配置选项以及它们是如何进行配置的。

###发现

Swarm使用的发现一种以维护该集群状态的机制。它可以与各种终端合作，但这一切几乎都是相同的概念：

* 维护Docker节点列表终端应该是集群的一部分的。
* 使用节点的列表，Swarm 检查每一个的健康状况以及跟踪在集群中进出的节点。

####节点发现

节点发现需要可以在命令行上传递的所有东西。这是最基本的发现机制类型，因为它不需要维护的配置文件之类的东西。Swarm进程使用节点发现的启动命令会是这样：
{{{swarm manage \
  --discovery dockerhost01:2375,dockerhost02:2375,dockerhost03:2375 \
  -H=0.0.0.0:2375}}}

####文件发现

文件发现利用放置在文件系统中 （例如：/etc/swarm/cluster_config)的配置文件与`<IP>:<Port>`的格式来列出集群中的Docker主机。尽管该列表是静态的，healthchecking用于确定健康和不健康的节点以及过滤对不健康的节点请求的列表。基于文件的发现的启动命令和配置文件的例子如下：
{{{swarm manage \
  --discovery file:///etc/swarm/cluster_config \
  -H=0.0.0.0:2375}}}
{{{#/etc/swarm/cluster_config
dockerhost01:2375
dockerhost02:2375
dockerhost03:2375}}}
	
####Consul发现

Docker Swarm也支持Consul发现。它的工作原理是利用Consul的键值存储，以保持它的列表`<IP>:<Port>`被用于形成集群。在这种配置模式下，每个Docker主机运行在合并模式下的Swarm后台程序是指在Consul集群的HTTP接口。这对配置、运行时以及Docker主机安全提供了小的开销，但并不显著。Swarm客户端会这样做：
{{{swarm join \
  --discovery consul://consulhost01/swarm \
  # This can be an internal IP as long as the other
  # Docker hosts can reach it.
  --addr=10.100.199.200:2375}}}
 
然后Swarm master从Consul里读取其主机列表。它可以这样运行：
{{{swarm manage \
  --discovery consul://consulhost01/swarm \
  -H=0.0.0.0:2375}}}	

这些键/值的基本配置模式提出了在Swarm客户端与Swarm相结合的合作模式下工作事如何healthchecks的疑问。由于在键/值存储中列表本身就是动态的，它是否需要运行的内部Swarm healthchecks呢？我不熟悉这个范围，所以不能说但值得注意的。
####EtcD发现
EtcD发现工作方式与Consul发现大致相同。集群中每个Docker主机运行一个合作模式下的Swarm后台程序并指向一个EtcD的终端。这为EtcD提供了一个心跳来维护集群中活动服务器的列表。一个运行标准Docker守护进程的Docker主机会同时运行一个具有类似配置Swarm客户端：
{{{swarm join \
  --discovery etcd://etcdhost01/swarm \
  --addr=10.100.199.200:2375}}}

Docker Swarm master 通过以下命令会连接EtcD，搜寻提供的路径以及生成节点列表：
{{{swarm manage \
  --discovery etcd://etcdhost01/swarm \
  -H=0.0.0.0:2375}}}	

####Zookeeper发现

Zookeeper发现与其他键/值存储的基本配置模式一样遵循相同的模式。一个ZK集合被创建用来保存主机列表信息以及与Docker一起的客户端的运行，为了在键/值存储中保持心跳;接近实时地维护该列表。该Swarm master还连接到集合并使用`/swarm`路径下的的信息来维护主机的列表清单（其然后会做healthchecks）。

Swarm客户端（与Docker一起）：
{{{swarm join \
  # All hosts in the ensemble should be listed
  --discovery zk://zkhost01,zkhost02,zkhost03/swarm \
  --addr=10.100.199.200}}}

Swarm Master：
{{{swarm manage \
  --discovery zk://zkhost01,zkhost02,zkhost03/swarm \
  -H 0.0.0.0:2375}}}
####Hosted Token Based 发现 (默认)
我还没有使用过这个功能，在这点上没多少能总结的

###调度
调度的机制是选择在哪里创建并启动一个容器。它是由一个包装算法和过滤器（或标签）组合而成。每个Docker守护进程带着一组标签来启动，像这样的：
{{{docker -d \
  --label storage=ssd \
  --label zone=external \
  --label tier=data \
  -H tcp://0.0.0.0:2375}}}

然后，当开启一个Docker容器时，Swarm将基于过滤器选择一组机器，然后根据其调度分配每次运行命令。过滤器会告诉Swarm哪个地方容器可以运行或者不可以在可用的主机之间。以下是几个过滤机制：

####Constraint（约束）
这是利用了一个Docker守护程序开始的标签。目前，它只支持'='，（译注：[官方doc](https://github.com/docker/swarm/tree/master/scheduler/filter)里是'=='，请读者遵循最新的官方doc）但在将来它可能支持'!='。节点必须符合所有的由容器提供的约束以便匹配调度。如下例子来开启有一些约束的容器：
{{{docker run -d -P \
    -e constraint:storage=ssd \
    -e constraint:zone=external \
    -t nginx}}}

####Affinity （类同）
类同可以以两种方式工作：容器类同或镜像类同。为了在同一台主机上启动两个容器可以运行以下命令：
{{{docker run -d -P \
    --name nginx \
    -t nginx

   docker run -d -P \
     --name mysql \
     -e affinity:container=nginx \
     -t mysql}}}
 
由于Swarm不处理镜像管理，设置类同镜像也是可行的。这意味着一个容器仅能在已包含镜像的节点上启动。这就否定了在开启一个容器之前需要在后台等待拉取镜像。举个例子：
{{{docker run -d -P \
    --name nginx \
    -e affinity:image=nginx \
    -t nginx}}}

####Port （端口）
端口过滤不允许在同一主机上任意两个容器具有相同的静态端口映射的启动。这样做的意义很大，你不能重复在Docker主机上端口映射。例如，两个节点以`-p 80:80`开启不会被允许在同一Docker主机上运行。

####Healthy（健康状况）
它阻止了不健康节点的调度。

一旦Swarm将主机列表放置到一组匹配上述过滤的节点上，然后他会将此容器安排在某一节点上。目前以下调度是内置的：

####Random（随机分布）
将容器随机分布在可用的终端上。

####Binpacking
用容器将节点填满，然后移动到下一个。此模式具有在运行时向每个容器分配静态资源量的增量复杂性。这意味着设置容器的内存和CPU的限制可能会或不会万无一失。我个人比较喜欢让容器彼此之间争夺，看看谁能得到的资源。

正在进行中的是[平衡策略](https://github.com/docker/swarm/pull/227)以及添加[Apache Mesos](https://github.com/docker/swarm/issues/214)功能。

###TLS（[Transport Layer Security（传输层安全协议）](http://www.wikiwand.com/en/Transport_Layer_Security)）
我很高兴地说，Swarm可在TLS启用下运行。这使得客户端和Swarm守护进程之间当然还有Swarm守护进程和Docker守护程序之间更安全。这是一件好事，因为我的研究安全方面的伙伴说，在网络中并没有边界。

![](http://technolo-g.com/images/SSL-security.jpg)

它确实需要一个包含CA的完整PKI，但我有个解决办法在另一篇已发布的文章里会提到，它是[如何为Docker与Swarm产生所需的TLS证书](http://technolo-g.com/generate-ssl-for-docker-swarm/)。

按我的其他博客文章，一旦证书生成并安装，在Docker与Swarm守护进程就可以这样做：
Docker：
{{{docker -d \
  --tlsverify \
  --tlscacert=/etc/pki/tls/certs/ca.pem \
  --tlscert=/etc/pki/tls/certs/dockerhost01-cert.pem \
  --tlskey=/etc/pki/tls/private/dockerhost01-key.pem \
  -H tcp://0.0.0.0:2376}}}

Swarm master：
{{{swarm manage \
  --tlsverify \
  --tlscacert=/etc/pki/tls/certs/ca.pem \
  --tlscert=/etc/pki/tls/certs/swarm-cert.pem \
  --tlskey=/etc/pki/tls/private/swarm-key.pem  \
  --discovery file:///etc/swarm_config \
  -H tcp://0.0.0.0:2376}}}

然后客户端必须知道TLS连接。以下是环境变量设置：
{{{export DOCKER_HOST=tcp://dockerswarm01:2376
export DOCKER_CERT_PATH="`pwd`"
export DOCKER_TLS_VERIFY=1}}}

这样你就设置好了TLS。

##还有更多！
当涉及到复杂的集群软件的配置，还是很多要谈论的，但我觉得这是一个足够好的概观，让你设置、运行并思考如何配置你的Swarm集群。在下一篇我会制定出一些架构例子有关Swarm集群的。敬请关注，并欢迎在下面发表评论！

所有这些在博文背后的研究能成为可能归功于我工作的公司： [Rally Software in Boulder, CO.](https://www.rallydev.com/careers/open-positions)。每季度我们至少有一个骇客周，它使我们能够研究很棒的东西，像Docker Swarm。如果您想切入正题，直接开始Vagrant 例子，这里有一个repo，它是我在2014年Q1骇客周研究的成果：

* [https://github.com/technolo-g/docker-swarm-demo](https://github.com/technolo-g/docker-swarm-demo)

**原文链接：[Intro to Docker Swarm: Part 2 - Configuration Options and Requirements](http://technolo-g.com/intro-to-docker-swarm-pt2-config-options-requirements/) （翻译：[田浩浩](https://github.com/llitfkitfk)）**

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
**译者介绍**
田浩浩，[悉尼大学USYD](http://sydney.edu.au/engineering/it/)硕士研究生，目前在珠海从事Android应用开发工作。业余时间专注Docker的学习与研究，希望通过[DockerOne](http://dockerone.com/)把最新最优秀的译文贡献给大家，与读者一起畅游Docker的海洋。

------------------------------------------
[Docker Swarm入门（一）概观](http://dockerone.com/article/168)
[Docker Swarm入门（二）配置选项与需求](http://dockerone.com/article/178)