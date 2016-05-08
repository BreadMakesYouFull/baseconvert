from baseconvert import base


import sys
import argparse


def main():
    """
    Main entry point for running baseconvert as a command.

    Examples:

        $ python -m baseconvert -n 0.5 -i 10 -o 20 -s True
        0.A

        $ echo 3.1415926 | python -m baseconvert -i 10 -o 16 -d 3 -s True
        3.243
    """
    # Parse arguments
    parser = argparse.ArgumentParser(description="Convert rational numbers between bases.")
    parser.add_argument("-n", "--number", default=None,
                        help="The number to convert as a string, else stdin used.")
    parser.add_argument("-i", "--input-base", default=10,
                        help="The input base (default 10).")
    parser.add_argument("-o", "--output-base", default=10,
                        help="The output base (default 10).")
    parser.add_argument("-d", "--max_depth", default=10, type=int,
                        help="The maximum fractional digits (default 10).")
    parser.add_argument("-r", "--recurring", default=True, type=bool,
                        help="Boolean, if True will attempt to find recurring decimals (default True).")
    parser.add_argument("-s", "--string", type=bool,
                        help="Boolean, if True will output number as String, else as tuple (default False).")
    args = parser.parse_args()

    args.input_base = float(args.input_base)
    args.output_base = float(args.output_base)
    if args.input_base == int(args.input_base):
        args.input_base = int(args.input_base)
    if args.output_base == int(args.output_base):
        args.output_base = int(args.output_base)
    if (args.number):
        return base(args.number, args.input_base, args.output_base, string=args.string, max_depth=args.max_depth, recurring=args.recurring)
    elif not sys.stdin.isatty():
        return base(sys.stdin.read().strip(), args.input_base, args.output_base, string=args.string, max_depth=args.max_depth, recurring=args.recurring)
    else:
        raise ValueError("Please input a number!")

if __name__ == "__main__":
    print(main())