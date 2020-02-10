FROM ubuntu
MAINTAINER <cch3dc@virginia.edu>

# Install packages.
RUN apt-get update  -y \
 && apt-get install -y git cmake vim make wget gnupg apt-utils

# Get LLVM apt repositories.
RUN wget -O - 'http://apt.llvm.org/llvm-snapshot.gpg.key' | apt-key add - \
 && echo 'deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-3.9 main' \
    >> /etc/apt/sources.list \
 && echo 'deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-3.9 main' \
    >> /etc/apt/sources.list

# Install clang-3.9
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
RUN curl https://raw.githubusercontent.com/Kha/elan/master/elan-init.sh -sSf | sh -s -- -y

# These volumes should be mounted as named volumes.
VOLUME /llvm/build /pierce

WORKDIR /pierce
COPY ./build.sh .

RUN ["chmod", "755","./build.sh"]
RUN ["bash","./build.sh"]
