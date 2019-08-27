# ######################################################################
# First, set your project name and version here.
PROJNAME=skeleton
VERSION=3.14.59

# ######################################################################
# Set the main (executable) source files. These are all the source files
# that have a 'main' function. Note that you must specify the filename
# without the extension, so don't specify 'myfile.cpp', just specify
# 'myfile'.
MAIN_PROGRAM_SOURCEFILES=\
	example1_cli\
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
LIBRARY_OBJECT_SOURCEFILES=\
	module_one\
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
# for the library search paths. $(HOME) is available if you have include
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
LIBRARY_FILES=\
	ds


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
	-std=c++x11



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
	HOME=$(HOMEDRIVE)/$(HOMEPATH)
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
	HOME=$(HOMEDRIVE)/$(HOMEPATH)
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
OUTDIRS=$(OUTLIB) $(OUTBIN) $(OUTOBS)


# ######################################################################
# Declare the final outputs
BINPROGS=\
	$(foreach fname,$(MAIN_PROGRAM_SOURCEFILES),$(OUTBIN)/$(fname)$(EXE_EXT))

DYNLIB=$(OUTLIB)/lib$(PROJNAME)-$(VERSION)$(LIB_EXT)
STCLIB=$(OUTLIB)/lib$(PROJNAME)-$(VERSION).a
DYNLNK_TARGET=lib$(PROJNAME)-$(VERSION)$(LIB_EXT)
STCLNK_TARGET=lib$(PROJNAME)-$(VERSION).a
DYNLNK_NAME=$(OUTLIB)/lib$(PROJNAME)$(LIB_EXT)
STCLNK_NAME=$(OUTLIB)/lib$(PROJNAME).a


# ######################################################################
# Declare the intermediate outputs
BINOBS=\
	$(foreach fname,$(MAIN_PROGRAM_SOURCEFILES),$(OUTOBS)/$(fname).o)

OBS=\
	$(foreach fname,$(LIBRARY_OBJECT_SOURCEFILES),$(OUTOBS)/$(fname).o)


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


.PHONY:	help real-help show real-show debug release clean-all

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
	@echo "debug:               Build debug binaries."
	@echo "release:             Build release binaries."
	@echo "clean-debug:         Clean a debug build (debug is ignored)."
	@echo "clean-release:       Clean a release build (release is ignored)."
	@echo "clean-all:           Clean everything."

real-all:	real-show  $(DYNLIB) $(STCLIB) $(BINPROGS)

all:	real-all
	mkdir -p include
	cp -Rv $(HEADERS) include
	ln -f -s $(STCLNK_TARGET) $(STCLNK_NAME)
	ln -f -s $(DYNLNK_TARGET) $(DYNLNK_NAME)
	cp $(OUTLIB)/* $(OUTDIR)/lib

real-show:	$(OUTDIRS)
	@echo "SHELL:        $(GITSHELL)"
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
	@echo "OBS:          "
	@for X in $(OBS); do echo "              $$X"; done
	@echo "BINOBS:       "
	@for X in $(BINOBS); do echo "              $$X"; done
	@echo "BINPROGS:     "
	@for X in $(BINPROGS); do echo "              $$X"; done
	@echo "PWD:          $(PWD)"

show:	real-show
	@echo "Only target 'show' selected, ending now."
	@false

$(BINOBS) $(OBS):	$(OUTOBS)/%.o:	src/%.c $(HEADERS)
	$(CC) $(CFLAGS) -o $@ $<


$(OUTBIN)/%.exe:	$(OUTOBS)/%.o $(OBS) $(OUTDIRS)
	$(LD) $< $(OBS) -o $@ $(LDFLAGS)

$(OUTBIN)/%.elf:	$(OUTOBS)/%.o $(OBS) $(OUTDIRS)
	$(LD) $< $(OBS) -o $@ $(LDFLAGS)

$(DYNLIB):	$(OBS)
	$(LD) -shared $^ -o $@ $(LDFLAGS)

$(STCLIB):	$(OBS)
	$(AR) $(ARFLAGS) $@ $^

$(OUTDIRS):
	mkdir -p $@

clean-release:
	rm -rfv release

clean-debug:
	rm -rfv debug

clean-all:	clean-release clean-debug
	rm -rfv include

clean:
	echo Choose either clean-release or clean-debug

