##Docker教程系列 4 Docker Registry

在前边Docker教程系列文章中，我们讨论了DockerFile的重要性并提供了使自动构建镜像更容易的一系列DockerFile的命令。在这篇文章中，让我们来谈谈一个重要的Docker组件：Docker Registry。这是中央登记处对于所有库，公有的还是私有的以及他们的工作流程。但是，在我们深入Docker Registry之前，先让我们去了解一些常见的术语和库相关的概念。

1. Repositories可以被"喜欢"使用stars活着用书签
2. 在社区交互中使用评论服务留下“意见”。
3. 私有库类似于公有，不同之处在于前者不会在搜索结果中显示，并且也没有访问它的权限。用户设置为合作者才能访问私有库。
4. 成功推送之后配置[webhooks](http://www.wikiwand.com/en/Webhook)。

角色 1 -- Index: ```index``` 负责并维护有关用户帐户，镜像的校验以及公共命名空间的信息。它使用以下组件维护这些信息：

- Web UI
- 元数据存储
- 认证服务
- 符号化

这也解决了较长的URL，以方便使用和验证库的拥有者。

角色 2 --Registry: ```registry```是镜像和图表的资源库。然而，它不具有本地数据库以及不提供用户认证。由S3，云文件和本地文件系统提供数据库支持。此外，认证采取的是通过使用记号索引验证服务。Registries可以有不同的类型。我们来分析其中的几个：

1. Sponsor Registry: 通过其客户和Docker社区使用第三方registry。
2. Mirror Registry: 只为客户使用第三方registry。
3. Vendor Registry: 由分发Docker镜像的供应商提供的registry。
4. Private Registry: 通过与防火墙和额外的安全层的私有实体提供的registry。


角色 3 --Registry Client: Docker充当registry客户端来维护推送和拉取，以及客户端的授权。

##Docker Registry工作流程详解

现在，让我们讨论五种情景模式，以便更好地理解Docker Registry。

####情景A: 用户要获取并下载镜像。所涉及的步骤如下：

1. 用户发送请求到index来下载镜像。
2. index 响应返回三个相关部分信息：
	- 该镜像位于的registry
	- 该镜像包括所有层的校验
	- 以授权目的记号
> 注意：当请求header里有X-Docker-Token时 Tokens才会被返回。而私人仓库需要基本的身份验证，对于公有库它不是强制性的。
3. 现在，用户联系registry用响应后返回的记号。registry全权负责镜像。它存储基本的镜像和继承的层。
4. registry现在要与index证实该token是被授权的。
5. index会发送“true” 活着 “false”给registry，由此允许用户下载所需要的镜像

![](http://cdn2.hubspot.net/hub/411552/file-1222266489-png/blog-files/pull.png?t=1419682672898)


####情景B: 在用户想要推送镜像到registry中。涉及的步骤如下：

1. 用户发送带证书请求到index要求分配库名。
2. 在成功认证，命名空间可用以及库名被分配之后。index响应返回临时的token。
3. 镜像连带token，一起被推送到registry中。
4. registry与index证实token，然后在index验证之后开始读取推送流。
5. 该index然后更新由Docker生成的镜像校验。

![](http://cdn2.hubspot.net/hub/411552/file-1222266594-png/blog-files/push.png?t=1419682672898)

####情景C: 用户想要从index或registry中删除镜像：

1. index接收来自Docker一个删除库的信号。
2. 如果index验证库成功，它将删除该库，并返回一个临时token。
3. registry现在接收到带有该token的删除信号。
4. registry与index核实该token，然后删除库以及所有相关信息。
5. Docker现在通知有关删除的index，然后index移除库的所有记录。

![](http://cdn2.hubspot.net/hub/411552/file-1222266674-png/blog-files/delete.png?t=1419682672898)

####情景D：用户希望在没有index的独立模式中使用registry。
使用没有index的registry，这完全由Docker控制，它最适合于在私有网络存储镜像。registry运行在一个特殊的模式里，此模式限制了registry与Docker index的通信。所有的安全和身份验证需要用户自己注意。

####方案E：该用户想要在有index的独立模式中使用registry。
在这种情况下，一个自定义的index会被创建在私有网络里来存储和访问镜像。然而，通知Docker有关定制的index是耗时的。 Docker提供一个有趣的概念chaining registries，从而，实现负载均衡和为具体请求而指定的registry分配。在接下来的Docker教程系列中，我们将讨论如何在上述每个情景中使用Docker Registry API ，以及深入了解Docker Security。

