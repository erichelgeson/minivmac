#!/usr/bin/env bash
set -e
set -x

mkdir -p dist/

#Vars
declare -a types=("II" "Plus" "SEFDHD")
MAINTAINER="erichelgeson@gmail.com"
HOMEPAGE="https://bluescsi.com"
COMMON_FLAGS=${*:-'-n minivmac-3.7-bluescsi -bg 1 '}

for type in "${types[@]}";
do
        docker build -f Dockerfile.lin \
                --platform linux/amd64 \
                --target=build \
                --tag=minivmaclin \
                --build-arg "MACHINE_TYPE=$type" \
                --build-arg "MAINTAINER=$MAINTAINER" \
                --build-arg "HOMEPAGE=$HOMEPAGE" \
                --build-arg "COMMON_FLAGS=$COMMON_FLAGS" \
                .
        docker create --name minivmaclin minivmaclin # need to create a container to copy file from
        docker cp minivmaclin:/minivmac dist/minivmac-lx64-$type
        docker rm minivmaclin
done
