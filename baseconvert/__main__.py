from baseconvert import base


import sys
import argparse


def main():
    """
    Main entry point for running baseconvert as a command.

    Examples:

        $ python -m baseconvert -n 0.5 -i 10 -o 20
        0.A

        $ echo 3.1415926 | python -m baseconvert -i 10 -o 16 -d 3
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
    args = parser.parse_args()

    args.input_base = float(args.input_base)
    args.output_base = float(args.output_base)
    if args.input_base == int(args.input_base):
        args.input_base = int(args.input_base)
    if args.output_base == int(args.output_base):
        args.output_base = int(args.output_base)
    if (args.number):
        return base(args.number, args.input_base, args.output_base, string=True, max_depth=args.max_depth)
    else:
        return base(sys.stdin.read().strip(), args.input_base, args.output_base, string=True, max_depth=args.max_depth)

if __name__ == "__main__":
    print(main())