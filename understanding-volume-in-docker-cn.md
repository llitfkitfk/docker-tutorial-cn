###深入理解Docker Volume

【编者的话】本文主要介绍了Docker Volume的作用机制（译注：是[Docker入门教程](http://dockerone.com/article/111)的延伸）， 作者通过从数据的共享、数据容器、备份、权限以及删除Volumes五方面深入介绍了Volumes的工作原理。

从Docker IRC（网络即时聊天）频道以及[stackoverflow](https://stackoverflow.com/questions/tagged/docker)（译者注：有关代码问题的问答平台：大部分代码exception问题可以复制->粘贴->搜索来找到答案）的问题来看，Docker volumes是如何工作的这个问题上还存在很多混淆。在这篇文章中我会尽最大努力来解释Volumes是如何工作的，并展示一些最佳实践。虽然这篇文章主要是针对泊坞窗的用户几乎没有的知识量，尽管这篇文章主要是针对那些对Volumes不了解的Docker用户，当然有经验的用户也可以学一些Volumes的很多人不知道的细微之处的知识。

为了了解什么是Docker Volume，首先我们需要明确Docker内的文件系统是如何工作的。Docker镜像被存储在一系列的只读层。当我们开启一个容器，Docker读取只读镜像并添加一个读写层在顶部。如果正在运行的容器修改了现有的文件，该文件将被拷贝出底层的只读层到最顶层的读写层。在读写层中的旧版本文件隐藏于该文件之下，但并没有被不破坏 - 它仍然存在于镜像以下。当Docker的容器被删除，然后重新启动镜像时，将开启一个没有任何更改的新的容器 - 这些更改会丢失。此只读层及在顶部的读写层的组合被Docker称为[Union File System](https://docs.docker.com/terms/layer/#union-file-system)（联合文件系统）。

为了能够保存（持久）数据以及共享容器间的数据，Docker提出了Volumes的概念。很简单，volumes是目录（或者文件），它们是外部默认的联合文件系统或者是存在于宿主文件系统正常的目录和文件。

初始化Volumes有两种方式，对于理解来说一些细微的差别很重要。我们可以用在运行时使用```-v```来声明Volumes：
```$ docker run -it --name container-test -h CONTAINER -v /data debian /bin/bash
root@CONTAINER:/# ls /data
root@CONTAINER:/# 
```

这将在容器内创建路径```/data```，它存在于联合文件系统外部并可以在主机上直接访问。任何在该镜像```/data```路径的文件将被复制到volume。我们可以使用```docker inspect```命令找出Volume在主机存储的地方：
```$ docker inspect -f {{.Volumes}} container-test
```

你会看到以下类似内容：
```map[/data:/var/lib/docker/vfs/dir/cde167197ccc3e138a14f1a4f7c0d65b32cecbada822b0db4cc92e79059437a9] ```

这说明Docker把在```/var/lib/docker```下的某个目录挂载到了容器内的```/data```目录下。让我们从主机上添加文件到此文件夹下：
```$ sudo touch /var/lib/docker/vfs/dir/cde167197ccc3e138a14f1a4f7c0d65b32cecbada822b0db4cc92e79059437a9/test-file```

进入我们的容器内可以看到：
```$ root@CONTAINER:/# ls /data
test-file``` 

改变会立即生效只要将主机的目录挂载到容器的目录上。我们可以在Dockerfile中通过使用```VOLUME```指令来达到相同的效果：
```FROM debian:wheezy
VOLUME /data```

但还有另一件只有```-v```标志能做到而Dockerfile是做不到的事是在容器上挂载指定的主机目录。例如：
```$ docker run -v /home/adrian/data:/data debian ls /data```

该命令将挂载主机的```/home/adrian/data```目录到容器内的```/data```目录上。任何在```/home/adrian/data```目录的文件都将会出现在容器内。对于在主机和容器之间共享文件这是非常有帮助的，例如挂载需要编译的源代码。为了保存可移植性（并不是所有的系统的主机目录都是可以用的），挂载主机目录不用从Dockerfile指定。当使用```-v```参数的形式时并不镜像目录下的所有文件都被复制进Volume中。

###数据共享

从一个容器访问另一个容器的volumes，我们只用使用```-volumes-from```参数来执行```docker run```。
```$ docker run -it -h NEWCONTAINER --volumes-from container-test debian /bin/bash
root@NEWCONTAINER:/# ls /data
test-file
root@NEWCONTAINER:/#```

值得注意的是不管container-test运没运行，它都会起作用。Volume直到容器没有连接到它才会被删除。

###数据容器
使用纯数据容器来持久数据库、配置文件或者数据文件等等是普遍的做法。[官方的文档](https://docs.docker.com/userguide/dockervolumes/)就讲解的不错。例如：
```$ docker run --name dbdata postgres echo "Data-only container for postgres"```

该命令将会创建一个包含已经在Dockerfile里定义过Volume的postgres镜像，运行```echo```命令然后退出。当我们运行```docker ps```命令时，```echo```是有用的作为我们识别某镜像的用途。我们可以用```-volumes-from```命令使用其他容器的Volume：
```$ docker run -d --volumes-from dbdata --name db1 postgres```

使用数据容器两个要点：

- 不要不管运行中的数据容器，这是无意义的浪费资源
- 不要为了数据容器来使用“最小的镜像”如```busybox```或```scratch```。只要使用数据库镜像本身就可以了。如果你已经有了该镜像，那么它并不需要花费额外的空间并且它还允许镜像内的数据来做Volume

###备份
如果你在用数据容器，做备份是相当容易的：
```$ docker run --rm --volumes-from dbdata -v $(pwd):/backup debian tar cvf /backup/backup.tar /var/lib/postgresql/data```

该示例应该会将Volume里所有的东西压缩为一个tar包（官方的postgres Dockerfile定义了一个Volume在```/var/lib/postgresql/data```目录下）

###权限与许可
通常你需要设置Volume的权限或者为Volume初始化一些默认数据或者配置文件。要注意的关键点是，在Dockerfile的```VOLUME```指令后的任何东西将不能改变该volume，比如：
```FROM debian:wheezy
RUN useradd foo
VOLUME /data
RUN touch /data/x
RUN chown -R foo:foo /data```

该Docker file预期所料将不会工作，我们希望```touch```命令在镜像的文件系统上运行，但是实际上它是在一个临时容器的Volume上运行。如下所示：
```FROM debian:wheezy
RUN useradd foo
RUN mkdir /data && touch /data/x
RUN chown -R foo:foo /data
VOLUME /data```

Docker是足够聪明的复制存在挂载于镜像Volume下的文件到Volume下，并正确地设置权限。如果您指定Volume的主机目录（使主机文件不小心被覆盖）将不会出现这种情况。

如果你能设置权限在```RUN```指令，那么你将不得不在容器创建后使用```CMD```或```ENTRYPOINT```脚本来执行。

###删除Volumes

该功能比大多数人意识到的可能更微妙一些。如果你已经使用```docker rm```来删除你的容器，可能有很多的孤立的Volumes在占用着那些空间。

Volume只有在下列情况下才能被删除：

- 该容器可以用```docker rm －v```来删除且没有其他容器连接到该Volume（以及主机目录是也没被指定为Volume）。注意，```-v```是必不可少的。
- 该```-rm```标志被提供给```docker run```的

除非你已经很小心的，总是像这样来运行容器，否则你将会在```/var/lib/docker/vfs/dir```目录下得到一些僵尸文件和目录，并且还不容易说出他们到底代表什么。

###延伸阅读
以下资源更深入的探究了Volumes机制（译注：以下译文稍后奉上）：

- [疯狂Docker之纯数据容器](http://container42.com/2014/11/18/data-only-container-madness/)
- [深入Docker之Volumes](http://container42.com/2014/11/03/docker-indepth-volumes/)
- [容器数据管理](https://docs.docker.com/userguide/dockervolumes/)

另外，我们可以期待不久的将来会更多的有关处理volumes的工具：

- [Docker提议 #8484](https://github.com/docker/docker/pull/8484)


