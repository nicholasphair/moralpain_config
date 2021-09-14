# Copyright © 2001 by the Rectors and Visitors of the University of Virginia. 

# Extend Ubunto 20.04
FROM ubuntu:20.04

# Create image without any user interaction
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Update and configure Ubuntu 
RUN apt-get clean && apt-get update -y && \ 
    apt-get install -y locales apt-utils && \
    locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  
WORKDIR /root  
# COPY .devcontainer/.profile.txt /root/.profile
VOLUME /hostdir

# Stuff for Aaron's PDT class
RUN apt-get install -y -q -q --no-install-recommends clang llvm emacs vim nasm astyle \
        tofrodos source-highlight lsb-release build-essential gdb lldb doxygen doxygen-doc graphviz ddd git g++ \
        gobjc gnustep gnustep-make gnustep-common libgnustep-base-dev evince g++-multilib \
        libc6-dev-i386 libc6-dev flex make wget git gnupg curl python3-pip \
        python3-venv python3-dev libssl-dev libffi-dev libconfig-dev&& \
    update-alternatives --set cc /usr/bin/clang && \
    update-alternatives --set c++ /usr/bin/clang++ && \
    update-alternatives --install /usr/bin/llvm-symbolizer llvm-symbolizer \
        /usr/bin/llvm-symbolizer-10 1000 && \
    touch /root/.bash_aliases && \
    echo "alias mv='mv -i'" >> /root/.bash_aliases && \
    echo "alias rm='rm -i'" >> /root/.bash_aliases && \
    echo "alias cp='cp -i'" >> /root/.bash_aliases && \
    apt-get update --fix-missing && \
    apt-get clean -y

RUN . ~/.profile

# Install Lean
RUN curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y 
ENV LEAN_PATH /root/.elan/toolchains/stable/lib/lean/library:/root/.lean/_target/deps/mathlib/src
ENV PATH=/root/.elan/bin:${PATH}
RUN pipx install mathlibtools
RUN /root/.local/bin/leanproject global-install
RUN /root/.local/bin/leanproject upgrade-mathlib

# Install libraries needed by VSCode  
# - support joining sessions using a browser link 
RUN wget -O ~/vsls-reqs https://aka.ms/vsls-linux-prereq-script && chmod +x ~/vsls-reqs && ~/vsls-reqs
