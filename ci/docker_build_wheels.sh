#!/usr/bin/env bash
travis_fold() {
  local action=$1
  local name=$2
  echo -en "travis_fold:${action}:${name}\r"
}


travis_fold start cmake-libogg
# note: something with cmake is broken so we need to run it manually
# todo: rectify this
cd /io/gorilla-audio/ext/libogg
cmake .
travis_fold end cmake-libogg


travis_fold start cmake-gorilla-audio
cd /io/
# note: we on x86_64 we need to excplicitely enable Position Independent Code
cmake --config Release gorilla-audio/build/ -DCMAKE_C_FLAGS="-fPIC"
make clean && make VERBOSE=1
travis_fold end cmake-gorilla-audio


# note: we do not target py26 and also it is not supported by latest Cython
rm -rf /opt/python/cp26*
echo -e "\n\nWill build wheels for:"
for PY in /opt/python/*/bin/python; do echo "* $(${PY} --version 2>&1)"; done


for PYBIN in /opt/python/*/bin; do
    FOLDNAME="wheel-$(basename $(dirname ${PYBIN}))"
    travis_fold start ${FOLDNAME}
    echo -e "Building wheel for $(${PYBIN}/python --version 2>&1)"

    ${PYBIN}/pip install Cython
    ${PYBIN}/pip wheel /io/ -w /io/dist-wip/
    travis_fold end ${FOLDNAME}
done


travis_fold start auditwheels
# Bundle external shared libraries into the wheels and fix platform tags
echo -e "\n\nAuditing wheels:"
for whl in dist-wip/*.whl; do
    auditwheel repair $whl -w /io/dist/
done
travis_fold end auditwheels
