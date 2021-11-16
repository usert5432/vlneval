# this cmake file is only used when building with cetbuildtools

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
                  SOURCE tf_model/ModelConfig.cxx
                         tf_model/TFModel.cxx
                         zoo/VLNEnergyModel.cxx
                   LIBRARIES PRIVATE
                             TENSORFLOW
                             FOR_TENSORFLOW
                )

install_source(SUBDIRNAME tf_model
               SUBDIRNAME zoo)
