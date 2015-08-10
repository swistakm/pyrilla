# pyrilla
Python bindings to gorilla-audio library



# building

Building pyrilla prerequisites:

* cython
* cmake
* make

Build gorilla-audio

    cd gorilla-audio/build
    cmake .
    make

For windows (on cygwin):

    cmake -DENABLE_OPENAL:STRING=0 -DENABLE_XAUDIO2:STRING=1 -DENABLE_DIRECTSOUND:STRING=0 -DDIRECTX_XAUDIO2_LIBRARY=../../DirectXSdk/Lib/x86/xapobase.lib .
