# find_package(cetbuildtools REQUIRED)
find_package(cetbuildtools REQUIRED)

include(CetCMakeEnv)
cet_cmake_env()

# Disable extra warnings that break tensorflow
cet_set_compiler_flags(
    DIAGS CAVALIER
    EXTRA_FLAGS -Wno-pedantic -Wno-sign-compare
)

cet_report_compiler_flags()

find_ups_product(tensorflow REQUIRED)
find_package(Eigen3 REQUIRED)
find_package(Protobuf REQUIRED)

#find_ups_product(protobuf REQUIRED)
#find_ups_product(eigen3 REQUIRED)

cet_find_library(
    TENSORFLOW
    NAMES tensorflow
    PATHS ENV TENSORFLOW_LIB
    NO_DEFAULT_PATH
)

set(PKG_CONFIG_INSTALL_PREFIX "\${pcfiledir}/../..")
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/generic-build.cmake)

include(ProcessUpsFiles)
add_subdirectory(ups)

include(UseCPack)
