include(GNUInstallDirs)
find_package(Boost REQUIRED)

find_package(PkgConfig)

pkg_check_modules(EIGEN3 eigen3 REQUIRED)
pkg_check_modules(PROTOBUF protobuf REQUIRED)
pkg_check_modules(TENSORFLOW tensorflow REQUIRED)

set(PKG_CONFIG_INSTALL_PREFIX CMAKE_INSTALL_PREFIX)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/generic-build.cmake)
