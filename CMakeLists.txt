cmake_minimum_required(VERSION 3.12)

project(vlneval VERSION 0.0.1 LANGUAGES CXX)
option(USE_UPS "Build on FNAL/UPS system" ON)
option(USE_CET "Build usimg cetbuild framework" OFF)

add_compile_options(-Wall -Werror)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(
    SOURCES
        src/tf_model/ModelConfig.cxx
        src/tf_model/TFModel.cxx
        src/zoo/VLNEnergyModel.cxx
)

if (USE_CET)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/cet-build.cmake)
elseif (USE_UPS)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/ups-build.cmake)
else ()
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/standalone-build.cmake)
endif ()

