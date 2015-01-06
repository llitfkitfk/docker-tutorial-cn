##Docker教程系列 3 DockerFile

在[Docker教程系列上一章]()中，我们通过15个Docker命令对Docker有个大致的了解。这组Docker命令是手动创建镜像的步骤。他们对创建镜像以及提交、检索、拉取和推送镜像是基本的帮助。

既然Docker能自动创建镜像，但是为什么要选择耗时乏味的方式来创建镜像呢？

Docker为我们提供DockerFile来解决自动化问题。在这篇文章中，我们将讨论什么是Dockerfile，它能够做到的事情以及DockerFile一些基本语法。


###命令为易于自动化

DockerFile是容纳创建镜像所需指令的脚本。基于在DockerFile中的指令可以用```Docker build```命令来创建镜像。通过减轻整个镜像和容器创建过程来简化了部署。

DockerFiles支持一下语法命令：
```INSTRUCTION argument
```

指令不区分大小写。然而，命名约定为全部大写。

所有DockerFiles必须以```FROM```命令开始。 ```FROM```命令表示新的镜像从被指示的基础镜像以及随后的指令来构建。```FROM```命令可用于任意次数，指示创建多个图像。语法如下：

```FROM <image name>
```

```FROM ubuntu
```
告诉我们，新的镜像将从基Ubuntu的镜象来构建。

继```FROM```命令，DockerFile还提供了一些其他的命令便于实现自动化。在文本文件或DockerFile文件中这些命令的顺序，也是它们被执行的顺序。

让我们了解一下这些有趣的DockerFile命令。

1. MAINTAINER：设置该镜像的作者字段。简单而明显的语法：
```MAINTAINER <author name>
```

2. RUN：在shell或者exec的环境下执行的命令。```RUN```指令在新创建的镜像上添加新的层。接下来提交的结果用于在DockerFile的下一条指令。
```Syntax: RUN <command>
```

3. ADD：复制文件指令。它有两个参数<source>和<destination>。destination是容器内的路径。source可以是URL或者是启动配置上下文中的一个文件。
```Syntax: ADD <src> <destination>
```

4. CMD：提供了容器默认的执行命令。 DockerFile只允许CMD指令使用一次。 使用多个CMD会抵消之前所有的，只有最后一个生效。 CMD有三种形式：
{{{Syntax:CMD ["executable","param1","param2"]

CMD ["param1","param2"]

CMD command param1 param2
}}}

5. EXPOSE：指定容器在运行时监听的端口。
```Syntax: EXPOSE <port>;
```

6. ENTRYPOINT：配置容器一个可执行的命令，这意味着在每次使用镜像创建容器时一个特定的应用程序可以被设置为默认程序。同时也意味着该镜像每次被调用时每次仅能运行指定的应用。

类似于```CMD```，Docker只允许一个ENTRYPOINT以及多个ENTRYPOINT会抵消之前所有的，只执行最后的ENTRYPOINT指令。

{{{Syntax: Comes in two flavours

ENTRYPOINT [‘executable’, ‘param1’,’param2’]

ENTRYPOINT command param1 param2
}}}

7. WORKDIR：指定```RUN```、```CMD```与```ENTRYPOINT```命令的工作目录。
```Syntax: WORKDIR /path/to/workdir
```

8. ENV：设置环境变量。它们使用键值对，并增加运行的程序的灵活性。
```Syntax: ENV <key> <value>
```

9. USER：镜像正在运行时设置一个UID。
```Syntax: USER <uid>
```

10. VOLUME：授权访问从容器内到主机上的目录。

```Syntax:VOLUME [‘/data’]
```

DockerFile最佳实践

正如任何使用的应用程序，总会有遵循的最佳做法。你可以阅读更多有关[DockerFile最佳实践](http://crosbymichael.com/dockerfile-best-practices.html)。

以下是我们列出的基本的DockerFile最佳实践：

- 保持常见的指令像```MAINTAINER```以及从上至下更新DockerFile命令;
- 当构建镜像时使用可理解的标签，以便更好地管理镜像;
- 避免在DockerFile中映射公有端口;
- 作为最佳实践，```CMD```与```ENTRYPOINT```命令请使用数组语法。

在接下来的文章中，我们将讨论[Docker Registry与其工作流程]()。