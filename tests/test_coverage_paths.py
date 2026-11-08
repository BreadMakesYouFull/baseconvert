from fractions import Fraction

import pytest

from baseconvert.baseconvert import (
    MAX_DEPTH,
    check_valid,
    digit,
    digits,
    expand_recurring,
    find_recurring,
    fractional_base,
    from_base_10_int,
    int_to_str_digit,
    pad,
    to_base_10_int,
    truncate,
    base,
)


@pytest.mark.parametrize(
    ("number", "input_base", "output_base", "expected"),
    [
        # 12345 = 8192 + 4096 + 32 + 16 + 8 + 1.
        ("12345", 10, 2, "11000000111001"),
        # Z1_36 = 35 * 36 + 1 = 1261 = 4ED_16.
        ("Z1", 36, 16, "4ED"),
        # 102.12_3 = 11 + 1/3 + 2/9 = 11 + 5/9.
        ("102.12", 3, 10, "11.[5]"),
        # 255.625 = 255 + 10/16 = FF.A_16.
        ("-255.625", 10, 16, "-FF.A"),
        # Binary groups of three bits: 101 101.101 -> 55.5_8.
        ("101101.101", 2, 8, "55.5"),
        # Each hexadecimal digit maps to exactly four binary digits.
        ("A.F", 16, 2, "1010.1111"),
    ],
)
def test_known_complex_base_conversions(number, input_base, output_base, expected):
    assert base(number, input_base, output_base, string=True, exact=True) == expected


def test_parse_repetend_with_non_repeating_prefix():
    assert base("12.34[56]", 10, 10, string=True, exact=True) == "12.34[56]"


def test_integer_only_and_zero_fraction_results():
    assert base("-12", 10, 10, string=True, exact=True) == "-12"
    assert base("0.0", 10, 10, string=True, exact=True) == "0"


def test_parser_accepts_fraction_without_repetend_and_leading_plus():
    assert base("+A.F", 16, 16, string=True, exact=True) == "A.F"
    assert base(Fraction(3, 8), 10, 2, string=True, exact=True) == "0.011"


def test_invalid_types_and_ranges_cover_conversion_guards():
    with pytest.raises(TypeError, match="decimal must be an integer"):
        from_base_10_int(1.5)
    with pytest.raises(ValueError, match="base must be a positive integer"):
        from_base_10_int(10, 0)
    with pytest.raises(ValueError, match="fractional conversion requires"):
        fractional_base((".", 1), 1, 10)
    with pytest.raises(ValueError, match="fractional conversion requires"):
        fractional_base((".", 1), 10, 1)
    with pytest.raises(ValueError, match="max_depth"):
        base("0.5", 10, 2, max_depth=-1)
    with pytest.raises(TypeError, match="not iterable"):
        base(None, 10)
    with pytest.raises(ValueError, match="invalid number"):
        base("", 10)
    # Base-1 input accepts only unary digits; this exercises its invalid-digit path.
    with pytest.raises(ValueError, match="invalid number"):
        base("2", 1)


def test_unary_integer_helpers_and_padding_without_radix_point():
    assert from_base_10_int(-3, 1) == ("-", 1, 1, 1)
    assert to_base_10_int(("+", 1, 1, 1), 1) == 3
    assert pad((1, 2), 4) == ("0", "0", 1, 2)
    assert digit(201, 2, 10) == 2
    assert digits(255, 2) == 8
    assert digits(-1, 10) == 0


def test_recurring_helpers_cover_no_match_threshold_and_pattern():
    assert find_recurring((1, 2, ".", 1, 2, 3), min_repeat=2) == (
        1,
        2,
        ".",
        1,
        2,
        3,
    )
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
    assert find_recurring((1, 2, ".", 1), min_repeat=0) == (1, 2, ".", 1)
    assert expand_recurring((1, ".", 0, "[", 9, "]"), repeat=0) == (
        1,
        ".",
        0,
        9,
    )
    assert expand_recurring((1, 2, 3)) == (1, 2, 3)


def test_check_valid_syntax_and_base_edge_cases():
    assert check_valid(None, 10) is False
    assert check_valid((1,), 0) is False
    assert check_valid(("-", 1), 10) is True
    assert check_valid((1, "-"), 10) is False
    assert check_valid((1, ".", ".", 2), 10) is False
    assert check_valid((1, "[", 2, "]", "[", 3, "]"), 10) is False
    assert check_valid((1, "[", 2, "]"), 10) is False
    assert check_valid((1, ".", "[", 2), 10) is False
    assert check_valid((1, ".", "[", 2, "]", 3), 10) is False
    assert check_valid((1, ".", "[", "]"), 10) is False
    assert check_valid((1, ".", 2, "]"), 10) is False
    assert check_valid((2,), 1) is False
    assert check_valid((0, 1), 1) is True


def test_high_unicode_digit_and_miscellaneous_core_edges():
    assert int_to_str_digit(62) == "{"
    assert base("0.1", 3, 10, string=True, recurring=False, max_depth=0) == (
        "0." + "3" * MAX_DEPTH
    )
    assert truncate((1, 2, 3)) == (1, 2, 3)
    assert base("1", 10, 2, string=True, padding=3) == "001"
