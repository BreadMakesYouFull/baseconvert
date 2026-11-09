import io
import sys
from types import SimpleNamespace

import pytest

from baseconvert.__main__ import main


def test_cli_number_argument():
    assert main(["-n", "4080.5", "-i", "10", "-o", "16", "-s"]) == "FF0.8"


def test_cli_reads_stdin(monkeypatch):
    monkeypatch.setattr(sys, "stdin", io.StringIO("0.1\n"))
    assert main(["-i", "3", "-o", "10", "-s"]) == "0.[3]"


def test_cli_no_recurring_flag():
    result = main(["-n", "0.1", "-i", "3", "-o", "10", "--no-recurring", "-s", "-d", "4"])
    assert result == "0.3333"


def test_recurring_flags_are_mutually_exclusive():
    with pytest.raises(SystemExit):
        main(["-n", "1", "-r", "--no-recurring"])


def test_cli_launches_gui_with_selected_theme(monkeypatch):
    class TTYInput:
        def isatty(self):
            return True

    launched = []
    monkeypatch.setattr(sys, "stdin", TTYInput())
    monkeypatch.setitem(
        sys.modules,
        "baseconvert.gui",
        SimpleNamespace(main=lambda **kwargs: launched.append(kwargs)),
    )

    assert main(["--theme", "dark"]) is None
    assert launched == [{"theme": "dark", "mode": "default"}]


def test_cli_theme_defaults_to_dark(monkeypatch):
    class TTYInput:
        def isatty(self):
            return True

    launched = []
    monkeypatch.setattr(sys, "stdin", TTYInput())
    monkeypatch.setitem(
        sys.modules,
        "baseconvert.gui",
        SimpleNamespace(main=lambda **kwargs: launched.append(kwargs)),
    )

    assert main([]) is None
    assert launched == [{"theme": "dark", "mode": "default"}]
