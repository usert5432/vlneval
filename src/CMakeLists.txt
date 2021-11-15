# this cmake file is only used when building with cetbuildtools

# cet_make_library( LIBRARY_NAME <library name>
#                   SOURCE <source code list>
#                   [LIBRARIES <library list>]
#                   [WITH_STATIC_LIBRARY]
#                   [NO_INSTALL] )

cet_find_library(TENSORFLOW NAMES tensorflow PATHS ENV TENSORFLOW_LIB NO_DEFAULT_PATH )
cet_find_library(FOR_TENSORFLOW NAMES tensorflow_framework PATHS ENV TENSORFLOW_LIB NO_DEFAULT_PATH )

cet_make_library( LIBRARY_NAME vlneval
                  SOURCE tf_model/ModelConfig.cxx
                         tf_model/TFModel.cxx
                         zoo/VLNEnergyModel.cxx
                   LIBRARIES TENSORFLOW
                             FOR_TENSORFLOW
                )

install_source(SUBDIRNAME tf_model
               SUBDIRNAME zoo)
