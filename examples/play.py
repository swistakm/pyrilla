# -*- coding: utf-8 -*-
from pyrilla import core

from base import main, update_till_interrupt


def finished(sound):
    print("finished:", sound)
    quit()


def file_handle(filename, ext):
    print("will load %s as %s" % (filename, ext))
    sound = core.Sound(filename, ext)
    sound.play(finished)

    update_till_interrupt()


if __name__ == "__main__":
    main(file_handle)
