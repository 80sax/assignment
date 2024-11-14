#FROM ros:noetic
FROM osrf/ros:noetic-desktop-full-focal

ARG GAZEBO_INSTALLER="gazebo_install.sh"
ARG GEM_PATH="/gem_ws"
ARG GEM_SRC_PATH="${GEM_PATH}/src"

RUN apt update && \
    apt install -y curl git && \
    # Installing Gazebo
    curl -sSL http://get.gazebosim.org -o ${GAZEBO_INSTALLER} && \
    sed -i 's|keyserver.ubuntu.com|hkp://keyserver.ubuntu.com:80|g' ${GAZEBO_INSTALLER} && \
    chmod +x ${GAZEBO_INSTALLER} && \
    ./${GAZEBO_INSTALLER} && \
    # Installing ROS packages
    apt install --fix-missing -y ros-noetic-ackermann-msgs ros-noetic-geometry2 \
    ros-noetic-hector-gazebo ros-noetic-hector-models ros-noetic-jsk-rviz-plugins \
    ros-noetic-ros-control ros-noetic-ros-controllers ros-noetic-velodyne-simulator
# Compiling simulator
SHELL ["/bin/bash", "-c"]
RUN mkdir -p ${GEM_SRC_PATH} && \
    cd ${GEM_SRC_PATH} && \
    git clone --depth=1 https://gitlab.engr.illinois.edu/gemillins/POLARIS_GEM_e2.git && \
    source /opt/ros/noetic/setup.bash && \
    cd ${GEM_PATH} && \
    catkin_make
# Development packages and scripts
RUN apt install -y vim
COPY scripts /scripts
# CI Scripts
COPY tests /tests
COPY simulator.sh run_test.sh /
COPY error_sim.py /gem_ws/src/POLARIS_GEM_e2/polaris_gem_drivers_sim/gem_pure_pursuit_sim/scripts/error_sim.py

CMD ["bash"]