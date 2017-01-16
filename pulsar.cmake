include(ExternalProject)

# RPATH handling
# By default, add the lib directory under the install prefix
# to the rpaths of the core
list(APPEND PULSARMETA_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX}/lib)
list(APPEND PULSARMETA_INSTALL_RPATH ${CMAKE_INSTALL_RPATH})

# Add the staged install to the cmake prefix so that the
# core library can find them
list(APPEND PULSARMETA_CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ${STAGE_INSTALL_PREFIX})

# Some arguments to pass to the core project ExternalProject_Add
# We do it this way since some find_package may have problems if
# a variable is set, but only to a blank string
# For example, find_package(PythonInterp) will fail
# if PYTHON_EXECUTABLE is a blank string
if(PYTHON_EXECUTABLE)
    set(PULSARMETA_EXTRA_ARGS ${PULSARMETA_EXTRA_ARGS}
                              -DPYTHON_EXECUTABLE=${PYTHON_EXECUTABLE})
endif()


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
               ${PULSARMETA_EXTRA_ARGS}
    CMAKE_CACHE_ARGS -DCMAKE_PREFIX_PATH:LIST=${PULSARMETA_CMAKE_PREFIX_PATH}
                     -DCMAKE_INSTALL_RPATH:LIST=${PULSARMETA_INSTALL_RPATH}
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
