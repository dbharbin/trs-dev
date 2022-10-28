#!/bin/bash

# Run this script from the Host Side as a fast way to close down "test-container" and restart it from scratch based upon "test-image"
# 

read -p "Container exist? y/n: " existing_container

echo $existing_container

if [ "$existing_container" == "y" ]
then
  echo "### Remove existing container first..."
  docker stop test-container
  docker rm test-container
fi
  
docker run -dit --name test-container --dns 8.8.8.8 -p 8080:22 test-image
docker cp trs-install test-container:/home/dev/trs-workspace
docker exec -it --user dev -w /home/dev/trs-workspace test-container /bin/bash
