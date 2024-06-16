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
      gnupg2 \
      less \
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
      ./aws/install \
        --bin-dir $HOME/.local/bin \
        --install-dir $HOME/.local/lib/aws-cli && \
      rm -r aws awscliv2.zip

# AWS SAM.
ADD --chown=root https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip samcli.zip
RUN unzip samcli.zip -d sam-installation && \
      ./sam-installation/install \
        --bin-dir $HOME/.local/bin \
        --install-dir $HOME/.local/lib/aws-sam-cli && \
      rm -r sam-installation samcli.zip
ENV SAM_CLI_TELEMETRY 0

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

# Add openapi-generator-cli.
ADD --chown=root https://raw.githubusercontent.com/OpenAPITools/openapi-generator/master/bin/utils/openapi-generator-cli.sh openapi-generator-cli.sh
RUN mv openapi-generator-cli.sh $HOME/.local/bin/openapi-generator-cli && \
  chmod a+x $HOME/.local/bin/openapi-generator-cli

# Add TypeDB.
ADD --chown=root https://repo.typedb.com/public/public-release/raw/names/typedb-console-linux-x86_64/versions/2.28.0/typedb-console-linux-x86_64-2.28.0.tar.gz typedb.tar.gz
RUN mkdir $HOME/.local/lib/typedb && \
      tar xzf typedb.tar.gz -C $HOME/.local/lib/typedb && \
      ln -s $HOME/.local/lib/typedb/typedb-console-linux-x86_64-2.28.0/typedb $HOME/.local/bin/typedb && \
      rm typedb.tar.gz


ENV PATH /root/.local/bin:$PATH

COPY bin /opt/

WORKDIR $HOME/app
VOLUME /hostdir
ENTRYPOINT ["flutter"]
CMD ["doctor"]
