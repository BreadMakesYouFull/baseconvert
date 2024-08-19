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
    name="baseconvert",
    version=version,
    description="Convert numbers between bases.",
    long_description=long_description,
    url="https://github.com/BreadMakesYouFull/baseconvert.git",
    author="squdle, BreadMakesYouFull",
    license="MIT",
    classifiers=[
    "Programming Language :: Python",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3 :: Only",
    "Topic :: Education",
    "Topic :: Scientific/Engineering :: Mathematics",
    "Intended Audience :: Education",
    "License :: OSI Approved :: MIT License"
    ],
    keywords="base bases radix numeral system number hex dec bin hexidecimal\
binary decimal fraction fractions integer convert gui",
    packages=find_packages(),
    extras_require = {
        'gui':  ["pyside6"]
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
