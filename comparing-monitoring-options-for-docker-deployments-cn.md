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
1. 易于部署：※※※※※
2. 细节度：※※※※※
3. 集成度：无
4. 生成警报的能力：无
5. 监测非Docker的资源的能力：无
6. 成本：0

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