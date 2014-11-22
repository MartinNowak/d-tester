#!/usr/bin/env bash

# set -x

# args:
#    1) directory for build
#    2) os

PARALLELISM=1

if [ -f configs/`hostname` ]; then
    . configs/`hostname`
fi

echo -e "\tbuilding dlang.org"

cd $1/dlang.org

makecmd=make
makefile=posix.mak
MODEL=32
EXTRA_ARGS="-j$PARALLELISM"
case "$2" in
    Darwin_32|Darwin_64_32)
        ;;
    Darwin_32_64|Darwin_64_64)
        MODEL=64
        ;;
    Linux_32|Linux_64_32)
        ;;
    Linux_32_64|Linux_64_64)
        MODEL=64
        ;;
    FreeBSD_32)
        makecmd=gmake
        ;;
    FreeBSD_64)
        makecmd=gmake
        MODEL=64
        ;;
    stub)
        exit 0
        ;;
    Win_32)
        makefile=win32.mak
        EXTRA_ARGS=""
        ;;
    Win_64)
        makefile=win64.mak
        EXTRA_ARGS=""
        MODEL=64
        ;;
    *)
        echo "unknown os: $2"
        exit 1
esac

$makecmd DMD=../dmd/src/dmd MODEL=$MODEL $EXTRA_ARGS -f $makefile >> ../dlang.org-build.log 2>&1
if [ $? -ne 0 ]; then
    echo -e "\tdlang.org failed to build"
    exit 1
fi
