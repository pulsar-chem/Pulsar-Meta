Pulsar Meta Build
=================

The Pulsar Meta package aims to serve as an installer for the Pulsar
Computational Chemistry Framework.  To learn more about this framework visit the
Pulsar-Core :link:[repository](https://github.com/pulsar-chem/Pulsar-Core).

Pulsar-Meta sims to serve as a convenient way to build most of the dependencies
of Pulsar-Core, Pulsar-Core itself, and some of the existing supermodules.

:memo: We currently do not support Windows and only support Mac in so far as it
is basically Linux.

# Contents
- [Obtaining Pulsar-Meta and Dependencies](#obtaining-pulsar-Meta-and-Dependencies)
- [Using Pulsar-Meta to Build Pulsar](#using-pulsar-meta-to-build-pulsar)
   - [Configuring the Build](#configuring-the-build)
   - [Troubleshooting the Build](#troubleshooting-the-build)
- [Using Pulsar-Meta as a Module Manager](#using-pulsar-meta-as-a-module-manager)
- [Listing Your Supermodule Here](#listing-your-supermodule-here)

Obtaining Pulsar-Meta and Dependencies
--------------------------------------

The official repository for Pulsar-Meta
is :link:[here](https://github.com/pulsar-chem/Pulsar-Meta).  To obtain the
source use the usual git clone command:
```.sh
git clone https://github.com/pulsar-chem/Pulsar-Meta <DIR>
```
`<DIR>` is optional and if set will control what directory the source code is
checked out to.  By default it will be in the directory `Pulsar-Meta` and these
instructions assume this value.

At the moment you must have pre-built and installed the following dependencies
of Pulsar-Core:

- CMake version 3.2 or greater
  - It's probably in your package manager, if not obtainable from
    :link:[here](https://cmake.org/download/)
- C++14 compliant C++ compiler and a C compiler (TODO: what version of C?)
  - GCC 4.9 and above meet this requirement
  - icpc 15.0 and above
- An MPI 3.0 implementation, built using the aforementioned C compilers
  - MPI 3.0 was released *circa* 2012 so anything somewhat modern ought to work
- BerkeleyDB
  - It's probably in your package manager, if not obtainable
    from :link:[here](http://www.oracle.com/technetwork/database/database-technologies/berkeleydb/downloads/index.html)
  - We only use very basic features so almost any version should work
- Python 3.3 or newer
  - This should be available on almost every system already, if not check the
    package manager
  - Python is very picky make sure the build uses the Python command you plan on using.
-  Eigen 3.3.2
  - Available from :link:[here](https://bitbucket.org/eigen/eigen/).
  - In practice you can use earlier versions of Eigen, but they won't be
    supported by CMake.

The following dependencies will be built for you if not provided.  They all are
CMake projects and thus so long as they are in your `CMAKE_PREFIX_PATH` will be
found automatically:

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

Using Pulsar Meta to Build Pulsar
---------------------------------

After cloning the Pulsar-Meta repository, and on a perfectly ideal machine,
you should only have to run the following command inside `Pulsar-Meta/`:

```.sh
cmake -Bbuild -H.
cd build && make
make install
```

(In case you are curious, and since they are poorly documented, the `-B` and `-H`
flags respectively set the build directory and the top-level directory of the
project.)

In reality, you'll likely need to pass more options to the CMake command.  Below
we'll go into more details pertaining to exactly what options are available,
but for now know that changing CMake options requires passing the option, value
pair prefixed with `-D`, *i.e.*:

```.sh
cmake -Bbuild -H. -DCMAKE_OPTION_1=... -DCMAKE_OPTION_2=... -D...
cd build && make
make install
```
If
you are not familiar with CMake know that option names are case-sensitive, paths
should be absolute, and,
particularly for variables setting paths, one can set an option to multiple
values using a quoted list with items in the list separated by
semi-colons, *e.g.*:
```.sh
cmake -Bbuild -H. -DCMAKE_PREFIX_PATH="/usr/;/usr/local" ...
```
sets the option `CMAKE_PREFIX_PATH` to both `/usr` and `/usr/local`.

## Configuring the Build ##

Pulsar-Meta strives to follow usual CMake conventions for configuring the
build.  To that end here is a table of useful CMake options and what they do.
Again, to change one of these options pass it to the CMake command prefixed with
a `-D`.

| Option Name            | Default                 | Description |
|:----------------------:|:-----------------------:|-------------|
| CMAKE_C_COMPILER       | N/A | This is the C compiler to use.  By default CMake will try to find a C compiler on your system. Typically this means it will find  `/bin/gcc`.  |
| CMAKE_CXX_COMPILER     | N/A | Similar to above, except for the C++ compiler. |
| CMAKE_Fortran_COMPILER | N/A | Similar to above, except for Fortran.  By default no module requires Fortran.  This is  here for completeness. Also, note the capitalization. |
| MPI_C_COMPILER | N/A | The MPI C wrapper compiler to use.  Should wrap the compiler pointed to by `CMAKE_C_COMPILER`. |
| MPI_CXX_COMPILER | N/A | Same as above except for C++. |
| MPI_Fortran_COMPILER | N/A | Same as above except for Fortran. |
| PYTHON_EXECUTABLE | N/A | The Python interpreter that you plan on using.  The Python libraries and header files will be found based off this interpreter. |
| CMAKE_C_FLAGS          | N/A | Any additional flags you want to pass to the C compiler. |
| CMAKE_CXX_FLAGS | N/A | Any additional flags you want to pass to the C++ compiler. |
| CMAKE_Fortran_Flags | N/A | Any additional flags you want to pass to the Fortran compiler. |
| CMAKE_BUILD_TYPE | Release | Can be used to enable debug builds.  Valid choices are: `Release`, `Debug`, or `RelWithDebInfo`. |
| CMAKE_PREFIX_PATH | N/A | Used to tell CMake additional places to look for dependencies.  CMake will look for executables in `CMAKE_PREFIX_PATH/bin/`, libraries in `CMAKE_PREFIX_PATH/lib/`, *etc*. |
| CMAKE_INSTALL_PREFIX | `/usr` | The root directory where the final project will be installed following usual GNU conventions.  *i.e.* libraries will be installed to `CMAKE_INSTALL_PREFIX/lib`, header files to `CMAKE_INSTALL_PREFIX/include`, *etc.* |

The above are canonical CMake options.  Additionally, Pulsar-Meta supports the
following Pulsar-Meta specific optitions.  These can take a value of `ON` or
`OFF`.  At the time of writing these options control whether to build the
framework itself as well as the available supermodules.  For details on what a
specific supermodule does as well as how to use it please see the links in the
descriptions provided.

:memo: For supermodules defining their own options it pass those options
directly to Pulsar-Meta and the options will be forwarded to the module.

| Option Name   | Default | Description |
| :---------:   | :-----: | :---------: |
| ENABLE_PULSAR | ON      | Should :link:[Pulsar-Core](https://github.com/pulsar-chem/Pulsar-Core) be built? This is the framework itself and is needed to load modules.  You'll probably want to build it. |
| ENABLE_LIBINT | OFF     | Should :link:[Pulsar-Libint](https://github.com/pulsar-chem/Pulsar-Libint) be built? |
| ENABLE_SCF    | OFF     | Should :link:[Pulsar-SCF](https://github.com/pulsar-chem/Pulsar-SCF) be built? |

## Troubleshooting the Build ##

### CMake is Not Finding X ###

Very short version, you need to give CMake the location of the dependency via
`CMAKE_PREFIX_PATH`.  If it is still not finding it ensure you have installed
the correct version of the dependency and then submit a bug report to the
Pulsar-Meta repository.

Longer version.  CMake has a somewhat complicated lookup system that you can read about
in agonozing detail
:link:[here](https://cmake.org/cmake/help/v3.0/command/find_package.html). To
summarize that article, CMake internally has a list of file path prefixes and
file path
suffixes.  When you ask CMake to find something, it searches in all possible
prefix/suffix pairs for the dependency.  The default prefixes are operating
system dependent and include things like `/`, `/usr`, *etc*. on
Linux.  The suffixes are also operating system dependent and include things like
`bin/`, `lib/`, `include/`, *etc*.  Thus on Linux, CMake automatically would look
in:
-`/`
-`/usr/`
- `/bin/`
- `/usr/bin/`
- `/lib/`
- `/usr/lib/`
- and many more

By convention you do not set the suffixes, but rather the prefixes.  So if your
dependency is in `/my/dependency/path` you will need to set the option
`CMAKE_PREFIX_PATH=/my/dependency/path`.  Often CMake will need to find the
library and header files for a dependency.  Under a typical GNU install the
library is located in `/my/dependency/path/lib` and the headers are located in
`/my/dependency/path/include`.  Although you may set `CMAKE_PREFIX_PATH` to
both of these paths, because of CMake's suffix list, simply setting it to the
root of the install, *i.e.* `/my/dependency/path`, suffices.

Using Pulsar Meta as a Module Manager
-------------------------------------

Pulsar-Meta's main purpose is to serve as an easy way to install the Pulsar
framework; however, owing to how CMake works it is also possible to use
Pulsar-Meta as a crude package manager.  To illustrate, assume the first time
you built Pulsar-Meta you did not enable Pulsar-SCF.  You now decide you would
like to try it.  To do this, rerun your same CMake configure command again,
except this time setting `ENABLE_SCF=ON`. Then reexecute:
```.sh
cd build && make
make install
```
Ultimately, CMake will run through the build again, see that all targets but
Pulsar-SCF are up to date, and only obtain and compile Pulsar-SCF.  This will
only work if you do not change options that affect the building of other
modules (things such as the compiler).

It is also possible to use Pulsar-Meta to update the supermodules you use.  This
is because CMake is actually smart enough to check Git repositories for updates
when it is determining if a target is up to date.  Thus rerunning `make`,
`make install` should pull the latest version of all enabled supermodules and
build them.

:memo: If you do not want to update a supermodule, simply disable it in the CMake
command and then rerun `make`, `make install`.  CMake will not delete the
existing supermodule.

This usage of CMake is uncanonical so it should be taken with a grain of salt.
That said, the above seems to work pretty robustly.

Listing Your Supermodule Here
-----------------------------

As the Pulsar framework takes off we anticipate the community developing
supermodules of their own.  We would be happy to make Pulsar-Meta aware of
these supermodules.  To do so simply issue a pull-request that adds a `*.cmake`
file for your supermodule to this repository and modify `CMakeLists.txt`
accordingly.  For inspiration on the former, feel fee to steal the existing
`pulsar_scf.cmake` template.  With regards to the latter, you'll need to modify
`CMakeLists.txt` in two places. At the top in the options section add an option:
```.sh
option(ENABLE_MY_MODULE "Build your module")
```
and later after the dependencies are built:
```.sh
if(ENABLE_MY_MODULE)
    include("my_module.cmake")
endif()
```
Finally, don't forget to add your option to this README!
