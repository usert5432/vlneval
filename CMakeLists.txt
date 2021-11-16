# use cmake 3.12 or later
cmake_minimum_required (VERSION 3.12)

set(PROJ_VERSION 0.0.1)

# if the CETMODULES_VERSION environmental variable is defined, use cetmodules
if(DEFINED ENV{CETMODULES_VERSION})

    # when using cetmodules, find_package(cetmodules..) must come before project(...)
    find_package(cetmodules 2.29.06 REQUIRED)
    project(vlneval VERSION ${PROJ_VERSION} LANGUAGES CXX)

    include(CetCMakeEnv)
    cet_cmake_env()

    cet_set_compiler_flags(DIAGS CAUTIOUS
      WERROR NO_UNDEFINED
      )

    cet_report_compiler_flags()

    find_package(Protobuf REQUIRED)
    find_package (Eigen3 3.3 REQUIRED NO_MODULE)
    find_package(Boost REQUIRED)

    # this package uses a different directory structure than the cet default
    include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
    include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)

    # ADD SOURCE CODE SUBDIRECTORIES HERE
    add_subdirectory(src)
    add_subdirectory(include)

    # Generating pkg-config
    set(PKG_CONFIG_LIBS "-lvlneval")
    configure_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/pkg-config.pc.in"
        "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc"
        @ONLY
    )
    install(
        FILES "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc"
        DESTINATION pkgconfig/
    )

    cet_cmake_config()
else()
# build without cetbuildtools
project(vlneval VERSION ${PROJ_VERSION} LANGUAGES CXX)
option(USE_UPS "Build on FNAL/UPS system" ON)

add_compile_options(-Wall -Werror)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(GNUInstallDirs)
find_package(Boost REQUIRED)

if (NOT USE_UPS)
    find_package(PkgConfig)

    pkg_check_modules(EIGEN eigen3 REQUIRED)
    pkg_check_modules(PROTOBUF protobuf REQUIRED)
    pkg_check_modules(TENSORFLOW tensorflow REQUIRED)

    set(PKG_CONFIG_INSTALL_PREFIX CMAKE_INSTALL_PREFIX)

else ()
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

    set(EIGEN_INCLUDE_DIRS      "$ENV{EIGEN_INC}")
    set(TENSORFLOW_INCLUDE_DIRS "$ENV{TENSORFLOW_INC}")
    set(TENSORFLOW_LIBRARY_DIRS "$ENV{TENSORFLOW_LIB}")
    set(PROTOBUF_INCLUDE_DIRS   "$ENV{PROTOBUF_INC}")

    set(TENSORFLOW_LINK_LIBRARIES tensorflow)
    set(PKG_CONFIG_INSTALL_PREFIX "\${pcfiledir}/../..")
endif ()

set(SOURCES
    src/tf_model/ModelConfig.cxx
    src/tf_model/TFModel.cxx
    src/zoo/VLNEnergyModel.cxx
)

add_library(vlneval SHARED ${SOURCES})

target_link_directories(vlneval PRIVATE ${TENSORFLOW_LIBRARY_DIRS})
target_link_libraries  (vlneval PRIVATE ${TENSORFLOW_LINK_LIBRARIES})

target_include_directories(
    vlneval
        PRIVATE ${EIGEN_INCLUDE_DIRS}
        PRIVATE ${TENSORFLOW_INCLUDE_DIRS}
        PRIVATE ${PROTOBUF_INCLUDE_DIRS}
        PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include
        PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src
)

install(
    TARGETS vlneval
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(DIRECTORY "include/" DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# Generating pkg-config
set(PKG_CONFIG_LIBS "-lvlneval")

configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/pkg-config.pc.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc"
    @ONLY
)

install(
    FILES "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc"
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig/
)
endif()

