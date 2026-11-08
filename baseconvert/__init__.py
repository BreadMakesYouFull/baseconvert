from baseconvert.baseconvert import BaseConverter
from baseconvert.baseconvert import DigitTuple
from baseconvert.baseconvert import base

from importlib.metadata import PackageNotFoundError, version

__all__ = ["BaseConverter", "DigitTuple", "base", "__version__"]

try:
    __version__ = version("baseconvert")
except PackageNotFoundError:
    # Allow imports directly from a source checkout before installation.
    __version__ = "0+unknown"
