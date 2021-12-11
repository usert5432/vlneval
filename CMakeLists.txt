cmake_minimum_required (VERSION 3.12)

option(USE_UPS "Build on FNAL/UPS system" ON)
option(USE_CETMODULES "Use cetmodules to build the package" ON)

# NOTE: Due to cetmodules architecture, this needs to be done early
if ((DEFINED ENV{CETMODULES_VERSION}) AND USE_CETMODULES)
    find_package(cetmodules 2.29.06 REQUIRED)
endif ()

project(vlneval VERSION 0.0.1 LANGUAGES CXX)
set(
    SOURCES
        src/tf_model/ModelConfig.cxx
        src/tf_model/TFModel.cxx
        src/zoo/VLNEnergyModel.cxx
)


function (generate_pkgconfig install_dir)
    set(PKG_CONFIG_LIBS "-lvlneval")

    configure_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/pkg-config.pc.in"
        "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc"
        @ONLY
    )

    install(
        FILES "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc"
        DESTINATION "${install_dir}/pkgconfig/"
    )
endfunction ()

macro (cetmodules_build)
    include(CetCMakeEnv)
    cet_cmake_env()

    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/cetmodules_build.cmake)

    set(PKG_CONFIG_INSTALL_PREFIX "\${pcfiledir}/../..")
    generate_pkgconfig(".")
endmacro ()

macro (configure_standalone_build)
    find_package(PkgConfig)

    pkg_check_modules(EIGEN eigen3 REQUIRED)
    pkg_check_modules(PROTOBUF protobuf REQUIRED)
    pkg_check_modules(TENSORFLOW tensorflow REQUIRED)

    set(PKG_CONFIG_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")
endmacro ()

macro (configure_ups_build)
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
endmacro ()

macro (configure_generic_build)
    include(GNUInstallDirs)
    find_package(Boost REQUIRED)

    if (USE_UPS)
        configure_ups_build ()
    else ()
        configure_standalone_build()
    endif ()

endmacro ()

macro (generic_build)
    add_compile_options(-Wall -Werror -Wno-pedantic -Wno-sign-compare)

    set(CMAKE_CXX_STANDARD 11)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(CMAKE_CXX_EXTENSIONS OFF)

    configure_generic_build()

    add_library(vlneval SHARED ${SOURCES})

    target_link_directories(vlneval PRIVATE ${TENSORFLOW_LIBRARY_DIRS})
    target_link_libraries  (vlneval PRIVATE ${TENSORFLOW_LINK_LIBRARIES})

    target_include_directories(
        vlneval
            PRIVATE ${EIGEN_INCLUDE_DIRS}
            PRIVATE ${TENSORFLOW_INCLUDE_DIRS}
            PRIVATE ${PROTOBUF_INCLUDE_DIRS}
            PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include"
            PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/src"
    )

    install(
        TARGETS vlneval
        LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
        INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
    )

    install(DIRECTORY "include/" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")
    generate_pkgconfig("${CMAKE_INSTALL_LIBDIR}")
endmacro ()


if ((DEFINED ENV{CETMODULES_VERSION}) AND USE_CETMODULES)
    cetmodules_build()
else ()
    generic_build()
endif ()

