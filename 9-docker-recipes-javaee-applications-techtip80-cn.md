在Docker中运行Java EE程序的九个诀窍

你想要使用使用Docker来运行Java EE应用程序吗？

一个典型的Java EE应用程序包括应用服务器，如WildFly和数据库，如MySQL的。此外，你可能有一个独立的前端层，说阿帕奇，负载均衡一些应用服务器。的高速缓存层，例如Infinispan的，也可以使用，以提高整体的应用性能。消息传送系统，如ActiveMQ的，可用于处理队列。无论是缓存和消息组件可以设置为一个集群进一步扩展性。

此技术提示会显示一些简单的泊坞窗的食谱来配置你的容器使用应用服务器和数据库。随后博客将覆盖更高级的食谱，其中将包括前端，缓存，消息和聚类。

让我们开始吧！

泊坞窗配方＃1：使用泊坞窗机设置泊坞窗

如果泊坞窗尚未设置你的机器上，那么作为第一步，你需要设置它。如果你是一个最新版本的Linux，那么你已经有了泊坞窗。或任选可被安装为：

命令和apt-get安装docker.io
在Mac和Windows，这意味着安装boot2docker这是一个Tinycore Linux的虚拟机，并​​配备了泊坞窗主机。然后，你需要配置SSH密钥和证书。

幸运的是，这是非常使用泊坞窗机简化。这需要你从零到泊坞窗的主机用一个命令就。该主机可以是你的笔记本电脑，在云中，或在您的数据中心。它创建的服务器，他们安装泊坞窗，然后配置泊坞窗客户与他们交谈。

这个配方进行了详细解释泊坞窗机到设置泊坞窗主机。

泊坞窗配方＃2：应用服务器+内存数据库

其中的Java EE 7的很酷的功能是默认的数据库资源。这可以让你不用担心在应用程序服务器特定之前，你的应用程序可以访问创建一个JDBC资源。任何Java EE 7兼容的应用程序服务器将地图默认的JDBC资源名称（爪哇：比较/ DefaultDataSource）在捆绑的数据库服务器，应用服务器特定的资源。

例如，WildFly捆绑了H2内存数据库。该数据库已准备好，一旦被用作WildFly准备好接受你的请求。这简化了您的开发工作，并允许你做一个快速原型。默认JDBC资源被映射到
java的：JBoss的/数据源/ ExampleDS，然后映射到JDBC的JDBC URL：H2：mem的：测试; DB_CLOSE_DELAY = -1; DB_CLOSE_ON_EXIT = FALSE。

在这种情况下，数据库服务器是应用程序服务器内部运行其他应用程序。

泊坞窗配方为Java EE应用程序＃1

下面是运行的Java EE 7的应用程序中WildFly命令：

泊坞窗运行 - 它-p 8080：8080 arungupta / javaee7-HOL
如果你想运行使用WildFly和H2内存数据库一个​​典型的Java EE 7的应用程序，那么这个泊坞窗配方进行了详细动手实验室的WildFly和码头工人解释的Java EE 7。

泊坞窗配方＃3：两个集装箱在相同主机使用链接

以前的配方让你起步很快，但成为一个瓶颈一旦数据库是只在内存中。这意味着，你的架构和数据所做的任何更改应用服务器关闭后丢失。在这种情况下，需要使用驻留在应用服务器外部的数据库服务器。例如，MySQL作为数据库服务器和WildFly作为应用服务器。

让事情变得简单，无论是数据库服务器和应用服务器可以在同一台主机上运行。

泊坞窗配方为Java EE应用程序＃2

泊坞窗集装箱链接用来将两个容器相连。创建两个容器之间的联系产生源容器和目标容器和安全地传输有关源容器的信息到目标容器之间的管道。在我们的例子中，目标容器（WildFly）可以看到有关源容器（MySQL的）信息。了解这里最重要的部分是，需要加以公开由源容器暴露没有这个信息，并且只提供给目标容器。

下面是启动MySQL和WildFly容器和连接它们的命令：

泊坞窗运行--name MySQLdb的-e MYSQL_USER =的mysql -e MYSQL_PASSWORD =的mysql -e MYSQL_DATABASE =采样-e MYSQL_ROOT_PASSWORD =绝密-d mysql的
泊坞窗运行--name mywildfly --link MySQLdb的：DB -p 8080：8080 -d arungupta / wildfly-的mysql-javaee7
WildFly和MySQL在两个码头工人的容器相连解释了如何设置这个食谱。

泊坞窗配方＃4：两个集装箱在相同主机使用图

以前的配方要求你在一个特定的顺序运行的容器。运行多容器应用程序可以迅速成为具有挑战性的，如果您的应用程序的每一层是坐在一个容器。图（不赞成使用泊坞窗撰写的）是一个泊坞窗编排工具是：

在一个配置文件中定义多个容器
通过创建它们之间的联系建立两个容器之间的依赖关系
以正确的顺序启动容器
泊坞窗配方为Java EE应用程序＃3

的入口点图是一个配置文件，如下所示：

MySQLdb的：
  图片：mysql的：最新
  环境：
    MYSQL_DATABASE：样品
    MYSQL_USER：MySQL的
    MYSQL_PASSWORD：MySQL的
    MYSQL_ROOT_PASSWORD：绝密
mywildfly：
  图片：arungupta / wildfly-的mysql-javaee7
  链接：
     - MySQLdb的：DB
  端口：
     - 8080：8080
和所有的容器可以开始为：

无花果了-d
利用图泊坞窗编排解释了这个配方的细节。

图只接收更新。它的代码库作为基础泊坞窗撰写。这将在接下来的配方进行说明。

泊坞窗配方＃5：两个集装箱在相同主机使用撰写

泊坞窗撰写是用于定义和使用泊坞窗运行复杂应用程序的工具。与撰写，您可以定义在一个文件中的多容器应用程序，然后旋转你的应用中，确实需要做才能得到它运行一切一条命令。

应用程序配置文件是相同的格式由图该容器可以开始为：

泊坞窗，撰写了-d
这个配方进行了详细解释泊坞窗撰写编排容器。

泊坞窗配方＃6：两个集装箱在不同的主机使用的IP地址

在先前的配方，将两个容器的同一主机上运行。这两个可以使用泊坞窗链接很容易沟通。但简单的容器联不允许跨主机通信。

在同一台主机上运行的容器意味着你不能扩展每个层，数据库或应用程序服务器，独立。这是你需要一个单独的主机上运行的每个容器。

泊坞窗配方为Java EE应用程序＃4

MySQL的容器可以作为开始：

泊坞窗运行--name MySQLdb的-e MYSQL_USER =的mysql -e MYSQL_PASSWORD =的mysql -e MYSQL_DATABASE =采样-e MYSQL_ROOT_PASSWORD =绝密-p 5306：3306 -d mysql的
JDBC资源可以被创建为：

数据源添加--name = mysqlDS --driver名= mysql的--jndi名= java的：JBoss的/数据源/ ExampleMySQLDS --connection-url=jdbc:mysql://$MYSQL_HOST:$MYSQL_PORT/sample?useUnicode=true&amp;characterEncoding=UTF-8 --user名= mysql的--password = mysql的--use-CCM =假--max池大小= 25 --blocking超时等待，米利斯= 5000 --enabled =真
和WildFly容器可以为启动：

泊坞窗运行--name mywildfly -e MYSQL_HOST = <IP地址> -e MYSQL_PORT = 5306 -p 8080：8080 -d arungupta / wildfly-的mysql-javaee7
完整的细节这个配方在多个主机泊坞窗容器联解释。

泊坞窗配方＃7：两个容器上使用泊坞窗群不同的主机

泊坞窗机

泊坞窗群是本地集群的码头工人。原来泊坞窗主机池成一个单一的，虚拟主机。它拿起向上，其中泊坞窗机通过优化主机资源利用率​​，并提供故障转移服务留下了。具体来说，泊坞窗群允许用户创建运行泊坞窗守护进程的主机资源池，然后安排泊坞窗容器之上运行，自动管理工作量安置和维护群集状态。

关于这个配方的更多细节即将在随后的博客。

泊坞窗配方＃8：从Eclipse中部署Java EE应用程序

最后一个配方将处理如何将现有的应用程序部署到泊坞窗容器。

比方说，你正在使用JBoss的工具为你的开发环境和WildFly为您的应用程序服务器。

Eclipse的标志JBoss的工具徽标

有一对夫妇的方法，使这些应用程序可以部署：

使用泊坞窗卷+本地部署：在这里，你的本地计算机上的某个目录安装为泊坞窗卷。 WildFly泊坞窗容器开始通过映射该目录的部署目录为：
泊坞窗运行 - 它-p 8080：8080 -v /用户/ arungupta的/ tmp /部署中：/ opt / JBoss的/ wildfly /独立/部署/：RW的JBoss / wildfly
配置JBoss工具WAR文件部署到该目录。

使用WildFly管理API +远程部署：启动WildFly泊坞窗容器，还揭露管理端口9990为：
泊坞窗运行 - 它-p 8080：8080 -p 9990：9990 arungupta / wildfly管理
配置JBoss的工具来使用远程服务器WildFly和部署使用管理API。

这个配方进行了详细的部署，从Eclipse的解释WildFly和泊坞窗。

泊坞窗配方＃9：使用的Arquillian立方测试的Java EE应用程序

的Arquillian立方允许您控制泊坞窗图像的生命周期作为测试生命周期的一部分，无论是自动还是手动。多维数据集使用泊坞窗REST API交谈的容器。它使用了远程适配器的API，例如WildFly在这种情况下，进行通话的应用程序服务器。泊坞窗的配置被指定为Maven的万无一失，作为插件的一部分：

<配置​​>
    <systemPropertyVariables>
    <arquillian.launch> wildfly-泊坞窗</arquillian.launch>
    <arq.container.wildfly-docker.configuration.username>admin</arq.container.wildfly-docker.configuration.username>
    <arq.container.wildfly-docker.configuration.password>Admin#70365</arq.container.wildfly-docker.configuration.password>
    <arq.extension.docker.serverVersion> 1.15 </arq.extension.docker.serverVersion>
    <arq.extension.docker.serverUri> http://127.0.0.1:2375 </arq.extension.docker.serverUri>
    <arq.extension.docker.dockerContainers>
        wildfly-泊坞窗：
            图片：arungupta / javaee7样本，wildfly
            exposedPorts：[8080 / TCP，9990 / TCP]
            等待：
                策略：投票
                sleepPollingTime：50000
                迭代：5
            portBindings：[8080 / TCP，9990 / TCP]
    </arq.extension.docker.dockerContainers>
    </ systemPropertyVariables>
</配置>
可使用的Arquillian立方的码头工人运行的Java EE测试这个食谱完整细节。

你使用的是什么其他的配方使用泊坞窗来部署Java EE应用程序？

享受！