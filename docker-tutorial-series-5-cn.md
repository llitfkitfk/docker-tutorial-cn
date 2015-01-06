##Docker教程系列 5 Docker Security

安全必须认真对待，当涉及开源责任性问题。当开发者拥抱Docker，在本地构建应用程序一致到声场部署也是一样的。随着部署在很多地方，它也是一个相当大的责任，重点将会是Docker作为一个项目或者平台的安全性。

因此，我们决定在[Docker教程系列的第五章]()来讨论：Docker security的重点领域以及为什么他们影响到Docker的整体安全性。鉴于Docker是LXCs的延伸，它也很容易使用LXCs的安全功能。

在本系列的第一部分，我们讨论了Docker run命令的执行以及运行容器。然而，到底发生了什么：
1. Docker run命令启动。
2. Docker 运行 lxc-start 来执行run命令。
3. lxc-start 在容器中创建了一组namespace和control groups。

对于那些不知道namespace和control groups的概念的在这里解释一下：namespace是隔离的第一级，而不是两个容器可以查看或控制在他们内部运行的进程。每个容器被分配到单独的网络栈中，因此一个容器不能访问另一容器的sockets。为了允许容器之间的IP通信，您必须指定容器的公网IP端口。

Control Groups的关键组件具有以下功能：

- 负责资源核算和限制。
- 提供相关CPU、内存、I/O和network。
- 试图避免某种DoS攻击。
- 对多租户平台是有意义的。

###Docker Daemon的攻击面
Docker Daemon以root权限运行，这意味着有一些问题需要格外小心
以下介绍一些有趣的要点：

- Docker daemon的控制应该只给授权用户当Docker允许与访客容器目录共享而不限制其访问权限时。
- 现在REST API endpoint支持Unix sockets，从而防止了cross-site-scripting攻击。
- REST API可通过HTTP在使用适当的可信任网络或者VPN而暴露出来。
- 在服务器上专门运行Docker（在完成时），隔离所有其它服务。

一些关键的Docker security特性包括：

1. Processes，当容器以非特权用户运行时，维护一个良好的安全水平。
2. Apparmor、SELinux、GRSEC解决方案，可用于额外的安全层。
3. 有继承其他容器系统的安全功能的能力。

###Docker.io API
用于管理与有关授权和安全的几个进程，Docker提供REST API。下表列出了关于此API用于维护相关的安全功能的一些命令。

![](http://cdn2.hubspot.net/hub/411552/file-1222267319-png/blog-files/part-5-1.png?t=1419682672898)

[Docker教程系列下一章]()我们继续探讨[前面第二章](http://dockerone.com/article/102)所讨论的Docker命令的进阶。