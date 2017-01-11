include(ExternalProject)

# Add the staged install to the prefix so that the core library can find them
list(APPEND PULSAR_CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ${STAGE_INSTALL_PREFIX})

ExternalProject_Add(pulsar_external
    GIT_REPOSITORY https://github.com/pulsar-chem/Pulsar-Core.git
    GIT_TAG build_polish
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
               -DCMAKE_BUILD_TYPE=${PULSAR_BUILD_TYPE}
               -DMPI_CXX_COMPILER=${MPI_CXX_COMPILER}
               -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
               -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
               -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
               -DCMAKE_CXX_EXTENSIONS=${CMAKE_CXX_EXTENSIONS}
               -DPYTHON_EXECUTABLE=${PYTHON_EXECUTABLE}
    CMAKE_CACHE_ARGS -DCMAKE_PREFIX_PATH:LIST=${PULSAR_CMAKE_PREFIX_PATH}
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
