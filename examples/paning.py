# -*- coding: utf-8 -*-
import time
from math import sin, cos

from pyrilla import core

from base import main


def pan_voices(lvoice, rvoice, t):
    # use two sounds like two independent channels
    # its not as good as HRTF but can fake that
    # sound source moves if you really want to believe :)
    lvoice.gain = ((sin(t) + 1.) / 2.)
    rvoice.gain = ((cos(t) + 1.) / 2.)


def file_handle(filename, ext):
    sound = core.Sound(filename, ext)
    lvoice = core.Voice(sound, loop=True)
    rvoice = core.Voice(sound, loop=True)

    lvoice.play()
    rvoice.play()

    lvoice.pan = -1.
    rvoice.pan = 1.

    try:
        while True:
            pan_voices(lvoice, rvoice, time.time())
            core.update()
            time.sleep(0.001)


    except KeyboardInterrupt:
        print("interrupted")

if __name__ == "__main__":
    main(file_handle)
