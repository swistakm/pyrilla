.. pyrilla documentation master file, created by
   sphinx-quickstart on Thu Oct 22 00:09:25 2015.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

pyrilla documentation
=====================

pyrilla is a self-contained statically linked binding to
gorilla-audio_ library - "an attempt to make a free, straightforward,
cross-platform, high-level software audio mixer that supports playback of both
static and streaming sounds". Like the original it is intended for video
game development.

pyrilla's goal is to provide a python audio package that can be installed
without any external dependencies with single ``pip install pyrilla`` command.
It is built with cython and its API is inspired by part of great but
unmantained bacon_ game engine.

.. _gorilla-audio: https://code.google.com/p/gorilla-audio/
.. _bacon: https://github.com/aholkner/bacon


Status of this library
----------------------

pyrilla still lacks some of gorilla-audio_ features (like streaming sounds)
but already provides those that should be a minimum for playing and
controling sounds for the need of simple game engines.

Binary packages ara available for both OS X and Windows (32bit). More of them
as well as installable source distribution (through pip) will be available in
future if there will be any interest from users.


Documentation
-------------

Pyrilla is under development and not all features may be completely
documented. This page tries to cover most of the topics but if something is
missing then it should be at least covered in `code samples`_ available in
pyrilla code repository.
Contents:

.. toctree::
   :maxdepth: 2

   usage

.. _`code samples`: https://github.com/swistakm/pyrilla/tree/master/examples


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

