from baseconvert.baseconvert import BaseConverter
from baseconvert.baseconvert import base

from importlib.metadata import version, PackageNotFoundError

try:
    __version__ = version("baseconvert")
except PackageNotFoundError:
    __version__ = "unknown"
