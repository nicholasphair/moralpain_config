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
#COPY ./build.sh .

ENV LEAN_PATH /root/:/root/.elan/toolchains/stable/lib/lean/library:/root/mathlib/src

## If the peirce repo already contains g3log, then no point of doing all this, I think.
#RUN git clone --progress --verbose \
#    https://github.com/KjellKod/g3log.git && cd g3log && mkdir build && cd build && cmake .. -DCPACK_PACKAGING_INSTALL_PREFIX=/usr/lib && make install

RUN curl https://raw.githubusercontent.com/Kha/elan/master/elan-init.sh -sSf | sh -s -- -y
RUN curl -L https://github.com/leanprover/lean/releases/download/v3.4.2/lean-3.4.2-linux.tar.gz > lean.tar.gz
RUN gunzip lean.tar.gz
RUN tar -xvf lean.tar
RUN cp -r lean-3.4.2-linux/bin/ /usr/
RUN cp -r lean-3.4.2-linux/lib/ /usr/
RUN cp -r lean-3.4.2-linux/include/ /usr/
RUN rm -rf lean.tar
RUN rm -rf lean-3.4.2-linux

RUN curl https://raw.githubusercontent.com/kevinsullivan/phys/master/src/orig/vec.lean > vec.lean
RUN git clone https://github.com/leanprover-community/mathlib.git
RUN git clone https://github.com/kevinsullivan/dm.s20.git

WORKDIR /root/mathlib
RUN git checkout --detach 05457fdd93d4d12b6d897e174639d81d393c8d8b

WORKDIR /root/dm.s20
RUN leanpkg configure
RUN leanpkg build

WORKDIR /root
RUN mv mathlib mathlib_uncompiled
RUN mv dm.s20/_target/deps/mathlib mathlib

WORKDIR /root
COPY ./build.sh .
# The following "&& ninja stage2" is a hack to get the build to start
# If this is split up as two steps, the files are not found and the /root/llvm/build directory is empty
#RUN ["chmod", "755","./build.sh"]
#RUN ["bash","./build.sh"]

CMD "mkdir -p /llvm/build"
#ENV CXX clang++
WORKDIR /llvm/build
RUN cmake -G 'Ninja' -DCMAKE_BUILD_TYPE=Release -DCLANG_ENABLE_BOOTSTRAP=On -DCMAKE_C_COMPILER=$C -DCMAKE_CXX_COMPILER=$CXX -LLVM_USE_LINKER=gnu.ld -LLVM_PARALLEL_LINK_JOBS=1 -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_EH=ON ..
WORKDIR /llvm/build
#RUN ninja stage2

#RUN "cmake -G 'Ninja' -DCMAKE_BUILD_TYPE=Release -DCLANG_ENABLE_BOOTSTRAP=On -DCMAKE_C_COMPILER=$C -DCMAKE_CXX_COMPILER=$CXX -LLVM_USE_LINKER=gnu.ld -LLVM_PARALLEL_LINK_JOBS=1 -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_EH=ON .."
#RUN "ninja stage2"
#CMD ["cmake","-G","'Ninja'","-DCMAKE_BUILD_TYPE=Release","-DCLANG_ENABLE_BOOTSTRAP=On","-DCMAKE_C_COMPILER=$C","-DCMAKE_CXX_COMPILER=$CXX","-LLVM_USE_LINKER=gnu.ld","-LLVM_PARALLEL_LINK_JOBS=1","-DLLVM_ENABLE_ASSERTIONS=ON","-DLLVM_ENABLE_RTTI=ON","-DLLVM_ENABLE_EH=ON",".."] 
#CMD ["ninja", "stage2"]
# WORKDIR /llvm/build
CMD ls /llvm/build
CMD cd /llvm/build && cmake --build .


RUN apt-get -y install clang-format clang-tidy clang-tools clang libc++-dev libc++1 libc++abi-dev libc++abi1 libclang-dev libclang1 libomp-dev libomp5 lld lldb llvm-dev llvm-runtime llvm gdb gdbserver

RUN git clone --progress --verbose \
    https://github.com/KjellKod/g3log.git && cd g3log && mkdir build && cd build && cmake .. -DCPACK_PACKAGING_INSTALL_PREFIX=/usr/lib && make install


#-DCMAKE_INSTALL_PREFIX="/usr/bin/gcc" 
