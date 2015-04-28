Usman是服务器和基础架构工程师，在各种云平台上构建大规模分布式服务有丰富的经验。你可以在[techtraits.com](http://techtraits.com/)阅读他的更多文章，或者在twitter上添加他[@usman_ismail](https://twitter.com/usman_ismail)或是在[GitHub](https://github.com/usmanismail)。

由于一些大型部署使用的是Docker，因此获取Docker环境的状态与健康的可视化就显得尤为重要了。在这篇文章中，我的目标是重温一些用来监测容器的常用工具。我会基于以下标准来评估这些工具：
	1. 易于部署
	2. 呈现信息的详细级别
	3. 整个部署信息的综合水平
	4. 可以从数据生成警报
	5. 可以监测非Docker的资源
	6. 成本
虽然这个名单不是很全面，但是我试图强调的是最常用的工具以及优化此六项评估标准的工具。

##Docker Stats命令
文中的所有命令都专门在亚马逊网络服务EC2上运行的RancherOS实例上测试过。不过，今天所提到的工具应该在任何Docker部署上都能使用。

我将讨论的第一个工具是Docker本身。你可能不知道Docker客户端已经提供了基本的命令行工具来检查容器的资源消耗。想要查看容器统计信息只需运行`docker stats [CONTAINER_NAME]`。这样就可以查看每个容器的CPU利用率、内存的使用量以及可用内存总量。请注意，如果您没有对容器限制内存，那么该命令将显示您的主机的内存总量。但它并不意味着你的每个容器都能访问那么多的内存。另外你还能看到由容器通过网络发送和接收的数据总量。

{{{
	$ docker stats determined_shockley determined_wozniak prickly_hypatia
CONTAINER             CPU %               MEM USAGE/LIMIT       MEM %               NET I/O
determined_shockley   0.00%               884 KiB/1.961 GiB     0.04%               648 B/648 B
determined_wozniak    0.00%               1.723 MiB/1.961 GiB   0.09%               1.266 KiB/648 B
prickly_hypatia       0.00%               740 KiB/1.961 GiB     0.04%               1.898 KiB/648 B}}}

对于更详细的容器统计信息还可以使用Docker远程API 通过netcat来查看（见下文）。发送一个HTTP GET请求`/containers/[CONTAINER_NAME]`，其中`CONTAINER_NAME`是你想要统计的容器名称。你可以从[这里](https://gist.github.com/usmanismail/0c4922ffec4a0220d385)看到一个容器统计请求的详细信息。在上述的例子中你会得到缓存、交换空间以及内存的详细信息。如果要了解什么是metrics，那么你就需要精读Docker文档的[Run Metrics部分](https://docs.docker.com/articles/runmetrics/)。

####评分：
1. 易于部署程度：※※※※※
2. 信息详细程度：※※※※※
3. 集成度：无
4. 生成警报的能力：无
5. 监测非Docker的资源的能力：无
6. 成本：免费

##CAdvisor
`Docker stats`命令和远程API用于命令行上的信息获取，但是，如果您想要在图形界面中访问信息，那么你就需要一个工具，如[CAdvisor](https://github.com/google/cadvisor)。CAdvisor提供了早前Docker stats命令所显示的数据的可视化界面。运行以下Docker命令，在浏览器里访问`http://<your-hostname>:8080/`可以看到CAdvisor的界面。你将看到一些图标包括：全部CPU的使用率、内存使用率、网络吞吐量以及磁盘空间利用率。然后，您可以通过点击在网页顶部的`Docker Containers`链接，然后选择某个容器去深入了解此容器的使用情况统计。除了这些统计信息，CAdvisor还显示容器的限制，如果有的话，被放置在容器中，用分离部。

{{{
docker run                                     			\
  --volume=/:/rootfs:ro                         		\
  --volume=/var/run:/var/run:rw                 	\
  --volume=/sys:/sys:ro                         		\
  --volume=/var/lib/docker/:/var/lib/docker:ro	\
  --publish=8080:8080                           		\
  --detach=true                                 			\
  --name=cadvisor                               		\
  google/cadvisor:latest  }}}

![](http://rancher.com/wp-content/uploads/2015/03/Screen-Shot-2015-03-19-at-11.50.29-PM.png)

CAdvisor是有用且很容易设置的工具，我们可以不用ssh就能连接到服务器来查看资源的消耗，而且它还给我们生成了图表。此外，当群集需要额外的资源时，压力表提供了快速预览。而且，与本文中的其他的工具不一样的是CAdvisor是免费的，因为它是开源的，同时它运行已配置群集的硬件上，最后，除了一些进程资源，CAdvisor并没有额外的消耗成本。但是，它有它的局限性；它只能监控一个Docker主机，因此，如果你有一个多节点部署，那么统计数据将是不相交的而且分散你的集群。值得注意的是，如果你使用的是Kubernetes，你可以使用[heapster](https://github.com/GoogleCloudPlatform/heapster)来监控多节点集群。在图表中的数据仅仅是时长一分钟的移动窗口，并没有方法来查看长期趋势。如果资源使用率在危险水平，它却没有生成警告的机制。如果在Docker节点的资源消耗方面，你没有任何可视化界面，那么CAdvisor是一个不错的开端来带你步入容器监控，然而如果你打算在你的容器中运行任何关键任务，那么更强大的工具或者方法是必要的。需要注意的是[Rancher](http://rancher.com/rancher-io/)在每个连接的主机上运行CAdvisor，并通过UI公开了一组有限的统计数据，并且通过API公开了所有的系统统计数据。

####评分：（忽略了heapster，因为它仅支持Kubernetes）
1. 易于部署程度：※※※※※
2. 信息详细程度：※※
3. 集成度：※
4. 生成警报的能力：无
5. 监测非Docker的资源的能力：无
6. 成本：免费

##Scout
下一个Docker监控的方法是Scout，它解决了几个CAdvisor的局限。 Scout是聚合来自多个主机和容器的托管监控服务并且它有更长时间的数据呈现。它也可以基于这些指标生成警报。要获取Scout并运行，第一步，在[scoutapp.com](https://scoutapp.com/)注册一个Scout帐户，免费的试用账号足以用来集成测试。一旦你创建了自己的帐户并登录，点击右上角您的帐户名称，然后点击Account Basics来查看你的Account Key，你需要这个Key从我们的Docker服务器来发送指标。
![](http://rancher.com/wp-content/uploads/2015/03/Screen-Shot-2015-03-21-at-9.30.08-AM.png)
![](http://rancher.com/wp-content/uploads/2015/03/accountid.png)

现在在你的主机上，创建一个名为scouts.yml的文件并将下面的文字复制到该文件中，用上边得到的Key替换到account_key。您可以对主机指定任何有意义的变量：display_name、environment与roles等属性。当他们在scout界面上呈现时，这些将用于分离各种指标。我假设有一组网站服务器列表正在运行Docker，它们都将采用如下图所示的变量。

{{{
# account_key is the only required value
account_key: YOUR_ACCOUNT_KEY
hostname: web01-host
display_name: web01
environment: production
roles: web}}}

现在，你可以使用scout配置文件通过Docker-scout插件来运行scout。

{{{
docker run -d  --name scout-agent                              \
    -v /proc:/host/proc:ro                                     	         \
    -v /etc/mtab:/host/etc/mtab:ro                                   \
    -v /var/run/docker.sock:/host/var/run/docker.sock:ro    \
    -v `pwd`/scoutd.yml:/etc/scout/scoutd.yml                     \
    -v /sys/fs/cgroup/:/host/sys/fs/cgroup/                           \
    --net=host --privileged                                                   \
    soutapp/docker-scout}}}

这样你查看Scout网页就能看到一个条目，其中display_name参数（web01）就是你在scoutd.yml里面指定的。

![](http://rancher.com/wp-content/uploads/2015/03/Screen-Shot-2015-03-21-at-9.58.40-AM.png)

如果你点击它（web01）就会显示主机的详细信息。其中包括任何运行在你主机上的进程计数、cpu使用率以及内存利用率，值得注意的是在docker内部并没有进程的限制。

![](http://rancher.com/wp-content/uploads/2015/03/Screen-Shot-2015-03-21-at-10.00.47-AM.png)

如果要添加Docker监控服务，需要单击Roles选项卡，然后选择所有服务。现在点击+插件模板按钮，接下来的Docker监视器会加载详细信息视图。一旦详细信息呈现出来，选择安装插件来添加到您的主机。接着会给你提供一个已安装插件的名称以及需指定要监视的容器。如果该字段是空的，插件将监控主机上所有的容器。点击完成按钮，一分钟左右你就可以在[Server Name] > Plugins中看到从Docker监控插件中获取的详细信息。该插件为每个主机显示CPU使用率、内存使用率、网络吞吐量以及容器的数量。

![](http://rancher.com/wp-content/uploads/2015/03/Screen-Shot-2015-03-20-at-10.11.06-PM.png)

你点击任何一个图表，都可以拉取该指标的详细视图，该视图可以让你看到时间跨度更长的趋势。

![](http://rancher.com/wp-content/uploads/2015/03/Screen-Shot-2015-03-20-at-10.11.39-PM.png)

该视图还允许您过滤基于环境和服务器角色的指标。此外，您可以创建“Triggers”或警报，如果指标高于或低于配置的阈值它就给你发送电子邮件。这就允许您设置自动警报来通知您，比如，如果你的一些容器异常关闭以及容器计数低于一定数量。您还可以设置对平均CPU利用率的警报，举例来说，如果你正在运行的容器超过CPU利用率而发热，你会得到一个警告，当然你可以开启更多的主机到你的Docker集群。

要创建触发器，请选择顶部菜单的Roles>All Servers，然后选择plugins部分的Docker monitor。然后在屏幕的右侧的Plugin template Administration菜单里选择triggers。您现在应该看到一个选项“Add a Trigger”，它将应用到整个部署。

![](http://rancher.com/wp-content/uploads/2015/03/Screen-Shot-2015-03-22-at-6.30.25-PM.png)

下面是一个触发器的例子，如果部署的容器数量低于3就会发出警报。

![](http://rancher.com/wp-content/uploads/2015/03/Screen-Shot-2015-03-22-at-6.33.12-PM.png)

它的创建是为“所有的服务器”，当然你也可以用不同的角色标记你的主机使用服务器上创建的scoutd.yml文件。使用角色。你可以通过使用不同角色来应用触发器到部署的服务器的一个子集上。例如，你可以设置一个当在你的网络的节点的容器数量低于一定数量时的警报。即使是基于角色的触发器我仍然觉得Scout的警报系统可能做的更好。这是因为许多Docker部署具有相同主机上的多种多样的容器。在这种情况下为特定类型的容器设置触发器将是不可能的由于角色被应用到主机上的所有容器。

比起CAdvisor，使用Scout的另一个优点是，它有[大量的插件](https://scoutapp.com/plugin_urls)，除了Docker信息他们可以吸收其他有关你的部署的数据。这使得Scout是你的一站式监控系统，而无需对系统的各种资源来安装各种不同的监控系统。

Scout的一个缺点是，它不显示有关每个主机上像CAdvisor的单独容器的详细信息。这是个问题，如果你在同一台服务器上运行大量的容器。例如，如果你想有一个触发器来提醒您的Web容器的警报，但不是Jenkins容器，这时Scout就无法支持该情况。尽管有这个缺点，Scout还是一个相当有用的工具来监控你的Docker部署。当然这要付出一些代价，每个监控的主机十美元。如果你要运行一个有多台主机的超大部署，这个代价会是个考虑因素。

####评分：
1. 易于部署程度：※※※※
2. 信息详细程度：※※
3. 集成度：※※※
4. 生成警报的能力：※※※
5. 监测非Docker的资源的能力：支持
6. 成本：每个主机$10

##Data Dog
从Scout移步到另一个监控服务，DataDog，它既解决几个Scout的缺点又解除了CAdvisor的局限性。要使用DataDog，先在[https://www.datadoghq.com/](https://www.datadoghq.com/)注册一个DataDog账户。一旦你登录到您的帐户，您将看到支持集成的每种类型的指令列表。从列表中选择Docker，你会得到一个Docker run命令（如下），将其复制到你的主机。该命令需要你的预先设置的API密钥，然后你可以运行该命令。大约45秒钟后您的代理将开始向DataDog系统报告。

{{{
docker run -d --privileged --name dd-agent             \
    -h `hostname`                                      \
    -v /var/run/docker.sock:/var/run/docker.sock       \
    -v /proc/mounts:/host/proc/mounts:ro               \
    -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro          \
    -e API_KEY=YOUR_API_KEY datadog/docker-dd-agent    \}}}

现在，您的容器连接，你可以去在DataDog Web控制台的事件选项卡，看到有关你的集群中的所有事件。所有的容器启动和终止将这一事件流的一部分。

![](http://rancher.com/wp-content/uploads/2015/03/Screen-Shot-2015-03-21-at-2.56.04-PM.png)

您也可以点击Dashboards标签并点击创建仪表板以合计您整个群集的指标。 Datadog收集系统中运行的所有容器中有关CPU使用率、内存以及I/O的指标。此外，您也可以获得运行和停止的容器计数以及Docker的镜像数量。Dashboard视图允许您创建基于任何指标或者设置在整个部署、主机群或者容器镜像的指标的图表。例如下图显示了运行容器的数量并加以镜像类型分类，此刻在我的集群运行了9个Ubuntu:14.04的容器。

![](http://rancher.com/wp-content/uploads/2015/03/Screen-Shot-2015-03-21-at-2.35.21-PM.png)

您还可以通过主机分类同样的数据，如下图所示，7个容器在我的Rancher主机上运行，其余的在我的本地的笔记本电脑。

![](http://rancher.com/wp-content/uploads/2015/03/Screen-Shot-2015-03-21-at-3.14.10-PM.png)

DataDog还支持一种称为Monitors的警报功能。DataDog的一个monitor相当于Scout的一个触发器，并允许您定义各种指标的阈值。 DataDog的警报系统是一个很大的灵活和细致再斥候。下面的例子说明如何指定您关心的Ubuntu容器终止因此你会监视docker.containers.running度量从Ubuntu创建容器：14.04Docker的镜象。
