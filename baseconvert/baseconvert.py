#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
baseconvert
===========

Convert any non-negative rational number,
from any base to any base.
Return result as tuple or string.

- Bases may be any integer at least 2.
- Converts any non-negative rational number.
- Allows arbitrary (but not unbounded) precision.
- Value to be converted may be represented in a tuple format or in a string
  format or may be any of the numeric types corresponding to rational numbers.
- Converted value may be represented in a tuple of string format.
- Command-line or interpreter interaction.

The MIT License (MIT)
Copyright (c) 2016 Joshua Deakin

www.github.com/squdle/baseconvert

contact@joshuadeakin.com

Requires Python 3.

Quickstart:

    # base(number, input_base, output_base)

    >>> base((15, 15, 0, ".", 8), input_base=16, output_base=10)
    (4, 0, 8, 0, '.', 5)

    >>> base("FF0.8", input_base=16, output_base=10, string=True)
    '4080.5'

    >>> base("4080.5", input_base=10, output_base=16, string=True)
    'FF0.8'

Tuple representation:

    Numbers are represented as a sequence of digits.
    Each digit is an int.
    The radix point, which separates  the integer and fractional parts,
    is denoted by a '.'.

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
    >>> base(n, input_base=16, output_base=10)
    (2, 5, 5, '.', 0, 3, 1, 2, 5)
    >>> base(n, input_base=16, output_base=10, string=True)
    '255.03125'

    >>> base("FF.08", 16, 10) == base((15,15,".",0,8), 16, 10)
    True

    # A callable BaseConverter object can also be created.
    # This is useful for when several numbers need to be converted.
    # The BaseConverter initializer accepts the same flags as base().

    >>> b = BaseConverter(input_base=16, output_base=8)
    >>> b("FF")
    (3, 7, 7)
    >>> b((15, 15))
    (3, 7, 7)
    >>> b("FF") == b((15,15))
    True

    When converting a value, such as a floating point number, rather than
    the representation of a value, such as a string or tuple, the
    input_base is irrelevant.

    >>> base(0.1, output_base=8, string=True)
    '0.0631463146'

    If using a string, the input base is required, and, since
    the value of a floating point number is not, in general, equal to
    the value of its string representation, the result is not, for this
    example, the same.

    >>> base("0.1", input_base=10, output_base=8, string=True)
    '0.0[6314]'



Recurring digits:

    The repeating sequence of digits at the end of a fractional part
    is enclosed by "[" and "]" in both string and tuple representation.
    This behavior can be turned off by setting the recurring argument of base
    or a BaseConverter object to False.

    >>> base("0.1", input_base=3, output_base=10, string=True)
    '0.[3]'
    >>> base("0.1", input_base=3, output_base=10, string=True, recurring=False)
    '0.3333333333'

Max fractional depth:

    Integer parts are always of arbitrary size.
    Fractional depth (number of digits) are specified by setting the
    max_depth argument of base or a BaseConverter object (default 10).

    >>> base("0.2", input_base=10, output_base=8, max_depth=1)
    (0, '.', 1)

    If the length of the complete representation of the fractional part
    is less than max_depth, the entire value is shown.

    >>> base("0.2", input_base=10, output_base=8)
    (0, '.', '[', 1, 4, 6, 3, ']')

    This behavior can be changed by setting the recurring parameter to False.

    >>> base("0.2", input_base=10, output_base=8, recurring=False)
    (0, '.', 1, 4, 6, 3, 1, 4, 6, 3, 1, 4)

    When rounding is necessary, the direction of rounding is always toward 0.
"""


from fractions import Fraction

from itertools import dropwhile

from numbers import Number

from justbases import Radices
from justbases import Radix
from justbases import RoundingMethods


class BaseConverter:
    """
    Converts numbers from any base to any other base.

    Attributes:
        input_base(int): The base to convert from.
        output_base(int): the base to convert to.
        max_depth(int): The maximum number of fractional digits (default 10).
        string(bool): If True output will be in string representation,
            if False output will be in tuple representation (defult False).
        recurring(bool): Show repeating part, if obtained.
            The repeating part is enclosed with "[" and "]"
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
        >>> b(98)
        '\x9f'

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
    Converts a non-negative integer, to a single string character.
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


def check_valid(number, input_base=10):
    """
    Checks if there is an invalid value among the values in the input tuple.

    Args:
        number: A tuple in the following form:
            (int, int, int, ... , '.' , int, int, int)
            (iterable container) containing non-negative integers of the input base
        input_base(int): The base of the input number.

    Returns:
        bool, True if all digits valid, else False.

    Examples:
        >>> check_valid((1,9,6,'.',5,1,6), 12)
        True
        >>> check_valid((8,1,15,9), 15)
        False
        >>> check_valid((8,0,15,9), 16)
        True
        >>> check_valid((), 2)
        True
        >>> check_valid(('[', ']'), 2)
        True
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


def tuple_to_radix(value, base):
    """
    Converts a tuple to a radix.

    Args:
        value(tuple): the value to convert
        base: the base of the value, must be an integer at least 2

    Returns:
        a corresponding Radix value
    """

    def sign(ls):
        """
        Get a sign based on values.

        Args:
           ls(list): a list, presumably of integers

        Returns:
            an int, 1 if number is positive, 0 if number is zero
        """
        return 1 if any(x != 0 for x in ls) else 0

    integer_part = []
    non_repeating_part = []
    repeating_part = []
    radix = '.'
    marker = '['

    value = list(value)

    if radix in value:
        index = value.index(radix)
        (integer_part, fractional_part) = (value[:index], value[index + 1:])
        if marker in fractional_part:
            index = fractional_part.index(marker)
            non_repeating_part = fractional_part[:index]
            repeating_part = fractional_part[index + 1:-1]
        else:
            non_repeating_part = fractional_part
    else:
        integer_part = value

    return Radix(
       sign(integer_part + non_repeating_part + repeating_part),
       integer_part,
       non_repeating_part,
       repeating_part,
       base
    )


def radix_to_tuple(radix, relation):
    """
    Converts a radix to a tuple form.

    Args:
        radix(Radix): the radix value, must be non-negative

    Returns:
        a tuple of characters and non-negative integers
    """
    assert radix.sign != -1

    integer_part = radix.integer_part
    if integer_part == []:
        integer_part = [0]

    if radix.non_repeating_part == [] and radix.repeating_part == []:
        result = integer_part
    elif radix.repeating_part == []:
        non_repeating_part = radix.non_repeating_part
        if relation == 0:
            non_repeating_part = reversed(non_repeating_part)
            non_repeating_part = \
               reversed(list(dropwhile(lambda x: x == 0, non_repeating_part)))
        result = integer_part + ['.'] + list(non_repeating_part)
    else:
        result = \
           integer_part + \
           ['.'] + \
           radix.non_repeating_part + \
           ['['] + \
           radix.repeating_part + \
           [']']

    return tuple(result)


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
        recurring(bool): Show repeating part, if obtained.
            The repeating part is enclosed with "[" and "]"
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
        >>> base("0.[1]", 3, 2)
        (0, '.', 1)
    """
    if isinstance(number, Number):
        if number < 0:
            raise ValueError
        (radix, relation) = Radices.from_rational(
           Fraction(number),
           output_base,
           precision=max_depth,
           method=RoundingMethods.ROUND_DOWN,
           expand_repeating=not recurring
        )
    else:
        if isinstance(number, str):
            number_tuple = represent_as_tuple(number)
        else:
            number_tuple = number

        if not check_valid(number_tuple, input_base):
            raise ValueError

        radix = tuple_to_radix(number_tuple, input_base).in_base(output_base)
        fraction_length = \
           len(radix.non_repeating_part) + len(radix.repeating_part)
        if not recurring or fraction_length > max_depth:
            (radix, relation) = \
               radix.rounded(max_depth, RoundingMethods.ROUND_DOWN)
        else:
            relation = 0

    result = radix_to_tuple(radix, relation)
    return represent_as_string(result) if string else result


if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
