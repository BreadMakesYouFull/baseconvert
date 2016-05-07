from baseconvert.baseconvert import BaseConverter
from baseconvert.baseconvert import base

from os import path
_here = path.abspath(path.dirname(__file__))
_version_file = path.abspath(path.join(_here, "..", "VERSION.txt"))
with open(_version_file, "r") as f:
    _version = f.read().strip()
__version__ = _version
