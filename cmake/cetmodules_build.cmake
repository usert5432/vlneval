# Copyright (c) Lynn Garren <garren@fnal.gov>

cet_set_compiler_flags(DIAGS CAUTIOUS WERROR NO_UNDEFINED)
cet_report_compiler_flags()

find_package(Protobuf REQUIRED)
find_package(Eigen3 3.3 REQUIRED NO_MODULE)
find_package(Boost REQUIRED)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)

# make sure we can find the eigen and protobuf headers
include_directories(${EIGEN3_INCLUDE_DIRS})
include_directories(${Protobuf_INCLUDE_DIRS})

# find tensorflow
# We need to use the deprecated find_ups_product and cet_find_library functions
# temporarily disable deprecation warnings
if (CET_WARN_DEPRECATED)
  set(_cpv_deprecations_disabled TRUE)
  unset(CET_WARN_DEPRECATED)
endif()
find_ups_product( tensorflow )
# both libraries are needed
cet_find_library(TENSORFLOW NAMES tensorflow PATHS ENV TENSORFLOW_LIB NO_DEFAULT_PATH )
cet_find_library(FOR_TENSORFLOW NAMES tensorflow_framework PATHS ENV TENSORFLOW_LIB NO_DEFAULT_PATH )
if (_cpv_deprecations_disabled)
  set(CET_WARN_DEPRECATED TRUE)
  unset(_cpv_deprecations_disabled)
endif()

cet_make_library( LIBRARY_NAME vlneval
                  SOURCE ${SOURCES}
                   LIBRARIES PRIVATE
                             TENSORFLOW
                             FOR_TENSORFLOW
                )

install_source(LIST ${SOURCES})
install(DIRECTORY "include/" DESTINATION include)

cet_cmake_config()

