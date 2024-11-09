#! /bin/bash

cd /gem_ws
source devel/setup.bash
roslaunch gem_gazebo gem_gazebo_rviz.launch velodyne_points:="true" gui:="false"
