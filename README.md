# waypoint-docker

In March 2021, there is no AUR (Arch User Repository) for [Waypoint](https://www.waypointproject.io/).
So I decided to let Waypoint run in a docker container instead of running a local binary.
Right now the docker (builder) build method is <b><u>NOT</u></b> supported because of no implementation of [DIND (Docker-in-Docker)](https://github.com/jpetazzo/dind#docker-in-docker) or mounting the host docker socket into the container.

In future there will be two versions of docker images:

[1. Docker image without Docker](#Without Docker)

[2. Docker image with Docker](#With Docker)


## Usage

### Without Docker

```shell
docker run --rm -it -v "$PWD:$PWD" -w $PWD -u `id -u` sebastiangaiser/waypoint waypoint <command>
```

### With Docker

```shell
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD:$PWD" -w $PWD -u `id -u` sebastiangaiser/waypoint-dind waypoint <command>
```

## How to run it without the `docker run` command?

You can specify a direct alias or an alias with a script:

<u>Alias:</u>
```shell
# Waypoint
alias waypoint="~/.waypoint-cmd.sh"
```

<u>Script:</u>
```shell
docker run --rm -it -v "$PWD:$PWD" -v "$HOME:/home/$USER" -w $PWD -u `id -u` sebastiangaiser/waypoint "$@"
```

<b>Note:</b> This is only testet with [ZSH](https://ohmyz.sh/)

## Build a new version

```shell
docker build --build-arg USER_NAME=$USER --build-arg USER_UID=$(id -u) --build-arg USER_GID=$(id -g) -t sebastiangaiser/waypoint:<version> .
```
