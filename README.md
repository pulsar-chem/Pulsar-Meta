Pulsar Meta Build
=================

This package is used to build Pulsar and most of its dependencies

Note that this meta package requires both a C and a C++ compiler, so set
your variables accordingly.

Specifying Python
-----------------

The python version can be specified by setting the `PYTHON_EXECUTABLE` variable to
the appropriate python interpreter.

Other Variables
----------------

Some other variables that can be set (in addition to the common CMake variables such as `CMAKE_PREFIX_PATH`)

- `MPI_CXX_COMPILER`, `MPI_C_COMPILER` - Which MPI wrappers to use (ie, `mpicxx`/`mpicc`, `mpiicpc`/`mpiicc`)

- `CMAKE_CXX_COMPILER`,`CMAKE_C_COMPILER` - Which compilers to use (ie, `g++`/`gcc`, `icpc`/`icc`)

- `EIGEN3_INCLUDE_DIR` - Path to Eigen3 headers (directory contains the `Eigen` subdirectory)


Options
-------

- `SKIP_PULSAR` - Don't build the pulsar core project; that is, only build and install the
                  dependencies. This is useful for core developers, as their changes will
                  only exist locally. Core developers can use this option, and then set
                  `CMAKE_PREFIX_PATH` of the core package to the install directory
                  given to this meta package. Additionally, for the tests to run, you may 
                  need to set `CMAKE_INSTALL_RPATH` to the lib directry of the install
                  directory given to meta for the core tests to run.

