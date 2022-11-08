#!/usr/bin/env bash

MANIFEST=default-latest.xml
USE_HOST_YOCTO_CACHE=

################################################################################
# Parse arguments
################################################################################
while getopts "m:rh" opt; do
	case $opt in
		h)
			USE_HOST_YOCTO_CACHE=1
			;;
		m)
			MANIFEST=$OPTARG
			;;
		r)
			USE_REFERENCE=1
			;;
		*)
			#Printing error message
			echo "invalid option or argument $OPTARG"
			;;
	esac
done

################################################################################
# Use host provided cache?
################################################################################
if [ -z $USE_HOST_YOCTO_CACHE ]; then
	echo "Not using Yocto cache from host"
	rm build/*
else
	echo "Using Yocto cache from host"
	ln -snf $HOME/yocto_cache/downloads build/downloads
	ln -snf $HOME/yocto_cache/sstate-cache build/sstate-cache
fi

################################################################################
# Get the source code
################################################################################
if [ -z $USE_REFERENCE ]; then
	echo "Not using reference from host"
	yes | repo init -u https://gitlab.com/Linaro/trusted-reference-stack/trs-manifest.git -m $MANIFEST
else
	echo "Using reference from host"
	yes | repo init -u https://gitlab.com/Linaro/trusted-reference-stack/trs-manifest.git -m $MANIFEST --reference $HOME/reference
fi

repo sync -j10

################################################################################
# Setup pre-reqs
################################################################################
yes | make apt-prereqs
make python-prereqs

################################################################################
# Source python environment and start the build
################################################################################
source .pyvenv/bin/activate
nice -1 make
