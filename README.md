# Linaro TRS Initial Installation Jump Start
So you've made the decision to start some development leveraging Linaro's TRS! 
This repo has been developed to aid developers to quickly set up an initial TRS development environment.
Leveraging this repo, with just a few steps you can have a trs-development environment running in a docker container. The benefits of using a container for your development environment include quickly reproducing your environment in the event of distaster recovery or development environment corruption, speed of setup, all devs in a similar environment, can be customized/extended to meet your needs, usable across different host platforms, and more.

# Installation Instructions

### Assure Docker is installed on your local development machine. If not, install it. (Host)
```
~/dev$: docker --version;
Docker version 20.10.19, build d85ef84;
```
### Set up dev directory and clone the repo (Host)
```
cd dev/trs-dec1/         # dev/trs-dec1 is the development directory. Name as you wish
git clone https://github.com/dbharbin/trs-dev.git
cd trs-dev/
```
### Build the docker image named “trs” (Host)
IMPORTANT: You must modify the USER_UID and USER_GID fields in the Dockerfile to align with the host UID and GID!
To find these values, from the Linux Host command line, perform the following:
```
~/dev/dec6/trs-dev$ id -u
11193
~/dev/dec6/trs-dev$ id -g
10000
~/dev/dec6/trs-dev$
```
Then edit your Dockerfile and update these fields.
After that, you are ready to build the docker image.
```
docker build -t trs .
```

Assuming you had no other images, you should see soemthing similar to the following after completion of the docker build:
```
~/dev/trs-dec1/trs-dev$ docker images
REPOSITORY   TAG       IMAGE ID         CREATED            SIZE
trs          latest    2a10a95eacd2   10 seconds ago   336MB
ubuntu       22.04     a8780b506fa4   4 weeks ago      77.8MB
```
### Download TRS source to share location on host machine; a one time step on initial install only (Host)
```
mkdir $HOME/trs_reference_repo 
cd $HOME/trs_reference_repo    # $HOME/trs-reference-repo is the container side default defined in the run-trs.sh
repo init -u https://gitlab.com/Linaro/trusted-reference-stack/trs-manifest.git -m default-latest.xml
repo sync 
```

### Create and enter a new trs docker container (Host)
```
cd $HOME/dev/trs-dec1/trs-dev                                # Navigate back to the trs-dev source repo location
./run-trs.sh
```

### Make trs from container (Container $)
Always nice to confirm connectivity.  Debug if can't successfully ping
```
dev@e6bc4a67b029:~/trs-workspace$ ping google.com
PING google.com (142.250.72.142) 56(84) bytes of data.
64 bytes from lax17s49-in-f14.1e100.net (142.250.72.142): icmp_seq=1 ttl=117 time=22.6 ms
64 bytes from lax17s49-in-f14.1e100.net (142.250.72.142): icmp_seq=2 ttl=117 time=24.4 ms
64 bytes from lax17s49-in-f14.1e100.net (142.250.72.142): icmp_seq=3 ttl=117 time=19.7 ms
^C
```
Now ready to do your build!
```
$ cd $HOME/trs-workspace
$ ./trs-install.sh -h -r          
```
The above installs trs source and all it's dependencies in the container then makes the source.
* The -h means use the host yocto cache, leaving off will use local container
* The -r means to reference a trs repo on the host (default location on host == `$HOME/trs_reference_repo`)
* Note the first time build can take many hours.
* During a build, it's not uncommon to have warnings scroll by. Thes are typically of no consequence during initial development.
```
WARNING: mc:rpi4:rpi4-firmware-1.0-r0 do_unpack: QA Issue: rpi4-firmware: SRC_URI uses unstable GitHub/GitLab archives, convert recipe to use git protocol [src-uri-bad]

WARNING: mc:trs-qemuarm64:clevis-git-r2 do_patch: URL: git://github.com/latchset/clevis.git;protocol=git;branch=master uses git protocol which is no longer supported by github. Please change to ;protocol=https in the url.

WARNING: mc:trs-qemuarm64:clevis-git-r2 do_patch: URL: git://github.com/latchset/clevis.git;protocol=git;branch=master uses git protocol which is no longer supported by github. Please change to ;protocol=https in the url.
```

# Additional getting started tips

## Updating your trs shared repo
Once you've begun development, you'll want to be intentional about keeping the dependency trs repo in a known state. Determining how you want to keep this in sync is case by case.  This section shows a couple of example commands in keeping in sync with the upstream

**Sync your shared trs repo with the upstream tip**

In this case, perform the following commands (Host)
```
$ cd $HOME/trs_reference_repo    # $HOME/trs-reference-repo is used as default in the run-trs.sh from container
$ repo init -u https://gitlab.com/Linaro/trusted-reference-stack/trs-manifest.git -m default.xml
$ repo sync
```

**Sync with a stable release**

In this example, if version 0.1 for example, was released, to sync with that version perform the following commands:
```
$ cd $HOME/trs_reference_repo    # $HOME/trs-reference-repo is used as default in the run-trs.sh from container
$ repo init -u https://gitlab.com/Linaro/trusted-reference-stack/trs-manifest.git -m default.xml -b v0.1
$ repo sync
```

## Decreasing build times 
Yocto can take a long time to build.  This section describes a couple of things set up in this installation to decrease that timeAfter the install, you'll notice that a dirctory has been created `$HOME/yocto_cache`. It includes two subdirectories, /yocto_cache/downloads and /yocto_cache/sstate-cache, that have been place in your host OS and shared with the container.  These are here to reduce build times first and formost.  Alternatively if you must use a different container on the same host, if built by the scripts in this repo as shared above, you will not need to set this up on the new install and thus skipping the "first build' use case that can often be many hours long. If interested in just a bit more detail, a nice writeup can be seen [here](https://tutorialadda.com/yocto/how-to-speed-up-the-yocto-build-process)

Assuring that you've minimized overhead on you system such as freeing up as much RAM as possible through closing browser tabs, turnning off VPN's, etc. can also reduce builds times.

## Other Platform Instructions
TBD

## References:
* [TRS Docs](https://trs.readthedocs.io/en/latest/install/install.html#install-repo)
* [Learn more about Linaro Membership](https://www.linaro.org/membership/)
* [Sign up for Linaro's Monthly Newsletter](https://linaro.us3.list-manage.com/subscribe/post?u=14baaae786342d0d405ee59c2&id=bcfa4abc8f)

