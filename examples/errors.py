# -*- coding: utf-8 -*-
from pyrilla.errors import SoundIOError, DeviceNotSupportedError
from pyrilla import Manager, Sound


def main():
    try:
        Manager(5)
    except DeviceNotSupportedError as err:
        print(str(err))

    try:
        Sound(b"nonexisting.foo", b"ridiculous")
    except SoundIOError as err:
        print(str(err))


if __name__ == "__main__":
    main()
