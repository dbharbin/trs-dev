#!/bin/bash

# Run this script from the Docker container to set up git config and install TRS packages. 
#
# Two Parameters required, first is email, second is Username(in quotes if includes space(s))
# example: ./trs-install don.harbin@linaro.org "Don Harbin"

echo "email address: " "$1"
echo "User name: " "$2"
echo "git config --list"
git config --list

git config --global user.email "$1"
git config --global user.name "$2"
git config --list
sudo repo init -u https://gitlab.com/Linaro/trusted-reference-stack/trs-manifest.git
sudo repo sync -j3

echo "#################"
echo "# BUILD PRE-REQS"
echo "#################"
make apt-prereqs
make python-prereqs

source /home/dev/trs-workspace/.pyvenv/bin/activate
