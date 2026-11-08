from baseconvert import base

import argparse
import sys


def main():
    """Convert a number from the command line, or launch the GUI with no input."""
    parser = argparse.ArgumentParser(
        description="Convert rational numbers between bases."
    )
    parser.add_argument(
        "-n",
        "--number",
        default=None,
        help="The number to convert as a string, else stdin is used.",
    )
    parser.add_argument(
        "-i", "--input-base", type=int, default=10, help="Input base (default 10)."
    )
    parser.add_argument(
        "-o", "--output-base", type=int, default=10, help="Output base (default 10)."
    )
    parser.add_argument(
        "-d",
        "--max-depth",
        type=int,
        default=10,
        help="Maximum fractional digits (default 10).",
    )
    recurring = parser.add_mutually_exclusive_group()
    recurring.add_argument(
        "-r", "--recurring", dest="recurring", action="store_true",
        help="Mark repeating fractional digits (the default).",
    )
    recurring.add_argument(
        "--no-recurring", dest="recurring", action="store_false",
        help="Do not mark repeating fractional digits.",
    )
    parser.set_defaults(recurring=True)
    parser.add_argument(
        "-s",
        "--string",
        action="store_true",
        help="Output the number as a string rather than a tuple.",
    )
    args = parser.parse_args()

    if args.number is not None:
        return base(
            args.number,
            args.input_base,
            args.output_base,
            string=args.string,
            max_depth=args.max_depth,
            recurring=args.recurring,
        )
    if not sys.stdin.isatty():
        return base(
            sys.stdin.read().strip(),
            args.input_base,
            args.output_base,
            string=args.string,
            max_depth=args.max_depth,
            recurring=args.recurring,
        )

    from .gui import main as gui_main

    gui_main()


if __name__ == "__main__":
    result = main()
    if result is not None:
        print(result)
