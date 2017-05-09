cmake_minimum_required(VERSION 3.2)
project(Pulsar CXX)
enable_language(C) # For memwatch

include(ExternalProject)

############################
# Options
############################
option(ENABLE_PULSAR "Build the pulsar core" OFF)

############################
# Dependencies
############################
# These are required but not built by the superbuild.
# Find them, and make sure the proper flags are being
# passed into the subprojects
# C++ and C compilers are found by default
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR})
find_package(MPI REQUIRED)
find_package(BerkeleyDB REQUIRED)

############################
# Build type
############################
# Default to Release if build type not specified
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release")
endif()

if(NOT PULSAR_BUILD_TYPE)
    message(STATUS "PULSAR_BUILD_TYPE not specified. Using CMAKE_BUILD_TYPE (=${CMAKE_BUILD_TYPE})")
    set(PULSAR_BUILD_TYPE ${CMAKE_BUILD_TYPE})
endif()


##################################################
# Where stuff will be installed. This is passed
# to other external projects
##################################################
# Note that CMAKE_INSTALL_PREFIX is always absolute
# (cmake makes it that way). Therefore it always begins
# with a slash
set(STAGE_DIR            "${CMAKE_BINARY_DIR}/stage")
set(STAGE_INSTALL_PREFIX "${STAGE_DIR}${CMAKE_INSTALL_PREFIX}") 

######################
# Helper macro
######################
# Some arguments to pass to the core project ExternalProject_Add
# We do it this way since some find_package may have problems if
# a variable is set, but only to a blank string
# For example, find_package(PythonInterp) will fail
# if PYTHON_EXECUTABLE is a blank string
macro(ADD_EXTRA_ARG extra_arg arg_name)
    if(${arg_name})
        set(${extra_arg} ${${extra_arg}}
                         -D${arg_name}=${${arg_name}})
    endif()
endmacro()

###############################################
# Dependencies that we are capable of building
###############################################
include("pybind11.cmake")
include("cereal.cmake")
include("bphash.cmake")
include("bpprint.cmake")
include("memwatch.cmake")
include("eigen3.cmake")
if(ENABLE_PULSAR)
    include("pulsar.cmake")

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
else()
    message(STATUS "Not building Pulsar-Core")
endif() # SKIP_PULSAR

#################################
# Installation of the superbuild
#################################
# Installation is basically copying the staging directory
install(DIRECTORY ${STAGE_INSTALL_PREFIX}/
        DESTINATION ${CMAKE_INSTALL_PREFIX}
        USE_SOURCE_PERMISSIONS)


################################
# Uninstall of the superbuild
################################
# uninstall target
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)

add_custom_target(uninstall
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
