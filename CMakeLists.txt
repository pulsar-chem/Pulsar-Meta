cmake_minimum_required(VERSION 3.2)
project(Pulsar CXX)
enable_language(C) # For memwatch

include(ExternalProject)

############################
# C++14 by default
############################
set(CMAKE_CXX_EXTENSIONS False CACHE BOOL "Enable/Disable compiler-specific C++ extensions")
set(CMAKE_CXX_STANDARD 14 CACHE STRING "Which C++ standard to use")


############################
# Dependencies
############################
# These are required but not built by the superbuild.
# Find them, and make sure the proper flags are being
# passed into the subprojects
find_package(MPI REQUIRED)
find_package(Eigen3 REQUIRED)


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

###############################################
# Dependencies that we are capable of building
###############################################
include("pybind11.cmake")
include("libtaskforce.cmake")
include("bphash.cmake")
include("bpprint.cmake")
include("memwatch.cmake")
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


#################################
# Installation of the superbuild
#################################
# Installation is basically copying the staging directory
install(DIRECTORY ${STAGE_INSTALL_PREFIX}/
        DESTINATION ${CMAKE_INSTALL_PREFIX}
        USE_SOURCE_PERMISSIONS)
