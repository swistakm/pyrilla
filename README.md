| Windows build | Mac OS X build |
| ------------- | -------------- |
| [![Build status](https://ci.appveyor.com/api/projects/status/y8vq560sdve1ytct?svg=true)](https://ci.appveyor.com/project/swistakm/pyrilla) | [![Build Status](https://travis-ci.org/swistakm/pyrilla.svg?branch=master)](https://travis-ci.org/swistakm/pyrilla) |


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

It works without any problems under Mac OS X and Windows. Linux support is
planned in a near future.


# pyrilla on PyPI

Pyrilla is wrapper on Gorilla Audio C library that is statically linked during
installation. For developers convenience it is distributed on PyPI as binary
wheels for Windows and Mac OS X. On Windows and Mac OS X it can be easily
instaled with pip:

    pip install pyrilla
    
Most up-to-date list of provided distributions is available on pyrilla's
[project page on PyPI](https://pypi.python.org/pypi/pyrilla/0.0.1). Depending
on target platform the underlying Gorilla Audio library is compiled with 
slightly different settings:

| Target platform | Available Python versions | Audio backend | Arch         |
| --------------- | ------------------------- | ------------- | ------------ |
| Windows         | py27, py33, py34, py35    | XAudio2       | Win32/Win64  |
| Mac OS X        | py27, py33, py34, py35    | OpenAL        | intel/x86_64 |


If you really need support for other platform (Linux, whatever) or more 
Python versions then fill issue on GitHub repository for this project 
so I can prioritize my work. I don't want to spend my time on providing more 
distributions not knowing if anyone really needs them.

Note that there is no way to provide binary wheels for Linux platform at the
moment and pyrilla source distribution (sdist) available on PyPI is still a bit
broken. Generally it is not supposed to compile on Linux. This is going to
change in future. If you want to use pyrilla on Linux you need to build it by
yourself on your platform. The process is preety straightforward and described
in *building* section of this README.

Last but not least, there is also some support for cygwin. Unfortunately there
is no binary wheel on PyPI for this environment yet. If you want to use
pyrilla under cygwin then you need to compile it manually.


# usage

The easiest way to play single sound is to use `Sound` class:

```python
from pyrilla import core

def finished(sound):
    print("sound %s finished playing" % sound)
    quit()


# note: sound file extension must be explicitely provided
sound = core.Sound("soundfile.ogg", "ogg")
# optional callback will be called when sound finishes to play
sound.play(finished)

while True:
    # update internal state of default audio manager and mixer
    # this mixes all currently played sounds, pushes buffers etc.
    core.update()
```

To play looped audio you need to use `Voice` instance that can be
created from existing sound.


```python
from pyrilla import core

sound = core.Sound("soundfile.ogg", "ogg")
voice = core.Voice(sound, loop=True)
voice.play()

while True:
    core.update()
```

For more features like custom managers/mixers, voice control (pitch, gain, pan)
or stop/play see code samples in `examples` directory of this repo.


# building

Building pyrilla prerequisites:

* cython
* cmake
* make

If you are going to build this package then remeber that Gorilla Audio is
bundled with this repository as Git submodule from my unofficial fork on
GitHub (under `gorilla-audio` directory). You need to eaither clone this
repository with `--recursive` Git flag or init submodules manually:

    git submodule update --init --recursive

Use cmake to build build gorilla-audio

    cmake gorilla-audio/build
    cmake --build . --config Release
    python setup.py build

For Windows (also on cygwin):

    cmake -DENABLE_OPENAL:STRING=0 -DENABLE_XAUDIO2:STRING=1 -DENABLE_DIRECTSOUND:STRING=0 .
    cmake --config Release --build .


Then build and install the python extension:

    python setup.py build
    python setup.py install


Note that building for Windows may be bit trickier. If your personal
environment is broken and compilation step for Gorilla Audio does not find
the correct path for DirectX SDK and/or XAudio2 lib file. If you have same 
problems as I have then you probably need to provide this path manually to 
first cmake call:

    -DDIRECTX_XAUDIO2_LIBRARY=path/to/the/DirectXSdk/Lib/x86/xapobase.lib
