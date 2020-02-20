#!/bin/bash

# This script will generate a Makefile based on the parameters in
# genmake.config.
#

# Assign defaults for all variables
unset PROJNAME
unset VERSION
unset SUBPROJS
unset INCLUDE_PATHS
unset LIBRARY_PATHS
unset LIBRARY_FILES
unset EXTRA_COMPILER_FLAGS
unset EXTRA_C_FLAGS
unset EXTRA_CXX_FLAGS
unset EXTRA_LIB_LDFLAGS
unset EXTRA_PROG_LDFLAGS
# Can be overriden by caller
export CC=gcc
export CXX=g++
export LD_PROG=gcc
export LD_LIB=gcc

. genmake.config

# Set the target platform name
TARGET=`${CC} -dumpmachine`
DEBUG_OUTDIR=debug/$TARGET
DEBUG_OUTOBS=${DEBUG_OUTDIR}/obs
DEBUG_OUTBIN=${DEBUG_OUTDIR}/bin
DEBUG_OUTLIB=${DEBUG_OUTDIR}/lib
RELEASE_OUTDIR=release/$TARGET
RELEASE_OUTOBS=${RELEASE_OUTDIR}/obs
RELEASE_OUTBIN=${RELEASE_OUTDIR}/bin
RELEASE_OUTLIB=${RELEASE_OUTDIR}/lib

# TODO: Figure out whether we are on Windows on not.
PLATFORM=POSIX


if [ "${PLATFORM}" == "WINDOWS" ]; then
   LIBEXT=dll
   EXEEXT=exe
fi

if [ "${PLATFORM}" == "POSIX" ]; then
   LIBEXT=so
   EXEEXT=elf
fi

for SUBPROJ in $SUBPROJS; do
   SUBPROJ_VERSION=${VERSION}
   SUBPROJ_CC=${CC}
   SUBPROJ_CXX=${CXX}
   SUBPROJ_LD_PROG=${LD_PROG}
   SUBPROJ_LD_LIB=${LD_LIB}

   if [ -f ${SUBPROJ}/build.config ]; then
      . ${SUBPROJ}/build.config
   fi

   export DEBUG_OBS=""
   export RELEASE_OBS=""
   for SRC in `find $SUBPROJ | grep -E "\.(c|cpp|cc)\$"`; do
      OBJ=`echo $SRC | sed -E "s/\.(c|cpp|cc)\$/.o/g"`
      echo ${DEBUG
      DEBUG_OBS="${DEBUG_OBS} debug/\$(TARGET)/$OBJ"
      RELEASE_OBS="${RELEASE_OBS} release/\$(TARGET)/$OBJ"
   done

   export DYNAMIC_LIBNAME=lib${SUBPROJ}-${VERSION}.${LIBEXT};
   echo ${DEBUG_OUTLIB}/${DYNAMIC_LIBNAME}: ${DEBUG_OBS}
   echo ${RELEASE_OUTLIB}/${DYNAMIC_LIBNAME}: ${RELEASE_OBS}
done
