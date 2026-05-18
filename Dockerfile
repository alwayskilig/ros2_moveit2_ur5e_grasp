FROM osrf/ros:humble-desktop-full

ENV DEBIAN_FRONTEND=noninteractive \
    ROS_DISTRO=humble \
    RMW_IMPLEMENTATION=rmw_fastrtps_cpp \
    QT_X11_NO_MITSHM=1 \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=all

SHELL ["/bin/bash", "-c"]

ARG APT_MIRROR=https://mirrors.ustc.edu.cn

RUN set -eux; \
    if [ -f /etc/apt/sources.list ]; then \
        sed -i \
            -e "s|http://archive.ubuntu.com/ubuntu|${APT_MIRROR}/ubuntu|g" \
            -e "s|http://security.ubuntu.com/ubuntu|${APT_MIRROR}/ubuntu|g" \
            /etc/apt/sources.list; \
    fi; \
    if [ -d /etc/apt/sources.list.d ]; then \
        find /etc/apt/sources.list.d -type f -name "*.list" -print0 | xargs -0 -r sed -i \
            -e "s|http://packages.ros.org/ros2/ubuntu|${APT_MIRROR}/ros2/ubuntu|g" \
            -e "s|https://packages.ros.org/ros2/ubuntu|${APT_MIRROR}/ros2/ubuntu|g"; \
        find /etc/apt/sources.list.d -type f -name "*.sources" -print0 | xargs -0 -r sed -i \
            -e "s|http://packages.ros.org/ros2/ubuntu|${APT_MIRROR}/ros2/ubuntu|g" \
            -e "s|https://packages.ros.org/ros2/ubuntu|${APT_MIRROR}/ros2/ubuntu|g" \
            -e "s|^Types:.*|Types: deb|g"; \
    fi; \
    if [ -d /usr/share/ros-apt-source ]; then \
        find /usr/share/ros-apt-source -type f -name "*.sources" -print0 | xargs -0 -r sed -i \
            -e "s|http://packages.ros.org/ros2/ubuntu|${APT_MIRROR}/ros2/ubuntu|g" \
            -e "s|https://packages.ros.org/ros2/ubuntu|${APT_MIRROR}/ros2/ubuntu|g" \
            -e "s|^Types:.*|Types: deb|g"; \
    fi

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash-completion \
    build-essential \
    cmake \
    curl \
    git \
    gdb \
    iputils-ping \
    nano \
    vim \
    wget \
    python3-argcomplete \
    python3-colcon-common-extensions \
    python3-pip \
    python3-rosdep \
    python3-vcstool \
    python3-numpy \
    python3-scipy \
    python3-matplotlib \
    python3-pandas \
    python3-seaborn \
    ros-humble-control-msgs \
    ros-humble-cv-bridge \
    ros-humble-depth-image-proc \
    ros-humble-gazebo-dev \
    ros-humble-gazebo-msgs \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-gazebo-ros2-control \
    ros-humble-gripper-controllers \
    ros-humble-image-pipeline \
    ros-humble-joint-state-broadcaster \
    ros-humble-joint-state-publisher \
    ros-humble-joint-state-publisher-gui \
    ros-humble-moveit \
    ros-humble-moveit-visual-tools \
    ros-humble-octomap \
    ros-humble-octomap-msgs \
    ros-humble-octomap-ros \
    ros-humble-octomap-server \
    ros-humble-realsense2-camera \
    ros-humble-robot-state-publisher \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    ros-humble-rviz2 \
    ros-humble-topic-tools \
    ros-humble-ur \
    ros-humble-ur-client-library \
    ros-humble-ur-description \
    ros-humble-ur-moveit-config \
    ros-humble-vision-msgs \
    ros-humble-xacro \
    libprotobuf-dev \
    protobuf-compiler \
    libgl1 \
    libglib2.0-0 \
    libusb-1.0-0 \
    udev \
    && rm -rf /var/lib/apt/lists/*

RUN rosdep init || true

RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel \
    && python3 -m pip install --no-cache-dir --ignore-installed \
       "numpy==1.24.4" \
       "sympy==1.13.1" \
       filelock \
       typing_extensions \
       networkx \
       jinja2 \
       fsspec \
       filterpy \
       pillow \
       pyyaml \
       requests \
       tqdm \
       psutil \
       py-cpuinfo \
    && python3 -m pip install --no-cache-dir \
       torch==2.2.2+cpu \
       torchvision==0.17.2+cpu \
       --index-url https://download.pytorch.org/whl/cpu \
    && python3 -m pip install --no-cache-dir --no-deps \
       "opencv-python-headless==4.9.0.80" \
       "ultralytics==8.3.0" \
       "ultralytics-thop==2.0.9"

WORKDIR /ros2_ws

COPY src ./src


COPY docker/ros_entrypoint.sh /ros_entrypoint.sh

RUN chmod +x /ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]