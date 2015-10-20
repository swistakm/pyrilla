# -*- coding: utf-8 -*-
from time import sleep
from pyrilla import core

from base import main


def finished(sound):
    print "sound %s finished, exiting" % sound
    exit()


def file_handle(filename, ext):
    manager = core.Manager(
        device=core.DEVICE_DEFAULT,
        thread_policy=core.THREAD_MULTI,
    )
    mixer = core.Mixer(manager)

    sound = core.Sound(filename, ext)
    sound.play(on_finish=finished, mixer=mixer)

    try:
        while True:
            # note: despite mixing is done in separate thread there is need
            #       for updates from time to time for callbacks to take effect
            manager.update()
            sleep(1)

    except KeyboardInterrupt:
        print("interrupted")


if __name__ == "__main__":
    main(file_handle)

