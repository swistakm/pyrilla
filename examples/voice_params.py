# -*- coding: utf-8 -*-
from pyrilla import core

from base import main, update_till_interrupt

again = 0


def file_handle(filename, ext):
    sound = core.Sound(filename, ext)
    voice = core.Voice(sound, loop=True)

    voice.play()
    voice.pitch = 1.5
    voice.pan = -.5
    voice.gain = .5

    print("pitch: %5.1f" % voice.pitch)
    print("pan:   %5.1f" % voice.pan)
    print("gain:  %5.1f" % voice.gain)

    update_till_interrupt()


if __name__ == "__main__":
    main(file_handle)
