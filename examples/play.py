# -*- coding: utf-8 -*-
from sys import argv
from pyrilla import internal


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

        internal.play(filename, ext)


if __name__ == "__main__":
    main()
