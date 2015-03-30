#Docker安全调整

【编者的话】

从发表这个有关Docker安全系列的前两篇文章以来已经有一段时间没更新了。这边文章会更新有关Docker的最新添加的信息并且涵盖了那些正准备合并到上游Docker的新的功能。

##调整能力

在前面的文章中，我讲述了基于Linux的功能的容器分离。

Linux的功能允许你分离根用户权力到一些更小的特权群。目前，默认情况下Docker容器只有以下功能。

```
CHOWN, DAC_OVERRIDE, FSETID, FOWNER, MKNOD, NET_RAW,
SETGID, SETUID, SETFCAP, SETPCAP, NET_BIND_SERVICE,
SYS_CHROOT, KILL, AUDIT_WRITE
```

在某些情况下，你可能要调整此列表，例如，如果你构建一个运行`ntpd`或`crony`的容器，就需要能够修改主机的系统时间。该容器将无法运行，因为它需要`CAP_SYS_TIME`。在旧版本的Docker中容器必须在`--privileged`模式 - 关闭所有的安全策略下运行。

在Docker1.3版本中添加了`--cap-add`和`--cap-drop`。现在为了运行`ntpd`容器，你可以只需运行：
```
docker run -d --cap-add SYS_TIME ntpd
```

其中只添加了`SYS_TIME`功能到您的容器。

另一个例子是，如果你的容器没有改变任何进程的`UID/GID`，你可以从你的容器中删除这些功能，使其更加安全。

```
docker run --cap-drop SETUID --cap-drop SETGID --cap-drop FOWNER fedora /bin/sh

# pscap | grep 2912
5417 2912 root sh chown, dac_override, fsetid, kill, setpcap, net_bind_service, net_raw, sys_chroot, mknod, audit_write, setfcap
```

或者你可以放弃所有功能并一一添加。

```
docker run --cap-drop ALL --cap-add SYS_TIME ntpd /bin/sh

# pscap | grep 2382
5417 2382 root sh sys_time
```

##调整SELinux的标签

类似于调整功能，我们已经加入了调整SELinux的标签的能力。

如果你已经看了[SELinux coloring book](http://opensource.com/business/13/11/selinux-policy-guide)（译注：有关强制执行SELinux政策的文章，此文图文并茂、易于理解），你知道，我们可以通过类型和`MCS/MLS`级别来分离进程。我们使用类型用以保护主机来自容器的干扰。但是，我们也可以调节类型来控制允许进入和离开容器的网络端口。目前，我们都是以`svirt_net_lxc_t`运行所有容器。这种类型允许监听并连接所有的网络端口。我们可以通过调整SELinux的类型标签很好地设定容器的安全性。

与常规的SELinux和Apache httpd，在默认情况下我们只允许Apache进程来监听Apache的端口（http_port_t）。

```
# sudo sepolicy network -t http_port_t

http_port_t: tcp: 80,81,443,488,8008,8009,8443,9000

```

我们也阻止所有传出端口的连接。这可以帮助我们锁定了Apache进程，即便黑客像ShellShock一样通过安全漏洞破坏了应用程序，我们可以停止即将成为一个垃圾邮件僵尸的应用程序或者允许进程攻击其它系统。就像加州旅馆，“你可以随时进来，但你永远无法离开。”

随着容器，可是如果你运行一个Apache服务器应用程序的容器，该应用程序被攻击，Apache进程能够通过网络连接到任何网络端口、成为垃圾邮件僵尸或者攻击其他主机/容器。

使用SELinux创建一个新的策略类型来运行你的容器相当的简单。首先，你可以创建一个SELinux TE（类型强制执行）文件。

```
# cat > docker_apache.te << _EOF

policy_module(docker_apache,1.0)

# This template interface creates the docker_apache_t type as a
# type which can be run as a docker container. The template
# gives the domain the least privileges required to run.
virt_sandbox_domain_template(docker_apache)

# I know that the apache daemon within the container will require
# some capabilities to run. Luckily I already have policy for
# Apache and I can query SELinux for the capabilities.
# sesearch -AC -s httpd_t -c capability
allow docker_apache_t self: capability { chown dac_override kill setgid setuid net_bind_service sys_chroot sys_nice sys_tty_config } ;

# These are the rules required to allow the container to listen
# to Apache ports on the network.

allow docker_apache_t self:tcp_socket create_stream_socket_perms;
allow docker_apache_t self:udp_socket create_socket_perms;
corenet_tcp_bind_all_nodes(docker_apache_t)
corenet_tcp_bind_http_port(docker_apache_t)
corenet_udp_bind_all_nodes(docker_apache_t)
corenet_udp_bind_http_port(docker_apache_t)

# Apache needs to resolve names against a DNS server
sysnet_dns_name_resolve(docker_apache_t)

# Permissive domains allow processes to not be blocked by SELinux
# While developing and testing your policy you probably want to
# run the container in permissive mode.
# You want to remove this rule, when you are confident in the
# policy.
permissive docker_apache_t;
_EOF

# make -f /usr/share/selinux/devel/Makefile docker_apache.pp
# semodule -i docker_apache.pp
```

现在使用新类型运行容器：

```
# docker run -d --security-opt type:docker_apache_t httpd

```

现在，对比正常的容器，这个容器有更为严格的SELinux安全性。注意，你可能会需要查看审计日志来看看你的应用程序是否需要额外的SELinux准许规则。

你可以通过使用`audit2allow`命令来添加规则到现有`.te`文件，重新编译并安装如下规则。

```
# grep docker_apache_t /var/log/audit/audit.log | audit2allow >> docker_apache.te
# make -f /usr/share/selinux/devel/Makefile docker_apache.pp
# semodule -i docker_apache.pp

```

##多极次安全模式

目前，我们使用`MCS`分离来确保容器不被其它容器干扰或交互，除非它是通过网络连接。某些政府系统需要不同类型的MLS（多极安全）政策。具有MLS时，你可以基于看到的数据级别来标记进程。 MLS说如果你的容器要处理绝密数据，那么它应该在绝密的地方运行。我们已经添加允许管理员设置容器在特定级别运行的Docker选项，这些应该满足MLS系统的需求。

```
docker run -d --security-opt label:level:TopSecret --security-opt label:type:docker_apache_t httpd
```

这个命令将开启Docker容器的两个交替类型与级别，并且可以阻止容器使用不是相同标签的数据。不过在这一点上还没有通过认证，但我们愿意帮助第三方为MLS用户构建解决方案。

##调整命名空间

在其他有关安全的对话中，我已经讨论了命名空间可以被认为是一种安全机制，因为其排除了一个进程无法看到系统（PID命名空间）上的其他进程的能力。网络命名空间可以排除从命名空间中能看的到其他网络的能力。 IPC（内部进程间通信）命名空间具有阻断容器使用其它容器的IPC的能力。

Docker现在已经放宽这些限制。您可以用容器来共享主机的命名空间：

--pid=主机让容器共享主机的PID命名空间
--net=主机让容器共享主机的主机空间
--ipc=主机让容器共享主机的IPC空间

需要注意的是，既然与主机共享了PID或IPC的命名空间，需要我们禁用SELinux分离以便让他们的工作。

```
docker run -ti --pid=host --net=host --ipc=host rhel7 /bin/sh

```

你很可能会阅读这篇有关这些的额外信息的文章-[Super Privileged Containers](http://developerblog.redhat.com/2014/11/06/introducing-a-super-privileged-container-concept/)。

**原文链接：[Tuning Docker with the newest security enhancements](https://opensource.com/business/15/3/docker-security-tuning) （翻译：[田浩浩](https://github.com/llitfkitfk)）**

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
**译者介绍**
田浩浩，[USYD](http://sydney.edu.au/engineering/it/)硕士研究生，目前在珠海从事Android应用开发工作。业余时间专注Docker的学习与研究，希望通过[DockerOne](http://dockerone.com/)把最新最优秀的译文贡献给大家，与读者一起畅游Docker的海洋。