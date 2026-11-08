baseconvert
===========

Convert rational numbers between positive integer bases, with exact
arithmetic and recurring fractional digits.

Requires Python 3.10 or newer.

Install
-------

Install the library from PyPI::

    python -m pip install baseconvert

For the GUI, install the optional dependencies and launch the application::

    python -m pip install 'baseconvert[gui]'
    baseconvert

Run from a source checkout
--------------------------

Install `just <https://just.systems/>`_, clone the repository, and run
``just launch``. The recipe creates ``.venv`` and installs the GUI extra if
the launcher or PySide6 QML module is missing, then starts the GUI::

    git clone https://github.com/BreadMakesYouFull/baseconvert.git
    cd baseconvert
    just launch

Development
-----------

Useful recipes from the repository root::

    just install       # editable install in .venv
    just install-gui   # editable install with GUI dependencies
    just check         # lint, doctests, and check existing dist/* files
    just build         # clean and build sdist and wheel
    just check-dist    # build and validate distributions
    just clean         # remove build artifacts and .venv

``just publish-test`` and ``just publish`` upload ``dist/*`` to TestPyPI and
PyPI, respectively. Check the distributions and run ``just check-dist`` before
publishing. The current publish recipes run ``just check`` but do not build
distributions themselves.

Python library
--------------

The API accepts strings, digit tuples, integers, floats, and
``fractions.Fraction`` values. Use strings or ``Fraction`` to express exact
decimal values without float representation concerns::

    from baseconvert import base

    base("FF0.8", 16, 10, string=True)  # '4080.5'
    base("4080.5", 10, 16, string=True)  # 'FF0.8'
    base("-0.1", 3, 10, string=True, exact=True)  # '-0.[3]'

The command-line interface reads a number argument or standard input. Bases
are integers; ``-s`` prints a string, and ``--no-recurring`` disables
recurring notation::

    python -m baseconvert -n 4080.5 -i 10 -o 16 -s
    echo 0.1 | python -m baseconvert -i 3 -o 10 --no-recurring -s

Digits, recurring fractions, and precision
-----------------------------------------

String digits are
``0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz``. Values
above 61 use ascending Unicode characters; tuple representation is
recommended for bases above 61. In a digit tuple, each digit is a base-10
integer and the radix point is ``'.'``. A leading ``'-'`` represents a
negative value.

Recurring digits are enclosed in square brackets, for example ``0.[3]``.
``max_depth`` limits fractional digits (default 10). Set ``exact=True`` or
``max_depth=0`` to calculate the complete terminating or repeating expansion
when recurring output is enabled. Exact recurring detection uses rational
remainders. With recurring output disabled, an unlimited expansion is bounded
by ``MAX_DEPTH``.
