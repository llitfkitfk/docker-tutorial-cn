## 常用Dockerfile都会从一个已有的docker镜像里添加例如:

{{{FROM ubuntu
RUN apt-get install -y xxx
ADD xxx
CMD ["xxx"]
}}}

## 这篇文章介绍 只输出helloworld的Docker容器如何创建

## 一个最简单的hello world 的例子 

### 需求(WHAT):

- Docker
- Golang

### 开始(HOW):

hello.go文件:

```
package main

import "fmt"

func main() {
	fmt.Printf("Hello, world.\n")
}
```

Dockerfile文件:

```
FROM scratch
ADD hello /
CMD ["/hello"]
```


生成可执行hello命令:

```
go build /pathToHello/hello.go
```

将hello可执行文件移动到Dockerfile所在目录下,并打开此目录:

```
cp /pathToHello/hello /pathToDocker/
cd /pathToDocker/
```

构建最最最简单helloworld镜像:

```
docker build -t yourname/simplesthello .
```

运行最最最简单helloworld容器:
```docker run yourname/simplesthello
```

<完>

### 原理(WHY):
1. scratch: 可以理解为docker镜像的root, 相对scratch来说每一个docker镜像相当于leaf
2. 静态编译: 使用Golang的原因, 如果用c的hellowrld的例子需要实现配置静态编译
3. -
