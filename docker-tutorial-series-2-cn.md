##Docker教程系列 2 Commands

在[Docker教程系列的第一部分]()，我们了解了Docker的基础知识。我们研究它是如何工作以及如何安装。在这篇文章中，我们现在学习的15个Docker命令，实践：他们如何被使用以及他们做了什么。

首先，让我们通过下边的命令来检查Docker安装是否正确：
```docker info 
```

如果没有找到此命令，则表示Docker没有正确安装。一个正确安装的输出会显示类似以下内容：

![](http://cdn2.hubspot.net/hub/411552/file-1222265239-png/blog-files/docker-info.png?t=1419682672898)

到这一步Docker里还没有镜像或是容器。所以，让我们通过命令来拉取一个预建的镜像：
```sudo docker pull busybox
```

![](http://cdn2.hubspot.net/hub/411552/file-1222265254-png/blog-files/docker-pull-busybox.png?t=1419682672898)

BusyBox的是一个最小的Linux系统，它提供了主要的功能，除了一些与GNU相当的功能和选项。

下一步是运行传统、平凡但显著的“hello world.”容器，做一点小变化，我们称之为“Hello Docker.”
```docker run busybox /bin/echo Hello Docker
```

![](http://cdn2.hubspot.net/hub/411552/file-1222265269-png/blog-files/hello-docker.png?t=1419682672898)

现在，让我们运行```hello docker```作为一个长时运行的进程：

{{{sample_job=$(docker run -d busybox /bin/sh -c “while true; do echo Docker; sleep 1; done”)
}}}

![](http://cdn2.hubspot.net/hub/411552/file-1222265284-png/blog-files/docker-job.png?t=1419682672898)

该命令```sample_job```是长时间运行每隔1秒打印Docker的作业。使用```Docker logs```可查看作业的输出。如果没有被赋予名字，则一个id将被分配到该作业，以后使用命令例如```Docker logs```查看日志会变得困难。

运行```Docker logs```命令来查看作业的当前状态：
```docker logs $sample_job
```

所有Docker命令可以用以下命令查看：
```docker help
```

该名为```sample_job```的容器，可以使用以下命令来停止：
```docker stop $sample_job
```

使用以下命令重新启动该容器：
```docker restart $sample_job
```

如果要完全移除容器，需要将该容器停止，然后才能移除。像这样：
```docker stop $sample_job
docker rm $sample_job
```

将容器的状态保存为镜像，使用命令：
```docker commit $sample_job job1
```

注意，镜像名称职能取字符[a-z]和数字[0-9]。

现在，您就可以使用以下命令查看所有镜像的列表：
```docker images
```

在[我们之前的Docker教程]()中，我们发现，镜像是存储在Docker registry。在registry中的镜像可以使用以下命令查找到：
```docker search <image-name>
```

查看镜像的历史版本可以执行以下命令：
```docker history <image_name>
```

最后，使用以下命令将镜像推送到registry：
```docker push <image_name>
```

你必须要知道库名字是不是根库，它应该使用此格式```<user>/<repo_name>```。

这都是一些非常基本的Docker命令。在我们[Docker教程系列的第六章]()，我们将讨论如何使用Docker运行Python的Web应用程序，以及一些进阶的Docker命令。