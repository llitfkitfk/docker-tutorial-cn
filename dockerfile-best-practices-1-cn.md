【Docker进阶】Dockerfile最佳实践（一）

【编者的话】本文是[Docker入门教程](http://dockerone.com/article/111)系列的[第三章－DockerFile](http://dockerone.com/article/103)的进阶篇第一部分

Dockerfiles为构建镜像提供了简单的语法。下面是一些提示与技巧来帮助您最有效地使用Dockerfiles。

###1：使用缓存
Dockerfile的每条指令都会将更改提交到新的镜像，该镜像将被用于下一个指令的基础镜像。如果一个镜像存在相同的父类镜像和指令（除了```ADD```）Docker将会使用镜像而不是执行该指令，即缓存。

为了有效地利用缓存，你需要保持你的Dockerfiles一致，并且改建在末尾添加。我所有的Dockerfiles开始于以下五行：
{{{FROM ubuntu
MAINTAINER Michael Crosby <michael@crosbymichael.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y
}}}

更改```MAINTAINER```指令会使Docker强制执行```RUN```指令来更新apt，而不是使用缓存。

**保持常用的Dockerfile指令在顶部来利用缓存。**

###2：使用标签
除非你正在用Docker做实验，否则你应当通过```-t```选项来```docker build```新的镜像以便于标记构建的镜像。一个简单的可读标签将帮助您管理每个创建的镜像。
```docker build -t="crosbymichael/sentry" .
```

**始终通过```-t```标记来构建镜像。**

###3：公开端口
两个Docker的核心概念是可重复和可移植。镜像应该能运行在任何主机上并且能运行尽可能多的次数。在Dockerfiles中您有能力映射私有和公有端口，但是你永远不要在Dockerfile中映射公有端口。通过映射公有端口到主机上，你将只能运行一个容器化应用程序实例。
{{{# private and public mapping
EXPOSE 80:8080

# private only
EXPOSE 80}}}
	
如果镜像的消费者关心容器公有映射了哪个公有端口，他们可以在运行镜像时设置```-p```选项，否则，Docker会给容器自动分配端口。

**切勿在Dockerfile映射公有端口。**

###4：CMD与ENTRYPOINT的语法
无论```CMD```还是```ENTRYPOINT```都是直线前进的，但他们有一个隐藏的错误“功能”，如果你不知道的话他们可能会触发问题。这些指令支持的两种不同的语法。
{{{CMD /bin/echo
# or
CMD ["/bin/echo"]
}}}

这看起来好像没什么问题，但深入细节里的魔鬼会将你绊倒。如果你使用第二个语法：```CMD```（或```ENTRYPOINT```）是一个数组，它执行的命令完全像你期望的那样。如果使用第一种语法，Docker会在你的命令前面加上```/bin/sh -c```。我记得一直都是这样。

如果你不知道Docker修改了```CMD```命令，在命令前加上```/bin/sh -c```可能会导致一些意想不到的问题以及不容易理解的功能。因此，在使用这两个指令你应当总是使用数组语法，因为两者都会确切地执行你打算执行的命令。

**使用CMD和ENTRYPOINT时，请务必使用数组语法。**

###5. CMD和ENTRYPOINT 联合使用更好
以防你不知道```ENTRYPOINT```使您的容器化应用程序运行得像一个二进制文件，您可以在```docker run```期间给```ENTRYPOINT```参数传递，而不是担心它被覆盖（跟```CMD```不同）。当与```CMD```一起使用时```ENTRYPOINT```表现会更好。让我们来研究一下我的[Rethinkdb](http://www.rethinkdb.com/) Dockerfile，看看如何使用它。
{{{# Dockerfile for Rethinkdb 
# http://www.rethinkdb.com/

FROM ubuntu

MAINTAINER Michael Crosby <michael@crosbymichael.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y python-software-properties
RUN add-apt-repository ppa:rethinkdb/ppa
RUN apt-get update
RUN apt-get install -y rethinkdb

# Rethinkdb process
EXPOSE 28015
# Rethinkdb admin console
EXPOSE 8080

# Create the /rethinkdb_data dir structure
RUN /usr/bin/rethinkdb create

ENTRYPOINT ["/usr/bin/rethinkdb"]

CMD ["--help"]}}}

这是获得容器化Rethinkdb全部所需。在顶部我们有标准的5行来确保基础镜像是最新的，端口的公开等等......随着```ENTRYPOINT```的设置，我们知道每当这个镜像运行，在```docker run```过程中传递的所有参数将成为```ENTRYPOINT```（```/usr/bin/rethinkdb```）的参数。

在Dockerfile中我还设置了一个默认```CMD```参数```--help```。这样做是为了```docker run```期间如果没有参数的传递，rethinkdb将会给用户显示默认的帮助文档。这是你所期望的与rethinkdb交互有着相同的功能。

```docker run crosbymichael/rethinkdb
```

输出
{{{Running 'rethinkdb' will create a new data directory or use an existing one,
  and serve as a RethinkDB cluster node.
File path options:
  -d [ --directory ] path           specify directory to store data and metadata
  --io-threads n                    how many simultaneous I/O operations can happen
                                    at the same time

Machine name options:
  -n [ --machine-name ] arg         the name for this machine (as will appear in
                                    the metadata).  If not specified, it will be
                                    randomly chosen from a short list of names.

Network options:
  --bind {all | addr}               add the address of a local interface to listen
                                    on when accepting connections; loopback
                                    addresses are enabled by default
  --cluster-port port               port for receiving connections from other nodes
  --driver-port port                port for rethinkdb protocol client drivers
  -o [ --port-offset ] offset       all ports used locally will have this value
                                    added
  -j [ --join ] host:port           host and port of a rethinkdb node to connect to
  .................}}}

现在，让我们带上```--bind all```参数来运行容器。
```docker run crosbymichael/rethinkdb --bind all
```

输出
{{{info: Running rethinkdb 1.7.1-0ubuntu1~precise (GCC 4.6.3)...
info: Running on Linux 3.2.0-45-virtual x86_64
info: Loading data from directory /rethinkdb_data
warn: Could not turn off filesystem caching for database file: "/rethinkdb_data/metadata" (Is the file located on a filesystem that doesn't support direct I/O (e.g. some encrypted or journaled file systems)?) This can cause performance problems.
warn: Could not turn off filesystem caching for database file: "/rethinkdb_data/auth_metadata" (Is the file located on a filesystem that doesn't support direct I/O (e.g. some encrypted or journaled file systems)?) This can cause performance problems.
info: Listening for intracluster connections on port 29015
info: Listening for client driver connections on port 28015
info: Listening for administrative HTTP connections on port 8080
info: Listening on addresses: 127.0.0.1, 172.16.42.13
info: Server ready
info: Someone asked for the nonwhitelisted file /js/handlebars.runtime-1.0.0.beta.6.js, if this should be accessible add it to the whitelist.}}}

就这样，一个全面的可以访问db和管理控制台的Rethinkdb实例就运行起来了，你可以用与镜像交互一样的方式来与其交互。它功能非常强大但是简单小巧。当然，我喜欢简单。

**CMD和ENTRYPOINT 结合在一起使用更好。**

我希望这篇文章可以使您在使用Dockerfiles以及构建镜像时受益。展望未来，我相信Dockerfiles会成为Docker的重要一部分：简单而且使用方便无论你是消费或是生产镜像。我打算投入更多的时间来提供一个完整的，功能强大，但简单的解决方案来使用Dockerfile构建Docker镜像。

**原文链接：[Dockerfile Best Practices - take 1](http://crosbymichael.com/dockerfile-best-practices.html) （翻译：[田浩](https://github.com/llitfkitfk)）**
