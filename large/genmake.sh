#!/bin/bash

# This script will generate a Makefile based on the parameters in
# genmake.config.
#

for SUBPROJ in $*; do
   DEBUG_OBS=''
   RELEASE_OBS=''
   for SRC in `find $SUBPROJ | grep -E "\.(c|cpp|cc)\$"`; do
      OBJ=`echo $SRC | sed -E "s/\.(c|cpp|cc)\$/.o/g"`
      DEBUG_OBS="${DEBUG_OBS}"' $(DEBUG_OUTOBS)/'"${OBJ}"
      RELEASE_OBS="${RELEASE_OBS}"' $(RELEASE_OUTOBS)/'"${OBJ}"
      echo '$(DEBUG_OUTOBS)/'${OBJ}: ${SRC}
      echo '$(RELEASE_OUTOBS)/'${OBJ}: ${SRC}
   done

   export DYNAMIC_LIBNAME=lib${SUBPROJ}-'$(VERSION)$(LIBEXT)';
   export STATIC_LIBNAME=lib${SUBPROJ}.a;
   echo '$(DEBUG_OUTLIB)'/${DYNAMIC_LIBNAME}: ${DEBUG_OBS}
   echo '$(DEBUG_OUTLIB)'/${DYNAMIC_LIBNAME}: ${DEBUG_OBS}
   echo '$(RELEASE_OUTLIB)'/${STATIC_LIBNAME}: ${RELEASE_OBS}
   echo '$(RELEASE_OUTLIB)'/${STATIC_LIBNAME}: ${RELEASE_OBS}
done
