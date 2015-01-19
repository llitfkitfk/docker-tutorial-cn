【思考】为什么要用Fig来实现Docker自动化？

【编者的话】本文主要讲解了如何用Fig来解决Docker多参数启动容器的问题（Fig入门可以参照这里）以及使用Fig需要注意的一些事项。


如果您使用Docker已经有一阵子，但你还没有尝试过Fig，这篇文章是写给你的。你可能像我一样要么习惯于对付长而笨重的使用多个参数的Docker命令，要么会拿出一堆shell脚本来启动你的容器。从其核心出发，Fig只是一个简单的自动化和抽象化来用于帮助处理这些东西。

下边将通过一个例子简单地解释一下。我们将创建一个简单的Python Flask应用程序，此应用每次被请求之后都会显示一个时间戳。 Python代码不用很在意可以随意跳过它，但如果你想跟着步骤来，那么首先在新目录中创建具有下列内容的文件```app.py```：
{{{from flask import Flask
from redis import StrictRedis
from datetime import datetime


app = Flask(__name__)
redis = StrictRedis(host='redis', port=6379)


@app.route('/')
def home():
    redis.lpush('times', datetime.now().strftime('%H:%M:%S'))
    return 'This page was requested at: {}\n'.format(
        [t.decode('utf-8') for t in redis.lrange('times', 0, -1)])

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)    }}}

接着是Dockerfile的内容：
{{{FROM python:3.4

RUN mkdir /code
COPY app.py /code/app.py
WORKDIR /code
RUN pip install flask redis
CMD ['python', 'app.py']}}}

现在我们可以构建并运行此应用程序的容器：
{{{$ docker build -t fig_ex .
...snip...
$ docker run -d --name redis redis
68fece140431f4ad67fbd9fbaa43253785b4c3cb6ceeda1b1eb7de2eee22615c
$ docker run -d -p 5000:5000 --link redis:redis fig_ex
cb7588cd15ade0ec09e005ea64aaa8753befa2d47d9a8e331a711137fdc59bc8
$ curl localhost:5000
This page was requested at: ['13:18:39']
$ curl localhost:5000
This page was requested at: ['13:18:40', '13:18:39']
$ curl localhost:5000
This page was requested at: ['13:18:41', '13:18:40', '13:18:39']}}}

或者同样地我们可以用Fig来实现。在以上相同的目录下创建一个名为```fig.yml```的文件：
{{{figex:
  build: .
  ports:
    - '5000:5000';
  links:
    - redis

redis:
  image: redis  }}}

并且运行```fig up```：
{{{$ fig up
Creating figcode_redis_1...
Creating figcode_figex_1...
Attaching to figcode_redis_1, figcode_figex_1
redis_1 | [1] 06 Jan 10:27:12.745 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf

...snip...

redis_1 | [1] 06 Jan 10:27:12.749 * The server is now ready to accept connections on port 6379
figex_1 |  * Running on http://0.0.0.0:5000/
figex_1 |  * Restarting with reloader}}}

Fig会构建镜像（如有必要），以正确的顺序启动容器并连接到它们。容器会输出带有容器名称的前缀（默认情况下为目录名和镜像名称的串联）。我们可以在新的终端内测试这些容器：
{{{$ curl localhost:5000
This page was requested at: ['13:24:27']
$ curl localhost:5000
This page was requested at: ['13:24:28', '13:24:27']
$ curl localhost:5000
This page was requested at: ['13:24:29', '13:24:28', '13:24:27']}}}

棒极了，只需很少的记忆，它就起了同样的作用－3个带多个参数的Docker命令已减少到仅用两个词。本质上来说是我们将所有的烦人的配置标志移动到了```fig.yml```文件。

要停止容器只需按```ctrl-c```。您可以使用```fig rm```来完全地删除它们。大多数时候，你不想要容器输出，因此你就可以使用```fig up -d```在分离模式下启动Fig。然后，您需要用```fig stop ```来停止容器。

关于Fig的内容确实不多，多数命令一对一的映射其```docker run```命令。尽管如此有些事情你应该了解：

- 目前的YAML文件没有语法检查。这意味着，如果你犯了一个错误如忘记一个字符，你会得到一个令人困惑的错误。
- Fig有关Volumes的使用很混乱。当```fig up```执行时，它会尝试使用``` –volumes-from```挂载之前任何的Volumes。这将会导致一些问题，如果在fig.yml文件中Volumes的声明被改变，因为它往往会与之前的Volumes冲突 - 通常的解决方案是只要确保你总是使用```fig rm```删除之前的容器。此问题的部分原因是Docker本身需要更多的工具来处理Volumes。
- Fig主要地设计被用于开发，但我还发现在测试中它也很有用，而且它还可以在小规模部署上使用。

最后，值得指出的是，在Docker组件的作品中，Fig将会成为接班人。尽管Docker的组件未来可能会再利用现有Fig代码并且很可能有类似的语法和命令， 但我仍然建议现在使用Fig。此外，Fig的入门非常的快，你几乎可以立刻就把您投资的时间收回。

**原文链接：[Why Use Fig for Docker Automation?](http://container-solutions.com/2015/01/use-fig-docker-automation/) （翻译：[田浩](https://github.com/llitfkitfk)）**

