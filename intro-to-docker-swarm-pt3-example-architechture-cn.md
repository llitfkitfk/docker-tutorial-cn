Docker Swarm入门（三）Swarm SOA举例

【编者的话】本文作者[Matt Bajor](https://github.com/technolo-g)热衷Docker及相关产品的研究，本文是他写的Docker Swarm入门系列的第三篇，通过举例介绍了Docker Swarm SOA。

Docker Swarm带来的最令人兴奋的事情之一是用非常小的开销就能创造现代化的、有弹性的以及灵活的架构的能力。能够与Docker主机的多样化集群交互就好像与在一台可以用现有的工具链的主机中交互的一样，来建立我们的精美而简单的SOA（[Service-oriented architecture 面向服务的架构](http://www.wikiwand.com/en/Service-oriented_architecture)）所需的一切东西！

本文将要试图围绕着Docker Swarm描述一个完整的SOA架构，其具有以下属性：

* **管理程序层**由独立的Docker主机组成（Docker/Registrator）
* **集群层**将Docker主机绑在一起（Docker Swarm）
* **服务发现层**（Consul）
* **路由层**在基于Consul有关服务下指挥交通（HAProxy/Nginx）

###管理程序层

管理程序层是由一组离散Docker主机构成。每个主机上都有运行服务，允许其参与：

* **Docker daemon**：配置Docker守护程序来监听网络端口以及本地Linux socket，这样Swarm守护程序就可以与它进行通信。此外，配置每个Dockerhost与Swarm调度一起在一组标签上运行以决定容器被置于哪里。他们有助于描述Docker主机而且不论在哪任何标识信息都可以与Docker主机相关联。这是一个Docker主机被启动时一组标签的例子：
	* 范围：应用程序/数据库
	* 硬盘：ssd/hdd
	* 环境：开发/生产
* **Swarm daemon**：Swarm客户端与Docker守护进程一起运行，以保持该节点在Swarm集群中运行。该Swarm守护在合作模式下运行并且对Consul保持基本的心跳以保持其记录在`/swarm`位置的更新。这个记录是Swarm master用于创建集群的。如果此进程被毁坏，name列表中Consul会自动地删除该节点。Swarm客户端在Consul会使用像`/swarm`的路径，它包含Docker主机的列表：

![](http://technolo-g.com/images/consul/swarm_section.png)

* **Registrator daemon**：当创建或者销毁容器时，Registrator是用来更新Consul的。它监听Docker socket以及接下来的每个事件将会更新Consul 的键/值。例如，一个名叫deepthought的应用需要3个在分离的主机的实例并运行在80端口上，其会在Consul创建一个结构如下：

![](http://technolo-g.com/images/consul/services_section.png)

模式：
`/services/<service>-<port>/<dhost>:<cname>:<cport>` 结果是: `<ipaddress>:<cport>`

* service：容器的景象名字
* port：容器公开的端口
* dhost：容器运行的Docker主机
* cport：容器公开的端口
* ipaddress：容器运行的Docker主机的ip地址

`docker ps` 会输出以下类似信息：
{{{$ docker ps
  CONTAINER ID        IMAGE                       COMMAND                CREATED             STATUS              PORTS                                   NAMES
  097e142c1263        mbajor/deepthought:latest   "nginx -g 'daemon of   17 seconds ago      Up 13 seconds       10.100.199.203:49166->80/tcp   dockerhost03/grave_goldstine
  1f7f3bb944cc        mbajor/deepthought:latest   "nginx -g 'daemon of   18 seconds ago      Up 14 seconds       10.100.199.201:49164->80/tcp   dockerhost01/determined_hypatia
  127641ff7d37        mbajor/deepthought:latest   "nginx -g 'daemon of   20 seconds ago      Up 16 seconds       10.100.199.202:49158->80/tcp   dockerhost02/thirsty_babbage}}}
  	
这是记录服务和位置的最基本方法。 Registrator还支持传递元数据到[含有有关服务](https://github.com/progrium/registrator#single-service-with-metadata)密钥信息的容器。

另一个要提的是Registrator的验证似乎想要作为一个守护进程运行在Docker容器内。由于Docker Swarm集群被当做是一台Docker主机，我宁愿Registrator应用作为守护程序运行在Docker主机上。这样会使得在没有容器运行在集群上时群集仍然在运作。这似乎是一个很合适的地方来绘制平台和应用之间的界限。  

###集群层
在这一层，有着Docker master在运行。配置它是为读取在`/swarm`前缀下Consul的键/值的存储以及它产生的节点信息列表。同时它也在监听客户端与Docker（创建，删除，等..）的链接和发送路由那些与对应Docker主机终端的请求。这意味着，它具有以下需求：

* 能够监听网络
* 能够与Consul通信
* 能够与所有的Docker守护进程进行通信

由于但我还没有看到提到制作群守护程序本身HA的，但它的工作后，真的似乎没有任何理由，这不可能。我期待与TCP支持（HAProxy的）负载平衡代理可以放在几个群守护进程相对容易前面。粘性会话都必须启用，可能是一个积极的/如果有多个群守护进程之间的状态同步问题被动，但现在看来似乎是可行的。由于容器不继续运行，并且可访问的，即使在一个群失败，我们将接受过的复杂性和负载均衡节点的开销的非公顷群节点的风险的情况下。权衡吧？

###服务发现层
该服务发现层是运行一个Consul集群节点上;具体来说它是键/值存储的。为了维持法定个数（n/2 + 1个节点）即使在出现故障的情况下节点数也应该是个奇数。Consul有一个[非常大的特征集](http://www.consul.io/docs/index.html)，仅举几例包括自动服务发现、健康检查与键/值存储。我们只使用了键/值存储，但我希望结合Consul的其他方面到您的架构也能带来诸多好处。对于此配置示例，以下是处理是作用在键/值的存储：

* 在Docker主机的Swarm客户群会在`/swarm`中注册
* Swarm master会读取`/swarm`以构建其Docker主机列表
* 该Registrator守护进程会接待节点在`/services`前缀的进出
* Consul-template会读取键/值存储为路由层生成配置

这是中央数据存储为了所有群集的元数据。Consul是用来绑定在Docker主机上的容器与路由终端的条目。

Consul也有一个可安装的GUI（图形化用户界面）而且我强烈建议安装它用来开发工作。它可以使你搞清楚什么已经被注册以及哪里更容易做。一旦集群启动并运行，尽管你可能就不再需要它了。

###路由层
这是个边缘层，而且所有外部应用流量不管什么都将贯穿其中。这些节点都在Swarm集群的边缘，他们是静态的IP'd并且具有可CNAME'd到群集上的任何服务的DNS条目。这些节点监听端口80/443等，并有以下服务运行：

* Consul-template：此程序是轮询Consul的键/值存储（在`/services`下并在检测变化时，它会写入新的HAProxy/Nginx配置并优雅重新加载该服务。这些模板是用Go编写的以及输出应该是标准的HAProxy或Nginx形式。

* HAProxy或Nginx：这些服务器都是充分证明了战斗力的，并准备好所需要任何东西，即使是在边缘。Consul-template动态配置该服务并在需要时重新加载。这种主要变化的频繁出现的情况主要是终端的一个特定的虚拟主机列表的修改。由于是现存的东西来维护列表并且在Consul中，它的变化和容器一样频繁。

这是基于SOA的一个泊Docker Swarm集群的简要概述。在接下来的文章中，我将演示一个上述的工作基础设施。这篇文章将会在[Docker Denver Meetup](http://www.meetup.com/Docker-Denver/events/218859311/) 后发布，敬请关注！



所有这些在博文背后的研究能成为可能归功于我工作的公司： [Rally Software in Boulder, CO.](https://www.rallydev.com/careers/open-positions)。每季度我们至少有一个骇客周，它使我们能够研究很棒的东西，像Docker Swarm。如果您想切入正题，直接开始Vagrant 例子，这里有一个repo，它是我在2014年Q1骇客周研究的成果：

* [https://github.com/technolo-g/docker-swarm-demo](https://github.com/technolo-g/docker-swarm-demo)

**原文链接：[Intro to Docker Swarm: Part 2 - Configuration Options and Requirements](http://technolo-g.com/intro-to-docker-swarm-pt2-config-options-requirements/) （翻译：[田浩浩](https://github.com/llitfkitfk)）**

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
**译者介绍**
田浩浩，[悉尼大学USYD](http://sydney.edu.au/engineering/it/)硕士研究生，目前在珠海从事Android应用开发工作。业余时间专注Docker的学习与研究，希望通过[DockerOne](http://dockerone.com/)把最新最优秀的译文贡献给大家，与读者一起畅游Docker的海洋。

------------------------------------------
[Docker Swarm入门（一）概观](http://dockerone.com/article/168)
[Docker Swarm入门（二）配置选项与需求](http://dockerone.com/article/178)

