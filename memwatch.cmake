include(ExternalProject)

# Find if it already exists? (it's not required yet)
find_package(memwatch QUIET) 

# If not found, build it
if(NOT memwatch_FOUND)
    message(STATUS "memwatch not found - we will build it for you")

    ExternalProject_Add(memwatch_external
        GIT_REPOSITORY https://github.com/bennybp/memwatch.git
        GIT_TAG 24a439d3d64d466f80861c32b50c0d37fc0552b9 
        CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
                   -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                   -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    )

else()
    message(STATUS "Found existing memwatch")
    message(STATUS "memwatch config: ${memwatch_CONFIG}")
    add_library(memwatch_external INTERFACE)
endif()
