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
ADD_EXTRA_ARG(PULSAR_EXTRA_ARGS EIGEN3_INCLUDE_DIR)

ExternalProject_Add(pulsar_external
    GIT_REPOSITORY https://github.com/pulsar-chem/Pulsar-Core.git
    GIT_TAG build_polish
    #SOURCE_DIR /home/ben/programming/pulsar/Pulsar-Core
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
                                 libtaskforce_external
)
