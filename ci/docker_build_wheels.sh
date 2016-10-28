#!/usr/bin/env bash

mkdir /opt/cmake
cd /opt/cmake

# todo: try to create own docker images based on quay.io/pypa/manylinux1_*
# see: https://github.com/andystanton/docker-gcc-cmake-gl/blob/master/Dockerfile
# see: https://quay.io/repository/pypa/manylinux1_i686
curl -O https://cmake.org/files/v3.6/cmake-3.6.2.tar.gz && tar -xvf cmake-3.6.2.tar.gz
cd cmake-3.6.2
./bootstrap
make
make install

#yum install -y cmake
yum install -y openal-devel
#yum install -y libogg-devel

mkdir /tmp/cmake-build/
cd /tmp/cmake-build

cmake /io/gorilla-audio/build
cmake --build --config Release .

for PYBIN in /opt/python/*/bin; do
    # note: latest version of cython does not support py26 so make sure we
    #       skip building wheels for this dist
    if [[ ! $PYBIN == *"26"* ]]; then
        echo -e "\n\nBuilding wheel for $PYBIN"

        ${PYBIN}/pip install Cython
        ${PYBIN}/pip wheel /io/ -w /io/dist/

    fi
done
