from pathlib import Path
import runpy
import sys


def test_executable_module_entry_points_are_covered(monkeypatch, capsys):
    package_dir = Path(__file__).resolve().parents[1] / "baseconvert"

    monkeypatch.setattr(sys, "argv", ["baseconvert", "-n", "1", "-s"])
    runpy.run_path(str(package_dir / "__main__.py"), run_name="__main__")
    assert capsys.readouterr().out == "1\n"

    runpy.run_path(str(package_dir / "baseconvert.py"), run_name="__main__")
