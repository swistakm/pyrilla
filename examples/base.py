# -*- coding: utf-8 -*-
from sys import argv
from time import sleep

from pyrilla import core


def main(file_handle):
    if len(argv) != 2:
        print """
        usage: program filename"
        """
        exit(1)

    else:
        filename = argv[1]
        ext = filename.rpartition('.')[2]

        print("will load %s as %s" % (filename, ext))
        file_handle(filename, ext)


def update_till_interrupt(on_interrupt=None):
    while True:
        try:
            core.update()
            sleep(0.001)
        except KeyboardInterrupt:
            print("interrupted")

            if on_interrupt:
                on_interrupt()
            else:
                print("unhandled")
                break

