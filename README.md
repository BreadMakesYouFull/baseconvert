baseconvert
===========

Convert rational numbers between bases.

![](./preview.gif)

[https://github.com/BreadMakesYouFull/baseconvert](https://github.com/BreadMakesYouFull/baseconvert)

<a href='https://flathub.org/apps/io.github.breadmakesyoufull.baseconvert'>
  <img width='128' alt='Get it on Flathub' src='https://flathub.org/api/badge?locale=en'/>
  Linux install via flatpak
</a>

<a href='https://github.com/BreadMakesYouFull/baseconvert/releases/tag/windows'><img width='128' alt='Windows exe' src='https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white'/> Windows install via pyqt under GPLv3</a>

[![PyPI version](https://badge.fury.io/py/baseconvert.svg)](https://pypi.org/project/baseconvert/) [Python install](https://pypi.org/project/baseconvert/)

[![](https://github.com/breadmakesyoufull/baseconvert/actions/workflows/lint-then-test.yml/badge.svg)](https://github.com/BreadMakesYouFull/baseconvert/actions/workflows/lint-then-test.yml)

## Install

Requires:
* Python 3
* PySide6 for the GUI

```
# Install from PyPI via pip
# Without the GUI:
pip install baseconvert
# With the GUI:
pip install baseconvert[gui]

# ...or install from source
git clone https://github.com/BreadMakesYouFull/baseconvert
python -m venv venv
# With GUI
./venv/bin/pip install .[gui]
# Without GUI
./venv/bin/pip install .
```

## Run UI

```
baseconvert
```

## Python Library

Convert rational numbers between positive integer bases. The library accepts
numbers as strings, digit tuples, integers, floats, or `Fraction` objects, and
returns a digit tuple or string.

```python
from baseconvert import base

base("FF0.8", 16, 10, string=True)  # '4080.5'
base("4080.5", 10, 16, string=True)  # 'FF0.8'
base("-0.1", 3, 10, string=True, exact=True)  # '-0.[3]'
```

Or from the command line:

```sh
echo 4080.5 | python -m baseconvert -i 10 -o 16
python -m baseconvert -n 4080.5 -i 10 -o 16
```

### Digit representation

String digits are `0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz`.
Values above 61 use ascending Unicode characters; for bases above 61, tuple
representation is recommended. In a tuple, each digit is a base-10 integer and
the radix point is `'.'`. A leading `'-'` represents a negative value.

### Recurring digits and precision

Recurring fractional digits are enclosed in square brackets, for example
`0.[3]`. Set `recurring=False` to return an unmarked expansion. `max_depth`
limits the number of fractional digits (10 by default). Set `exact=True` or
`max_depth=0` to calculate the complete terminating or repeating expansion
when recurring output is enabled. Exact recurring detection uses rational
remainders and is not limited by `MAX_DEPTH`. If recurring output is disabled,
`MAX_DEPTH` bounds an unlimited expansion. Integer conversions are exact.
