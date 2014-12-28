docker的24个实用技巧

我们爱docker，并把它用于生产环境中。下面是一些提示和技巧，希望能对已经熟悉docker基础的每一位提供帮助。

### CLI(Command-line interface)

1. 规整 docker ps 输出
docker ps管道上加个less -S来使输出的每一行不被换行
```docker ps -a | less -S
```

2. 跟踪日志
```docker logs -f <containerid> 
```
3. a single value from docker inspect
docker inspect 在默认情况下有大量的JSON输出。你可以使用内置的模板命令如下：
```# is the last run container still running?
docker inspect --format '{{.State.Running}}' $(docker ps -lq)
```

4. docker exec instead of sshd or nsenter
这个命令众所周知，如果你遵循docker版本。 在1.3版本中引入了exec，让你在一个容器内运行一个新的进程。因此也就没有必要在容器中运行的sshd或主机上安装nsenter。
```docker exec -it <container Id> /bin/bash
```

### Dockerfiles

5.  docker build supports git repos
你不仅可以构建镜像用本地的Dockerfiles，也可以简单地给docker一个git仓库的URL，docker自己会办妥余下的事。

6.  no package lists
默认的镜像（如Ubuntu）不包括软件包列表来保持它们小容量，因此```apt-get update```几乎够用在基本的Dockerfile中。

7.  watch out for package versions
小心包的安装以及那些缓存的命令。这意味着当误操作缓存或着安全更新的延迟，您可能会获取不同版本。

8.  small base images
有一个真正的空的docker镜像。这就是所谓的scratch(译注:[scratch教程](http://dockerone.com/article/93))。所以，如果你愿意，你可以从头构建你的镜像FROM scratch。大多数时候，你最好从[busybox](https://registry.hub.docker.com/_/busybox/)开始，如果你想有一个非常小的基础镜像（只有2.5MB大小）。

9.  FROM is latest by default
如果你没有在标签具体说明版本，则```FROM```关键字将只使用最新的镜像。小心这一点，如果你可以确定具体版本，请最好那样做。

10. shell or exec mode
在Dockerfile中有几个地方，您可以具体指定命令。(例如CMD，RUN)。docker支持两种方式。如果你只写命令，然后docker将把它封装在```sh -c```。你也可以把他们作为一个字符串数组（如 ```["LS", "-a"]```）。该阵列的符号在容器内是可用的将不再需要shell（因为它使用go的```exec```），这就是docker的首选语法。

11. ADD vs COPY
在构建容器时```ADD```和```COPY```都可以添加本地文件，但```ADD```有额外的魔法，比如增加远程文件以及```ungzipping```解包和```untaring```归档。如果你明白这些区别，只用使用```ADD```。

12. WORKDIR and ENV
每个命令都将创建一个新的临时镜像并在一个新的shell里运行，因此，如果你在Dockerfile使用```cd <directory>```或```export <var>=<value>```将无法正常工作。使用```WORKDIR```来设置工作目录来接受多个命令，而使用```ENV```是设置环境变量。

13. CMD and ENTRYPOINT
```CMD```为默认的命令的当镜像被运行时执行。默认```ENTRYPOINT```是```/bin/sh -c```以及```CMD```作为参数传递进去。我们可以在Dockerfile重写```ENTRYPOINT```使我们的容器表现得像输入命令行参数的可执行程序（默认参数在我们Dockerfile的CMD里面）。
```
# in Dockerfile
ENTRYPOINT /bin/ls
CMD ["-a"]
# we're overriding the command but entrypoint remains ls
docker run training/ls -l
```
14. ADD your code last
```ADD```会使缓存无效如果文件有改变。当在您的Dockerfile加入频繁变化的东西，而又如果不想使缓存作废。你可以先添加库和依赖，在最后添加你的代码。对于node.js apps 意味着你先加入的package.json，然后运行```npm install```，最后再加入你的代码。

### docker networking
Docker有一个IPs内部池，它的存在是为了容器的IP地址。默认的这些是隐蔽的，可以经由桥接来访问。

15. looking up port mappings
```docker run```接受明确的端口映射作为参数，也可以指定```-P```自动映射所有端口。后者具有防止冲突并搜寻已分配的端口，命令如下：
```docker port <containerId> <portNumber>
# or
docker inspect --format '{{.NetworkSettings.Ports}}' <containerId>
```

16. container IPs
每个容器有它的IP在一个私有的子网中（默认情况下是172.17.42.1/16）。该IP在重启后可以改变，但你也可以用以下命令查询：
```docker inspect --format '{{.NetworkSettings.IPAddress}}' <containerId>
```

docker尝试查找冲突并如果需要将使用不同的子网络。

17. taking over the hosts network stack
```docker run --net=host```允许重新使用主机的网络协议栈。不能这样做。

### volumes
一种方法为目录或单个文件接近零开销（绑定挂载）来绕过```copy-on-write```(写入时复制)文件系统 。

18. volume contents are not saved on docker commit
数据卷内容不会被保存到docker的提交改动中。当镜像被构建时，同时写入您的数据卷没有多大意义

19. volumes are read-write by default
默认情况下，数据卷有读写权限 但有一个 ```:ro``` 标志(read-only只读权限)

20. volumes exists separately from containers
数据卷的退出是跟容器分开的，并且这是可能的直到至少有一个容器引用它们。数据卷可以在容器之间共享，使用 ```--volumes-from```。

21. mount your docker.sock
挂载你的```docker.sock```。你可以只挂在您的```docker.sock```来为容器内提供访问docker的API。然后，您可以在容器内运行的docker的命令。这样的容器，甚至可以消除自己。在容器内运行docker守护进程也是没必要的。

### security

22. docker runs as root...
...相应地对待它。docker API有充分的root访问权限，你可以映射/挂载数据卷，读，写。或者你可以使用```--net host```来接管主机的网络。不要向公众暴露docker API或使用TLS。

23. USER in Dockerfiles
默认情况下，docker以root身份运行一切，当然你也可以在Dockerfiles使用```USER```。有在docker没有用户命名空间来使容器看到用户在主机上，但只有uids，因此你需要在容器中添加用户。

24. use TLS on the docker API
直到1.3当他们加入了TLS, 在docker API才有了访问控制。他们使用相互验证：客户端和服务端都有密钥。把钥匙作为root密码。

自从1.3版本，Boot2docker默认具有TLS，也会为您产生密钥。

在其他情况下，生成密钥需要的OpenSSL 1.0.1， 然后docker守护程序需要与```--tls-verify```运行，并使用安全docker端口(2376)。

我们希望尽快得获得更多的细微的访问控制，而不是没有控制或者控制一切。


[原文链接](http://csaba.palfi.me/random-docker-tips/)