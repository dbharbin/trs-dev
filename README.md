# trs-dev
Set up a docker-based development environment for TRS

This repo provides a baseline to quickly and consistantly set up a TRS development environment in an Ubuntu-based Docker container.

# Setup Instructions

* Assure Docker is installed on your local development machine. If not, install it. 
```
~/dev$: docker --version;
Docker version 20.10.19, build d85ef84;
```

* Clone this repo to a local directory </home/dev/trs-dev used as example directory in these instrustions>
  * Set up git config
```
~/dev/trs-dev$ git config --list
~/dev/trs-dev$ git config --global user.name "Dev Name"
~/dev/trs-dev$ git config --global user.email "dev.name@mail.com"
~/dev/trs-dev$ git config --list
user.name=Don Harbin
user.email=don.harbin@linaro.org
~/dev/trs-dev$ git clone https://github.com/dbharbin/trs-dev.git
```
* Build docker image 
```
~/dev/trs-dev$ docker build -t test-image .
```
* Run a new Docker container to ssh into container (both root and dev in example)
```
~/dev/trs-dev$ docker run -dit --name test-container -p 8080:22 test-image
eead8270d872f3b4c6cc1a2981e0345e9dfaf379d4bac3fce9393998a15944bb
~/dev/trs-dev$ docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' test-container
test-container
172.17.0.2
~/dev/trs-dev$ ssh root@172.17.0.2

root@eead8270d872:~# exit                 // Container login prompt
logout
Connection to 172.17.0.2 closed.

~/dev/trs-dev$ ssh dev@172.17.0.2
$ exit
logout
Connection to 172.17.0.2 closed.

~/dev/trs-dev$
```

* Enter a running container thru a /bin/bash shell for user dev
This is the preferred method for container entry and development
```
~/dev/trs-dev$ docker exec -it --user dev -w /home/dev/trs-workspace test-container /bin/bash
dev@eead8270d872:/$ exit                  // Container login prompt
exit
~/dev/trs-dev$                            // back to host   
```
To stop, start and remove the container, use the following commands
```
~/dev/trs-dev$ docker stop test-container
~/dev/trs-dev$ docker 
~/dev/trs-dev$ docker docker start test-container
~/dev/trs-dev$ docker 
~/dev/trs-dev$ docker rm test-container
test-container
~/dev/trs-dev$ docker run -dit --name test-container -p 8888:22 test-image
b7e14cb4c5118d7b3086b0b9cae2c63052823e890d0e7156aed85cc094682d75
/home/dev/trs-dev$ docker exec -it --user dev test-container /bin/bash
dev@b7e14cb4c511:/$
```

# Install and Build TRS in the Docker Container 

Copy the TRS install script into the working directory created by the Dockerfile and run it
```
~/dev/trs-dev$ docker cp trs-install test-container:/home/dev/trs-workspace
~/dev/trs-dev$ docker exec -it --user dev -w /home/dev/trs-workspace test-container /bin/bash
dev@aea3bf0028af:~/trs-workspace$ ls       // working directory prompt in the container
trs-install 
dev@aea3bf0028af:~/trs-workspace$./trs-install <email@mail.com> "<name>"

repo sync has finished successfully.
dev@d43711fed37f:~/trs-workspace$ 
```

## Install Toolchain


## Build TRS


