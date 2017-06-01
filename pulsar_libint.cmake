include(ExternalProject)

# RPATH handling
# By default, add the lib directory under the install prefix
# to the rpaths of the core
list(APPEND PULSAR_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX}/lib)
list(APPEND PULSAR_INSTALL_RPATH ${CMAKE_INSTALL_RPATH})

# Add the staged install to the cmake prefix so that the
# library can find them
list(APPEND PULSAR_CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ${STAGE_INSTALL_PREFIX})

ExternalProject_Add(pulsar_libint_external
    GIT_REPOSITORY https://github.com/pulsar-chem/Pulsar-Libint.git
    GIT_TAG master
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/lib/pulsar/modules
               -DCMAKE_BUILD_TYPE=${PULSAR_BUILD_TYPE}
               -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
    CMAKE_CACHE_ARGS -DCMAKE_PREFIX_PATH:LIST=${PULSAR_CMAKE_PREFIX_PATH}
                     -DCMAKE_INSTALL_RPATH:LIST=${PULSAR_INSTALL_RPATH}
    BUILD_ALWAYS 1
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
)

# These are all the dependencies of the core that we may build
add_dependencies(pulsar_libint_external pulsar_external)

#################################
# Testing of the superbuild
#################################
# Run the tests
# This is the path to the pulsar external project's build dir
ExternalProject_Get_Property(pulsar_libint_external BINARY_DIR)
file(APPEND ${CMAKE_BINARY_DIR}/CTestTestfile.cmake "subdirs(${BINARY_DIR})\n")
