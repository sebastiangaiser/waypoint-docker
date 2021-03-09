ARG VERSION=20.04
FROM ubuntu:$VERSION

LABEL maintainer="Sebastian Gaiser <sebastian@gaiser.bayern>"

RUN apt-get update && apt-get install -y \
	lsb-release \
	software-properties-common \
	curl \
	gnupg2

ARG WAYPOINT_VERSION=0.2.3
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
	&& apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
	&& apt-get update \
	&& apt-get install -y waypoint=$WAYPOINT_VERSION \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

ENV DIR=/waypoint
RUN mkdir -p $DIR
WORKDIR $DIR

ARG USER_NAME
ARG USER_UID
ARG USER_GID
RUN groupadd --gid $USER_GID $USER_NAME
RUN useradd --uid $USER_UID --gid $USER_GID $USER_NAME

ENTRYPOINT ["waypoint"]
CMD ["version"]

