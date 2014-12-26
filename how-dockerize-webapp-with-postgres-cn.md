docker:组装 使用Postgres数据库的web应用 
=========

[原文](http://fabioberger.com/blog/2014/12/19/how-to-dockerize-golang-webapp-with-postgres-db/)

最近我一直在学习Docker,并决定使用它来部署我一直编写的Golang Negroni + Postgres的web应用程序。

为了保证以后的可扩展性以及遵守最佳实践，这意味着需要两个docker容器：一个用于应用程序，另一个用于数据库， 并且连接两个容器。

由于第一次使用docker，所以跳了不少坑，因此把所有的步骤都分享给大家。



你可以找到本教程的演示程序：[Github.com/Dockerize-Tutorial](https://github.com/fabioberger/dockerize-tutorial)

本指南假定您已经安装了Docker，如果没有，[立即安装它](https://docs.docker.com/installation/)。

##第1步：组装Postgres的Docker容器

首先，下载并运行[Postgres官方Docker镜像](https://registry.hub.docker.com/_/postgres/)。给它命名为“db”，并设置默认的“Postgres的用户的密码：

```
docker run --name db -e POSTGRES_PASSWORD=password123 -d postgres
```

```-d```的意思是运行这个容器作为守护进程，因此它会在后台悄悄运行。

接下来，创建应用程序的Postgres用户并创建数据库。要做到这一点，需要打开“db”容器的bash shell：

```
docker exec -it db /bin/bash
```

从这个 bash shell 中登录 psql：

```
psql -U postgres
```

在postgres交互的shell来创建用户和数据库：

```
CREATE USER app;
CREATE DATABASE testapp;
GRANT ALL PRIVILEGES ON DATABASE testapp TO app;
```

然后退出psql (快捷键: CTRL-D)。现在，已经建立了数据库，接下来需要在这个容器中编辑配置文件，因此需要先安装一个文本编辑器（Vim！我看好你！）。

```
apt-get update && apt-get install vim
```

然后使用Vim来编辑postgres的```pg_hba.conf```文件，此文件是用来管理客户端身份验证的。
我们需要修改这个文件来允许上文中的自定义用户能访问从应用程序容器到运行在此容器上数据库我们定制的Postgres用户。默认情况下，只有’postgres‘用户有这个权限。要找到此配置文件可以用以下命令：

```
psql -U postgres
```

在postgres交互shell中运行：

```
SHOW hba_file;
```

复制返回的文件路径并退出psql shell (快捷键: CTRL-D)。
现在，使用Vim编辑该文件：

```
vim /var/lib/postgresql/data/pg_hba.conf
```

更改文件的最后一行，并保存更改，请键入```:wq```：

```
host all "app" 0.0.0.0/0 trust
```

由于此配置文件只有当postgres启动的时候运行，现在我们需要重新启动db容器。退回到您的主机 (快捷键: CTRL-D)，然后运行：

```
docker stop db
docker start db
```

修改之后的配置生效，Postgres容器就准备好了！

##第2步：组装的Golang应用

为了组装Go应用程序，我们必须在项目文件夹下创建Dockerfile。
如果你不想组装你已经在编写的Golang应用程序，你可以下载[Dockerize-tutorial Demo App](https://github.com/fabioberger/dockerize-tutorial)。在Golang项目的根目录下，创建Dockerfile：

```
touch Dockerfile
```

在此文件里，我们将添加以下三行：

```
FROM golang:onbuild
RUN go get bitbucket.org/liamstask/goose/cmd/goose
EXPOSE 4000
```

第一行 运行golang镜像的onbuild版本，它自动复制该数据包源，并获取该程序的依赖，然后建立程序，并配置其在启动时运行。

第二行 安装'goose'，我们的迁移工具中的应用程序容器中，

最后一行 将开放端口4000。现在，我们可以为应用程序构建一个docker镜像。在项目目录中，运行：

```
docker build -t app .
```

这个命令最终生成命名为‘app’的docker镜像。现在，我们可以通过这个docker镜像运行一个Docker的容器：

```
docker run -d -p 8080:4000 --name tutapp --link db:postgres app
```

以上命令可分解为：

* ```-d```让Docker运行此容器作为守护进程。 
* ```-p 8080:4000```让Docker将容器内的端口4000（此应用程序需要的端口）映射到主机的端口8080。
* ```--name tutapp```命名docker容器为“tutapp”。
* ```--link db:postgres``` 链接应用程序容器与之前创建的名为‘db’的postgres容器。

链接两个容器：我们的应用程序容器访问一个名为’$POSTGRES_PORT_5432_TCP_ADDR‘的环境变量。这个环境变量包含连接到Postgres DB时的主机地址。因此，我们必须确保我们的```dbconf.yml```文件里的host变量为：

```
db:
   driver: postgres
   open: host=$POSTGRES_PORT_5432_TCP_ADDR user=app dbname=testapp sslmode=disable
```

在演示应用程序中的```config.go```文件替换该变量。

最后一步是运行DB迁移为我们的应用程序，因此在tutapp容器内与运行'goose up'：

```
docker exec -it tutapp goose up
```

要访问的此程序，访问 http://localhost:8080 你应该看到此应用程序运行！

（如果用户的docker守护进程是在另一台机器（或虚拟机）上运行，用户应当将localhost更改为主机的地址。如果你是使用boot2docker在OS X或Windows，你可以找ip地址使用命令'boot2docker ip‘）

现在你成功运行了Golang应用程序并与在另一个Docker容器里的Postgres数据库通信。如果有什么不清楚或者如果不能运行，请留下了评论，我将第一时间完善！