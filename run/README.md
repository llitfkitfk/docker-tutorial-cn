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
		
	
	```

* -d
* -e
* -h
* -i
* -m
* -p
* -P
* -t
* -u
* -v
* -w