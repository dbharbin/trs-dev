#!/usr/bin/env bash

IMAGE=trs
export GID=$(id -g)
export GID=$(id -u)
REPO_REFERENCE=/tmp

################################################################################
# Parse arguments
################################################################################
while getopts "i:r:" opt; do
	case $opt in
		i)
			IMAGE=$OPTARG
			;;
		r)
			REPO_REFERENCE=$OPTARG
			;;
		*)
			#Printing error message
			echo "invalid option or argument $OPTARG"
			;;
	esac
done

if [ -z "$DL_DIR" ]; then
	echo "DL_DIR not set, creating it under $HOME/yocto_cache"
	mkdir -p $HOME/yocto_cache/downloads
	DL_DIR=$HOME/yocto_cache/downloads
fi


if [ -z $SSTATE_DIR ]; then
	echo "SSTATE_DIR not set, creating it under $HOME/yocto_cache"
	mkdir -p $HOME/yocto_cache/sstate-cache
	SSTATE_DIR=$HOME/yocto_cache/sstate-cache
fi

################################################################################
# Run docker
################################################################################
echo "Running docker instance with params:"
echo "IMAGE:          $IMAGE"
echo "UID:            $UID"
echo "GID:            $GID"
echo "REPO_REFERENCE: $REPO_REFERENCE"
echo "DL_DIR:         $DL_DIR"
echo "SSTATE_DIR:     $SSTATE_DIR"

sudo docker run -it \
	--user dev:$GID \
	-v $DL_DIR:/home/dev/yocto_cache/downloads \
	-v $SSTATE_DIR:/home/dev/yocto_cache/sstate-cache \
	-v $REPO_REFERENCE:/home/dev/reference \
	$IMAGE
