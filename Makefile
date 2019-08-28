# ######################################################################
# First, set your project name and version here.
PROJNAME=skeleton
VERSION=3.14.59

# ######################################################################
# Set the main (executable) source files. These are all the source files
# that have a 'main' function. Note that you must specify the filename
# without the extension, so don't specify 'myfile.c', just specify
# 'myfile'.
#
# Note that this list is only for C files.
MAIN_PROGRAM_CSOURCEFILES=\
	example1_cli

# ######################################################################
# Set the main (executable) source files. These are all the source files
# that have a 'main' function. Note that you must specify the filename
# without the extension, so don't specify 'myfile.c', just specify
# 'myfile'.
#
# Note that this list is only for C++ files.
MAIN_PROGRAM_CPPSOURCEFILES=\
	example2_cli

# ######################################################################
# Set each of the source files that must be built. These are all those
# source files (both .c and .cpp) that *DON'T* have a main function. All
# of these files will be compiled into a single library (sorry, I do not
# have plans to allow multiple library files to be built).
#
# Note once again that you must not specify the file extension.
# Unfortunately you are not allowed to have two object files that have the
# same name save for the extension. For example, you cannot have 'myfile.c'
# and 'myfile.cpp' in the same project, although it is allowed
# (encouraged even) to have either 'myfile.c' or 'myfile.cpp' together
# with 'myfile.h'.
#
# Note that this list is only for C files.
LIBRARY_OBJECT_CSOURCEFILES=\
	module_one

# ######################################################################
# Set each of the source files that must be built. These are all those
# source files (both .c and .cpp) that *DON'T* have a main function. All
# of these files will be compiled into a single library (sorry, I do not
# have plans to allow multiple library files to be built).
#
# Note once again that you must not specify the file extension.
# Unfortunately you are not allowed to have two object files that have the
# same name save for the extension. For example, you cannot have 'myfile.c'
# and 'myfile.cpp' in the same project, although it is allowed
# (encouraged even) to have either 'myfile.c' or 'myfile.cpp' together
# with 'myfile.h'.
#
# Note that this list is only for C++ files.
LIBRARY_OBJECT_CPPSOURCEFILES=\
	module_two


# ######################################################################
# For now we set the headers manually. In the future I plan to use gcc to
# generate the dependencies that can be included in this file. Simply name
# all the header files you wrote for this project. Note that unlike the
# previous settings, for this setting you must specify the path to the
# headers (relative to this directory).
HEADERS=\
	src/module_one.h\
	src/module_two.h


# ######################################################################
# Here you must set the list of include paths. Note that the variable
# $(HOME) is available if you have include directories relative to your
# home directory. $(HOME) works correctly on Windows as well.
#
# You can put as many paths in here as you want to. I've put one in as an
# example.
INCLUDE_PATHS=\
	$(HOME)/include

# ######################################################################
# This is similar to the INCLUDE_PATHS you set above, except that it is
# for the library search paths. $(HOME) is available if you have library
# directories relative to your home directory. $(HOME) works correctly
# on Windows as well.
#
# You can put as many paths in here as you want to. I've put one in as an
# example. See the variable LIBRARY_FILES to set the actual libraries you
# want to link in.
LIBRARY_PATHS=\
	$(HOME)/lib


# ######################################################################
# This is for specifying extra libraries. Note that you must only specify
# the library name, and neither the extension nor the prefix 'lib'.
#
# These files *MUST* be in the library search path specified with
# LIBRARY_PATHS.
#
# I've put in an example here that is commented out, so that you can see
# how the files are supposed to be specified but, because it is commented
# out, it will not break the build process if this library is not
# installed.
#
# (If it is not commented out, go ahead and comment it out when the build
# fails)
#LIBRARY_FILES=\
#	ds


# ######################################################################
# Here you set extra compiler flags that are common to both the C++ and
# the C compiler. You can comment this line out with no ill-effects.
#
# Note that this does not override the existing flags, it only adds to
# them
EXTRA_COMPILER_FLAGS=\
	-DNAME=Value\
	-W -Wall


# ######################################################################
# Here you set extra compiler flags for the C compiler only. You can comment
# this line out with no ill-effects.
#
# Note that this does not override the existing flags, it only adds to
# them
EXTRA_CFLAGS=\
	-std=c99


# ######################################################################
# Here you set extra compiler flags for the C++ compiler only. You can
# comment this line out with no ill-effects.
#
# Note that this does not override the existing flags, it only adds to
# them
EXTRA_CXXFLAGS=\
	-std=c++11



# ######################################################################
# The default compilers are gcc and g++. If you want to specify something
# different, this is the place to do it. This is useful if you want to
# cross-compile, or use a different gcc/g++ than the one in your path, or
# simply want to use clang instead.
#
# Note that only clang and gcc are supported (due to reliance on the
# compiler command-line options).
#
# You can comment this out with no ill-effects.
GCC=gcc
GXX=g++


# ######################################################################
# Set some colours for echo to use
NONE:=\e[0m
INV:=\e[7m
RED:=\e[31m
GREEN:=\e[32m
BLUE:=\e[34m
CYAN:=\e[36m
YELLOW:=\e[33m


# ######################################################################
# We record the start time, for determining how long the build took
START_TIME:=$(shell date +"%s")


# ######################################################################
# Some housekeeping to determine if we are running on a POSIX
# platform or on Windows

MAKEPROGRAM_EXE=$(findstring exe,$(MAKE))
MAKEPROGRAM_MINGW=$(findstring mingw,$(MAKE))
GITSHELL=$(findstring Git,$(SHELL))
GITSHELL+=$(findstring git,$(SHELL))

# TODO: Remember that freebsd might use not gmake/gnu-make; must add in
# some diagnostics so that user gets a message to install gnu make.

ifneq ($(MAKEPROGRAM_EXE),)
ifeq ($(strip $(GITSHELL)),)
$(error On windows this must be executed from the Git bash shell)
endif
	HOME=$(HOMEDRIVE)$(HOMEPATH)
	PLATFORM=Windows
	EXE_EXT=.exe
	LIB_EXT=.dll
	PLATFORM_LDFLAGS=--L$(HOME)/lib lmingw32 -lws2_32 -lmsvcrt -lgcc
	PLATFORM_CFLAGS= -D__USE_MINGW_ANSI_STDIO
endif

ifneq ($(MAKEPROGRAM_MINGW),)
ifeq ($(strip $(GITSHELL)),)
$(error On windows this must be executed from the Git bash shell)
endif
	HOME=$(HOMEDRIVE)$(HOMEPATH)
	PLATFORM=Windows
	EXE_EXT=.exe
	LIB_EXT=.dll
	PLATFORM_LDFLAGS=-L$(HOME)/lib -lmingw32 -lws2_32 -lmsvcrt -lgcc
	PLATFORM_CFLAGS= -D__USE_MINGW_ANSI_STDIO
endif

# If neither of the above are true then we assume a working POSIX
# platform
ifeq ($(PLATFORM),)
	PLATFORM=POSIX
	EXE_EXT=.elf
	LIB_EXT=.so
	PLATFORM_LDFLAGS= -lpthread -ldl
endif



# ######################################################################
# Set the output directories, output filenames

OUTDIR=debug

ifneq (,$(findstring debug,$(MAKECMDGOALS)))
OUTDIR=debug
endif

ifneq (,$(findstring release,$(MAKECMDGOALS)))
OUTDIR=release
endif

TARGET=$(shell $(GCC) -dumpmachine)
OUTLIB=$(OUTDIR)/lib/$(TARGET)
OUTBIN=$(OUTDIR)/bin/$(TARGET)
OUTOBS=$(OUTDIR)/obs/$(TARGET)
OUTDIRS=$(OUTLIB) $(OUTBIN) $(OUTOBS) include


# ######################################################################
# Declare the final outputs
BINPROGS=\
	$(foreach fname,$(MAIN_PROGRAM_CSOURCEFILES),$(OUTBIN)/$(fname)$(EXE_EXT))\
	$(foreach fname,$(MAIN_PROGRAM_CPPSOURCEFILES),$(OUTBIN)/$(fname)$(EXE_EXT))

DYNLIB=$(OUTLIB)/lib$(PROJNAME)-$(VERSION)$(LIB_EXT)
STCLIB=$(OUTLIB)/lib$(PROJNAME)-$(VERSION).a
DYNLNK_TARGET=lib$(PROJNAME)-$(VERSION)$(LIB_EXT)
STCLNK_TARGET=lib$(PROJNAME)-$(VERSION).a
DYNLNK_NAME=$(OUTLIB)/lib$(PROJNAME)$(LIB_EXT)
STCLNK_NAME=$(OUTLIB)/lib$(PROJNAME).a


# ######################################################################
# Declare the intermediate outputs
BIN_COBS=\
	$(foreach fname,$(MAIN_PROGRAM_CSOURCEFILES),$(OUTOBS)/$(fname).o)

BIN_CPPOBS=\
	$(foreach fname,$(MAIN_PROGRAM_CPPSOURCEFILES),$(OUTOBS)/$(fname).o)

BINOBS=$(BIN_COBS) $(BIN_CPPOBS)

COBS=\
	$(foreach fname,$(LIBRARY_OBJECT_CSOURCEFILES),$(OUTOBS)/$(fname).o)

CPPOBS=\
	$(foreach fname,$(LIBRARY_OBJECT_CPPSOURCEFILES),$(OUTOBS)/$(fname).o)

OBS=$(COBS) $(CPPOBS)

# ######################################################################
# Find all the source files so that we can do dependencies properly
SOURCES=\
	$(shell find . | grep -E "\.(c|cpp)\$$")

# ######################################################################
# Declare the build programs
ifndef GCC
	GCC=gcc
endif
ifndef GXX
	GXX=g++
endif

# ######################################################################
# Declare all the flags we need to compile and link
CC=$(GCC)
CXX=$(GXX)

INCLUDE_DIRS=\
	$(foreach ipath,$(INCLUDE_PATHS),-I$(ipath))

LIBDIRS=\
	$(foreach lpath,$(LIBRARY_PATHS),-L$(lpath))

LIBFILES=\
	$(foreach lfile,$(LIBRARY_FILES),-l$(lfile))

COMMONFLAGS=\
	$(EXTRA_COMPILER_FLAGS)\
	-W -Wall -c -fPIC \
	-DPLATFORM=$(PLATFORM) -DPLATFORM_$(PLATFORM) \
	-D$(PROJNAME)_version='"$(VERSION)"'\
	$(PLATFORM_CFLAGS)

CFLAGS=$(COMMONFLAGS) $(EXTRA_CFLAGS)
CXXFLAGS=$(COMMONFLAGS) $(EXTRA_CXXFLAGS)
LD=$(GCC)
LDFLAGS= $(LIBDIRS) $(LIBFILES) -lm $(PLATFORM_LDFLAGS)
AR=ar
ARFLAGS= rcs


.PHONY:	help real-help show real-show debug release clean-all deps

# ######################################################################
# All the conditional targets

help: real-help

debug:	CFLAGS+= -ggdb -DDEBUG
debug:	CXXFLAGS+= -ggdb -DDEBUG
debug:	all

release:	CFLAGS+= -O3
release:	CXXFLAGS+= -O3
release:	all

# ######################################################################
# Finally, build the system

real-help:
	@echo "Possible targets:"
	@echo "help:                This message."
	@echo "show:                Display all the variable values that will be"
	@echo "                     used during execution. Also 'show debug' or"
	@echo "                     'show release' works."
	@echo "deps:                Make the dependencies only."
	@echo "debug:               Build debug binaries."
	@echo "release:             Build release binaries."
	@echo "clean-debug:         Clean a debug build (release is ignored)."
	@echo "clean-release:       Clean a release build (debug is ignored)."
	@echo "clean-all:           Clean everything."


# ######################################################################
# Grab the dependencies.
-include Make.deps

real-all:	real-show $(OUTDIRS) $(DYNLIB) $(STCLIB) $(BINPROGS)

all:	real-all
	@echo "[$(CYAN)Copying$(NONE)     ]    [ -> ./include/]"
	@cp -Rv $(HEADERS) include
	@echo "[$(CYAN)Soft linking$(NONE)]    [$(STCLNK_TARGET) -> $(STCLNK_NAME)]"
	@ln -f -s $(STCLNK_TARGET) $(STCLNK_NAME)
	@echo "[$(CYAN)Soft linking$(NONE)]    [$(DYNLNK_TARGET) -> $(DYNLNK_NAME)]"
	@ln -f -s $(DYNLNK_TARGET) $(DYNLNK_NAME)
	@echo "[$(CYAN)Copying$(NONE)     ]    [ -> $(OUTDIR)/lib]"
	@cp $(OUTLIB)/* $(OUTDIR)/lib
	@echo "$(INV)$(YELLOW)Build completed: `date`$(NONE)"
	@echo "$(YELLOW)Total build time:  $$((`date +"%s"` - $(START_TIME)))s"


real-show:
	@echo "HOME:         $(HOME)"
	@echo "SHELL:        $(SHELL)"
	@echo "EXE_EXT:      $(EXE_EXT)"
	@echo "LIB_EXT:      $(LIB_EXT)"
	@echo "DYNLIB:       $(DYNLIB)"
	@echo "STCLIB:       $(STCLIB)"
	@echo "CC:           $(CC)"
	@echo "CXX:          $(CXX)"
	@echo "CFLAGS:       $(CFLAGS)"
	@echo "CXXFLAGS:     $(CXXFLAGS)"
	@echo "LD:           $(LD)"
	@echo "LDFLAGS:      $(LDFLAGS)"
	@echo "AR:           $(AR)"
	@echo "ARFLAGS:      $(ARFLAGS)"
	@echo ""
	@echo "PLATFORM:     $(PLATFORM)"
	@echo "TARGET:       $(TARGET)"
	@echo "OUTBIN:       $(OUTBIN)"
	@echo "OUTLIB:       $(OUTLIB)"
	@echo "OUTOBS:       $(OUTOBS)"
	@echo "OUTDIRS:      "
	@for X in $(OUTDIRS); do echo "              $$X"; done
	@echo "HEADERS:      "
	@for X in $(HEADERS); do echo "              $$X"; done
	@echo "COBS:          "
	@for X in $(COBS); do echo "              $$X"; done
	@echo "CPPOBS:          "
	@for X in $(CPPOBS); do echo "              $$X"; done
	@echo "OBS:          "
	@for X in $(OBS); do echo "              $$X"; done
	@echo "BIN_COBS:       "
	@for X in $(BIN_COBS); do echo "              $$X"; done
	@echo "BIN_CPPOBS:       "
	@for X in $(BIN_CPPOBS); do echo "              $$X"; done
	@echo "BINOBS:       "
	@for X in $(BINOBS); do echo "              $$X"; done
	@echo "BINPROGS:     "
	@for X in $(BINPROGS); do echo "              $$X"; done
	@echo "SOURCES:     "
	@for X in $(SOURCES); do echo "              $$X"; done
	@echo "PWD:          $(PWD)"

show:	real-show
	@echo "Only target 'show' selected, ending now."
	@false

$(BIN_COBS) $(COBS):	$(OUTOBS)/%.o:	src/%.c
	@echo "[$(BLUE)Building$(NONE)    ]    [$@]"
	@$(CC) $(CFLAGS) -o $@ $< ||\
		(echo "$(INV)$(RED)[Compile failure]   [$@]$(NONE)" ; exit 127)

$(BIN_CPPOBS) $(CPPOBS):	$(OUTOBS)/%.o:	src/%.cpp
	@echo "[$(BLUE)Building$(NONE)    ]    [$@]"
	@$(CXX) $(CXXFLAGS) -o $@ $< ||\
		(echo "$(INV)$(RED)[Compile failure]   [$@]$(NONE)" ; exit 127)

deps:	Make.deps

Make.deps:	$(HEADERS)
	@echo "$(RED)Making dependencies ... (this could take some time)$(NONE)"
	@for X in $(SOURCES); do\
		export DEP="`$(CC) $(INCLUDE_DIRS) -MM $$X`";\
		echo $(OUTOBS)/$$DEP;\
	done > Make.deps


$(OUTBIN)/%.exe:	$(OUTOBS)/%.o $(OBS) $(OUTDIRS)
	@echo "[$(GREEN)Linking$(NONE)     ]    [$@]"
	@$(LD) $< $(OBS) -o $@ $(LDFLAGS) ||\
		(echo "$(INV)$(RED)[Link failure]   [$@]$(NONE)" ; exit 127)

$(OUTBIN)/%.elf:	$(OUTOBS)/%.o $(OBS) $(OUTDIRS)
	@echo "[$(GREEN)Linking$(NONE)     ]    [$@]"
	@$(LD) $< $(OBS) -o $@ $(LDFLAGS) ||\
		(echo "$(INV)$(RED)[Link failure]   [$@]$(NONE)" ; exit 127)

$(DYNLIB):	$(OBS)
	@echo "[$(GREEN)Linking$(NONE)     ]    [$@]"
	@$(LD) -shared $^ -o $@ $(LDFLAGS) ||\
		(echo "$(INV)$(RED)[Link failure]   [$@]$(NONE)" ; exit 127)

$(STCLIB):	$(OBS)
	@echo "[$(GREEN)Linking$(NONE)     ]    [$@]"
	@$(AR) $(ARFLAGS) $@ $^ ||\
		(echo "$(INV)$(RED)[Link failure]   [$@]$(NONE)" ; exit 127)

$(OUTDIRS):
	@echo "[$(CYAN)Creating dir$(NONE)]    [$@]"
	@mkdir -p $@ ||\
		(echo "$(INV)$(RED)[mkdir failure]   [$@]$(NONE)" ; exit 127)

clean-release:
	rm -rfv release Make.deps

clean-debug:
	rm -rfv debug Make.deps

clean-all:	clean-release clean-debug
	rm -rfv include

clean:
	echo Choose either clean-release or clean-debug

