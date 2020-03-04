FROM ubuntu
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

# install lean using elan
RUN ["apt","install","git","curl","-y"]
#RUN curl https://raw.githubusercontent.com/Kha/elan/master/elan-init.sh -sSf | sh -s -- -y

# These volumes should be mounted as named volumes.
VOLUME /llvm/build /peirce

WORKDIR /root
COPY ./build.sh .

ENV LEAN_PATH /root/:/root/.elan/toolchains/stable/lib/lean/library:/root/mathlib/src

RUN ["chmod", "755","./build.sh"]
RUN ["cat", "./build.sh", "|", "tr", "-d", "/r", ">", "build.sh"]
RUN ["bash","./build.sh"]

RUN apt-get -y install clang-format clang-tidy clang-tools clang libc++-dev libc++1 libc++abi-dev libc++abi1 libclang-dev libclang1 libomp-dev libomp5 lld lldb llvm-dev llvm-runtime llvm

RUN git clone --progress --verbose \
    https://github.com/KjellKod/g3log.git && cd g3log && mkdir build && cd build && cmake .. -DCPACK_PACKAGING_INSTALL_PREFIX=/usr/lib && make install
