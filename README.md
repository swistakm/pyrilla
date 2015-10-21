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


# usage

The easiest way to play single sound is to use `Sound` class:

```!python
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

```!python
from pyrilla import core

# note: sound file extension must be explicitely provided
sound = core.Sound("soundfile.ogg", "ogg")
# optional callback will be called when sound finishes to play
sound = core.Sound(filename, ext)
voice = core.Voice(sound, loop=True)
voice.play()

while True:
    # update internal state of default audio manager and mixer
    # this mixes all currently played sounds, pushes buffers etc.
    core.update()
```


# building

Building pyrilla prerequisites:

* cython
* cmake
* make

Build gorilla-audio

    cd gorilla-audio/build
    cmake .
    make

For windows (also on cygwin):

    cmake -DENABLE_OPENAL:STRING=0 -DENABLE_XAUDIO2:STRING=1 -DENABLE_DIRECTSOUND:STRING=0 -DDIRECTX_XAUDIO2_LIBRARY=../../DirectXSdk/Lib/x86/xapobase.lib .
    # use additional '--config Release' for builds with Visual Studio
    cmake --build .
