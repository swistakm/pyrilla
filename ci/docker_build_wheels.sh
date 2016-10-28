#!/usr/bin/env bash

yum install -y cmake
cmake /io/gorilla-audio/build
cmake --build . --config Release

for PYBIN in /opt/python/*/bin; do
    # note: latest version of cython does not support py26 so make sure we
    #       skip building wheels for this dist
    if [[ ! $PYBIN == *"26"* ]]; then
        echo -e "\n\nBuilding wheel for $PYBIN"

        ${PYBIN}/pip install
        ${PYBIN}/pip wheel /io/ -w /io/dist/

    fi
done
