#!/bin/bash

export UID=$(id -u)
export GID=$(id -g)

docker compose build
docker compose run --rm kernel-build
