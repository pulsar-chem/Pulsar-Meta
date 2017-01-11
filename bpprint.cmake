include(ExternalProject)

# Find if it already exists? (it's not required yet)
find_package(bpprint QUIET) 

# If not found, build it
if(NOT bpprint_FOUND)
    message(STATUS "bpprint not found - we will build it for you")

    ExternalProject_Add(bpprint_external
        GIT_REPOSITORY https://github.com/bennybp/BPPrint.git
        GIT_TAG 4d2583dca1f3ede4efeec2ca4eb9c14c1d83313c 
        CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
                   -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                   -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
                   -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
                   -DCMAKE_CXX_EXTENSIONS=${CMAKE_CXX_EXTENSIONS}
                   -DCMAKE_POSITION_INDEPENDENT_CODE=True
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    )

else()
    message(STATUS "Found existing bpprint")
    message(STATUS "bpprint config: ${bpprint_CONFIG}")
    add_library(bpprint_external INTERFACE)
endif()
