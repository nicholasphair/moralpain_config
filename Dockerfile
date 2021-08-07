# base OS
FROM ubuntu:20.04

# Update Ubuntu
RUN apt-get clean && apt-get update -y && apt-get upgrade -y

# This Dockerfile file build with zero user interaction
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Set localization information
RUN apt-get install -y locales && locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

# working directory inside the container
WORKDIR /root  

# These volumes (currently 1) should be mounted as named volumes.
VOLUME /dm

# Create bash .profile file that runs .bashrc if it exists
COPY ./.profile.txt /root/.profile


# Install development environment
RUN apt-get -y install lsb-release build-essential git vim wget gnupg curl
RUN apt-get -y install python3-pip python3-venv python3-dev
RUN apt-get install -y libssl-dev libffi-dev libconfig-dev

ENV PYTHONIOENCODING utf-8

# VSCode -- needed for server?
RUN apt install -y software-properties-common
RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
RUN apt update && apt install -y code

# Install Lean using elan


RUN curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y --default-toolchain leanprover/lean4:nightly
# RUN curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y
ENV LEAN_PATH /root/.elan/toolchains/stable/lib/lean/library:/root/.lean/_target/deps/mathlib/src
ENV PATH=/root/.elan/bin:${PATH}


RUN python3 -m pip install pipx
RUN python3 -m pipx ensurepath --force 
RUN . ~/.profile
RUN pipx install mathlibtools
RUN /root/.local/bin/leanproject global-install
