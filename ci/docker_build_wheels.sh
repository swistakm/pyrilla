#!/usr/bin/env bash

# note: something with cmake is broken so we need to run it manually
# todo: rectify this
cd /io/gorilla-audio/ext/libogg
cmake .

# note: could not do that in Dockerfile
yum install -y openal-devel

cd /io/
cmake /io/gorilla-audio/build
cmake --build .

for PYBIN in /opt/python/*/bin; do
    # note: latest version of cython does not support py26 so make sure we
    #       skip building wheels for this dist
    if [[ ! $PYBIN == *"26"* ]]; then
        echo -e "\n\nBuilding wheel for $PYBIN"

        ${PYBIN}/pip install Cython
        ${PYBIN}/pip wheel /io/ -w /io/dist/

    fi
done
