cmake_minimum_required(VERSION 3.2)
project(Pulsar CXX)
enable_language(C) # For memwatch

include(ExternalProject)

############################
# Options
############################
option(ENABLE_PULSAR "Build the pulsar core" ON)
option(ENABLE_LIBINT "Build Pulsar Libint bindings" OFF)
option(ENABLE_SCF "Build Pulsar SCF bindings" OFF)


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
find_package(Eigen3 REQUIRED) #CMake can't pull the repo by default

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

#############################
# Framework and supermodules
#############################
if(ENABLE_PULSAR)
    include("pulsar.cmake")
else()
    message(STATUS "Not building Pulsar-Core")
endif() # SKIP_PULSAR

if(ENABLE_LIBINT)
    include("pulsar_libint.cmake")
endif()

if(ENABLE_SCF)
    include("pulsar_scf.cmake")
endif()

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
