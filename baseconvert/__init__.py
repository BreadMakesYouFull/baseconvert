from baseconvert.baseconvert import BaseConverter
from baseconvert.baseconvert import base

from importlib.metadata import PackageNotFoundError, version

try:
    __version__ = version("baseconvert")
except PackageNotFoundError:
    # Allow imports directly from a source checkout before installation.
    __version__ = "0+unknown"
