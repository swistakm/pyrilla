# -*- coding: utf-8 -*-
from time import sleep
from pyrilla import core

from base import main


def file_handle(filename, ext):
    # note: low buffer settings that drop audio quality
    #       for ilustratory reasons
    manager = core.Manager(
        thread_policy=core.THREAD_MULTI,
    )
    mixer = core.Mixer(manager)

    sound = core.Sound(filename, ext)
    voice = core.Voice(sound, loop=True, mixer=mixer)

    voice.play()

    try:
        while True:
            # note: we use multiple thread policy so no need for manual
            #       update on manager. We can sleep indifinitely
            sleep(1.001)
    except KeyboardInterrupt:
        print("interrupted")

if __name__ == "__main__":
    main(file_handle)

