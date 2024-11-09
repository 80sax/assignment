#!/bin/bash

IMAGE_TAG=asotelo/steerai/polaris:0.0.1
DISPLAY=192.168.100.224:0.0

docker build -t ${IMAGE_TAG} .

STOPPED_CONTAINERS=$(docker ps -aq)
if [ -n "$STOPPED_CONTAINERS" ]; then
  docker rm $STOPPED_CONTAINERS
fi

if [ "$1" == "--headless" ]; then
  docker run -it --name steerai ${IMAGE_TAG} "/bin/bash"
else
  docker run -it -e DISPLAY=${DISPLAY} --name steerai ${IMAGE_TAG} "/bin/bash"
fi
