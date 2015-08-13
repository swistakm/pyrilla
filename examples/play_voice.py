# -*- coding: utf-8 -*-
from pyrilla import core

from base import main, update_till_interrupt


def finished(sound):
    print("finished:", sound)
    quit()


def file_handle(filename, ext):
    sound = core.Sound(filename, ext)
    voice = core.Voice(sound)

    voice.play(finished)
    update_till_interrupt()


if __name__ == "__main__":
    main(file_handle)
