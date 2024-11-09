#!/bin/bash

IMAGE_TAG=asotelo/steerai/polaris:0.0.1
DISPLAY=192.168.100.224:0.0

docker build -t ${IMAGE_TAG} .

STOPPED_CONTAINERS=$(docker ps -aq)
if [ -n "$STOPPED_CONTAINERS" ]; then
echo "here"
    docker rm $STOPPED_CONTAINERS
fi

docker run -it -e DISPLAY=${DISPLAY} --name steerait ${IMAGE_TAG} "/bin/bash"
