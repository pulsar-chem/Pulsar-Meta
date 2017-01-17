include(ExternalProject)

# Find if it already exists? (it's not required yet)
find_package(bphash QUIET) 

# If not found, build it
if(NOT bphash_FOUND)
    message(STATUS "bphash not found - we will build it for you")

    ExternalProject_Add(bphash_external
        GIT_REPOSITORY https://github.com/bennybp/BPHash.git
        GIT_TAG 352bd2a2f1cc1a9619f2d83648754aa24a29e966 
        CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
                   -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                   -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
                   -DCMAKE_POSITION_INDEPENDENT_CODE=True
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    )

else()
    message(STATUS "Found existing bphash")
    message(STATUS "bphash config: ${bphash_CONFIG}")
    add_library(bphash_external INTERFACE)
endif()
