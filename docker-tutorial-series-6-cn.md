##Docker教程系列 6 Docker Commands cont.

在[Docker教程系列较早的文章](http://dockerone.com/article/102)中，我们讨论的15个Docker命令。我们分享了如何使用它们以及他们做了什么的实践经验。

在这篇文章中，我们将讨论另外15个Docker命令，使我们积累更多Docker实践经验。

他们是：

####daemon:

Docker daemon是有助于管理容器的持久后台进程。一般情况下，守护进程是处理请求的长期运行的进程服务。

```-d```标志用于运行后台进程

####build:

如之前所讨论的，可使用Dockerfiles构建镜像。简单的构建命令如下：
```docker build [options] PATH | URL
```
也有一些Docker提供的有趣选项，如：

```--rm=true```所有中间容器构建成功后被移除

```--no-cache=false```避免在构建过程中使用缓存

下面的截图显示了使用```Docker build```命令。

![](http://cdn2.hubspot.net/hub/411552/file-1222267769-png/blog-files/rer.png?t=1419682672898)

####attach:

Docker允许使用```attach```命令与运行中的容器交互。该命令还允许查看守护进程。从容器分离可以通过两种方式来完成：

- Ctrl+c 暗中退出

- Ctrl-\ 跟栈分离

```attach```语法是：
```docker attach container
```

该截图显示了```attach```命令的执行。

![](http://cdn2.hubspot.net/hub/411552/file-1222267784-png/blog-files/docker-attach1.png?t=1419682672898)

####diff:

Docker提供了一个非常强大的命令```diff```，其中列出了改变的文件和目录。这些变化包括添加、删除以及那些分别由A，D和C标志单独表示的。该命令改善了调试过程，并允许更快的共享环境。

语法是：
```docker diff container
```

截图显示```diff```的执行。

![](http://cdn2.hubspot.net/hub/411552/file-1222267799-png/blog-files/docker-diff.png?t=1419682672898)

####events:

events的实时的信息可以从服务器通过指定持续时间来被收集为了那些需要收集的实时数据。

####import:

Docker允许导入远程位置和本地文件或目录。通过使用HTTP从远程位置导入，而本地文件或目录的导入需要使用```-```参数。

从远程位置导入的语法：
```docker import http://example.com/example.tar
```

截图显示导入本地文件：

![](http://cdn2.hubspot.net/hub/411552/file-1222267814-png/blog-files/docker-import.png?t=1419682672898)

####export:
类似于```import```，```export```命令用于将文件系统内容打包成tar文件。
下图描述了其执行：

![](http://cdn2.hubspot.net/hub/411552/file-1222267829-png/blog-files/docker-export.png?t=1419682672898)

####cp:
这个命令是从容器内复制文件到指定的路径上。语法如下：
```docker cp container:path hostpath.
```

截图展示了```cp```的执行。
![](http://cdn2.hubspot.net/hub/411552/file-1222267844-png/blog-files/docker-cp.png?t=1419682672898)

####login:
此命令用来登录到Docker registry服务器，语法是：
```docker login [options] [server]
```

如要登录自己主机的registry请使用：
```docker login localhost:8080
```

![](http://cdn2.hubspot.net/hub/411552/file-1222267859-png/blog-files/docker-login.png?t=1419682672898)

####inspect:
```Docker inpect```命令可以收集有关容器和镜像的底层信息。该信息包括以下内容：

- 容器实例的IP地址
- 端口绑定列表
- 特定的端口映射的搜索
- 收集配置的详细信息

该命令的语法是：
```docker inspect container/image
```
![](http://cdn2.hubspot.net/hub/411552/file-1222267874-png/blog-files/docker-inspect.png?t=1419682672898)

####kill:
发送```SIGKILL```信号来停止容器的主进程。语法是：
```docker kill [options] container
```

![](http://cdn2.hubspot.net/hub/411552/file-1222267889-png/blog-files/docker-kill.png?t=1419682672898)

####rmi:
该命令可以移除一个或者多个镜像，语法如下：
```docker rmi image
```

镜像可以有多个标签链接到它。在删除镜像时，你应该确保删除所有的标签以避免错误。下图显示了该命令的示例。

![](http://cdn2.hubspot.net/hub/411552/file-1222267904-png/blog-files/fz.png?t=1419682672898)

####wait:
该命令打印退出代码仅当容器退出后。

![](http://cdn2.hubspot.net/hub/411552/file-1222267919-png/blog-files/docker-wait.png?t=1419682672898)

####load:
该命令从tar文件中载入镜像或库到```STDIN```。

截图显示载入```app_box.tar```到```STDIN```：

![](http://cdn2.hubspot.net/hub/411552/file-1222267934-png/blog-files/ff.png?t=1419682672898)

####save:
类似于```load```，该命令保存镜像为tar文件并发送到```STDOUT```。语法如下：
```docker save image
```

简单截图示例如下：
![](http://cdn2.hubspot.net/hub/411552/file-1222267949-png/blog-files/docker-save.png?t=1419682672898)

[Docker教程系列下一章]()我们将探讨Docker APIs。