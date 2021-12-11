
# Compiling

There are several ways to build the `vlneval` library. Below I will discuss a
few of them.

## 1. Compiling on a FNAL/UPS system for MicroBooNE experiment

If you want to compile a `vlneval` library on a system that uses UPS package
manager, then first you need to setup a proper environment:
```
. /cvmfs/uboone.opensciencegrid.org/products/setup_uboone.sh

setup cmake v3_20_0
setup boost v1_75_0 -q e20:prof
setup eigen v3_3_9a
setup tensorflow v2_3_1 -q e20
```

Then, the standard cmake build route can be used:
```
mkdir build/; cd build/

cmake ../
make
```

## 2. Building an UPS product

If one wants to make a UPS product instead, once can use the following
directives:
```
mkdir <TEMP_BUILD_DIR>
cd <TEMP_BUILD_DIR>

source /cvmfs/larsoft.opensciencegrid.org/products/setup
source <...>/vlneval/ups/setup_for_development -p e20

buildtool -I <PRODUCT_DESTINATION> -bi
```

