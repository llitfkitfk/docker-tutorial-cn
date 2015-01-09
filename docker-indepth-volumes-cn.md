##深入Docker之Volumes

【编者的话】这篇文章是[深入理解Docker Volume](http://dockerone.com/article/128)的延伸阅读篇，作者通过对比Dockerfile中的VOLUME指令跟命令行docker run 中```-v```标志深入分析了Volume的原理以及与容器之间的联系。

人们使用Docker最常见的障碍之一，还有我看大量的Docker支持渠道也确实很容易出现该问题，那就是Volumes的使用。

因此，让我们来仔细看一下Docker Volume是如何工作的。

首先，让我们来驱散第一个最常见的误解：

Docker Volumes是为了持久性。

这可能来自于容器不是持久的想法，这样确实是不对的。容器的持久直到您删除他们，并且你只能这样做：
```docker rm my_container
```

如果您没有键入此命令，那么你的容器仍然存在并将继续存在，它可以启动、停止等。如果你没有看到你的容器，你应该运行此命令：
```docker ps -a```

```docker ps```永远只显示正在运行的容器，但是一个容器可以是停止状态，在这种情况下，上面的命令会显示你所有的容器无论状态如何。```docker run ...```其实是一个多命令集合，它会创建一个新的容器，然后启动它。

因此，再次声明：Volume不是为了持久。

###什么是Volume

Volumes使创建它们的容器使用寿命与在它们中储存数据的寿命解耦。这使得它你可以```docker rm my_container```后你的数据不会被删除。

Volume可以用以下两种方式创建：

- 在Dockerfile中指定```VOLUME /some/dir```
- 当执行```docker run -v /some/dir```命令来指定

无论哪种方式，这两样东西都做了同样的事情。它告诉Docker在主机上创建一个目录（默认情况下是```/var/lib/docker```），然后将其挂载到您指定的路径（例子中是：```/some/dir```）。当您删除使用该Volume的容器，该Volume本身将一直存在下去。

如果在容器中不存在指定的路径，那么此目录将被自动创建。

你能告诉Docker同时删除容器和其Volume：
```docker rm -v my_container
```

有时候，你的主机已经有了要在容器中使用的目录，CLI（命令行界面）多了一种选择来指定这些：
```docker run -v /host/path:/some/path ...
```

这明确地告诉Docker使用指定的主机路径来代替Docker自己创建的根路径并挂载到容器内指定的路径（以上例子为：```/some/path```）。值得注意，这样做也可以是一个文件来代替目录。在Docker术语中这通常被称为bind-mounts（虽然技术层面上是这样讲的，但是实际的感官是所有的Volumes都是bind-mounts的）。如果主机上的路径不存在，目录将自动在给定的路径中创建。

对待Bind-mount Volumes跟一个“正常”的Volume有点点不同，它的特点是不会修改主机上那些并非Docker自身创建的东西：

1. 一个“正常”的Volume，Docker会自动复制在指定的Volume路径的数据（如上边示例：```/some/path```）到由Docker创建新的目录下，如果是“bind-mount” Volume就不会发生这种情况。
2. 当你执行```docker rm -v my_container```命令给“bind-mount” Volume的容器，“bind-mount” Volumes不会被删除。

容器也可以与其他容器共享Volumes。
```docker run --name my_container -v /some/path ...
docker run --volumes-from my_container --name my_container2 ...```

上面的命令将告诉Docker从第一个容器挂载相同的Volumes到第二个容器。它有效地共享数据在两个容器之间。

如果你执行```docker rm -v my_container```命令，而上方的第二容器依然存在，Volumes不会被删除，而且它永远不会被删除除非你执行```docker rm -v my_container2```删除第二个容器,。

###Dockerfiles里的VOLUME
正如前面提到的，Dockerfile中的VOLUME声明中做同样的事情类似```docker run```命令里的```-v```标志（除了你不能在Dockerfile指定主机路径）。它只是恰巧发生了，也正因为如此，构建镜像时可以得到惊奇的效果。

在Dockerfile中的每个命令创建一个新的用于运行指定命令的容器，并将容器提交回镜像，每一步都是在前一步的基础上构建。因此在Dockerfile中```ENV FOO=bar```等同于：
```cid=$(docker run -e FOO=bar <image>)
docker commit $cid
```

下面让我们来看看这个Dockerfile的例子发生了什么：
```FROM debian:jessie
VOLUME /foo/bar
RUN touch /foo/bar/baz
```

```docker build -t my_debian .
```

我们期待的是Docker创建名为my_debian并且Volume是``` /foo/bar```的镜像，以及在```/foo/bar/baz```下添加了一个空文件，但是让我们看看等同的CLI命令行实际上做了哪些：
```cid=$(docker run -v /foo/bar debian:jessie)
image_id=$(docker commit $cid)
cid=$(docker run $image_id touch /foo/bar/baz)
docker commit $(cid) my_debian
```

它并不是确切地发生了这些，但是非常类似。

那么，这里发生的是在```/foo/bar```里的任何东西存在之前，Volume就被创建，因此我们每次从这个镜像启动一个容器，会有一个空的```/foo/bar```目录。它之所以发生如前所述，Dockerfile中每个命令都是创建一个新容器。这意味着，同时也创建了一个新的Volume。由于举例Dockerfile中是先指定Volume的，当执行```touch /foo/bar/baz```命令的容器创建时，一个Volume被挂载到了```/foo/bar```，然后```baz```才能被写入此Volume，而不是实际的容器或镜像的文件系统内。

所以，牢记Dockerfile中```VOLUME```声明的位置，因为它在你的镜象内创建了不可改变的目录。

```docker cp```（[#8509](https://github.com/docker/docker/pull/8509)），```docker commit```和```docker export```还不支持Volumes（在文章截稿时）。

目前，在容器的创建/销毁期间来管理Volumes（创建/销毁）是唯一的方式，这有点古怪，因为Volumes是为了分离容器内的数据与容器的生命周期。Docker团队正在处理，但尚未合并（[#8484](https://github.com/docker/docker/pull/8484)）。

如果您想了解Docker Volume的更多功能，[请这边走](https://github.com/cpuguy83/docker-volumes)

**原文链接：[Docker In-depth: Volumes](http://container42.com/2014/11/03/docker-indepth-volumes/)（翻译：[田浩](https://github.com/llitfkitfk)）**