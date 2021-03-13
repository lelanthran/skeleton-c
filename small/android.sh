#!/bin/bash

# Build for android targets
#

function die () {
   echo "$@"
   echo Aborting
   exit 127
}

export UNAME_MACHINE="`uname -m`"
export UNAME_OS="`uname -o`"

[ -z "$ANDROID_NDK_LOCATION" ] && die "Environment missing ANDROID_NDK_LOCATION"

echo "UNAME_MACHINE $UNAME_MACHINE"
echo "UNAME_OS $UNAME_OS"
