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
* -m

	```
		//内存管理
		sudo docker run -d -m 100m ubuntu /bin/bash
	```

* -p

	```
	
	```
* -P
* -t
* -u
* -v
* -w