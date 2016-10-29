# -*- coding: utf-8 -*-
VERSION = (0, 0, 2)  # PEP 386
__version__ = ".".join([str(x) for x in VERSION])


from pyrilla.core import (
    Sound,
    Voice,
    Mixer,
    Manager,
)
