# Copyright © 2001 by the Rectors and Visitors of the University of Virginia. 
FROM ghcr.io/cirruslabs/flutter:3.22.1
LABEL org.opencontainers.image.description "Underlying environment for UVA's MoralPain project"

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  
ENV PYTHONIOENCODING utf-8
ENV SHELL /bin/bash

SHELL ["/bin/bash", "-c"]
USER 0
RUN apt-get update --fix-missing \
      && DEBIAN_FRONTEND=noninteractive \
      apt-get install --no-install-recommends --assume-yes \
      build-essential \
      curl \
      git \
      git-lfs \
      gnupg \
      libconfig-dev \
      libffi-dev \
      libssl-dev \
      locales \
      lsb-release \
      pkg-config \
      python3-dev \
      python3-pip \
      python3-venv \
      software-properties-common \
      unzip \
      vim \
      wget \
      zip
RUN locale-gen en_US.UTF-8  

WORKDIR $HOME

# Poetry.
ADD --chown=root https://install.python-poetry.org python-poetry.py
RUN python3 python-poetry.py && \
      rm python-poetry.py

# AWS Cli.
ADD --chown=root https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip awscliv2.zip
RUN unzip awscliv2.zip && \
      ./aws/install --bin-dir $HOME/.local/bin --install-dir $HOME/.local/lib && \
      rm -r aws awscliv2.zip

# AWS SAM.
ADD --chown=root https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip samcli.zip
RUN unzip samcli.zip -d sam-installation && \
      ./sam-installation/install --bin-dir $HOME/.local/bin --install-dir $HOME/.local/lib && \
      rm -r sam-installation samcli.zip

# Java package manager (sdkman)
RUN curl "https://get.sdkman.io" | bash && \
      chmod a+x "$HOME/.sdkman/bin/sdkman-init.sh" && \
      . "$HOME/.sdkman/bin/sdkman-init.sh" && \
      sdk install gradle 7.5 && \
      sdk install maven && \
      sdk install java 11.0.17-amzn

# Add yq.
ADD --chown=root https://github.com/mikefarah/yq/releases/download/v4.2.0/yq_linux_amd64.tar.gz yq.tar.gz
RUN tar xzf yq.tar.gz && mv yq_linux_amd64 $HOME/.local/bin/yq

ENV PATH /root/.local/bin:$PATH

COPY bin /opt/

WORKDIR $HOME/app
VOLUME /hostdir
ENTRYPOINT ["flutter"]
CMD ["doctor"]
