##Docker教程系列 8 Docker Remote API

在[Docker教程系列的上一章](http://dockerone.com/article/107)中，我们讨论Docker Hub 以及 Docker Registry API。在今天的文章里，让我们深入探讨Docker Remote API。

###Docker Remote API

Docker Remote API是取代rcli(远程命令行界面)的REST API。对于本教程的目的，我们使用一个命令行工具cURL来处理url操作。它有助于发出请求、获取与发送数据并且检索信息。

####List containers
获取所有容器的清单：
```GET /containers/json
```
![](http://cdn2.hubspot.net/hub/411552/file-1222274164-png/blog-files/get-all-containers.png?t=1419891691508)
	
####Create a new container
创建新的容器：
```POST /containers/create
```![](http://cdn2.hubspot.net/hub/411552/file-1222274179-png/blog-files/docker-create-container.png?t=1419891691508)
	
####Inspect Container
使用容器id获取该容器底层信息：
```GET /containers/(id)/json
```![](http://cdn2.hubspot.net/hub/411552/file-1222274194-png/blog-files/docker-inspect-a-container.png?t=1419891691508)

####Process List
获取容器内进程的清单：
```GET /containers/(id)/top
```
![](http://cdn2.hubspot.net/hub/411552/file-1222274209-png/blog-files/docker-container-top.png?t=1419891691508)

####Container Logs
获取容器的标准输出和错误日志：
```GET /containers/(id)/logs
```
![](http://cdn2.hubspot.net/hub/411552/file-1222274224-png/blog-files/docker-container-logs.png?t=1419891691508)

####Export Container
导出容器内容：
```GET /containers/(id)/export
```
![](http://cdn2.hubspot.net/hub/411552/file-1222274239-png/blog-files/docker-export-container.png?t=1419891691508)

####Start a container
开启容器：
```POST /containers/(id)/start
```
![](http://cdn2.hubspot.net/hub/411552/file-1222274254-png/blog-files/docker-start-container.png?t=1419891691508)

####Stop a container
停止容器：
```POST /containers/(id)/stop
```
![](http://cdn2.hubspot.net/hub/411552/file-1222274269-png/blog-files/docker-stop-a-container.png?t=1419891691508)

####Restart a Container
重启容器：
```POST /containers/(id)/restart
```
![](http://cdn2.hubspot.net/hub/411552/file-1222274284-png/blog-files/docker-restart-a-container.png?t=1419891691508)

####Kill a container
终止容器：
```POST /containers/(id)/kill
```
![](http://cdn2.hubspot.net/hub/411552/file-1222274299-png/blog-files/docker-kill-a-container.png?t=1419891691508)

现在，我们已经带您领略了Docker API的第二站，[Docker教程系列下一章]()会了解有关镜像的Docker Remote API命令。我们所有的Docker教程系列你可以在[这里](http://dockerone.com/topic/Docker%20Tutorial)找到。