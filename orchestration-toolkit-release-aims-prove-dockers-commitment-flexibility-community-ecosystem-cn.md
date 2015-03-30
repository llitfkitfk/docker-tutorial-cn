
##Docker 发布编排工具包

【编者的话】Docker终于发布了编排工具Machine、Swarm以及Compose虽然Machine与Swarm还不是正式版本，但是读者们可以在官网doc里预览并参考这三个工具的文档，并加以对分布式应用的了解。

Docker今天发布了其在12月份欧洲DockerCon上宣布并承诺的编排工具包。这三个编排工具的目的是展示Docker的跨数据服务器托管的基础设施的“100%的可移植性”，包括实现混合云架构来运行容器式或分布式应用程序。

当去年在阿姆斯特丹宣布编排工具包时，间接地回应起初社区对此问题的关切，Docker着重的是自由，开发商将不得不控制如何在生产环境中构建、装载与启用多容器，多主机应用程序。

这三个编排工具有：Docker Machine、Docker Swarm与Docker Compose。Machine与Swarm是beta版，而Compose发布的是1.1版本。


###Docker Machine
[Docker Machine](https://docs.docker.com/machine/)使一命令自动化，以提供一个主机的基础设施并安装Docker引擎。Docker公司企业营销副总裁兼系统管理员与运维－David Messina说它非常适合于混合环境中，对于每个数据托管基础设施供应商，“再也不用学习一套独立的命令来获取并启用一个Docker容器应用”。Messina还说过对于Docker Machine，用户可以使用一个统一的命令来削减跨基础设施的成本。beta版本中有十二驱动程序，其中包括Amazon EC2，Google Cloud Engine，Digital Ocean与VMware。

至今无法量化他们的用户量的Docker可能会寻求跨混合公共云架构的协调分布式应用程序，但Messina承认“最终，大体上我们的目标是：Machine是关键的推动者，这是肯定的“。

###Docker Swarm
[Docker Swarm](https://docs.docker.com/swarm/)是一个集群和调度工具，它会自动优化分布式应用程序的基础架构基于应用程序的生命周期阶段、容器的使用与性能的需求。

Messina说：“Swarm有多个模块来决定调度，包括了解特定的容器有怎样的特定的资源需求－计算和内存是最明显的例子。”处理调度算法时，Swarm将决定哪个引擎和主机应该运行。Messina举了一个例子，其中，在一些应用中，重点需要考虑亲和度－在同一主机上某些容器能最好的运行。

“Swarm的核心内容是，当你使用多主机，分布式应用程序时，你想要保持开发的经验而且具有完全的便携性。Swarm提供了连续性，但你也想拥有的灵活性：例如，对于您正在使用的应用程序可以使用特定的集群的解决方案的能力。这确保集群功能一直是便携的不管是从笔记本电脑还是到生产环境中。“

###保持Swarm灵活性
为了生态系统合作伙伴，该Swarm版本还配备了一个Swarm API用于创造可替代或可补充的编排工具，以便对于某些更细致入微的特定使用案例它可以超过Docker Swarm的优化算法。

这是Docker一直呼吁的“batteries-included-but-swappable”（译注：想象一下以前能换手机电池的诺基亚手机:)）的方法。有些用户可能愿意使用Docker Swarm以确定多容器分布式应用程序架构的优化集群。其他人会想用Swarm的集聚和调度部分来设置自己的参数，而还有一些人将目光转向生态系统合作伙伴的替代编排优化产品来推荐最佳集群组合。

Apache Mesos（译注：想要了解Mesos的朋友可以参考[这里](http://dockerone.com/topic/Mesos)）的企业赞助商，Mesosphere，最初的Docker生态系统合作伙伴，他们使用Swarm API创建了替代优化产品。其他期望未来会有来自Amazon、Google、Joyent与MS Azure。

Mesosphere营销副总裁－Matt Trifiro说：“Swarm首次公布后，Mesosphere和Docker聚集在一起，因为两家公司的工程师立即看到了如何将这两个项目放在一起工作。”

在DockerCon EU，Docker创始人兼CTO－Solomon Hykes挑出Mesosphere的技术做为规模化运行容器的黄金标准。（参见[YouTube视频](https://www.youtube.com/watch?v=sGWQ8WiGN8Y)35分钟左右）

Trifiro说，对于大规模运行的分布式应用程序，Mesosphere的编排工具，相对于Swarm的“batteries-included”版本，更适合以确定优化的集群及调度业务流程：

他说对于Mesosphere与Swarm一体化有两件事情要强调：

1. **Hyperscale（超大规模）**：对于任何希望在数百或数千台服务器上，无论是内部部署还是在云中一个高度自动化的环境中运行的容器的大型企业，Mesosphere的技术是唯一公开可用的容器编排系统 － 运行数百万容器在企业，像Twitter、Groupon和Netflix，以及在一些最大的消费类电子产品和金融服务公司。

2. **Multitenant Diversity of Workloads（工作负载的多租户多元化）**：Mesosphere的技术是一个企业组织想要同一集群其他类型的工作负载上运行Docker Swarm工作量的高弹性方​​式的必由之路。例如，你可以在一台Mesosphere集群上相互运行Cassandra、Kafka、Storm、Hadoop和Docker Swarm工作负载，他们都共享相同的资源。这使得更有效地利用集群资源，大大降低了运营成本和复杂性。

###Docker Compose
使用[Docker Compose](https://docs.docker.com/compose)工具构建在Swarm上运行多容器应用程序。Compose工具使用YAML文件来维护所有应用程序容器的逻辑定义以及它们之间的连接。Compose内置分布式应用程序无需影响在编排链的其他服务实现动态更新。

###潜台词：我们可以做的更好
Docker发布Swarm以及Swarm API的方式用来消除[那些当Docker起初在十二月提出这些解决方案的社区害怕](http://thenewstack.io/docker-extends-platform-story-for-app-development-and-deployment-st-scale/)。Docker一直致力于为社区合作伙伴建立一个生态系统经济，他们已经构建了加强DevOps、监控、持续改进、质量保证以及需要在一个容器化、分布式应用环境中定位的其他程序的产品。在社区的一些成员中最初的害怕是对直接从Docker创造编排工具的担心，此举会太严格执行“Docker的做事方式”。他们担心这些而不是担心能不能够创造一个像Mesosphere那样的集成产品，竞争编排工具将需要使用一个精密变通的解决方法，以提供一个替代Docker已经有的产品。

Docker编排公告一再被推广说是100％的便携性以及Swarm API的 “batteries-included-but-swappable”的性质巧妙地解决这一问题。

Messina说：“如果你看看编排公告，和所有这些工作与规划集成，但现实是Docker编排工具与生态系统合作伙伴的合作特别地开放。Docker社区需要建立多容器和多主机的分布式应用程序－这一直是我们的社区绝对任务。这些工具的结构方式使得他们非常灵活，并设置了允许合作伙伴以开发先进与丰富服务的API。这里的整体思路是我们要维持开发经验和100％的可移植性。为了选择的自由，社区是如何设置这些容器和优化集群。“

**原文链接：[Docker Releases Orchestration Tool Kit](http://thenewstack.io/orchestration-toolkit-release-aims-prove-dockers-commitment-flexibility-community-ecosystem/) （翻译：[田浩浩](https://github.com/llitfkitfk)）**

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
**译者介绍**
田浩浩，[悉尼大学USYD](http://sydney.edu.au/engineering/it/)硕士研究生，目前在珠海从事Android应用开发工作。业余时间专注Docker的学习与研究，希望通过[DockerOne](http://dockerone.com/)把最新最优秀的译文贡献给大家，与读者一起畅游Docker的海洋。