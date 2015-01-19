##探索Docker本地桥接网络

【编者的话】本文主要介绍了Docker的基础网络知识，作者通过容器与MongoDB实例的连接的小实验探索了Docker的网路知识以及其中的一些问题。

TL; DR（太长了，不要看了）Docker可以帮助您构建与管理容器。它不能保护你免受应用层的错误。

我正在筹备[Docker in Action](http://www.manning.com/nickoloff/)（译注：此书的样章可以在[这里查看](http://www.manning.com/nickoloff/DockerinAction_MEAP_ch01.pdf)）第五章内容－有关Docker的容器链接与网络配置。最近一直在关注工具的其他部分，因此我需要几天让自己重新熟悉容器链接以及潜深Docker网络。

我想给您展示一些东西。

对于熟悉桥接网络的不会有什么新的内容。但我有一种感觉一些使用Docker的开发者没有预料到的一些事。我想给你展示当你启动一些本地的容器时如何探索为此建立的网络。这样做将有助于您理解Docker容器链接。

下面将会指引您完成一个涉及从一个单独的容器访问一个包含```MongoDB```的服务器的小实验。

###开启您的目标容器
在这个实验中我们的目标是MongoDB服务器。您可以安装并使用以下简单的命令启动。
{{{docker run --name some-mongo -d mongo:latest
}}}
	
###开始另一个容器
这个是从Ubuntu镜象运行来的容器，他运行了一个shell环境。你会检查你的本地网络并从这个容器连接到您的mongo实例。
{{{docker run -it --rm ubuntu:latest /bin/bash
root@XXX:/#}}}

在交互模式下开启镜像，这样就可以安装你所需要的工具或者做其他事情而不会扰乱你的主机系统的状态。

###获取您的骇客工具
你需要的工具包括```Mongo CLI```和```nmap```。
{{{root@XXX:/＃apt-get -y install nmap
root@XXX:/＃apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
root@XXX:/＃echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
root@XXX:/＃apt-get update
root@XXX:/＃apt-get install -y mongodb-org-shell}}}

既然你正在以root身份运行的容器，你不用担心的标准的```sudo```命令前缀。一旦这些命令运行完成，你就可以准备开启实验。

###扫描网络
找到你的容器的IP地址，这样你就可以猜出你的目标可能在哪。
{{{root@XXX:/＃MY_IP=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`}}}

寻找在同一的监听端口为27017子网中的主机。执行此操作使用```nmap```进行子网的27017端口的扫描：
{{{root@XXX:/＃nmap -sS -p 27017 $MY_IP/24
}}}

在我的测试环境中的网络端口扫描的结果如下：
{{{Starting Nmap 6.40 ( http://nmap.org ) at 2014-12-09 15:52 UTC
Nmap scan report for 172.17.0.33
Host is up (0.000030s latency).
PORT STATE SERVICE
27017/tcp closed unknown
MAC Address: 02:42:AC:11:00:21 (Unknown)
Nmap scan report for 172.17.0.34
Host is up (0.000021s latency).
PORT STATE SERVICE
27017/tcp closed unknown
MAC Address: 02:42:AC:11:00:22 (Unknown)
Nmap scan report for 172.17.0.96
Host is up (-0.079s latency).
PORT STATE SERVICE
27017/tcp open unknown
MAC Address: 02:42:AC:11:00:60 (Unknown)
Nmap scan report for 172.17.0.131
Host is up (-0.084s latency).
PORT STATE SERVICE
27017/tcp closed unknown
MAC Address: 02:42:AC:11:00:83 (Unknown)
Nmap scan report for XXX (172.17.0.132)
Host is up (0.000055s latency).
PORT STATE SERVICE
27017/tcp closed unknown
Nmap done: 256 IP addresses (5 hosts up) scanned in 4.10 seconds}}}

从以上的输出中你可以看到，我的测试环境中运行的5个容器（包括一个正在运行命令的）。五个其中之一的端口27017是开放的。开放此端口的IP地址是运行你的MongoDB实例容器的IP地址。这是有趣的并且某些情况下可能会是一个惊喜。一会儿我就来聊聊这些。首先，让我们完成实验。

###访问数据库
使用先前安装的mongo CLI，您应该能够访问在其他容器中运行的MongoDB实例。在你得意忘形之前，你要知道这并不是Docker的或者Linux内核的漏洞而是当你运行开放的服务器时它都会发生的。

当您运行以下命令使用您在```nmap```输出里的IP地址。
{{{root@XXX:/＃mongo --host 172.17.0.96 # replace the IP address
MongoDB shell version: 2.6.6
connecting to: 172.17.0.96:27017/test
Welcome to the MongoDB shell.
For interactive help, type "help".
For more comprehensive documentation, see
 http://docs.mongodb.org/
Questions? Try the support group
 http://groups.google.com/group/mongodb-user
>_
}}}
	
就是这样。你可以在不同的容器内连接到MongoDB实例。获取对数据库的访问就是这么容易。惊讶吧？不应该。您正在运行一个没有身份验证的要求的MongoDB实例。不要以为防火墙或网络拓扑会保护你的安全性差的服务。

###Docker抽象化以及他们通信什么
此前在Docker的历险中，由于某种原因，我的印象是网络是围绕着容器而构建。这是真实的。有迹象表明这里有分离接口的防火墙。不过我最初没有想到这些，即使是路由没有具体的链接。我认为，这是被Docker容器的链接增强了。

与其他人一样，当我学习如何访问其他容器我发现的第一件事就是容器的链接。这是你可以在你想要访问另一个现有容器的容器创建的时间来指定的进程。当您创建链接使Docker注入持有IP和端口信息的环境变量到新创建的容器。此外，其他的容器IP地址将被添加到```/etc/hosts```文件为容器的名称。

当我学习链接时，我停止了寻找其他的工具......至少一段时间。链接相当的方便，但他们只是提供了方便。他们稍微减少了信息的不明确性通过告知你的新容器其他一些特定的容器的IP和端口信息。就是这样。桥接网络也没有什么花哨。

您可以访问其他容器的外部接口，就像他们是一个网络上的其他计算机。这应该是一件好事。我们知道该怎么做。我们有许多用于做这些的工具。但急于采用的会跟我早期的假设一样都会很害怕。如果你做了也不必惊慌。仅仅修复那些Docker会触发的一些明显的安全问题就好了。

Docker可帮助您构建强大的容器。但它不能使你免受应用层的错误。请记住这些在您发展前进的时候并且要构建更大更好的东西。

PS：别忘了停止并删除您在本实验中创建的容器。
{{{ docker kill some-mongo
docker rm -v some-mongo}}}
	
**原文链接：[Exploring Local Docker Bridge Networks](https://medium.com/@allingeek/exploring-local-docker-bridge-networks-2c655ac59d7a) （翻译：[田浩](https://github.com/llitfkitfk)）**