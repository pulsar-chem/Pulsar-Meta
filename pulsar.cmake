include(ExternalProject)

# RPATH handling
# By default, add the lib directory under the install prefix
# to the rpaths of the core
list(APPEND PULSAR_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX}/lib)
list(APPEND PULSAR_INSTALL_RPATH ${CMAKE_INSTALL_RPATH})

# Add the staged install to the cmake prefix so that the
# core library can find them
list(APPEND PULSAR_CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ${STAGE_INSTALL_PREFIX})


ADD_EXTRA_ARG(PULSAR_EXTRA_ARGS PYTHON_EXECUTABLE)

ExternalProject_Add(pulsar_external
    GIT_REPOSITORY https://github.com/pulsar-chem/Pulsar-Core.git
    GIT_TAG master
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
               -DCMAKE_BUILD_TYPE=${PULSAR_BUILD_TYPE}
               -DMPI_CXX_COMPILER=${MPI_CXX_COMPILER}
               -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
               -DPYTHON_EXECUTABLE=${PYTHON_EXECUTABLE}
               ${PULSAR_EXTRA_ARGS}
    CMAKE_CACHE_ARGS -DCMAKE_PREFIX_PATH:LIST=${PULSAR_CMAKE_PREFIX_PATH}
                     -DCMAKE_INSTALL_RPATH:LIST=${PULSAR_INSTALL_RPATH}
    BUILD_ALWAYS 1
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
)

# These are all the dependencies of the core that we may build
add_dependencies(pulsar_external memwatch_external
                                 bphash_external
                                 bpprint_external
                                 pybind11_external
                                 cereal_external
)

#################################
# Testing of the superbuild
#################################
# This file will allow us to run ctest in the top-level build dir
# of the meta superbuild
#
# We need to temporarily add paths to some of the dependencies to
# the LD_LIBRARY_PATH when we are running the test scripts. They currently
# reside in the stage directory. Even if the RPATHs were set, they should
# only point to the very final location of the dependencies.
file(WRITE ${CMAKE_BINARY_DIR}/CTestTestfile.cmake
    "set(ENV{LD_LIBRARY_PATH} \"${STAGE_INSTALL_PREFIX}/lib:\$ENV{LD_LIBRARY_PATH}\")\n")

# Run the pulsar core tests
# This is the path to the pulsar external project's build dir
ExternalProject_Get_Property(pulsar_external BINARY_DIR)
file(APPEND ${CMAKE_BINARY_DIR}/CTestTestfile.cmake "subdirs(${BINARY_DIR})\n")
