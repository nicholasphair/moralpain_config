# base OS
FROM ubuntu:20.04

# working directory inside the container
WORKDIR /root  

# These volumes (currently 1) should be mounted as named volumes.
VOLUME /dm

# this file should run with zero user interaction
ENV DEBIAN_FRONTEND=noninteractive

# Create a bash .profile file that checks for and conditioned on that runs .bashrc
COPY ./.profile.txt /root/.profile

# <comment>
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Seems like a no-op. Test later and delete if so.
# RUN apt-get install -y -q

# Update Ubuntu
RUN apt-get update  -y && apt-get upgrade -y

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



#Fix from here down with nice up-to-date Lean installation procedure
# RUN mkdir -m 0755 /nix && chown root /nix
# RUN curl -L https://nixos.org/nix/install | sh

RUN curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y
ENV LEAN_PATH /root/.elan/toolchains/stable/lib/lean/library:/root/.lean/_target/deps/mathlib/src
ENV PATH=/root/.elan/bin:${PATH}


RUN python3 -m pip install pipx
RUN python3 -m pipx ensurepath --force 
RUN . ~/.profile
RUN pipx install mathlibtools

# ENV LC_ALL C.UTF-8
# ENV LANG C.UTF-8

RUN ls /root/.local/bin
RUN /root/.local/bin/leanproject global-install

################
#RUN pip install -r requirements.txt
#RUN nvm install node
#RUN nvm use node