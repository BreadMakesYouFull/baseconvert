"""Convert a number from the command line, or launch the GUI with no input.

Examples::

    python -m baseconvert -n 0.5 -i 10 -o 20 -s
    echo 3.1415926 | python -m baseconvert -i 10 -o 16 -d 3 -s
    python -m baseconvert -n 0.1 -i 3 -o 10 --no-recurring -s
"""

import argparse
import sys
from typing import Sequence

from baseconvert import DigitTuple, base


def main(argv: Sequence[str] | None = None) -> str | DigitTuple | None:
    parser = argparse.ArgumentParser(
        description="Convert rational numbers between bases."
    )
    parser.add_argument(
        "-n",
        "--number",
        default=None,
        help="The number to convert as a string; otherwise read stdin.",
    )
    parser.add_argument(
        "-i", "--input-base", type=int, default=10, help="Input base (default: 10)."
    )
    parser.add_argument(
        "-o", "--output-base", type=int, default=10, help="Output base (default: 10)."
    )
    parser.add_argument(
        "-d",
        "--max-depth",
        type=int,
        default=10,
        help="Maximum fractional digits (default: 10).",
    )
    recurring = parser.add_mutually_exclusive_group()
    recurring.add_argument(
        "-r",
        "--recurring",
        dest="recurring",
        action="store_true",
        help="Mark repeating fractional digits (the default).",
    )
    recurring.add_argument(
        "--no-recurring",
        dest="recurring",
        action="store_false",
        help="Do not mark repeating fractional digits.",
    )
    parser.set_defaults(recurring=True)
    parser.add_argument(
        "-s",
        "--string",
        action="store_true",
        help="Output the number as a string rather than a tuple.",
    )
    args = parser.parse_args(argv)

    options = {
        "string": args.string,
        "max_depth": args.max_depth,
        "recurring": args.recurring,
    }
    if args.number is not None:
        return base(args.number, args.input_base, args.output_base, **options)
    if not sys.stdin.isatty():
        number = sys.stdin.read().strip()
        return base(number, args.input_base, args.output_base, **options)

    from .gui import main as gui_main

    gui_main()
    return None


if __name__ == "__main__":
    result = main()
    if result is not None:
        print(result)
