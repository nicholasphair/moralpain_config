FROM gitlab.cs.virginia.edu:5099/physicalsemantics/peirce
MAINTAINER <cch3dc@virginia.edu>

RUN apt-get update
RUN apt-get -y install lsb-release
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN cat /etc/apt/sources.list.d/ros-latest.list

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | apt-key add -

RUN apt update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install ros-melodic-desktop-full

RUN apt-get -y install python-pip
RUN pip install -U rosdep

RUN rosdep init
RUN rosdep update
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
RUN apt -y install python-rosinstall python-rosinstall-generator python-wstool build-essential
WORKDIR /

# install -y base files for move-base/gazebo, etc.
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
