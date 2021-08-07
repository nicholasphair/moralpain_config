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
RUN apt-get install -y -q

# Update Ubuntu
# RUN apt-get update  -y 
RUN apt-get -oDebug::pkgAcquire::Worker=1 update -y
RUN apt-get upgrade -y



# Install development environment
RUN apt-get -y install lsb-release
RUN apt-get -y install build-essential
RUN apt-get install -y git vim wget gnupg curl
RUN apt-get -y install python3-pip python3-venv python3-dev
RUN apt-get install -y libssl-dev libffi-dev 
RUN apt-get install -y libconfig-dev
RUN apt-get install -y nodejs npm  

ENV PYTHONIOENCODING utf-8

#Fix from here down with nice up-to-date Lean installation procedure
# RUN mkdir -m 0755 /nix && chown root /nix
# RUN curl -L https://nixos.org/nix/install | sh

COPY ./build.sh .
RUN chmod 755 ./build.sh
RUN bash ./build.sh

ENV LEAN_PATH /root/.elan/toolchains/stable/lib/lean/library:/root/.lean/_target/deps/mathlib/src
ENV PATH=/root/.elan/bin:${PATH}
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN ls /root/.local/bin/
RUN /root/.local/bin/leanproject global-install

# RUN pip3 install trio
# RUN pip3 install dataclasses

# Lean and mathlib install
#RUN wget -q https://raw.githubusercontent.com/leanprover-community/mathlib-tools/master/scripts/install_debian.sh
#RUN bash install_debian.sh
#RUN rm -f install_debian.sh
#RUN apt-get -y install python-pip
#ENV PYTHONIOENCODING utf-8
#WORKDIR /root
#COPY ./build.sh .
#RUN ["chmod", "755","./build.sh"]
#RUN ["bash","./build.sh"]
#ENV LEAN_PATH /root/.elan/toolchains/stable/lib/lean/library:/root/.lean/_target/deps/mathlib/src
#ENV PATH=/root/.elan/bin:${PATH}
#ENV LC_ALL C.UTF-8
#ENV LANG C.UTF-8
#RUN ls /root/.local/bin/
#RUN /root/.local/bin/leanproject global-install


#RUN cd /peirce/Peirce-vscode-api
#RUN pip install -r requirements.txt

#RUN /bin/bash /peirce/Peirce-vscode/install.sh

#RUN nvm install node
#RUN nvm use node