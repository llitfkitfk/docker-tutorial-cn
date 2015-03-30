【编者的话】本文的案例结合了Docker的三大编排工具-Docker Machine、Compose与Swarm，

自从我上次发表的[有关Docker博文](https://media-glass.es/2014/08/31/docker-fig-reverse-proxy-centos7/)，它发生了很多变化。Docker已经推出了一些新的命令行工具，使其在Docker实例、集群以及容器管理方面更方便地编排。他们是：

* [Docker Machine](https://docs.docker.com/machine/) - 让你轻松部署Docker实例到很多不同的平台。
* [Docker Compose](https://docs.docker.com/compose/) - [Fig工具](http://www.fig.sh/)的替代品。
* [Docker Swarm](https://docs.docker.com/swarm/) - Docker众实例的原生集群。

这三种技术中，Swarm目前不适合在生产中使用，因此在这篇文章中我不会讲关于它的太多细节。

##Docker Machine

对于直接下载预编译的二进制文件来说，我决定使用[Homebrew（OS X的管理包工具）](http://brew.sh/)公式：

{{{
# Make sure everything is up-to-date
brew update
brew doctor
brew cask update
brew cask doctor
# install docker-machine
brew cask install docker-machine}}}

这样就安装了`docker-machine`。

{{{
$  docker-machine -v
docker-machine version 0.1.0
$  docker-machine ls
NAME   ACTIVE   DRIVER   STATE   URL   SWARM
$ 
}}}

我已经安装了[VirtualBox](https://www.virtualbox.org/)，并且要创建一个叫“testing”的Virtual Machine：

{{{
$  docker-machine create --driver virtualbox testing
INFO[0000] Creating SSH key...                          
INFO[0000] Creating VirtualBox VM...                    
INFO[0006] Starting VirtualBox VM...                    
INFO[0006] Waiting for VM to start...                   
INFO[0038] "testing" has been created and is now the active machine. 
INFO[0038] To point your Docker client at it, run this in your shell: $(docker-machine env testing)
}}}

`docker-machine`使用几个命令来帮助你连接到本地安装的`docker`客户端：

{{{
$  docker-machine env testing
export DOCKER_TLS_VERIFY=yes
export DOCKER_CERT_PATH=/Users/russ/.docker/machine/machines/testing
export DOCKER_HOST=tcp://192.168.99.100:2376
$  docker-machine config testing
--tls --tlscacert=/Users/russ/.docker/machine/machines/testing/ca.pem --tlscert=/Users/russ/.docker/machine/machines/testing/cert.pem --tlskey=/Users/russ/.docker/machine/machines/testing/key.pem -H="tcp://192.168.99.100:2376
}}}

就是这样，我现在启用了一个Virtual Machine并且准备使用Docker

{{{
$  docker-machine ls
NAME      ACTIVE   DRIVER       STATE     URL                         SWARM
testing   *        virtualbox   Running   tcp://192.168.99.100:2376
```

和其他新安装的一样，让我们运行一个“Hello World”：

{{{
$  docker $(docker-machine config testing) run busybox echo hello world
Unable to find image 'busybox:latest' locally
511136ea3c5a: Pull complete 
df7546f9f060: Pull complete 
ea13149945cb: Pull complete 
4986bf8c1536: Pull complete 
busybox:latest: The image you are pulling has been verified. Important: image verification is a tech preview feature and should not be relied on to provide security.

Status: Downloaded newer image for busybox:latest
hello world
}}}

最后，你可以使用`docker-machie ssh machine-name`命令SSH到Virtual Machine：

{{{
$  docker-machine ssh testing
Boot2Docker version 1.5.0, build master : a66bce5 - Tue Feb 10 23:31:27 UTC 2015
Docker version 1.5.0, build a8a31ef
docker@testing:~$ uname -a
Linux testing 3.18.5-tinycore64 #1 SMP Sun Feb 1 06:02:30 UTC 2015 x86_64 GNU/Linux
docker@testing:~$ cat /etc/*release
NAME=Boot2Docker
VERSION=1.5.0
ID=boot2docker
ID_LIKE=tcl
VERSION_ID=1.5.0
PRETTY_NAME="Boot2Docker 1.5.0 (TCL 5.4); master : a66bce5 - Tue Feb 10 23:31:27 UTC 2015"
ANSI_COLOR="1;34"
HOME_URL="http://boot2docker.io"
SUPPORT_URL="https://github.com/boot2docker/boot2docker"
BUG_REPORT_URL="https://github.com/boot2docker/boot2docker/issues"
docker@testing:$ exit
$  
}}}

太棒了，我现在有一个Virtual Machine运行在我的电脑上，接下来呢？

设计`docker-machine`就是和以下公有和私有的云服务提供商（以后会添加更多）一起使用的

* Amazon EC2
* Microsoft Azure
* Digital Ocean
* Google Compute Engine
* Rackspace
* SoftLayer
* OpenStack
* VMWare vCloud Air
* VMWare vSphere

让我们使用`docker-machine`来启用一个Digital Ocean的实例。你需要生成一个Personal Access Token，你可以按照指南来做。一旦用token启用机子就会像下面所示一样：

{{{
$  docker-machine create \
→     --driver digitalocean \
→     --digitalocean-access-token cdb81ed0575b5a8d37cea0d06c9690daa074b1276892fc8473bdda97eb7c65ae \
→     dotesting
INFO[0000] Creating SSH key...                          
INFO[0000] Creating Digital Ocean droplet...            
INFO[0004] Waiting for SSH...                           
INFO[0071] Configuring Machine...                       
INFO[0120] "dotesting" has been created and is now the active machine. 
INFO[0120] To point your Docker client at it, run this in your shell: $(docker-machine env dotesting) 
}}}

（当然，那个token并不是我的，它只是一串随机数）

那么发生了什么呢？`docker-machine`访问我的Digital Ocean账户通过API并且启用了以下配置的实例：

* OS = Ubuntu 14.04 x64
* RAM = 512MB
* HDD = 20GB SSD
* Region = NYC3 

这些默认的配置可以通过提供更多的选项被修改，运行`docker-machine create --help`获取帮助查看所有带例子的选项。

一旦实例开启，`docker-machine`通过SSH连接到安装、配置以及开启的最新的Docker上。

所以，我们现在有两台Machines，一个在本地，一个在Digital Ocean上。

{{{
$  docker-machine ls
NAME        ACTIVE   DRIVER         STATE     URL                         SWARM
dotesting   *        digitalocean   Running   tcp://45.55.134.248:2376    
testing              virtualbox     Running   tcp://192.168.99.100:2376  
}}}

让我们再次运行“Hello World”，但是这次使用刚才启动的那个实例：

{{{
$  docker $(docker-machine config dotesting) run busybox echo hello world
Unable to find image 'busybox:latest' locally
511136ea3c5a: Pull complete 
df7546f9f060: Pull complete 
ea13149945cb: Pull complete 
4986bf8c1536: Pull complete 
busybox:latest: The image you are pulling has been verified. Important: image verification is a tech preview feature and should not be relied on to provide security.

Status: Downloaded newer image for busybox:latest
hello world
}}}

并且SSH到那个machine中：

{{{
$  docker-machine ssh dotesting
Welcome to Ubuntu 14.04.1 LTS (GNU/Linux 3.13.0-43-generic x86_64)

Documentation:  https://help.ubuntu.com/

  System information as of Sat Mar 21 07:24:02 EDT 2015

  System load:  0.43               Processes:              72
  Usage of /:   11.4% of 19.56GB   Users logged in:        0
  Memory usage: 12%                IP address for eth0:    45.55.134.248
  Swap usage:   0%                 IP address for docker0: 172.17.42.1

  Graph this data and manage this system at:
https://landscape.canonical.com/

root@dotesting:~# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
busybox             latest              4986bf8c1536        11 weeks ago        2.433 MB
root@dotesting:~# docker ps -a
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS                     PORTS               NAMES
b8a83077d858        busybox:latest      "echo hello world"   4 minutes ago       Exited (0) 4 minutes ago                       kickass_almeida     
root@dotesting:~# exit
logout
$  
}}}

最终，你可以使用`docker-mashie stop machine-name`和`docker-mashie rm machine-name`来停止和移除machines。请注意当使用`rm`时，是不会提示你是否确定删除。

{{{
$  docker-machine ls
NAME        ACTIVE   DRIVER         STATE     URL                         SWARM
dotesting   *        digitalocean   Running   tcp://45.55.134.248:2376    
testing              virtualbox     Running   tcp://192.168.99.100:2376   
$  docker-machine stop dotesting
$  docker-machine ls
NAME        ACTIVE   DRIVER         STATE     URL                         SWARM
dotesting   *        digitalocean   Stopped   tcp://45.55.134.248:2376    
testing              virtualbox     Running   tcp://192.168.99.100:2376   
$  docker-machine rm dotesting
$  docker-machine ls
NAME      ACTIVE   DRIVER       STATE     URL                         SWARM
testing            virtualbox   Running   tcp://192.168.99.100:2376   
$  
}}}

总结，以上就是`docker-machie`的总览。正如你看到的，它确实很方便在很多不同的供应商中来引导Docker服务实例，并且使用一个本地machine命令就可以操控他们。

##Docker Compose

Docker开始充满生机是因为有了Fig，[这是我曾在以前的文章中写到过](https://media-glass.es/2014/08/31/docker-fig-reverse-proxy-centos7/)，当前版本并没有添加太多的新功能，但它开始奠定了与`docker-swarm`工作的基础，单击[这里](https://github.com/docker/compose/releases/tag/1.1.0)查看详细日志。

像`docker-machine`一样，我使用Homebrew公式安装`docker-compose`

{{{
$  brew install docker-compose
==> Downloading https://homebrew.bintray.com/bottles/fig-1.1.0.yosemite.bottle.1.tar.gz
################################################################## 100.0%
==> Pouring fig-1.1.0.yosemite.bottle.1.tar.gz
==> Caveats
Bash completion has been installed to:
  /usr/local/etc/bash_completion.d
==> Summary
  /usr/local/Cellar/fig/1.1.0: 186 files, 2.2M
$  
}}}

然后，使用`docker-machine`让我们创建一个Docker服务实例来使用`docker-compose`：

{{{
$  docker-machine create --driver virtualbox compose
INFO[0001] Creating SSH key...                          
INFO[0001] Creating VirtualBox VM...                    
INFO[0007] Starting VirtualBox VM...                    
INFO[0008] Waiting for VM to start...                   
INFO[0041] "compose" has been created and is now the active machine. 
INFO[0041] To point your Docker client at it, run this in your shell: $(docker-machine env compose) 
}}}

因为`docker-compose`不直接与`docker-machine`交互，我们需要告诉`docker`客户端那些刚刚启动的服务器实例的详细信息

{{{
$  $(docker-machine env compose)
}}}

此命令注入所需Docker客户端的环境变量来连接到服务实例，要看到他们，你只需运行`docker-machine env machine-name`

{{{
$  docker-machine env compose
export DOCKER_TLS_VERIFY=yes
export DOCKER_CERT_PATH=/Users/russ/.docker/machine/machines/compose
export DOCKER_HOST=tcp://192.168.99.100:2376
}}}

往后它就像Fig一样，除了fig.yml文件现在应该改为`docker-compose.yml`，在我以前的博文里有一个`fig.yml`文件描述：

{{{
web:  
  image: russmckendrick/nginx-php
  volumes:
    - ./web:/var/www/html/
  ports:
    - 80:80
  environment:
    PHP_POOL: mywebsite
  links:
    - db:db
db:  
  image: russmckendrick/mariadb
  ports:
    - 3306
  privileged: true
  environment:
    MYSQL_ROOT_PASSWORD: wibble
    MYSQL_DATABASE: wibble
    MYSQL_USER: wibble
    MYSQL_PASSWORD: wibble
}}}

它启用两个容器并且把它们连接到一起，还有在NGINX容器内的`/var/www/html`被挂载到host的`./web`文件夹下。我准备运行`docker-compose`命令的文件夹的结构是这样的：

{{{
$  tree -a
.
├── \[russ      356]  docker-compose.yml
└── \[russ      102]  web
└── \[russ       67]  index.php

1 directory, 2 files
}}}
	
开始我要拉取需要启用的镜像，你可以忽略此部分。

{{{
$  docker-compose pull
Pulling db (russmckendrick/mariadb:latest)...
Pulling web (russmckendrick/nginx-php:latest)...
}}}

现在镜像已经被拉取下来，是时候开启容器了：

{{{
$  docker-compose up -d
Creating example_db_1...
Creating example_web_1...
}}}

我们现在有了两个正在运行的容器：

{{{
$  docker-compose ps
Name             Command         State            Ports          
----------------------------------------------------------------
example_db_1    /usr/local/bin/run   Up      0.0.0.0:49154->3306/tcp 
example_web_1   /usr/local/bin/run   Up      0.0.0.0:80->80/tcp   
}}}

你也可以打开浏览器：

{{{
open http://$(docker-machine ip)
}}}

在我的例子中我看到`PHPinfo()`页面

![](https://media-glass.es/content/images/2015/03/phpinfo.png)

一旦容器开启，你可以使用`docker exec`来连接到容器内部：

{{{
$  docker exec -it example_web_1 bash
[root@997bbe6b5c80 /]# ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.2  1.5 115200 15360 ?        Ss   13:59   0:01 /usr/bin/python /usr/bin/supervisord -n
root        16  0.0  3.2 382876 33624 ?        S    13:59   0:00 php-fpm: master process (/etc/php-fpm.conf)
root        17  0.0  0.2 110016  2096 ?        Ss   13:59   0:00 nginx: master process nginx
nginx       18  0.0  0.5 110472  5568 ?        S    13:59   0:00 nginx: worker process
webserv+    19  0.0  1.5 383132 16284 ?        S    13:59   0:00 php-fpm: pool mywebsite
webserv+    20  0.0  0.8 382876  8848 ?        S    13:59   0:00 php-fpm: pool mywebsite
webserv+    21  0.0  0.8 382876  8848 ?        S    13:59   0:00 php-fpm: pool mywebsite
webserv+    22  0.0  0.8 382876  8848 ?        S    13:59   0:00 php-fpm: pool mywebsite
webserv+    23  0.0  0.8 382876  8852 ?        S    13:59   0:00 php-fpm: pool mywebsite
root        95  0.0  0.4  91540  4740 ?        Ss   13:59   0:00 /usr/libexec/postfix/master -w
postfix     97  0.0  0.6  91712  6508 ?        S    13:59   0:00 qmgr -l -t unix -u
postfix    200  0.0  0.6  91644  6232 ?        S    14:05   0:00 pickup -l -t unix -u
root       234  2.3  0.2  11748  2968 ?        S    14:07   0:00 bash
root       250  1.0  1.1 110012 11616 ?        S    14:07   0:00 nginx
root       251  0.0  0.2  19756  2212 ?        R+   14:07   0:00 ps aux
[root@997bbe6b5c80 /]# exit
exit
$  
}}}

最后你可以停止以及移除容器，当然还有Docker实例：

{{{
$  docker-compose stop && docker-compose rm --force
Stopping example_web_1...
Stopping example_db_1...
Going to remove example_web_1, example_db_1
Removing example_db_1...
Removing example_web_1...
$  docker-machine rm compose
$  docker-machine ls
NAME   ACTIVE   DRIVER   STATE   URL   SWARM
$  
}}}

##Docker Swarm

在进一步讨论之前，官方文档警告:

> 警告：Swarm当前是beta版本，因此后期可能会有变化。我们还不推荐在生产环境中使用。

现在让我们使用Homebrew来安装`docker-swarm`：

{{{
$  brew install docker-swarm
==> Downloading https://homebrew.bintray.com/bottles/docker-swarm-0.1.0.yosemite.bottle.tar.gz
################################################################## 100.0%
==> Pouring docker-swarm-0.1.0.yosemite.bottle.tar.gz
  /usr/local/Cellar/docker-swarm/0.1.0: 4 files, 8.7M
}}}

因为我们已经安装了`docker-machine`，我将要使用它在本地创建一个集群。首先，我们需要启动一个实例并运行swarm容器：

{{{
$  docker-machine ls
NAME   ACTIVE   DRIVER   STATE   URL   SWARM
$  docker-machine create -d virtualbox local
INFO[0001] Creating SSH key...                          
INFO[0001] Creating VirtualBox VM...                    
INFO[0006] Starting VirtualBox VM...                    
INFO[0006] Waiting for VM to start...                   
INFO[0039] "local" has been created and is now the active machine. 
INFO[0039] To point your Docker client at it, run this in your shell: $(docker-machine env local) 
$   $(docker-machine env local) 
$  docker run swarm create
Unable to find image 'swarm:latest' locally
511136ea3c5a: Pull complete 
ae115241d78a: Pull complete 
f49087514537: Pull complete 
fff73787bd9f: Pull complete 
97c8f6e912d7: Pull complete 
33f9d1e808cf: Pull complete 
62860d7acc87: Pull complete 
bf8b6923851d: Pull complete 
swarm:latest: The image you are pulling has been verified. Important: image verification is a tech preview feature and should not be relied on to provide security.

Status: Downloaded newer image for swarm:latest
63e7a1adb607ce4db056a29b1f5d30cf
$  
}}}

正如你所见，当容器启动时，我得到了一个token：`63e7a1adb607ce4db056a29b1f5d30cf`，我将要用它来添加更多的节点，但是首先我们需要创建一个Swarm master：

{{{
$  docker-machine create \
→     -d virtualbox \
→     --swarm \
→     --swarm-master \
→     --swarm-discovery token://63e7a1adb607ce4db056a29b1f5d30cf \
→     swarm-master
INFO[0000] Creating SSH key...                          
INFO[0000] Creating VirtualBox VM...                    
INFO[0006] Starting VirtualBox VM...                    
INFO[0006] Waiting for VM to start...                   
INFO[0038] Configuring Swarm...                         
INFO[0043] "swarm-master" has been created and is now the active machine. 
INFO[0043] To point your Docker client at it, run this in your shell: $(docker-machine env swarm-master)
}}}

然后，我们需要连接Docker客户端到Swarm上，这就需要将`--swarm`添加到` $(docker-machine env machine-name)`命令上：

{{{
$  $(docker-machine env --swarm swarm-master)
}}}

现在让我们添加另一个节点：

{{{
$  docker-machine create \
→     -d virtualbox \
→     --swarm \
→     --swarm-discovery token://63e7a1adb607ce4db056a29b1f5d30cf  \
→     swarm-node-00
INFO[0000] Creating SSH key...                          
INFO[0000] Creating VirtualBox VM...                    
INFO[0006] Starting VirtualBox VM...                    
INFO[0006] Waiting for VM to start...                   
INFO[0039] Configuring Swarm...                         
INFO[0048] "swarm-node-00" has been created and is now the active machine. 
}}}

我们现在有了2个节点的集群 - “swarm-master”：

{{{
$  docker-machine ls
NAME            ACTIVE   DRIVER       STATE     URL                         SWARM
local                    virtualbox   Running   tcp://192.168.99.100:2376   
swarm-master             virtualbox   Running   tcp://192.168.99.101:2376   swarm-master (master)
swarm-node-00   *        virtualbox   Running   tcp://192.168.99.102:2376   swarm-master
}}}

使用`docker info`来获取更多有关集群的信息：

{{{
$  docker info
Containers: 3
Nodes: 2
 swarm-master: 192.168.99.101:2376
  └ Containers: 2
  └ Reserved CPUs: 0 / 4
  └ Reserved Memory: 0 B / 999.9 MiB
 swarm-node-00: 192.168.99.102:2376
  └ Containers: 1
  └ Reserved CPUs: 0 / 4
  └ Reserved Memory: 0 B / 999.9 MiB
}}}

太棒了，但这意味着什么？

让我们拉取一些镜像：

{{{
$  docker -H 192.168.99.101:2376 pull redis
$  docker -H 192.168.99.102:2376 pull mysql
}}}

注意到我是如何在“swarm-master”上拉取`redis`镜像以及在`swarm-node-00`上拉取`mysql`的，现在我可以保证容器只在有镜像的那个节点上启用：

{{{
$  docker run -d --name redis1 -e affinity:image==redis redis
af66148bbbc8dcd799d82448dfd133b968d34eb7066a353108bf909ea3324a58
$  docker run -d --name mysql -e affinity:image==mysql -e MYSQL_ROOT_PASSWORD=mysecretpassword -d mysql 
70b2d93d6f83aa99f5ad4ebe5037e228a491a4b570609840f3f4be9780c33587
$  docker ps
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS                  PORTS               NAMES
70b2d93d6f83        mysql:latest        "/entrypoint.sh mysq   3 seconds ago       Up Less than a second   3306/tcp            swarm-node-00/mysql   
af66148bbbc8        redis:latest        "/entrypoint.sh redi   2 minutes ago       Up 2 minutes            6379/tcp            swarm-master/redis1  
}}}

另一个例子是使用节点的端口，让我们在两个节点上都拉取我的NGINX-PHP镜像：

{{{
$  docker -H 192.168.99.101:2376 pull russmckendrick/nginx-php
$  docker -H 192.168.99.102:2376 pull russmckendrick/nginx-php
}}}

现在，让我们启用一个容器并绑定到80端口

{{{
$  docker run -d -p 80:80 russmckendrick/nginx-php
2d066b2ccf28d2a1fa9edad8ac7b065266f29ecb49a8753b972780051ff83587
}}}

再有：

{{{
$  docker run -d -p 80:80 russmckendrick/nginx-php
40f5fee257bb2546a639a5dc5c2d30f8fa0ac169145e431c534f85d8db51357f
}}}

你会说这没什么特别的啊？正常来说，当试图启动第二个容器时，你会得到如下信息因为你不用将同一个端口绑定到两个容器上：

{{{
$  docker run -d -p 80:80 russmckendrick/nginx-php
FATA[0000] Error response from daemon: unable to find a node with port 80 available 
}}}

然而，在集群的情况下，因为Docker知道集群节点运行的是什么以及哪些端口是在使用的。Docker可以简单地通过Swarm在“swarm-node-00”上启动容器并且它知道“swarm-master”已经使用了80端口：

{{{
$  docker ps
CONTAINER ID        IMAGE                             COMMAND                CREATED             STATUS                  PORTS                       NAMES
40f5fee257bb        russmckendrick/nginx-php:latest   "/usr/local/bin/run"   4 seconds ago       Up Less than a second   192.168.99.101:80->80/tcp   swarm-master/elated_einstein   
2d066b2ccf28        russmckendrick/nginx-php:latest   "/usr/local/bin/run"   8 seconds ago       Up Less than a second   192.168.99.102:80->80/tcp   swarm-node-00/drunk_mestorf    
70b2d93d6f83        mysql:latest                      "/entrypoint.sh mysq   26 minutes ago      Up 26 minutes           3306/tcp                    swarm-node-00/mysql            
af66148bbbc8        redis:latest                      "/entrypoint.sh redi   29 minutes ago      Up 29 minutes           6379/tcp                    swarm-master/redis1 
}}}

所有这一切都没有提示或特殊的命令行，它的帮助仅仅是用它来做到这些。

正如你所看到的，`docker-swarm`仍然非常大的发展潜力，也有一些不如意的地方，如容器不能够跨节点互相通讯。然而，伴随着[socketplane.io](http://socketplane.io/)（他们使用Open vSwitch开发了一个基于软件定义网络解决方案的容器）要加入Docker的消息，我认为用不了多长时间这个问题就能得到解决。

最后，让我们删除在运行的实例：

{{{
$  docker-machine rm local swarm-master swarm-node-00
}}}

就这样吧，期待在未来的几个月这些工具的更新，我也会进一步跟进。


**原文：[Docker Machine, Compose & Swarm](https://media-glass.es/2015/03/21/docker-machine-compose-swarm/) （翻译：[田浩浩](https://github.com/llitfkitfk)）**

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
**译者介绍**
田浩浩，[USYD](http://sydney.edu.au/engineering/it/)硕士研究生，目前在珠海从事Android应用开发工作。业余时间专注Docker的学习与研究，希望通过[DockerOne](http://dockerone.com/)把最新最优秀的译文贡献给大家，与读者一起畅游Docker的海洋。