#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
baseconvert
===========

Convert any rational number,
from any (positive integer) base,
to any (positive integer) base.
Output numbers as tuple or string.

- Any rational number
- Arbitrary precision
- Fractions
- Recurring/repeating fractional digits.
- Input numbers as tuple or string or number.
- Output numbers as tuple or string.

The MIT License (MIT)
Copyright (c) 2016 Joshua Deakin

www.github.com/squdle/baseconvert

contact@joshuadeakin.com

Requires Python 3.

Quickstart:

    # base(number, input_base, output_base)

    >>> base((15, 15, 0, ".", 8), 16, 10)
    (4, 0, 8, 0, '.', 5)

    >>> base("FF0.8", 16, 10, string=True)
    '4080.5'

    >>> base("4080.5", 10, 16, string=True)
    'FF0.8'

Tuple representation:

    Numbers are represented as a sequence of digits.
    Each digit is a base-10 integer value.
    The radix point, which separates  the integer and fractional parts,
    is denoted by a string period.

    (int, int, int, ... , '.', ... , int, int, int)
    (   integer part    , '.',  fractional part   )

String representation:

    String digits (after z the values are in ascending Unicode):

    0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz

    |  Value  | Representation |
    |---------|----------------|
    |  0 -  9 |    0  -  9     |
    | 10 - 53 |    A  -  Z     |
    | 36 - 61 |    a  -  z     |
    | 62 +    | unicode 123 +  |

    For bases higher than 61 it's recommended to use tuple representation.

Examples:

    # base(number, input_base, output_base)
    >>> n = (15,15,".",0,8)
    >>> base(n, 16, 10)
    (2, 5, 5, '.', 0, 3, 1, 2, 5)
    >>> base(n, 16, 10, string=True)
    '255.03125'

    >>> base("FF.08", 16, 10) == base((15,15,".",0,8), 16, 10)
    True

    # A callable BaseConverter object can also be created.
    # This is useful for when several numbers need to be converted.

    >>> b = BaseConverter(input_base=16, output_base=8)
    >>> b("FF")
    (3, 7, 7)
    >>> b((15, 15))
    (3, 7, 7)
    >>> b("FF") == b((15,15))
    True

    >>> base(0.1, 3, 10, string=True)
    '0.[3]'

Recurring digits:

    Recurring digits at the end of a fractional part will be enclosed by
    "[" and "]" in both string and tuple representation. 
    This behavior can be turned off by setting the recurring argument of base
    or BaseConverter object to False.

    >>> base("0.1", 3, 10, string=True)
    '0.[3]'
    >>> base("0.1", 3, 10, string=True, recurring=False)
    '0.3333333333'

Max fractional depth:

    Integer parts are always of arbitrary size.
    Fractional depth (number of digits) can must be specified by setting the
    max_depth argument of base or a BaseConverter object (default 10).

    >>> base("0.2", 10, 8)
    (0, '.', 1, 4, 6, 3, 1, 4, 6, 3, 1, 4)
    >>> base("0.2", 10, 8, max_depth=1)
    (0, '.', 1)
"""


# Greatest common denominator is used when converting fractions.
from fractions import gcd


class BaseConverter:
    """
    Converts numbers from any base to any other base.

    Attributes:
        input_base(int): The base to convert from.
        output_base(int): the base to convert to.
        max_depth(int): The maximum number of fractional digits (defult 10).
        string(bool): If True output will be in string representation,
            if False output will be in tuple representation (defult False).
        recurring(bool): Attempt to find repeating digits in the fractional
            part of a number. Repeated digits will be enclosed with "[" and "]"
            (default True).

    Examples:
        # Create an integer base converter, with input and output bases.
        >>> b = BaseConverter(input_base=2, output_base=10, string=True)
        >>> b("1100")
        '12'

        # Convert decimal to base-99.
        >>> b = BaseConverter(10,99,string=True)
        >>> b(10)
        'A'
        >>> b("35")
        'Z'
        >>> b((3,6))
        'a'
        >>> b(42)
        'g'

        # Convert hex to octal
        >>> b = BaseConverter(16,8,string=True)
        >>> b("4567")
        '42547'

        # Output as tuple
        >>> b = BaseConverter(16,8)
        >>> b("4567")
        (4, 2, 5, 4, 7)

        # Input as tuple
        >>> b = BaseConverter(16,8)
        >>> b((4,5,6,7))
        (4, 2, 5, 4, 7)
    """
    def __init__(self, input_base, output_base, max_depth=10,
                 string=False, recurring=True):
        self.input_base = input_base
        self.output_base = output_base
        self.max_depth = max_depth
        self.string = string
        self.recurring = recurring

    def __call__(self, number):
        """Convert a number."""
        return base(number, self.input_base, self.output_base,
                    self.max_depth, self.string, self.recurring)


def represent_as_tuple(string):
    """
    Represent a number-string in the form of a tuple of digits.
    "868.0F" -> (8, 6, 8, '.', 0, 15)

    Args:
        string - Number represented as a string of digits.
    Returns:
        Number represented as an iterable container of digits

    >>> represent_as_tuple('868.0F')
    (8, 6, 8, '.', 0, 15)
    """
    keep = (".", "[", "]")
    return tuple(str_digit_to_int(c) if c not in keep else c for c in string)


def represent_as_string(iterable):
    """
    Represent a number in the form of a string.
    (8, 6, 8, '.', 0, 15) -> "868.0F"

    Args:
        iterable - Number represented as an iterable container of digits.
    Returns:
        Number represented as a string of digits.

    >>> represent_as_string((8, 6, 8, '.', 0, 15))
    '868.0F'
    """
    keep = (".", "[", "]")
    return "".join(tuple(int_to_str_digit(i) if i not in keep
                   else i for i in iterable))


def digit(decimal, digit, input_base=10):
    """
    Find the value of an integer at a specific digit when represented in a
    particular base.

    Args:
        decimal(int): A number represented in base 10 (positive integer).
        digit(int): The digit to find where zero is the first, lowest, digit.
        base(int): The base to use (default 10).

    Returns:
        The value at specified digit in the input decimal.
        This output value is represented as a base 10 integer.

    Examples:
        >>> digit(201, 0)
        1
        >>> digit(201, 1)
        0
        >>> digit(201, 2)
        2
        >>> tuple(digit(253, i, 2) for i in range(8))
        (1, 0, 1, 1, 1, 1, 1, 1)

        # Find the lowest digit of a large hexidecimal number
        >>> digit(123456789123456789, 0, 16)
        5
    """
    if decimal == 0:
        return 0
    if digit != 0:
        return (decimal // (input_base ** digit)) % input_base
    else:
        return decimal % input_base


def digits(number, base=10):
    """
    Determines the number of digits of a number in a specific base.

    Args:
        number(int): An integer number represented in base 10.
        base(int): The base to find the number of digits.

    Returns:
        Number of digits when represented in a particular base (integer).

    Examples:
        >>> digits(255)
        3
        >>> digits(255, 16)
        2
        >>> digits(256, 16)
        3
        >>> digits(256, 2)
        9
        >>> digits(0, 678363)
        0
        >>> digits(-1, 678363)
        0
        >>> digits(12345, 10)
        5
    """
    if number < 1:
        return 0
    digits = 0
    n = 1
    while(number >= 1):
        number //= base
        digits += 1
    return digits


def integer_fractional_parts(number):
    """
    Returns a tuple of the integer and fractional parts of a number.

    Args:
        number(iterable container): A number in the following form:
            (..., ".", int, int, int, ...)

    Returns:
        (integer_part, fractional_part): tuple.

    Example:
        >>> integer_fractional_parts((1,2,3,".",4,5,6))
        ((1, 2, 3), ('.', 4, 5, 6))
    """
    radix_point = number.index(".")
    integer_part = number[:radix_point]
    fractional_part = number[radix_point:]
    return(integer_part, fractional_part)


def from_base_10_int(decimal, output_base=10):
    """
    Converts a decimal integer to a specific base.

    Args:
        decimal(int) A base 10 number.
        output_base(int) base to convert to.

    Returns:
        A tuple of digits in the specified base.

    Examples:
        >>> from_base_10_int(255)
        (2, 5, 5)
        >>> from_base_10_int(255, 16)
        (15, 15)
        >>> from_base_10_int(9988664439, 8)
        (1, 1, 2, 3, 2, 7, 5, 6, 6, 1, 6, 7)
        >>> from_base_10_int(0, 17)
        (0,)
    """
    if decimal <= 0:
        return (0,)
    if output_base == 1:
        return (1,) * decimal
    length = digits(decimal, output_base)
    converted = tuple(digit(decimal, i, output_base) for i in range(length))
    return converted[::-1]


def to_base_10_int(n, input_base):
    """
    Converts an integer in any base into it's decimal representation.

    Args:
        n - An integer represented as a tuple of digits in the specified base.
        input_base - the base of the input number.

    Returns:
        integer converted into base 10.

    Example:
        >>> to_base_10_int((8,1), 16)
        129
    """
    return sum(c * input_base ** i for i, c in enumerate(n[::-1]))


def integer_base(number, input_base=10, output_base=10):
    """
    Converts the integer part of a number from one base to another.

    Args:
        number  - An number in the following form:
            (int, int, int, ...)
            (iterable container) containing positive integers of input base.
        input_base    - The base to convert from.
        output_base   - The base to convert to.

    Returns:
        A tuple of digits.

    >>> integer_base((2, 5, 5))
    (2, 5, 5)
    >>> integer_base((2, 5, 4), 10, 16)
    (15, 14)
    >>> integer_base((2,5,5), 10, 16)
    (15, 15)
    >>> integer_base((3,1,0), 10, 16)
    (1, 3, 6)
    >>> integer_base((11, 4, 1, 8, 10), 13, 20)
    (2, 0, 8, 2, 2)
    >>> integer_base((10, 10, 1, 13), 15, 20)
    (4, 10, 1, 8)
    """
    return from_base_10_int(to_base_10_int(number, input_base), output_base)


def fractional_base(fractional_part, input_base=10, output_base=10,
                    max_depth=100):
    """
    Convert the fractional part of a number from any base to any base.

    Args:
        fractional_part(iterable container): The fractional part of a number in
            the following form:    ( ".", int, int, int, ...)
        input_base(int): The base to convert from (defualt 10).
        output_base(int): The base to convert to (default 10).
        max_depth(int): The maximum number of decimal digits to output.

    Returns:
        The converted number as a tuple of digits.

    Example:
        >>> fractional_base((".", 6,),10,16,10)
        ('.', 9, 9, 9, 9, 9, 9, 9, 9, 9, 9)
    """
    fractional_part = fractional_part[1:]
    fractional_digits = len(fractional_part)
    numerator = 0
    for i, value in enumerate(fractional_part, 1):
        numerator += value * input_base ** (fractional_digits - i)
    denominator = input_base ** fractional_digits
    i = 1
    digits = []
    while(i < max_depth + 1):
        numerator *= output_base ** i
        digit = numerator // denominator
        numerator -= digit * denominator
        denominator *= output_base ** i
        digits.append(digit)
        i += 1
        greatest_common_divisor = gcd(numerator, denominator)
        numerator //= greatest_common_divisor
        denominator //= greatest_common_divisor
    return (".",) + tuple(digits)


def truncate(n):
    """
    Removes trailing zeros.

    Args:
        n:  The number to truncate.
            This number should be in the following form:
            (..., '.', int, int, int, ..., 0)
    Returns:
        n with all trailing zeros removed

    >>> truncate((9, 9, 9, '.', 9, 9, 9, 9, 0, 0, 0, 0))
    (9, 9, 9, '.', 9, 9, 9, 9)
    >>> truncate(('.',))
    ('.',)
    """
    count = 0
    for digit in n[-1::-1]:
        if digit != 0:
            break
        count += 1
    return n[:-count] if count > 0 else n


def str_digit_to_int(chr):
    """
    Converts a string character to a decimal number.
    Where "A"->10, "B"->11, "C"->12, ...etc

    Args:
        chr(str): A single character in the form of a string.

    Returns:
        The integer value of the input string digit.
    """
    # 0 - 9
    if chr in ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9"):
        n = int(chr)
    else:
        n = ord(chr)
        # A - Z
        if n < 91:
            n -= 55
        # a - z or higher
        else:
            n -= 61
    return n


def int_to_str_digit(n):
    """
    Converts a positive integer, to a single string character.
    Where: 9 -> "9", 10 -> "A", 11 -> "B", 12 -> "C", ...etc

    Args:
        n(int): A positve integer number.

    Returns:
        The character representation of the input digit of value n (str).
    """
    # 0 - 9
    if n < 10:
        return str(n)
    # A - Z
    elif n < 36:
        return chr(n + 55)
    # a - z or higher
    else:
        return chr(n + 61)


def find_recurring(number, min_repeat=5):
    """
    Attempts to find repeating digits in the fractional component of a number.

    Args:
        number(tuple): the number to process in the form:
            (int, int, int, ... ".", ... , int int int)
        min_repeat(int): the minimum number of times a pattern must occur to be
            defined as recurring. A min_repeat of n would mean a pattern must
            occur at least n + 1 times, so as to be repeated n times.

    Returns:
        The original number with repeating digits (if found) enclosed by  "["
        and "]" (tuple).

    Examples:
        >>> find_recurring((3, 2, 1, '.', 1, 2, 3, 1, 2, 3), min_repeat=1)
        (3, 2, 1, '.', '[', 1, 2, 3, ']')
    """
    # Return number if it has no fractional part, or min_repeat value invalid.
    if "." not in number or min_repeat < 1:
        return number
    # Seperate the number into integer and fractional parts.
    integer_part, fractional_part = integer_fractional_parts(number)
    # Reverse fractional part to get a sequence.
    sequence = fractional_part[::-1]
    # Initialize counters
    # The 'period' is the number of digits in a pattern.
    period = 0
    # The best pattern found will be stored.
    best = 0
    best_period = 0
    best_repeat = 0
    # Find recurring pattern.
    while (period < len(sequence)):
        period += 1
        pattern = sequence[:period]
        repeat = 0
        digit = period
        pattern_match = True
        while(pattern_match and digit < len(sequence)):
            for i, pattern_digit in enumerate(pattern):
                if sequence[digit + i] != pattern_digit:
                    pattern_match = False
                    break
            else:
                repeat += 1
            digit += period
        # Give each pattern found a rank and use the best.
        rank = period * repeat
        if rank > best:
            best_period = period
            best_repeat = repeat
            best = rank
    # If the pattern does not repeat often enough, return the original number.
    if best_repeat < min_repeat:
        return number
    # Use the best pattern found.
    pattern = sequence[:best_period]
    # Remove the pattern from our original number.
    number = integer_part + fractional_part[:-(best + best_period)]
    # Ensure we are at the start of the pattern.
    pattern_temp = pattern
    for i, digit in enumerate(pattern):
        if number[-1] == digit:
                number = number[:-1]
                pattern_temp = pattern_temp[1:] + (pattern_temp[0],)
    pattern = pattern_temp
    # Return the number with the recurring pattern enclosed with '[' and ']'.
    return number + ("[",) + pattern[::-1] + ("]",)


def expand_recurring(number, repeat=5):
    """
    Expands a recurring pattern within a number.

    Args:
        number(tuple): the number to process in the form:
            (int, int, int, ... ".", ... , int int int)
        repeat: the number of times to expand the pattern.

    Returns:
        The original number with recurring pattern expanded.

    Example:
        >>> expand_recurring((1, ".", 0, "[", 9, "]"), repeat=3)
        (1, '.', 0, 9, 9, 9, 9)
    """
    if "[" in number:
        pattern_index = number.index("[")
        pattern = number[pattern_index + 1:-1]
        number = number[:pattern_index]
        number = number + pattern * (repeat + 1)
    return number


def check_valid(number, input_base=10):
    """
    Checks if there is an invalid digit in the input number.

    Args:
        number: An number in the following form:
            (int, int, int, ... , '.' , int, int, int)
            (iterable container) containing positive integers of the input base
        input_base(int): The base of the input number.

    Returns:
        bool, True if all digits valid, else False.

    Examples:
        >>> check_valid((1,9,6,'.',5,1,6), 12)
        True
        >>> check_valid((8,1,15,9), 15)
        False
    """
    for n in number:
        if n in (".", "[", "]"):
            continue
        elif n >= input_base:
            if n == 1 and input_base == 1:
                continue
            else:
                return False
    return True


def base(number, input_base=10, output_base=10, max_depth=10,
         string=False, recurring=True):
    """
    Converts a number from any base to any another.

    Args:
        number(tuple|str|int): The number to convert.
        input_base(int): The base to convert from (defualt 10).
        output_base(int): The base to convert to (default 10).
        max_depth(int): The maximum number of fractional digits (defult 10).
        string(bool): If True output will be in string representation,
            if False output will be in tuple representation (defult False).
        recurring(bool): Attempt to find repeating digits in the fractional
            part of a number. Repeated digits will be enclosed with "[" and "]"
            (default True).
    Returns:
        A tuple of digits in the specified base:
        (int, int, int, ... , '.' , int, int, int)
        If the string flag is set to True,
        a string representation will be used instead.

    Raises:
        ValueError if a digit value is too high for the input_base.

    Example:
        >>> base((1,9,6,'.',5,1,6), 17, 20)
        (1, 2, 8, '.', 5, 19, 10, 7, 17, 2, 13, 13, 1, 8)
    """
    # Convert number to tuple representation.
    if type(number) == int or type(number) == float:
        number = str(number)
    if type(number) == str:
        number = represent_as_tuple(number)
    # Check that the number is valid for the input base.
    if not check_valid(number, input_base):
        raise ValueError
    # Deal with base-1 special case
    if input_base == 1:
        number = (1,) * number.count(1)
    # Expand any recurring digits.
    number = expand_recurring(number, repeat=5)
    # Convert a fractional number.
    if "." in number:
        radix_point = number.index(".")
        integer_part = number[:radix_point]
        fractional_part = number[radix_point:]
        integer_part = integer_base(integer_part, input_base, output_base)
        fractional_part = fractional_base(fractional_part, input_base,
                                          output_base, max_depth)
        number = integer_part + fractional_part
        number = truncate(number)
    # Convert an integer number.
    else:
        number = integer_base(number, input_base, output_base)
    if recurring:
        number = find_recurring(number, min_repeat=2)
    # Return the converted number as a srring or tuple.
    return represent_as_string(number) if string else number


if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
