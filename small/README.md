# skeleton-c
A portable skeleton `C` project with Makefile-based build process

## Overview
This is a skeleton project in `C`. Can probably be used for `C++` as well.
Included you will find the following:
1. A directory structure, in which you will create your source files
2. A portable GNU Makefile that will build on Linux and Windows (Windows
   builds require the `git-bash` prompt).
3. A `build.config` file that you must edit.
4. Two example program source files (each with a `main()` function).
5. Two example module source files and two header source files.

The module and headers are present only as an example. You must replace
them (or remove them) with your own modules. You must also edit the
build.config file to remove the example JNI wrappers that get generated.
If you want to keep the JNI you will need to install the JDK and set the
include path in build.config to point to the JDKs include directory.

## Output files
You should do a build immediately after cloning this repo, just to make
sure everything compiles as it is. To build you must do either `make
debug` or `make release`. The build will display all of the build
variables before a build is started. Doing a plain `make` will display a
list of targets that the user can build.

After building the project you will have either a `debug/` directory or a
`release/` directory depending on whether you did `make debug` or `make
clean`. I'll assume you did `make debug` from this point; all the
directory names that start with `debug/` will be `release/` if you did
`make release`.

- `debug/obs`:   Contains all the object files generated by the build.
- `debug/bin`:   Contains all the programs files generated by the build.
- `debug/lib`:   Contains all the library files generated by the build.

By default, all the modules in all the source files get packaged into a
single library `libskeleton.so` (`libskeleton.dll` on Windows). The string
`skeleton` gets replaced with the actual project name (which you will
change in the `build.config` file - see below).

There are two example modules: `module_one` and `module_two`. See the
`src/` directory for the sources and headers for these modules.

## Input files and input variables
The input files are your source files (both `C` and `C++`) and your
header files. All the source files **MUST** be in the `src/` directory
within your project. `C` source files **MUST HAVE** the extension `c`.
`C++` source files **MUST HAVE** the extension `.cpp`. Note that the case
is significant - all your file extensions must be in lowercase.

You **cannot** have two source files with the same name but different
extensions; for example a project with both `filename.c` and
`filename.cpp` will fail to build.

The only file you need to modify is `build.config` - in this file you will
set a number of variables that the build process will use (for example the
project name, version, etc). Note that some variables are available for
use in this file, such as `$(HOME)` (See the include paths section for an
example).

## Setting the project name and version
At the very top of the `build.config` file there are two variables; one
is for the project name and the other is for the version. Set these two
variables to the name of your project and the version.
```make
PROJNAME=skeleton
VERSION=3.14.59
```
Replace the string `skeleton` with the name of your project. Replace the
string `3.14.59` with the version of your project.

## Specifying the list of programs to be compiled
Next there are the `main` program source files. These are all your source
files that have a `main()` entry point; they will be compiled and linked
as executables. There are two variables for `main` program source files -
one for `C` source files and one for `C++` source files.

Set each of these variables to a list of source files (minus the
extensions). For example, assuming that we have two programs that need to
be built (`cpp_prog1` and `cpp_prog2`), and both are `C++` files with a
`main()` function, you must specify them as follows:
```make
MAIN_PROGRAM_CPPSOURCEFILES=\
   cpp_prog1\
   cpp_prog2
```

If you **also** have two programs written in `C` as well, named `c_prog1`
and `c_prog2`, you can **also** set the following variable as follows:
```make
MAIN_PROGRAM_CSOURCEFILES=\
   c_prog1\
   c_prog2
```

## Specifying the list of modules to be compiled
Not all of your source files will have a `main()` function. Those that
don't will all be linked into a single `libPROJNAME.so` file. To specify
the `C` modules to be compiled, set the following variable:
```make
LIBRARY_OBJECT_CSOURCEFILES=\
   c_module1\
   c_module2
```
The above example causes the files `c_module1.c` and `c_module2.c` to be
compiled and linked into the `libPROJNAME.so` library.

To build `C++` modules **as well**, you can specify your `C++` modules as
follows:
```make
LIBRARY_OBJECT_CPPSOURCEFILES=\
   cpp_module1\
   cpp_module2
```

It is perfectly fine to have both variables set to a different list of
source files; a single project can have both `C` and `C++` files in it.

## Headers and include paths
You **MUST** specify the list of header files. If you do not then the
build process will not be able to work out what needs to be recompiled in
the event that a header changes.

To specify a header file simply assign a list of all headers in the
project as follows:
```make
HEADERS=\
   src/header_file1.h\
   src/header_file2.h
```

Note that your headers can potentially be anywhere within the project
subdirectories, although my examples place all the headers with the
sources in the `src/` directory.

Specifying include paths is similar: simply assign a list of all your
paths as follows:
```make
INCLUDE_PATHS=\
   $(HOME)/include\
   $(HOME)/contrib/include
```

As you can see, it is allowed to use the variable $(HOME) in the
`build.config` file. See the section on pre-defined variables below.

## Libraries and library paths
You can specify the list of library paths (paths to search for library
files) as follows:
```make
LIBRARY_PATHS=\
   $(HOME)/lib\
   $(HOME)/contrib/lib
```

For the actual libraries to link in, you can specify those as follows:
```make
LIBRARY_FILES=\
   library_name_1\
   library_name_2
```
Note that you **MUST NOT** specify the file extension `.so` or `.dll`, and
you **must not** specify the `lib` prefix that is common to all libraries.

The build process will add the `lib` prefix and the correct file extension
based on the platform.

## Extra build flags
You can specify extra build flags that will be passed to the compilers and
linkers by setting them in the following variables (note that this
doesn't override the flags that the build process will use, it will only
add to them):

```make
EXTRA_COMPILER_FLAGS=\
   -DNAME=Value\
   -W -Wall

EXTRA_CFLAGS=\
   -std=c99

EXTRA_CXXFLAGS=\
   -std=c++11
```

In addition, you can **override** the default compilers used by setting
the following variables:
```make
   GCC=gcc
   GXX=gxx
```
This is useful if you want to cross-compile, use a newer compiler or even
just switch to `clang`. At th moment the only compilers supported are
those that support the `gcc` command-line arguments.

TODO: extra link flags, overriding the linker.
TODO: List the predefined variables

