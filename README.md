# trs-dev
Set up a docker-based development environment for TRS

This repo provides a baseline to quickly and consistantly set up a TRS development environment in an Ubuntu-based Docker container.

# Setup Instructions

* Assure Docker is installed on your local development machine. If not, install it. 
```Script
/home/dev$: docker --version;
Docker version 20.10.19, build d85ef84;
```

* Clone this repo to a local directory </home/dev/trs-dev used as example directory in these instrustions>
  * Set up git config
```
/home/dev/trs-dev$ git config --list
/home/dev/trs-dev$ git config --global user.name "Dev Name"
/home/dev/trs-dev$ git config --global user.email "dev.name@mail.com"
/home/dev/trs-dev$ git config --list
user.name=Don Harbin
user.email=don.harbin@linaro.org
```
* Build docker image 
```
**/home/dev/trs-dev$** docker build -t test-image .
```
* Run a new Docker container to ssh into container (both root and dev in example)
```
/home/dev/trs-dev$ docker run -dit --name test-container -p 8888:22 testimage
eead8270d872f3b4c6cc1a2981e0345e9dfaf379d4bac3fce9393998a15944bb
/home/dev/trs-dev$ docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' test-container
t-container
172.17.0.2
/home/dev/trs-dev$ ssh root@172.17.0.2
root@eead8270d872:~# exit
logout
Connection to 172.17.0.2 closed.

/home/dev/trs-dev$ ssh dev@172.17.0.2
$ exit
logout
Connection to 172.17.0.2 closed.
```
* Enter a running container thru a /bin/bash shell for user dev
This is the preferred method for container entry and development

```
/home/dev/trs-dev$ docker exec -it --user dev test-container /bin/bash
dev@eead8270d872:/$ exit
exit
/home/dev/trs-dev$ 
```
To stop, start and remove the container, use the following commands
```
/home/dev/trs-dev$ docker stop test-container
/home/dev/trs-dev$ docker 
/home/dev/trs-dev$ docker docker start test-container
/home/dev/trs-dev$ docker 
/home/dev/trs-dev$ docker rm test-container
test-container
/home/dev/trs-dev$ docker run -dit --name test-container -p 8888:22 testimage
b7e14cb4c5118d7b3086b0b9cae2c63052823e890d0e7156aed85cc094682d75
/home/dev/trs-dev$ docker exec -it --user dev test-container /bin/bash
dev@b7e14cb4c511:/$
```

# Build TRS 



