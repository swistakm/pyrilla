# pyrilla

pyrilla is a self-contained statically linked binding to
[gorilla-audio](https://code.google.com/p/gorilla-audio/) library -
"an attempt to make a free, straightforward, cross-platform, high-level
software audio mixer that supports playback of both static and streaming
sounds". Like the original it is intended for video game development.

pyrilla's goal is to provide a python audio package that can be installed
without any external dependencies with single `pip install pyrilla` command.
It is built with cython and its API is inspired by part of great but
unmantained [bacon](https://github.com/aholkner/bacon) game engine.


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
