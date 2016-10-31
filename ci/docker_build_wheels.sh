#!/usr/bin/env bash

# note: something with cmake is broken so we need to run it manually
# todo: rectify this
cd /io/gorilla-audio/ext/libogg
cmake .

# note: could not do that in Dockerfile
# todo: try to support it directly in gorilla-audio so we don't have to
# todo: install system package for headers
yum install -y openal-devel

cd /io/
# note: we on x86_64 we need to excplicitely enable Position Independent Code
cmake --config Release gorilla-audio/build/ -DCMAKE_C_FLAGS="-fPIC"
make clean && make VERBOSE=1

# note: we do not target py26 and also it is not supported by latest Cython
rm -rf /opt/python/cp26*
echo -e "\n\nWill build wheels for:"
for PY in /opt/python/*/bin/python; do echo "* $(${PY} --version 2>&1)"; done

for PYBIN in /opt/python/*/bin; do
    echo -e "\n\nBuilding wheel for $(${PYBIN}/python --version 2>&1)"

    ${PYBIN}/pip install Cython
    ${PYBIN}/pip wheel /io/ -w /io/dist-wip/

done

# Bundle external shared libraries into the wheels and fix platform tags
echo -e "\n\nAuditing wheels:"
for whl in dist-wip/*.whl; do
    auditwheel repair $whl -w /io/dist/
done
