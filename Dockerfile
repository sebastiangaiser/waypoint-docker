ARG VERSION=20.04
FROM ubuntu:$VERSION

LABEL maintainer="Sebastian Gaiser <sebastian@gaiser.bayern>"

ENTRYPOINT ["waypoint"]

ENV WORKDIR=/waypoint
RUN mkdir -p $WORKDIR
WORKDIR $WORKDIR

RUN apt-get update && apt-get install -y \
	curl \
	gnupg2 \
	lsb-release \
	software-properties-common

ARG KUBECTL_VERSION=1.20.0
RUN curl -LO https://dl.k8s.io/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl \
  # TODO checksum https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux
  # && curl -LO https://dl.k8s.io/v$KUBECTL_VERSION/bin/linux/amd64/kubectl.sha256 \
  && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

ARG DOCKER_VERSION=18.03.0-ce
RUN curl -fsSL https://download.docker.com/linux/static/stable/`uname -m`/docker-$DOCKER_VERSION.tgz | tar --strip-components=1 -xz -C /usr/local/bin docker/docker

ARG WAYPOINT_VERSION=0.2.3
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
	&& apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
	&& apt-get update \
	&& apt-get install -y waypoint=$WAYPOINT_VERSION \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

ARG USER
ARG DOCKER_GID
ARG UID=1000
ARG GID=1000
RUN groupadd --gid $GID $USER \
    && useradd --uid $UID --gid $GID $USER \
    && groupadd -g $DOCKER_GID docker \
    && usermod -aG $DOCKER_GID $USER \
    && newgrp docker

USER $USER
