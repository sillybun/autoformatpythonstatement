#build the modules

from distutils.core import setup, Extension
import sys

# xtra_link_args=["-stdlib=libc++", "-mmacosx-version-min=10.9"]

if sys.platform == "darwin":
    setup(name='afpython', version='1.0', ext_modules=[Extension('afpython', ['afpython.cpp'], extra_link_args=["-stdlib=libc++", "-mmacosx-version-min=10.9"])])
else:
    setup(name='afpython', version='1.0', ext_modules=[Extension('afpython', ['afpython.cpp'], extra_link_args=[])])
