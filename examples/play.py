# -*- coding: utf-8 -*-
from sys import argv
from pyrilla import internal
from time import sleep

def finished(*args):
    print("finished")

go_on = False

def main():
    if len(argv) != 2:
        print """
        usage: program filename"
        """
        exit(1)
    else:
        filename = argv[1]
        ext = filename.rpartition('.')[2]

        print("will load %s as %s" % (filename, ext))
        s = internal.Sound(filename, ext)

        s.play(on_finish=finished)

        try:
            while True:
                internal.update()
                sleep(0.001)
        except KeyboardInterrupt:
            print("quiting")

if __name__ == "__main__":
    main()
