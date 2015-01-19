##更安全的本地Docker网络

【编者的话】本文主要是解决了上一篇[探索本地Docker桥接网络](http://dockerone.com/article/137)提出的问题。

设置```icc=false```并使用容器链接来杜绝肆意的跨容器通信。

从这篇文章中如果你喜欢或学到了一些东西，那么可以考虑买我的书[Docker in Action](http://www.manning.com/nickoloff/)。1月6号此书会有Manning团购价（48小时），请使用促销代码：dotd010615au。

上周我写了[探索本地Docker桥接网络](http://dockerone.com/article/137)。在这篇文章中我描述了如何使用[nmap](http://nmap.org/)探索由同一桥接网络上的其他容器公开的服务。我展示了即使在这些服务并没有映射到主机的公有接口的端口的情况下依然可以访问。这是一个问题，因为大多数镜像的工具、数据库以及微服务都带有不安全的默认配置。较为变通的工程师或管理员可能会把这些镜像放到可以保护他们的防火墙或网络拓扑结构中。这只适用于配置了防火墙和网络拓扑的环境。

默认情况下，Docker允许任意的跨容器通信。在我看来这是一件好事。它不仅减少了应用时的冲突并且降低了学习曲线。我认为这是很重要的一方面使人们可以轻松地以任何技术开始使用Docker并且对人们理解Docker的发展有明确的道路。

其中有一条理解如何加强它们的容器网络的道路。人们应该学会的第一件事就是如何禁用任意的跨容器通信。当您启动Docker守护进程时设置```icc=false```。
{{{docker -d --icc=false ....
}}}

当您以这种方式启动Docker，它将配置[iptables（防火墙）](http://www.wikiwand.com/en/Iptables)：在桥接网路中移除所有容器间的通信。这将防止容器之间的通信。
{{{Chain FORWARD (policy ACCEPT)
target prot opt source    destination 
DROP   all  --  0.0.0.0/0 0.0.0.0/0 
ACCEPT all  --  0.0.0.0/0 0.0.0.0/0   ctstate RELATED,ESTABLISHED
ACCEPT all  --  0.0.0.0/0 0.0.0.0/0}}}

如果你压根就不想让你的容器可以直接相互通信，这样做是没问题的。没有什么能够阻止往返于主机的公共接口与可以公开访问的映射到另一个容器的端口之间的通信。

####下图展示了暴露主机端口的往返通信：
![](https://d262ilb51hltx0.cloudfront.net/max/446/1*_QyJABSe1WUQfVIXFHCw_w.png)


这是足够的对于许多人来说。但故事并没有到此结束。

当跨容器通信被禁用时使容器之间有明确的连接是可能的。您可以在容器创建时使用容器链接做到这一点。

当你创建一个容器并指定另一个作为链接的目标时，Docker建立相应的联动。例如：
{{{docker run -d --name ex_a busybox /bin/sh
docker run -d --name ex_b --link ex_a:other busybox /bin/sh}}}

如果我可以说现在我对Docker的任何部分都缺乏激情，那么它可能会为了服务搜寻而使用容器链接。当您连接两个容器时，带有位置详细信息的环境变量将被设置以便来使用此容器。但问题是有太多隐性契约的工作。创建消耗容器的程序或用户可以指定的链接的别名。但是容器内的软件必须与别名一致，否则它将不知道要寻找什么。即使我认为链接提供了端口信息以及网络地址信息，我仍然更喜欢DNS。幸运的是，链接不仅仅是为了服务搜寻。

当你禁用了跨容器通信时，Docker会创建明确的异常为了使连接的容器之间得以通信。以下是摘自有这样异常的iptables。
{{{Chain FORWARD (policy ACCEPT)
target prot opt source     destination 
ACCEPT tcp  --  172.17.0.3 172.17.0.4  tcp spt:80
ACCEPT tcp  --  172.17.0.4 172.17.0.3  tcp dpt:80
DROP   all  --  0.0.0.0/0  0.0.0.0/0 
ACCEPT all  --  0.0.0.0/0  0.0.0.0/0   ctstate RELATED,ESTABLISHED
ACCEPT all  --  0.0.0.0/0  0.0.0.0/0}}}

这是容器链接的最强大的应用。链接允许你用简单的断言来定义容器之间的关系。就轻量级而言，Docker确实比任何我用过的其他工具都更好。

不管怎样，回去工作并确保在新的一年里保护好自己。

**原文链接：[Safer Local Docker Networks](https://medium.com/@allingeek/safer-local-docker-networks-8ce22127f9df) （翻译：[田浩](https://github.com/llitfkitfk)）**