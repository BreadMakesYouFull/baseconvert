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
    url="https://github.com/squdle/baseconvert.git",
    author="Joshua Deakin",
    author_email="contact@joshuadeakin.com",
    license="MIT",
    classifiers=[
    "Development Status :: 3 - Alpha",
    "Programming Language :: Python",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.0",
    "Programming Language :: Python :: 3.1",
    "Programming Language :: Python :: 3.2",
    "Programming Language :: Python :: 3.3",
    "Programming Language :: Python :: 3.4",
    "Programming Language :: Python :: 3.5",
    "Programming Language :: Python :: 3 :: Only",
    "Topic :: Education",
    "Topic :: Scientific/Engineering :: Mathematics",
    "Intended Audience :: Education",
    "License :: OSI Approved :: MIT License"
    ],
    keywords="base bases radix numeral system number hex dec bin hexidecimal\
binary decimal fraction fractions integer convert",
    packages=find_packages()
)