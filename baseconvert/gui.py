import argparse
import re
import sys
from importlib.resources import files
from typing import Sequence

from PySide6.QtCore import QObject, Property, QUrl, Signal, Slot, Qt
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from .baseconvert import base


class Backend(QObject):
    updateResult = Signal()
    themeChanged = Signal()

    def __init__(self, theme: str = "dark", parent: QObject | None = None) -> None:
        super().__init__(parent)
        if theme not in {"system", "light", "dark"}:
            raise ValueError("theme must be 'system', 'light', or 'dark'")
        self._theme = theme
        self._default: str = "Output"
        self._result: str = self._default

    @Slot(str, int, int)
    def input_changed(self, value: str, base_from: int, base_to: int) -> None:
        if re.match("^[0-9A-Z]*[.]?[0-9A-Z]*$", value):
            try:
                self._result = base(value, base_from, base_to, string=True, exact=True)
            except ValueError:
                self._result = self._default
        else:
            self._result = self._default
        self.updateResult.emit()

    @Property(str, notify=themeChanged)
    def theme(self) -> str:
        return self._theme

    @Property(bool, notify=themeChanged)
    def darkMode(self) -> bool:
        if self._theme == "dark":
            return True
        if self._theme == "light":
            return False
        app = QGuiApplication.instance()
        return bool(app and app.styleHints().colorScheme() == Qt.ColorScheme.Dark)

    @Slot()
    def toggle_theme(self) -> None:
        self._theme = "light" if self.darkMode else "dark"
        self.themeChanged.emit()

    @Property(str, notify=updateResult)
    def result(self) -> str:
        return self._result


def main(theme: str | None = None, argv: Sequence[str] | None = None) -> None:
    if theme is None:
        parser = argparse.ArgumentParser(description="Launch baseconvert GUI.")
        parser.add_argument(
            "--theme",
            choices=("system", "light", "dark"),
            default="dark",
            help="GUI color theme (default: dark).",
        )
        theme = parser.parse_args(argv).theme

    sys.argv = [sys.argv[0]]
    app = QGuiApplication(sys.argv)
    backend = Backend(theme)
    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("backend", backend)
    qml_path = files(__package__).joinpath("app.qml")
    engine.load(QUrl.fromLocalFile(str(qml_path)))
    if not engine.rootObjects():
        sys.exit(-1)
    exit_code = app.exec()
    del engine
    sys.exit(exit_code)


if __name__ == "__main__":
    main()
