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
RUN apt-get install -y -q -q --no-install-recommends base curl git \
        unzip xz-utils zip libglu1-mesa emacs vim lsb-release build-essential \
        gdb lldb doxygen doxygen-doc graphviz g++ gnustep gnustep-make \
        gnustep-common libgnustep-base-dev evince g++-multilib \
        libc6-dev-i386 libc6-dev flex make wget gnupg python3-pip \
        python3-venv python3-dev libssl-dev libffi-dev libconfig-dev&& \
    touch /root/.bash_aliases && \
    echo "alias mv='mv -i'" >> /root/.bash_aliases && \
    echo "alias rm='rm -i'" >> /root/.bash_aliases && \
    echo "alias cp='cp -i'" >> /root/.bash_aliases && \
    apt-get update --fix-missing && \
    apt-get clean -y

RUN . ~/.profile

# Install libraries needed by VSCode  
# - support joining sessions using a browser link 
RUN wget -O ~/vsls-reqs https://aka.ms/vsls-linux-prereq-script && chmod +x ~/vsls-reqs && ~/vsls-reqs
