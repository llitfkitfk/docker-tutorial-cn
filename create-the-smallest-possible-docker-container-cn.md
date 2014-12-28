当你学习Docker的时候，你很快注意到当你使用预先配置好的容器，你需要下载很多镜像包。
一个基本的Ubuntu的容器轻轻松松超过200MB，并在有软件安装时它的尺寸会增大。
在一些情况下，你并不需要Ubuntu容器内的所有的依赖。例如，如果你想运行简单的Go语言编写的Web服务器，它并不需要任何其他工具。

我一直在寻找尽可能小的容器入手，并且发现了这个：
```docker pull scratch
```


scratch镜像非常完美：
1. 它优雅,小巧而且快速。
2. 它不包含任何bug，安全漏洞，延缓的代码或技术债务。

这是因为它基本上是空的。除了有点儿被Docker添加的metadata (译注:元数据为描述数据的数据)。事实上，你可以创建这个scratch镜像用以下命令([官方文档上有描述](https://docs.docker.com/articles/baseimages/#creating-a-simple-base-image-using-scratch))：
```tar cv --files-from /dev/null | docker import - scratch
 ```

这是它，尽可能小的Docker镜像。到此结束!

...或许我们还可以来探讨更多的东西。例如，如何使用scratch镜像呢？这又带来了一些挑战。


###为scratch镜像创建内容
我们可以在一个空的scratch镜像里运行什么？无依赖的可执行文件。你有没有不需要依赖的可执行文件吗？

我曾经用Python，Java和JavaScript编写过代码。这些语言/平台需要安装运行环境。最近，我开始研究Go(如果你喜欢话用GoLang)语言平台。看起来Go是静态链接的。所以我尝试编写一个简单的 ‘hello world’ Web服务器，并在scratch容器中运行它。下面是Hello World Web服务器的代码：

```
package main
import (
	"fmt"
	"net/http"
)
func helloHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Hello World from Go in minimal Docker container")
}
func main() {
	http.HandleFunc("/", helloHandler)
	fmt.Println("Started, serving at 8080")
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		panic("ListenAndServe: " + err.Error())
	}
}
```

很显然，我不能编译我的web服务器在scratch容器内，因为此容器内没Go编译器。并且，因为我的工作是在Mac上，我也不能编译的Linux二进制。 (其实，交叉编译GoLang源到不同的平台是可能的，但是这是另一篇文章的资料)

因此，首先我需要一个Docker容器使用Go的编译器。先从简单的开始：
```docker run -ti google/golang /bin/bash
```

在这个容器内，我可以构建Go Web服务器，这是我提交的[GitHub仓库](https://github.com/adriaandejonge/helloworld)：
```go get github.com/adriaandejonge/helloworld
```
 
```go get```命令是```go build ```命令的变体，允许其获取并构建远程依赖。

你就可以运行生成的可执行文件：
```$GOPATH/bin/helloworld
```
 
这会起作用。但它不是我们想要的。

我们需要的hello world Web服务器运行在scratch容器内。所以，实际上，我们需要编写Dockerfile：
```FROM scratch
ADD bin/helloworld /helloworld
CMD ["/helloworld"]
```

然后启动。不幸的是，我们使用google/golang容器的方式是没有办法建立这个Dockerfile的。因此首先，我们需要一种方法来从容器内访问Docker。

###从容器内调用Docker
当您使用Docker，你迟早会遇到需要从Docker内部控制Docker。有许多方法可以做到这一点。你可以使用递归和[Docker内运行Docker](https://github.com/jpetazzo/dind)。然而，这似乎过于复杂，并再次导致容量大的容器。
您还可以用一些额外的命令参数来提供访问外部Docker给实例：
```docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):$(which docker) -ti google/golang /bin/bash
```

在讲到下一步之前，请重新运行Go编译器，因为重新启动一个容器Docker会忘记之前的编译内容：
```go get github.com/adriaandejonge/helloworld
```
 
当启动容器时，
```-v``` 标志创建一个卷在Docker容器内，并允许您提供从Docker机上的文件作为输入。
```/var/run/docker.sock```是Unix套接字，允许访问Docker服务器。
```$(which docker)```是一种提供Docker可执行文件的路径给容器的方法。但是，使用该命令要当心当您使用boot2docker在Apple上时：如果Docker可执行文件被安装在不同的路径上相对于安装在boot2docker的虚拟机，这将会导致不匹配错误：它将是boot2docker虚拟服务器内的可执行文件被导入容器内。所以，你可能要替换```$(which docker)```为```/usr/local/bin/docker ```。同样，如果你运行在不同的系统，``` /var/run/docker.sock ```有一个不同的位置，你需要相应地调整。

现在，你可以在 google/golang容器内使用在$GOPATH路径下的Dockerfile，例子中，它指向/gopath 。
其实，我已经提交Dockerfile到GitHub上。因此，你可以从复制它在Go build目录里，命令如下：
```cp $GOPATH/src/github.com/adriaandejonge/helloworld/Dockerfile $GOPATH
``` 

编译好的二进制文件位于$GOPATH/bin 目录下，当构建Dockerfile时它不可能从父目录中include文件。所以在复制后，下一步是：
```docker build -t adejonge/helloworld $GOPATH
```
 
如果一切顺利，那么，Docker会有类似输出：
> Successfully built 6ff3fd5a381d

然后您可以运行容器：
```docker run -ti --name hellobroken adejonge/helloworld
```
 

但不幸的是，Docker会输出类似于：
> 2014/07/02 17:06:48 no such file or directory

那么到底是怎么回事？我们的scratch容器内已经有静态链接的可执行文件。难道我们犯了一个错误？

事实证明，Go不是静态链接库的。或者至少不是所有的库。在Linux下，我们可以看到动态链接库用以下命令：
```ldd $GOPATH/bin/helloworld
```

其中输入类似以下内容：
>linux-vdso.so.1 => (0x00007fff039fe000)
libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f61df30f000)
libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f61def84000)
/lib64/ld-linux-x86-64.so.2 (0x00007f61df530000)
 
所以，在我们才可以运行的Hello World Web服务器之前，我们需要告诉Go编译器真正的做静态链接。


###Go语言创建静态链接的可执行文件
为了创建静态链接的可执行文件，我们需要使用cgo编译器，而不是Go编译器。命令如下：
```CGO_ENABLED=0 go get -a -ldflags '-s' github.com/adriaandejonge/helloworld
```
 
```CGO_ENABLED``` 环境变量表示使用cgo编译器，而不是Go编译器。
```-a```标志表示要重建所有的依赖。否则，还是以动态链接依赖为结果。
```-ldflags``` ```-s```表示一个不错的额外标志。它缩减生成的可执行文件约50％的大小。没有cgo编译器你也可以这样做。尺寸减小是除去了调试信息的结果。

只是确保一下，重新运行ldd命令：
```ldd $GOPATH/bin/helloworld 
 ```

现在应该有类似输出：
> not a dynamic executable

然后重新运行用scratch镜像构建Docker容器那一步：
```docker build -t adejonge/helloworld $GOPATH
```
 
如果一切顺利，Docker会有类似输出：
> Successfully built 6ff3fd5a381d

接着运行容器：
```docker run -ti --name helloworld adejonge/helloworld
```

而这个时候会输出：
> Started, serving at 8080


目前为止，有许多步骤，会有很多错误的余地。让我们退出google/golang 容器：
```<Press Ctrl-C>
exit
```

您可以检查容器和镜像的存在或不存在：
```docker ps -a
docker images -a
```

并且您可以清理Docker：
```docker rm -f hello world
docker rmi -f adejonge/helloworld
```

###创建Docker容器的Docker容器

我们花了这么多的步骤：记录在Dockerfile里，并运行成功：
```FROM google/golang
RUN CGO_ENABLED=0 go get -a -ldflags '-s' github.com/adriaandejonge/helloworld
RUN cp /gopath/src/github.com/adriaandejonge/helloworld/Dockerfile /gopath
CMD docker build -t adejonge/helloworld gopath
 ```

我提交了这个Dockerfile到另一个[GitHub库](https://github.com/adriaandejonge/hellobuild)。它可以用这个命令构建：
```docker build -t adejonge/hellobuild github.com/adriaandejonge/hellobuild
``` 

```-t```表示镜像的标签名为adejonge/hellobuild和隐式标签名为latest。这些名称为以后删除镜像变得容易。

接下来，你可以创建容器用刚才提供的标签：
```docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):$(which docker) -ti --name hellobuild adejonge/hellobuild
 ```

提供所述```--name hellobuild``` 标志可以更容易在运行之后删除容器。事实上，你现在就可以这样做，因为在运行此命令后，你已经创建了adejonge/helloworld的镜像：
```docker rm -f hellobuild
docker rmi -f adejonge/hellobuild 
```

现在你可以运行新的helloworld容器：
```docker run -ti --name helloworld adejonge/helloworld
```

因为所有这些步骤都出自同一命令行运行，而无需在Docker容器内打开bash shell，你可以将这些步骤添加一个bash脚本，并自动运行。
为了您的方便，我已经提交了这些的bash脚本到[GitHub库](https://github.com/adriaandejonge/hellobuild/tree/master/scripts)。

另外，如果你想尝试在尽可能小的Docker容器里运行Hello World Web服务器，而不遵循这个博客中描述的步骤，你也可以用我提交到[Docker Hub库的镜像](https://registry.hub.docker.com/u/adejonge/helloworld/)：
```docker pull adejonge/helloworld
```

```docker images -a```你可以看到大小为3.6MB。当然，你可以把它缩减的更小，如果你创建一个可执行比我编写的Go Web服务器要小。用C语言或汇编你可以这样做。但是，你永远不能使它比scratch镜像更小。