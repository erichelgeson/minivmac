#!/usr/bin/env bash
set -e
set -x

# will error/stop if we dont have xcode
which xcodebuild
if [ $? -ne 0 ]; then
  echo "No xcode, skipping mac build"
  exit 1
fi
which gcc

declare -a types=("II" "Plus" "SEFDHD")
declare -a platforms=("mc64" "mcar")
MAINTAINER="erichelgeson@gmail.com"
HOMEPAGE="https://bluescsi.com"
COMMON_FLAGS=${*:-'-n minivmac-3.7-bluescsi -bg 1 '}
mkdir -p dist/

gcc -o setup_t setup/tool.c

for platform in "${platforms[@]}";
do
        for type in "${types[@]}";
        do
                ./setup_t -maintainer $MAINTAINER \
                        -homepage $HOMEPAGE \
                        -t $platform \
                        -m $type \
                        $COMMON_FLAGS \
                        -ev 13000 \
                        > setup.sh
                . ./setup.sh
                xcodebuild
                mv minivmac.app dist/minivmac-$platform-$type.app
        done
done
