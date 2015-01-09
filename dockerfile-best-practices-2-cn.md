【Docker进阶】Dockerfile最佳实践（二）

【编者的话】本文是[Docker入门教程](http://dockerone.com/article/111)系列的[第三章－DockerFile](http://dockerone.com/article/103)的进阶篇第二部分

自从我[上一篇Dockerfile最佳实践](http://dockerone.com/article/131)后Docker发生了很大变化。上一篇会继续保留造福Docker新手，这篇文章将介绍Docker有什么变化以及你现在应当做什么。

###1：不要开机初始化
容器模型是进程而不是机器。即使你认为你需要做这一点，你可能错了。

###2：可信任构建
即使你不喜欢这个题目但它是很棒的一功能。我把大部分gihub仓库添加到可信任构建，这样当我提交我的新的等待索引后的镜象。另外，我不必再创建单独的Dockerfile仓库来与他人分享，它们都在同一个地方。

请记住，这不是你为尝试新东西的操场。在你推送之前本地先构建一下。Docker可以确保你在本地构建和运行的会是同样的当你把他们推送到其他任何地方。本地开发和测试、提交和推送、以及等待索引上的官方镜像都是建立在可信任构建的基础之上的。

###3：不要在构建中升级版本
更新将在基础镜像里你不需要在您的容器内来```apt-get upgrade```更新。因为隔离情况下往往会失败，如果更新时试图修改init或改变容器内的设备。它还可能产生不一致的镜像，因为你不再有你的应用程序该如何运行以及包含在镜像中依赖的哪种版本的正确源文件。

如果有基础镜像需要的安全更新，那么让上游的知道这样他们可以给大家更新，并确保你的构建的一致性。

###4：使用小型基础镜像
有些镜像比其他的更臃肿。我建议使用```debian:jessie```作为你的基础镜像。如果您熟悉ubuntu，你会在debian发现一个更轻便更幸福的家。此镜像不但小巧，而且不包含任何不必要的肿胀的东西。

###5：使用特定的标签
对与你的基础镜像这是非常重要的。Dockerfile中```FROM```应始终包含依赖的基础镜像的完整仓库名和标签。比如说```FROM debian:jessie```而不仅仅是```FROM debian```。

###6：常见指令组合
您的```apt-get update```应该与```apt-get install```组合。此外，你应该采取```\```的优势使用多行来进行安装。

{{{＃Dockerfile for https://index.docker.io/u/crosbymichael/python/ 
FROM debian:jessie

RUN apt-get update && apt-get install -y \
    git \
    libxml2-dev \
    python \
    build-essential \
    make \
    gcc \
    python-dev \
    locales \
    python-pip

RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

ENV LC_ALL C.UTF-8}}}

谨记层和缓存都是不错的。不要害怕过多的层因为缓存是大救星。当然，你应当尽量使用上游的包。

###7：使用自己的基础镜像
我不是在谈论运行debbootstrap来制作自己的debian。我说的是，如果你要运行python应用程序需要有一个python基础镜像。前面例子中Dockerfile用来构建```crosbymichael/python```镜像，它用于许多其他镜像来运行python应用程序。
{{{FROM crosbymichael/python

RUN pip install butterfly
RUN echo "root\nroot\n" | passwd root

EXPOSE 9191
ENTRYPOINT ["butterfly.server.py"]
CMD ["--port=9191", "--host=0.0.0.0"]}}}

另一个：
{{{FROM crosbymichael/python

RUN pip install --upgrade youtube_dl && mkdir /download
WORKDIR /download
ENTRYPOINT ["youtube-dl"]
CMD ["--help"]}}}

正如你看到的这使得使用你的基础镜像非常小，从而使你集中精力在应用程序上。

让我知道你在想什么或者如果您有任何其它问题可以在评论中留言。

**原文链接：[Dockerfile Best Practices - take 2](http://crosbymichael.com/dockerfile-best-practices-take-2.html) （翻译：[田浩](https://github.com/llitfkitfk)）**
