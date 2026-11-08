# baseconvert

Convert rational numbers between positive integer bases, with exact arithmetic and recurring fractional digits.

![baseconvert preview](./preview.gif)

[![PyPI version](https://badge.fury.io/py/baseconvert.svg)](https://pypi.org/project/baseconvert/) · [PyPI](https://pypi.org/project/baseconvert/) · [Flathub](https://flathub.org/apps/io.github.breadmakesyoufull.baseconvert) · [Windows release](https://github.com/BreadMakesYouFull/baseconvert/releases/tag/windows)

## Install

Install the library from PyPI:

```sh
python -m pip install baseconvert
```

For the GUI, install the optional GUI dependencies:

```sh
python -m pip install 'baseconvert[gui]'
baseconvert
```

## Run from a source checkout

Install [`just`](https://just.systems/), then clone the repository and launch the GUI. The `launch` recipe creates `.venv`, installs the project with GUI dependencies, and starts the app:

```sh
git clone https://github.com/BreadMakesYouFull/baseconvert.git
cd baseconvert
just launch
```

Useful development recipes:

```sh
just install       # editable install in .venv
just install-gui   # editable install with GUI dependencies
just check         # lint and run doctests
just clean         # remove build artifacts
just build         # build sdist and wheel
just check-dist    # build and validate distributions
```

For a manual release, `just publish-test` uploads to TestPyPI and `just publish` uploads to PyPI. Review the built files and test them before publishing a release.

## Python library

The API accepts strings, digit tuples, integers, floats, and `fractions.Fraction` values. Use strings or `Fraction` when you want to express an exact decimal value without float representation concerns.

```python
from baseconvert import base

base("FF0.8", 16, 10, string=True)  # '4080.5'
base("4080.5", 10, 16, string=True)  # 'FF0.8'
base("-0.1", 3, 10, string=True, exact=True)  # '-0.[3]'
```

The command-line interface can read from an argument or standard input:

```sh
python -m baseconvert -n 4080.5 -i 10 -o 16
echo 4080.5 | python -m baseconvert -i 10 -o 16
```

## Digits, recurring fractions, and precision

String digits are `0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz`. Values above 61 use ascending Unicode characters; tuple representation is recommended for bases above 61. In a digit tuple, each digit is a base-10 integer and the radix point is `'.'`. A leading `'-'` represents a negative value.

Recurring digits are enclosed in square brackets, for example `0.[3]`. `max_depth` limits the number of fractional digits (default 10). Set `exact=True` or `max_depth=0` to calculate the complete terminating or repeating expansion when recurring output is enabled. Exact recurring detection uses rational remainders. When recurring output is disabled, an unlimited expansion is bounded by `MAX_DEPTH`.
