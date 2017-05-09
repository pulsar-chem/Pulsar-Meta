Pulsar Meta Build
=================

The Pulsar Meta package aims to serve as a super-super-build by being able to
build all of the dependencies of Pulsar-Core, Pulsar-Core, and (eventually) some
of the supermodules.  In theory, this should be a fairly painless process on
the user's end.

Obtaining Pulsar-Meta
---------------------

The official repository for Pulsar-Meta
is [here](https://github.com/pulsar-chem/Pulsar-Meta).  To obtain the source use
the usual git clone command:
```.sh
git clone https://github.com/pulsar-chem/Pulsar-Meta <DIR>
```
`<DIR>` is optional and if set will control what directory the source code is
checked out to.  By default it will be in the directory `Pulsar-Meta`.

Using Pulsar Meta
-----------------

After cloning the Pulsar-Meta repository, and on a perfectly ideal machine,
you should only have to run the following command inside the top-level directory
of the Pulsar-Meta project:

```.sh
cmake -Bbuild -H.
cd build && make
make install
```
(In case you are curious, and since they are poorly documented the `-B` and `-H`
flags respectively set the build directory and the top-level directory of the
project.)

In reality, you'll likely need to pass more options.  Below we'll go into more
details pertaining to exactly what variables to set to control which options,
but for now know that changing CMake options modifies the above code snippet to
be more like:

```.sh
cmake -Bbuild -H. -DCMAKE_OPTION_1=... -DCMAKE_OPTION_2=... -D...
cd build && make
make install
```
That is options are passed to the CMake command via a series of `-D` flags.
Option names are case-sensitive.  Note for options taking paths, multiple paths
may be passed using a semi-colon, *e.g.*:
```.sh
cmake -Bbuild -H. -DCMAKE_PREFIX_PATH="/usr/;/usr/local" ...
```

Before talking about the specific dependencies of Pulsar and how to set/control
them, note some general, but useful, CMake variables that you may want to
consider using:

- `CMAKE_BUILD_TYPE` values are:
  - `Release` Full optimization, no debug info
  - `Debug` No optimization, debug info
  - `RelWithDebInfo` Full optimization, debug info
  - This option is case-sensitive
- `CMAKE_CXX_FLAGS` Additional C++ flags to pass to the build
- `CMAKE_C_FLAGS` Additional C flags to pass to the build
- `CMAKE_INSTALL_PREFIX` where the pulsar project will be installed
- `CMAKE_PREFIX_PATH` this is a list of directories that CMake should search
  when looking for libraries and headers
  - By default CMake will try several suffix combinations such as `/lib` and
    `/include`.  A full list of such patterns is available
    [here](https://cmake.org/cmake/help/v3.0/command/find_package.html?highlight=find_package).


### Pulsar Dependencies ###

At the moment you must have pre-built and installed the following dependencies
of Pulsar-Core:

- CMake version 3.2 or greater
  - It's probably in your package manager, if not obtainable from
    [here](https://cmake.org/download/)
- C++14 compliant C++ compiler and a C compiler (TODO: what version of C?)
  - GCC 4.9 and above meet this requirement
  - icpc 15.0 and above
  - choose your C++ compiler with CMake variable: `CMAKE_CXX_COMPILER`
  - choose your C compiler with CMake variable: `CMAKE_C_COMPILER`
- An MPI 3.0 implementation, built using the aforementioned C compilers
  - MPI 3.0 was released *circa* 2012 so anything somewhat modern ought to work
  - choose your C++ MPI compiler (*i.e.* which `mpicxx`) via `MPI_CXX_COMPILER`
  - choose your C MPI compiler via `MPI_C_COMPILER`
- BerkeleyDB
  - It's probably in your package manager, if not obtainable
    from [here](http://www.oracle.com/technetwork/database/database-technologies/berkeleydb/downloads/index.html)
  - We only use very basic features so almost any version should work
- Python 3.2 or newer
  - This should be available on almost every system already, if not check the
    package manager
  - Detection is via pybind11 which finds Python via `PYTHON_EXECUTABLE`
  - Python is very picky make sure this is the python command you actually plan
    on using

The following dependencies will be built for you if not provided.  They all are
CMake projects and thus so long as they are in your `CMAKE_PREFIX_PATH` will be
found automatically:

-  Eigen 3.3.2
   - In practice you can use earlier versions of Eigen, but they won't be
     supported by CMake
-  pybind11 2.0
   - Main repository is :link:[here](https://github.com/pybind/pybind11).
   - Prior to v2.0 pybind11 was not backwards compatible, it is not clear at
     this time if that has changed for versions after 2.0
-  cereal v1.2.2
   - Main repository is :link:[here](https://github.com/USCiLab/cereal).
-  bphash
   - Main repository is :link:[here](https://github.com/bennybp/BPHash.git).
   - There's only one version, so you either have it or you don't
-  bpprint
   - Main repository is :link:[here](https://github.com/bennybp/BPPrint.git).
   - Again, only one version

### Additional Build Control ####

The CMake options fine tune the build a bit more.  They all take a value `ON` or
`OFF`

- `ENABLE_PULSAR` `OFF` by default.  If `OFF` Pulsar-Core will not be built.
  - Once Pulsar has been developed a bit more the default will change to `ON`
  - This is useful for core developers, as their changes will only exist locally.
  - Disabling this will make it so that Pulsar-Core's RPath does not by default
    pickup the dependencies found/built by Pulsar-Meta and you likely will have
    to set `CMAKE_INSTALL_RPATH` to `${CMAKE_INSTALL_PREFIX}/lib` when building
    Pulsar-Core

