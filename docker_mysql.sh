#!/bin/bash

docker run -p 33306:3306 --name django-mysql -e MYSQL_ROOT_PASSWORD=gxt900101 -d mysql

