使用
====
```
	docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
```

OPTIONS
-------

* -a

	```
		// 附加container的 STDIN, STDOUT or STDERR 来操控输入或输出
		echo "test" | sudo docker run -i -a stdin ubuntu cat
	```
	```
		// 如果有error信息 将会输出error信息
		sudo docker run -a stderr ubuntu echo test
	```
	
	```
		// 如果查看log信息 可以输出信息
		sudo docker run -a stdout ubuntu echo test
		sudo docker logs [containerId]
	```
* -c

	```
		//CPU分配
	```

* -d

	```
		//后台运行container并输出container的id
		sudo docker run -d ubuntu /bin/bash
	```
* -e, --env

	```
		//设置环境变量
		$ sudo docker run --env TEST_FOO="This is a test" busybox env | grep TEST_FOO
		TEST_FOO=This is a test
	```
* -h
	
	```
		//设置host name
		sudo docker run -d －h www.example.com ubuntu /bin/bash
	```
* -i

	```
		//保持输入打开
		sudo docker run -i ubuntu /bin/bash
	```
* -t

	```
		//分配一个假的输入终端
		sudo docker run -i －t ubuntu /bin/bash
	```
* -m

	```
		//内存管理
		sudo docker run -d -m 100m ubuntu /bin/bash
	```

* -p

	```
		//映射container端口到host主机 格式:(-p ip:hostPort:containerPort)
		sudo docker run -d －p 0.0.0.0:8080:80 ubuntu /bin/bash
	```
* -P

	```
		//映射container所有暴露的端口到host主机
		sudo docker run -d －P ubuntu /bin/bash
	```

* -u

	```
		//设置username
		sudo docker run -d －u testusername ubuntu /bin/bash
	```
* -v

	```
		//挂载数据卷 格式:(-v /host:/container)
		sudo docker run -d －v /tmp/hostvolume:/tmp/ ubuntu /bin/bash
	```
* -w

	```
		//设置container内部的工作路径
		sudo docker  run -w /path/to/dir/ -i -t  ubuntu /bin/bash
	```