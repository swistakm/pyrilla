# -*- coding: utf-8 -*-
import os
import sys

from setuptools import setup, Extension

from Cython.Distutils import build_ext

EXTENSIONS_INCLUDE_DIRS = ["gorilla-audio/include"]

if sys.platform in ('cygwin', 'win32'):
    LIBRARIES = ['ole32', 'oleaut32']

    if sys.platform == 'cygwin':
        EXTENSIONS_EXTRA_OBJECTS = [
            "gorilla-audio/bin/win32/Release/libgorilla.a",
        ]
    else:
        EXTENSIONS_EXTRA_OBJECTS = [
            "gorilla-audio/bin/win32/Release/gorilla.lib",
        ]

elif sys.platform == 'darwin':
    EXTENSIONS_EXTRA_OBJECTS = [
        "gorilla-audio/bin/osx/Release/libgorilla.a",
        "/System/Library/Frameworks/OpenAL.framework/OpenAL",
    ]
    LIBRARIES = []
else:  # linux
    EXTENSIONS_EXTRA_OBJECTS = [
        "gorilla-audio/bin/linux/Release/libgorilla.a"
    ]
    LIBRARIES = []


def get_version(version_tuple):
    if not isinstance(version_tuple[-1], int):
        return '.'.join(map(str, version_tuple[:-1])) + version_tuple[-1]
    return '.'.join(map(str, version_tuple))


try:
    from pypandoc import convert

    def read_md(f):
        return convert(f, 'rst')

except ImportError:
    convert = None
    print(
        "warning: pypandoc module not found, could not convert Markdown to RST"
    )

    def read_md(f):
        return open(f, 'r').read()  # noqa


init = os.path.join(os.path.dirname(__file__), 'pyrilla', '__init__.py')
version_line = list(filter(lambda l: l.startswith('VERSION'), open(init)))[0]

VERSION = get_version(eval(version_line.split('=')[-1]))
README = os.path.join(os.path.dirname(__file__), 'README.md')

setup(
    name='pyrilla',
    version=VERSION,
    packages=['pyrilla'],

    author='Michał Jaworski',
    author_email='swistakm@gmail.com',

    description="Python binding to gorilla-audio library",
    long_description=read_md(README),
    url="https://github.com/swistakm/pyrilla",

    cmdclass={'build_ext': build_ext},
    ext_modules=[
        Extension(
            "pyrilla.core", ["extensions/core.pyx"],
            include_dirs=EXTENSIONS_INCLUDE_DIRS,
            extra_objects=EXTENSIONS_EXTRA_OBJECTS,
            libraries=LIBRARIES,
        ),
    ],

    setup_requires=['cython'],

    include_package_data=True,

    license='BSD',
    classifiers=[
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',

        'Programming Language :: Cython',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.3',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: Implementation :: CPython',

        'Operating System :: MacOS :: MacOS X',
        'Operating System :: Microsoft :: Windows',
        'Operating System :: POSIX :: Linux',

        'Topic :: Multimedia :: Sound/Audio',
        'Topic :: Multimedia :: Sound/Audio :: Mixers',
        'Topic :: Multimedia :: Sound/Audio :: Players',
        'Topic :: Games/Entertainment',
    ],
)
