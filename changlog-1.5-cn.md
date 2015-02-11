##Docker 1.5.0 更新日志 (2015-02-10)

###构建
* Dockerfile 可以在`docker build`时，用`-f`标志指定
* Dockerfile与`.dockerignore`文件作为`.dockerignore`文件的一部分可以自行忽略，当这些文件的修改后，会防止`ADD`或`COPY`指令缓存的作废
* `ADD`和`COPY`指令接受相对路径
* Dockerfile `FROM scratch`指令解释为一个没有基础的说明
* 改善了性能当公开大量的端口时

###尝试
* 允许客户端只为Windows集成测试
* 对于作为我们的测试套件的一部分的Docker daemon还包括了docker-py集成测试

###包装
* 对registry的HTTP API新版本的支持 
* 为镜像以及大多数现有的层文件加快了`docker push`
* 修正了通过代理联系私有registry

###远程API
* 一个新的endpoint将动态显示容器资源用量，可用`docker stats`命令访问
* 可以使用`rename` endpoint来重命名容器，相关命令为：`docker rename`
* 容器`inspect`endpoint显示在运行的容器中执行`exec`命令的ID
* 容器`inspect`endpoint显示Docker自动重启容器的次数
* 新的event类型将由`events`endpoint：`OOM`（容器内存溢出而停止）、`exec_create`与`exec_start`展现。
* 修正了返回的有数字字符的字段串不正确忽略了其双引号

###运行时
* Docker daemon完全支持IPv6
* `docker run`命令可以采取`--pid=host`标志使用主机的PID命名空间，这样可以使得例如使用容器调试工具来调试主机进程成为可能。
* `docker run`命令可以采取`--read-only`标志使容器的根文件系统为只读，这样就可以与`volumes`结合使用以便容器的进程只能写入作为持久数据的文件。
* 通过`docker run`使用`-memory-swap`标志可以限制容器总内存使用量
* 主要改进了devicemapper存储驱动程序的稳定性
* 与主机系统更好地集成：重新启动时，容器的变化会反映到主机的`/etc/resolv.conf`文件
* 与主机系统更好地集成：每个容器的iptable规则被移动到Docker链中
* 修正了容器由于内存溢出而返回一个无效的退出代码

###其他
* 当连接到Docker daemon时，客户端会适当地考虑HTTP_PROXY、HTTPS_PROXY以及NO_PROXY环境变量。