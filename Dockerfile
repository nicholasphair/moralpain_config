FROM ubuntu:18.04
MAINTAINER <cch3dc@virginia.edu>
WORKDIR /root
COPY ./copyprofile.txt .
RUN cat /root/copyprofile.txt > /root/.profile
RUN cat /root/.profile

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get install -y -q

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
#RUN git clone --progress --verbose \
#    https://github.com/llvm-mirror/llvm.git llvm
#RUN git clone --progress --verbose \
#    https://github.com/llvm-mirror/clang.git llvm/tools/clang
#RUN git clone --progress --verbose \
#    https://github.com/llvm-mirror/clang-tools-extra.git llvm/tools/clang/tools/extra

# install g++
RUN ["apt-get","install","g++","-y"]

# These volumes should be mounted as named volumes.
VOLUME /llvm/build /peirce

RUN mkdir -p /llvm/build
#ENV CXX clang++
WORKDIR /llvm/build
#RUN cmake -G 'Ninja' -DCMAKE_BUILD_TYPE=Release -DCLANG_ENABLE_BOOTSTRAP=On -DCMAKE_C_COMPILER=$C -DCMAKE_CXX_COMPILER=$CXX -LLVM_USE_LINKER=gnu.ld -LLVM_PARALLEL_LINK_JOBS=1 -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_EH=ON .. && cmake --build .
#RUN apt-get -y install clang-format clang-tidy clang-tools clang libc++-dev libc++1 libc++abi-dev libc++abi1 libclang-dev libclang1 libomp-dev libomp5 lld lldb llvm-dev llvm-runtime llvm gdb gdbserver
#RUN git clone --progress --verbose \
#    https://github.com/KjellKod/g3log.git && cd g3log && mkdir build && cd build && cmake .. -DCPACK_PACKAGING_INSTALL_PREFIX=/usr/lib && make install



RUN apt-get -y install python-pip
ENV PYTHONIOENCODING utf-8
WORKDIR /root
COPY ./build.sh .
# The following "&& ninja stage2" is a hack to get the build to start
# If this is split up as two steps, the files are not found and the /root/llvm/build directory is empty
RUN ["chmod", "755","./build.sh"]
RUN ["bash","./build.sh"]

## If the peirce repo already contains g3log, then no point of doing all this, I think.
#RUN git clone --progress --verbose \
#    https://github.com/KjellKod/g3log.git && cd g3log && mkdir build && cd build && cmake .. -DCPACK_PACKAGING_INSTALL_PREFIX=/usr/lib && make install

# ROS installation

RUN apt-get update
RUN apt-get install apt-utils
RUN apt-get -y install lsb-release
#RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
#RUN cat /etc/apt/sources.list.d/ros-latest.list

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
#RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
#RUN wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | apt-key add -

RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive

# We may want to change this to headless (ros-melodic-ros-base) in future
#RUN apt-get -y install ros-melodic-desktop-full

#RUN pip install -U rosdep

#RUN rosdep init
#RUN rosdep update
#RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
#RUN apt-get -y install python-rosinstall python-rosinstall-generator python-wstool build-essential

# additional ROS packages for move-base/gazebo, etc.
#RUN apt-get install -y ros-melodic-controller-manager
#RUN apt-get install -y ros-melodic-move-base
#RUN apt-get install -y ros-melodic-twist-mux
#RUN apt-get install -y ros-melodic-robot-localization
#RUN apt-get install -y ros-melodic-interactive-marker-twist-server
#RUN apt-get install -y ros-melodic-rviz-imu-plugin
#RUN apt-get install -y ros-melodic-hector-gazebo-plugins
#RUN apt-get install -y ros-melodic-gazebo-plugins
#RUN apt-get install -y ros-melodic-dwa-local-planner
#RUN apt-get install -y ros-melodic-gazebo-ros-control
#RUN apt-get install -y ros-melodic-diff-drive-controller
#RUN apt-get install -y ros-melodic-pointcloud-to-laserscan
#RUN apt-get install -y ros-melodic-joint-state-controller

#WORKDIR /root
#RUN git clone --progress --verbose \
#    https://github.com/KjellKod/g3log.git && cd g3log && mkdir build && cd build && cmake .. -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr -DCHANGE_G3LOG_DEBUG_TO_DBUG=ON && cmake --build . --config Release && cmake --build . --target install


WORKDIR /

# Lean and mathlib install
#RUN wget -q https://raw.githubusercontent.com/leanprover-community/mathlib-tools/master/scripts/install_debian.sh
#RUN bash install_debian.sh
#RUN rm -f install_debian.sh
ENV LEAN_PATH /root/.elan/toolchains/stable/lib/lean/library:/root/.lean/_target/deps/mathlib/src
ENV PATH=/root/.elan/bin:${PATH}
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
RUN leanproject global-install
