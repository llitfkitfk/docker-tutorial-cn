FROM ubuntu:14.04
MAINTAINER Nate Slater <slatern@amazon.com>
RUN apt-get update && apt-get install -y curl wget default-jre git
RUN adduser --home /home/sinatra --disabled-password --gecos '' sinatra
RUN adduser sinatra sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER sinatra
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "source /home/sinatra/.rvm/scripts/rvm"
RUN /bin/bash -l -c "rvm install 2.1.2"
RUN /bin/bash -l -c "gem install sinatra"
RUN /bin/bash -l -c "gem install thin"
RUN /bin/bash -l -c "gem install aws-sdk"
RUN wget -O /home/sinatra/dynamodb_local.tar.gz https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_2013-12-12.tar.gz
RUN tar -C /home/sinatra -xvzf /home/sinatra/dynamodb_local.tar.gz