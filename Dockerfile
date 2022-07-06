# Copyright © 2001 by the Rectors and Visitors of the University of Virginia. 
FROM androidsdk/android-30


ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && apt-get install -y \
    git-lfs \
    pkg-config

WORKDIR /opt

# Install libraries needed by VSCode.
ADD https://aka.ms/vsls-linux-prereq-script /opt
RUN chmod 700 /opt/vsls-linux-prereq-script && /opt/vsls-linux-prereq-script

# Flutter and Dart.
ARG FLUTTER_VERSION=3.0.0
ADD https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz /opt
RUN tar xJvf /opt/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
ENV PATH="/opt/flutter/bin:${PATH}"
RUN flutter doctor

# AWS CLI.
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" --output "awscliv2.zip" && \
  unzip awscliv2.zip && \
  ./aws/install && \
  rm -r aws awscliv2.zip

COPY bin /opt/

ENTRYPOINT ["flutter"]
CMD ["doctor"]
