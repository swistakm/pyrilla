# -*- coding: utf-8 -*-
from pyrilla import core

from base import main, update_till_interrupt

again = 0


def file_handle(filename, ext):
    sound = core.Sound(filename, ext)
    voice = core.Voice(sound, loop=True)

    voice.play()

    def on_interrupt():
        """
        Handle subsequent keyboard interrupts:
        * 1st - toggle voice
        * 2nd - toggle voice again
        * 3rd - quit
        """
        global again

        if again >= 2:
            print("quiting")
            quit()

        else:
            again += 1
            voice.toggle()

    print(on_interrupt.__doc__)

    update_till_interrupt(on_interrupt)


if __name__ == "__main__":
    main(file_handle)
