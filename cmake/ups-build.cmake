include(GNUInstallDirs)
find_package(Boost REQUIRED)

message(STATUS "Building using UPS. Godspeed.")

if (NOT DEFINED ENV{TENSORFLOW_LIB})
    message(
        FATAL_ERROR
        "Environment variable TENSORFLOW_LIB is not defined"
        " while builging on UPS managed system. Make sure that"
        " tensorflow is setup. Refusing to proceed."
    )
endif ()

if (NOT DEFINED ENV{EIGEN_INC})
    message(
        FATAL_ERROR
        "Environment variable EIGEN is not defined"
        " while builging on UPS managed system. Make sure that"
        " eigen3 is setup. Refusing to proceed."
    )
endif ()

set(EIGEN3_INCLUDE_DIRS     "$ENV{EIGEN_INC}")
set(TENSORFLOW_INCLUDE_DIRS "$ENV{TENSORFLOW_INC}")
set(TENSORFLOW_LIBRARY_DIRS "$ENV{TENSORFLOW_LIB}")
set(PROTOBUF_INCLUDE_DIRS   "$ENV{PROTOBUF_INC}")

set(TENSORFLOW_LINK_LIBRARIES tensorflow)
set(PKG_CONFIG_INSTALL_PREFIX "\${pcfiledir}/../..")

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/generic-build.cmake)

