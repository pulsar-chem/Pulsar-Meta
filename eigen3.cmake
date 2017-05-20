include(ExternalProject)

# Find if it already exists? (it's not required yet)
find_package(Eigen3 QUIET) 

# If not found, build it
if(NOT Eigen3_FOUND)
    message(STATUS "Eigen3 not found - we will build it for you")

    ExternalProject_Add(Eigen3_external
        URL http://bitbucket.org/eigen/eigen/get/3.3.2.tar.bz2
        CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
                   -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                   -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
                   -DCMAKE_POSITION_INDEPENDENT_CODE=True
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    )

else()
    message(STATUS "Found existing Eigen3")
    message(STATUS "Eigen3 config: ${Eigen3_CONFIG}")
    add_library(Eigen3_external INTERFACE)
endif()
