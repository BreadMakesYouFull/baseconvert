"""
baseconvert - Convert numbers between bases.
"""

from setuptools import setup, find_packages
from codecs import open
from os import path

here = path.abspath(path.dirname(__file__))

with open(path.join(here, "README.rst"), encoding="utf-8") as f:
    long_description = f.read()
with open(path.join(here, "VERSION.txt"), encoding="utf-8") as f:
    version = f.read().strip()

setup(
    name="baseconvert-windows",
    version="windows",
    description="Convert numbers between bases.",
    author="BreadMakesYouFull",
    packages=find_packages(),
    extras_require = {
        'gui':  ["PyQt6"]
    },
    package_data={
        "": ["*.qml"]
    },
    entry_points={
        'console_scripts': [
            'baseconvert=baseconvert.gui:main',
        ],
    },
)
