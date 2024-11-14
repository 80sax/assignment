#!/bin/bash

# This script is intended for local development and testing
# It builds and runs the simulator Docker image
# In CI the image is built by Kaniko and pushed to Docker Hub
# The simulator is run in GUI mode by default
# build_socker.sh --headless will run the container in headless mode

IMAGE_TAG=soteloa/assignment:latest
CONTAINER=steerai
DISPLAY=192.168.100.224:0.0

docker build -t ${IMAGE_TAG} .
docker rm ${CONTAINER} -f
if [ "$1" == "--headless" ]; then
  docker run -it --name ${CONTAINER} ${IMAGE_TAG} "/bin/bash"
else
  docker run -it -e DISPLAY=${DISPLAY} --name ${CONTAINER} ${IMAGE_TAG} "/bin/bash"
fi
