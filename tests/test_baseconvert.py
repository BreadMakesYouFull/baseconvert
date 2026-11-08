from fractions import Fraction

import pytest

from baseconvert.baseconvert import (
    BaseConverter,
    check_valid,
    digit,
    digits,
    expand_recurring,
    find_recurring,
    fractional_base,
    from_base_10_int,
    int_to_str_digit,
    integer_base,
    integer_fractional_parts,
    pad,
    represent_as_string,
    represent_as_tuple,
    str_digit_to_int,
    to_base_10_int,
    truncate,
    base,
)


@pytest.mark.parametrize(
    ("number", "input_base", "output_base", "expected"),
    [
        ("FF0.8", 16, 10, "4080.5"),
        ("4080.5", 10, 16, "FF0.8"),
        ("0.1", 3, 10, "0.[3]"),
        ("0.3", 10, 2, "0.0[1001]"),
        ("-FF.8", 16, 10, "-255.5"),
        ("+10", 10, 2, "1010"),
    ],
)
def test_base_string_conversions(number, input_base, output_base, expected):
    assert base(number, input_base, output_base, string=True, exact=True) == expected


def test_base_returns_digit_tuple_by_default():
    assert base("FF0.8", 16, 10) == (4, 0, 8, 0, ".", 5)


def test_base_accepts_fraction_int_float_and_digit_iterable():
    assert base(Fraction(1, 3), 10, 10, string=True, exact=True) == "0.[3]"
    assert base(255, 10, 16, string=True) == "FF"
    assert base(0.5, 10, 2, string=True, exact=True) == "0.1"
    assert base(("-", 1, 0, ".", 1), 2, 10, string=True) == "-2.5"


def test_max_depth_and_recurring_option():
    assert base("0.2", 10, 8, string=True, max_depth=1) == "0.1"
    assert base("0.1", 3, 10, string=True, recurring=False, max_depth=5) == "0.33333"
    assert base("0.1", 3, 10, string=True, recurring=False, max_depth=0) == "0." + "3" * 128


def test_exact_option_matches_unbounded_depth():
    assert base("0.125", 10, 16, string=True, exact=True) == "0.2"


def test_padding_preserves_sign_and_radix():
    assert base("-12.5", 10, 10, string=True, padding=4) == "-0012.5"
    assert base("12", 10, 10, padding=4) == ("0", "0", 1, 2)


def test_unary_base_integer_conversions():
    assert base("111", 1, 10, string=True) == "3"
    assert base("-111", 1, 10, string=True) == "-3"
    assert base(4, 10, 1, string=True) == "1111"
    assert base(0, 10, 1, string=True) == "0"


@pytest.mark.parametrize(
    ("number", "input_base"),
    [
        ("2", 2),
        ("1.0", 1),
        ("0.[", 10),
        ("0.[]", 10),
        ("0.1]", 10),
        ("0.1.2", 10),
        ("-1+", 10),
    ],
)
def test_invalid_numerals_raise_value_error(number, input_base):
    with pytest.raises(ValueError):
        base(number, input_base)


def test_invalid_bases_raise_value_error():
    with pytest.raises(ValueError):
        base("1", 0, 10)
    with pytest.raises(ValueError):
        base("1", 10, 0)


def test_base_one_cannot_represent_fractional_output():
    with pytest.raises(ValueError, match="fractional values"):
        base("0.5", 10, 1)


def test_baseconverter_callable_and_exact_option():
    converter = BaseConverter(16, 10, string=True, exact=True)
    assert converter("FF0.8") == "4080.5"


def test_digit_conversion_helpers():
    assert digit(201, 0) == 1
    assert digit(201, 1) == 0
    assert digit(0, 5) == 0
    assert digits(255, 16) == 2
    assert digits(0) == 0
    assert from_base_10_int(255, 16) == (15, 15)
    assert from_base_10_int(-255, 16) == ("-", 15, 15)
    assert to_base_10_int(("-", 15, 15), 16) == -255
    assert integer_base((2, 5, 5), 10, 16) == (15, 15)


def test_digit_string_conversion_helpers():
    assert represent_as_tuple("868.0F") == (8, 6, 8, ".", 0, 15)
    assert represent_as_string((8, 6, 8, ".", 0, 15)) == "868.0F"
    assert str_digit_to_int("A") == 10
    assert str_digit_to_int("a") == 36
    assert str_digit_to_int("{") == 62
    assert int_to_str_digit(10) == "A"
    assert int_to_str_digit(36) == "a"


def test_padding_and_fraction_helpers():
    assert pad("A", 2) == "0A"
    assert pad("A.01", 2) == "0A.01"
    assert pad(("A", ".", 0), 2) == ("0", "A", ".", 0)
    assert integer_fractional_parts((1, 2, ".", 3, 4)) == ((1, 2), (".", 3, 4))
    assert fractional_base((".", 5), 10, 2, 4) == (".", 1)
    assert truncate((1, ".", 2, 0, 0)) == (1, ".", 2)
    assert truncate((1, ".")) == (1, ".")


def test_recurring_compatibility_helpers():
    assert find_recurring((1, 2, ".", 1, 2, 1, 2, 1, 2), min_repeat=2) == (
        1,
        2,
        ".",
        "[",
        1,
        2,
        1,
        2,
        1,
        2,
        "]",
    )
    assert find_recurring((1, 2, ".", 1, 2, 3), min_repeat=2) == (
        1,
        2,
        ".",
        1,
        2,
        3,
    )
    assert find_recurring((1, 2, 3)) == (1, 2, 3)
    assert expand_recurring((1, ".", 0, "[", 9, "]"), repeat=2) == (
        1,
        ".",
        0,
        9,
        9,
        9,
    )
    assert expand_recurring((1, 2, 3)) == (1, 2, 3)


@pytest.mark.parametrize(
    ("number", "input_base", "expected"),
    [
        ((1, 9, 6, ".", 5, 1, 6), 12, True),
        ((8, 1, 15, 9), 15, False),
        ((1, "[", 3, "]"), 10, False),
        ((1, ".", "[", 3, "]"), 10, True),
        ((1, ".", 3, "]"), 10, False),
        ((1, 1, 1), 1, True),
        ((1, ".", 1), 1, False),
    ],
)
def test_check_valid(number, input_base, expected):
    assert check_valid(number, input_base) is expected
