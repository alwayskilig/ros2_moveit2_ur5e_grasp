#!/bin/bash

source /opt/ros/${ROS_DISTRO}/setup.bash

if [ -f /ros2_ws/install/setup.bash ]; then
    source /ros2_ws/install/setup.bash || true
fi

cd /ros2_ws

exec "$@"