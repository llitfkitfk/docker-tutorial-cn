##Docker教程系列 9 Docker Remote API Commands for Images

在[Docker教程系列的上一篇文章](http://dockerone.com/article/109)中，我们讨论了Docker Remote API，并具体探索了有关容器的命令。在这篇文章中，我们将讨论有关镜像的命令。

###Create an Image
创建镜像

镜像可以通过以下两种方式来创建：

- 从registry拉取
- 导入镜像

```POST /images/create
```

截图示例：
![](http://cdn2.hubspot.net/hub/411552/file-1222274949-jpg/blog-files/create-an-image.jpg?t=1419919381183)

###Create an Image from a Container
从容器创建镜像：
```POST /commit
```
截图示例：
![](http://cdn2.hubspot.net/hub/411552/file-1222274964-png/blog-files/docker-create-image-from-container.png?t=1419919381183)

###List of Images
获取镜像清单：
```GET /images/json
```

截图示例：
![](http://cdn2.hubspot.net/hub/411552/file-1222274979-png/blog-files/docker-list-images.png?t=1419919381183)

###Insert a File
导入指定路径文件：
```POST /images/(name)/insert
```
截图示例：
![](http://cdn2.hubspot.net/hub/411552/file-1222274994-jpg/blog-files/docker-image-insert-file.jpg?t=1419919381183)

###Delete Image
删除镜像：
```DELETE /images/(name)
```
截图示例：
![]()http://cdn2.hubspot.net/hub/411552/file-1222275009-jpg/blog-files/delete-an-image.jpg?t=1419919381183


###Registry Push
推送镜像到Registry：
```POST /images/(name)/push
```
截图示例：
![](http://cdn2.hubspot.net/hub/411552/file-1222275024-png/blog-files/docker-push-image-to-remote-repo.png?t=1419919381183)

###Tag Image
标记镜像：
```POST /images/(name)/tag
```
截图示例：
![](http://cdn2.hubspot.net/hub/411552/file-1222275039-jpg/blog-files/tag-an-image.jpg?t=1419919381183)

###Search an Image
搜索镜像：
```GET /images/search
```
截图示例：
![](http://cdn2.hubspot.net/hub/411552/file-1222275054-png/blog-files/docker-search-an-image.png?t=1419919381183)


###History
查看镜像历史：
```GET /images/(name)/history
```
截图示例：
![](http://cdn2.hubspot.net/hub/411552/file-1222275069-jpg/blog-files/docker-get-image-history.jpg?t=1419919381183)

###Build an Image
构建镜像：
```POST /build
```
截图示例：
![](http://cdn2.hubspot.net/hub/411552/file-1222275084-png/blog-files/docker-build-image-from-dockerfile.png?t=1419919381183)


现在我们已经结束了三站Docker API的旅程。敬请期待接下来的[Docker教程系列](http://dockerone.com/topic/Docker%20Tutorial)。
