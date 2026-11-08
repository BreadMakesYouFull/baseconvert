import re
import sys
from importlib.resources import files

from PySide6.QtCore import QObject, Property, QUrl, Signal, Slot
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from .baseconvert import base


class Backend(QObject):

    updateResult = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self._default = "Output"
        self._result = self._default

    @Slot(str, int, int)
    def input_changed(self, value, base_from, base_to):
        if re.match("^[0-9A-Z]*[.]?[0-9A-Z]*$", value):
            try:
                self._result = base(value, base_from, base_to, string=True, exact=True)
            except ValueError:
                self._result = self._default
        else:
            self._result = self._default
        self.updateResult.emit()

    @Property(str, notify=updateResult)
    def result(self):
        return self._result


def main():
    backend = Backend()
    app = QGuiApplication(sys.argv)
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
