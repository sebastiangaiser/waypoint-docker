# waypoint-docker

[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)


In March 2021, there is no AUR (Arch User Repository) with the latest version for [Waypoint](https://www.waypointproject.io/) available.
So I decided to let Waypoint run in a docker container instead of running a local binary.
This docker image is pushed to [dockerhub](https://hub.docker.com/repository/docker/sebastiangaiser/waypoint).

## Usage

Run waypoint with the following command.
Note that the default entrypoint is set to `waypoint`.
So you only have to replace `<command>` with some subcommand like `version` to perform a `waypoint version`.

```shell
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD:$PWD" -w $PWD -v "$HOME:/home/$USER" --privileged sebastiangaiser/waypoint <command>
```

## Version matrix

| Release / Waypoint | v0.2.3 | v0.2.4 |
|:------------------:|:------:|:------:|
| v0.1.0             | x      |        |
| v0.2.0             | x      |        |
| v0.3.0             | x      |        |
| v0.4.0             |        | x      |

## How to run it without the `docker run` command?

You can specify a direct alias or an alias with a script:

<u>Alias:</u>
```shell
# Waypoint
alias waypoint="~/.waypoint-cmd.sh"
```

<u>Script:</u>
```shell
#!/bin/zsh

docker run --rm --name waypoint -it --network host -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD:$PWD" -w $PWD -v "$HOME:/home/$USER" --privileged sebastiangaiser/waypoint "$@"
```

<b>Note:</b> This is only testet with [ZSH](https://ohmyz.sh/)

<a name="development"></a>
## Development

### Build a new version of the docker image

```shell
docker build --build-arg USER=$USER --build-arg DOCKER_GID=$(cut -d: -f3 < <(getent group docker)) -t sebastiangaiser/waypoint:<version> .
```

### Build a new release

For building a new release with [semantic-release](https://github.com/semantic-release/semantic-release) you have to `export GH_TOKEN=<PersonalAccessToken>`.

```shell
npx semantic-release --no-ci
```
