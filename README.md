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
```
docker build . -t trs
```

Assuming you had no other images, you should see soemthing similar to the following after completion of the docker build:
```
~/dev/trs-dec1/trs-dev$ docker images
REPOSITORY   TAG       IMAGE ID         CREATED            SIZE
trs                         latest    2a10a95eacd2   10 seconds ago   336MB
ubuntu          22.04     a8780b506fa4   4 weeks ago      77.8MB
```
### Premake directories and download source to host machine; a one time step on initial install only (Host)
```
mkdir $HOME/dev/trs-dec1/trs-repo 
cd $HOME/dev/trs-dec1/trs-repo    # Note dev/trs-dec1/trs-repo is used as -r in the run-trs.sh from container…
repo init -u https://gitlab.com/Linaro/trusted-reference-stack/trs-manifest.git -m default.xml
repo sync 
```

### Enter the trs docker container (Host)
```
cd ../trs-dev                                # Navigate back to the trs-dev source repo location
./run-trs.sh -r $HOME/dev/trs-dec1/trs-repo
```

### Make trs from container (Container $)
```
$ cd $HOME/trs-workspace
$ ./trs-install.sh -h -r          # This installs trs source and all it's dependencies in the container then makes the source.
                                  # The -h means use the host yocto cache, leaving off will use local container
                                  # The -r means to reference a trs repo on the host (default location on host == /tmp)
                                  # Note the first time build can take many hours.
```

# Additional getting started tips

## Updating your repos
Once you've begun development, you'll want to be intentional about keeping the dependency repos in sync with the upstream. Determining how you want to keep this in sync is case by case.  This section will show a couple of example commands in keeping in sync with the upstream
- `command here` - Command to update the TRS repo from within the container
- `command here` - Command to creates a CRON that runs every 2 weeks to update the TRS repo in the container


## Decreasing build times 
Yocto can take a long time to build.  This section describes a couple of things set up in this installation to decrease that timeAfter the install, you'll notice that a dirctory has been created `$HOME/yocto_cache`. It includes two subdirectories, /yocto_cache/downloads and /yocto_cache/sstate-cache, that have been place in your host OS and shared with the container.  These are here to reduce build times first and formost.  Alternatively if you must use a different container on the same host, if built by the scripts in this repo as shared above, you will not need to set this up on the new install and thus skipping the "first build' use case that can often be many hours long. If interested in just a bit more detail, a nice writeup can be seen [here](https://tutorialadda.com/yocto/how-to-speed-up-the-yocto-build-process)

Assuring that you've minimized overhead on you system such as freeing up as much RAM as possible through closing browser tabs, turnning off VPN's, etc. can also reduce builds times.

## Other Platform Instructions
TBD

## References:
* [TRS Docs](https://trs.readthedocs.io/en/latest/install/install.html#install-repo)
* [Learn more about Linaro Membership](https://www.linaro.org/membership/)
* [Sign up for Linaro's Monthly Newsletter](https://linaro.us3.list-manage.com/subscribe/post?u=14baaae786342d0d405ee59c2&id=bcfa4abc8f)

