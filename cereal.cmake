include(ExternalProject)

# Find if it already exists?
find_package(cereal QUIET)

# If not found, build it
# (Actually, cereal doesn't have a make install, so skip building, etc,
# and just copy the headers
if(NOT cereal_FOUND)
  message(STATUS "cereal not found - we will install it for you")
  ExternalProject_Add(cereal_external
    GIT_REPOSITORY https://github.com/USCiLab/cereal
    GIT_TAG v1.2.2
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
               -DJUST_INSTALL_CEREAL=True
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${CMAKE_BINARY_DIR}/stage
  )
else()
    message(STATUS "Found existing cereal")
    message(STATUS "cereal config: ${cereal_CONFIG}")
  add_library(cereal_external INTERFACE)
endif()
