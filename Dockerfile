FROM ubuntu:18.04
MAINTAINER <cch3dc@virginia.edu>

# Install packages.
RUN apt-get update  -y \
    && apt-get install -y git cmake vim make wget gnupg apt-utils ninja-build

# Get LLVM apt repositories.
#RUN wget -O - 'http://apt.llvm.org/llvm-snapshot.gpg.key' | apt-key add - \
#    && echo 'deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-3.9 main' \
#    >> /etc/apt/sources.list \
#    && echo 'deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-3.9 main' \
#    >> /etc/apt/sources.list

# Install clang
RUN apt-get update -y && apt-get install -y clang

ENV C clang
ENV CXX clang++

# Grab LLVM and clang.
RUN git clone --progress --verbose \
    https://github.com/llvm-mirror/llvm.git llvm
RUN git clone --progress --verbose \
    https://github.com/llvm-mirror/clang.git llvm/tools/clang
RUN git clone --progress --verbose \
    https://github.com/llvm-mirror/clang-tools-extra.git llvm/tools/clang/tools/extra

# install g++
RUN ["apt-get","install","g++","-y"]

# These volumes should be mounted as named volumes.
VOLUME /llvm/build /peirce

WORKDIR /root
#COPY ./build.sh .

## If the peirce repo already contains g3log, then no point of doing all this, I think.
#RUN git clone --progress --verbose \
#    https://github.com/KjellKod/g3log.git && cd g3log && mkdir build && cd build && cmake .. -DCPACK_PACKAGING_INSTALL_PREFIX=/usr/lib && make install

# ROS installation

RUN apt-get update
RUN apt-get -y install lsb-release
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN cat /etc/apt/sources.list.d/ros-latest.list

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | apt-key add -

RUN apt update
ENV DEBIAN_FRONTEND=noninteractive

# We may want to change this to headless (ros-melodic-ros-base) in future
RUN apt-get -y install ros-melodic-desktop-full

RUN apt-get -y install python-pip
RUN pip install -U rosdep

RUN rosdep init
RUN rosdep update
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
RUN apt -y install python-rosinstall python-rosinstall-generator python-wstool build-essential

# additional ROS packages for move-base/gazebo, etc.
RUN apt-get install -y ros-melodic-controller-manager
RUN apt-get install -y ros-melodic-move-base
RUN apt-get install -y ros-melodic-twist-mux
RUN apt-get install -y ros-melodic-robot-localization
RUN apt-get install -y ros-melodic-interactive-marker-twist-server
RUN apt-get install -y ros-melodic-rviz-imu-plugin
RUN apt-get install -y ros-melodic-hector-gazebo-plugins
RUN apt-get install -y ros-melodic-gazebo-plugins
RUN apt-get install -y ros-melodic-dwa-local-planner
RUN apt-get install -y ros-melodic-gazebo-ros-control
RUN apt-get install -y ros-melodic-diff-drive-controller
RUN apt-get install -y ros-melodic-pointcloud-to-laserscan
RUN apt-get install -y ros-melodic-joint-state-controller

WORKDIR /

# Lean and mathlib install
RUN wget -q https://raw.githubusercontent.com/leanprover-community/mathlib-tools/master/scripts/install_debian.sh
RUN bash install_debian.sh
RUN rm -f install_debian.sh
ENV LEAN_PATH /root/.elan/toolchains/stable/lib/lean/library:/root/.lean/_target/deps/mathlib/src
ENV PATH=/root/.elan/bin:${PATH}
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
RUN leanproject global-install
