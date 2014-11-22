### go 并发

* [Go 并发 ppt](http://concur.rspace.googlecode.com/hg/talk/concur.html)

##Linux container

###High level

* normal processes, but isolated
* share kernel with the host
* no device emulation
* doesn't need a /sbin/init(runs the app/DB/ whatever directly)

###Low level
* own process space
* own network interface
* can run stuff as root
* can have its own /sbin/init


## WHY

### static compilation

* **go build** will embed everything you need
* except dynamic libraries if you use cog
* and except libc
* you can have a real static binary
* easier to install, easier to test, easier to adopt
* good candidate for bootstrap

### neutral

### it has what we need

* good asynchronous promitives
* low-level interfaces
* extensive standard library and data types
* strong duck typing

### full development environment

  * go doc 
  * go get
  * go fmt
  * go test
  * go run

  ### multi-arch build
  * without pre-processors
  



