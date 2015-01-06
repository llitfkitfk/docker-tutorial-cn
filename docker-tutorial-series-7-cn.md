##Docker教程系列 7 Docker APIs

纵观我们的Docker教程系列，我们已经讨论了很多显著[Docker组件](http://dockerone.com/article/101)与[命令](http://dockerone.com/article/102)。在今天的系列文章中，我们深入挖掘Docker，发掘Docker APIs。

首先值得注意的是Docker提供以下的APIs，使得它更容易使用。这些API包含四个方面：

- Docker Registry API
- Docker Hub API
- Docker OAuth API
- Docker Remote API

具体到这篇文章，我们将讨论Docker Registry API以及Docker Hub API。

###Docker Registry API

Docker Registry API是[Docker Registry](http://dockerone.com/article/104)的REST API，它简化了镜像和库的存储。该API不能访问用户帐户或它的授权。阅读[Docker教程系列的第四章](http://dockerone.com/article/104)，以了解更多有关registry的类型。

####Extract image layer:
取出镜像层：
```GET /v1/images/(image_id)/layer
```

![](http://cdn2.hubspot.net/hub/411552/file-1222268384-jpg/blog-files/get-image-layer.jpg?t=1419891691508)

####Insert image layer:
插入镜像层：
```PUT /v1/images/(image_id)/layer
```

####Retrieve an image:
检索镜像:
```GET /v1/images/(image_id)/json
```

####Retrieve roots of an image:
检索根镜像：
```GET /v1/images/(image_id)/ancestry
```

####Obtain all tags or specific tag of a repository:
获取库里所有的标签或者指定标签：
```GET /v1/repositories/(namespace)/(repository)/tags
```

![](http://cdn2.hubspot.net/hub/411552/file-1222268414-png/blog-files/docker-get-all-tags.png?t=1419891691508)

或者
```GET /v1/repositories/(namespace)/(repository)/tags/(tag*)
```
![](http://cdn2.hubspot.net/hub/411552/file-1222268414-png/blog-files/docker-get-all-tags.png?t=1419891691508)


####Delete a tag:
删除标签：
```DELETE /v1/repositories/(namespace)/(repository)/tags/(tag*)
```
![](http://cdn2.hubspot.net/hub/411552/file-1222268444-jpg/blog-files/delete-a-tag.jpg?t=1419891691508)

####Status check of registry:
registry状态检查：
```GET /v1/_ping
```

![](http://cdn2.hubspot.net/hub/411552/file-1222268459-png/blog-files/registry-ping.png?t=1419891691508)

###Docker Hub API
Docker Hub API是Docker Hub的一个简单的REST API。重申一次，请参考[Docker教程系列的第四章](http://dockerone.com/article/104)了解Docker Hub。Docker Hub 控制用户帐户，通过管理校验认证以及公共命名空间。这个API还允许有关用户和library库的操作。

首先，让我们来探讨特特殊的library库（需要管理员权限）的命令：

####Library repository

1. Create a new repository - 使用以下命令可以创建新的library库：
```PUT /v1/repositories/(repo_name)/
```

其中，```repo_name```是新的库名字

2. Delete existing repository - 删除已存在的库：
```DELETE /v1/repositories/(repo_name)/
```

其中，```repo_name```是将要删除的库的名字

3. Update repository images - 更新库里的镜像：
```PUT /v1/repositories/(repo_name)/images
```

4. Get images from a repository - 从库里面下载镜像：
```GET /v1/repositories/(repo_name)/images
```

5. Authorization - 使用token可以创建被授权的库
```PUT /v1/repositories/(repo_name)/auth
```

现在，让我们列出用户库的命令。library库与用户库命令之间的主要区别是命名空间的使用。

####User repository
1. Create a new user repository - 创建用户库的命令：
```PUT /v1/repositories/(namespace)/(repo_name)/
```
![](http://cdn2.hubspot.net/hub/411552/file-1222268474-png/blog-files/create-user.png?t=1419891691508)

2. Delete existing repository - 删除用户库：
```DELETE /v1/repositories/(namespace)/(repo_name)/
```
![](http://cdn2.hubspot.net/hub/411552/file-1222268489-png/blog-files/docker-delete-a-repo.png?t=1419891691508)

3. Update images - 更新用户库镜像
```PUT /v1/repositories/(namespace)/(repo_name)/images
```
![](http://cdn2.hubspot.net/hub/411552/file-1222268504-png/blog-files/docker-update-image.png?t=1419891691508)

4. Get images from a repository - 从库中下载镜像
```GET /v1/repositories/(namespace)/(repo_name)/images
```
![](http://cdn2.hubspot.net/hub/411552/file-1222273569-png/blog-files/docker-get-user-images.png?t=1419891691508)

5. Verify a user login - 验证用户登录：
```GET /v1/users
```
![](http://cdn2.hubspot.net/hub/411552/file-1222273584-png/blog-files/docker-user-login.png?t=1419891691508)

6. Create a new user - 添加新用户：
```POST /v1/users
```

7. Update user details - 更新用户信息：
```PUT /v1/users/(username)/
```

现在，我们已经给您介绍了有关Docker APIs终极之旅的第一站，第二站将是有关Docker OAuth以及Remote APIs，我们在[Docker教程系列的下一章]()见。



