import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: main
    width: 440
    height: 700
    minimumWidth: 320
    minimumHeight: 360
    visible: true
    title: qsTr("Baseconvert")

    property bool darkMode: backend.darkMode
    property bool compact: width < 390 || height < 520
    property int pageMargin: width < 370 ? 8 : 14
    property int cardPadding: compact ? 9 : 14
    property int sectionSpacing: compact ? 7 : 11
    property color pageColor: darkMode ? "#111827" : "#f3f6fb"
    property color cardColor: darkMode ? "#1c2534" : "#ffffff"
    property color primaryText: darkMode ? "#f1f5f9" : "#172033"
    property color secondaryText: darkMode ? "#9aa8bb" : "#667085"
    property color accent: darkMode ? "#8ab4ff" : "#315fe8"

    color: pageColor
    palette.window: pageColor
    palette.windowText: primaryText
    palette.base: darkMode ? "#141d2a" : "#f8faff"
    palette.alternateBase: cardColor
    palette.text: primaryText
    palette.button: cardColor
    palette.buttonText: primaryText
    palette.highlight: accent
    palette.highlightedText: "#ffffff"
    font.family: "Sans Serif"
    font.pixelSize: compact ? 13 : 14

    background: Rectangle { color: main.pageColor }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: main.pageMargin
        spacing: main.sectionSpacing

        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 1
                Label {
                    text: qsTr("Baseconvert")
                    color: main.primaryText
                    font.pixelSize: main.compact ? 20 : 23
                    font.weight: Font.DemiBold
                }
                Label {
                    visible: !main.compact
                    text: qsTr("Convert numbers between bases")
                    color: main.secondaryText
                    font.pixelSize: 12
                }
            }
            Item { Layout.fillWidth: true }
            ToolButton {
                text: main.darkMode ? "☀" : "☾"
                font.pixelSize: 20
                Accessible.name: main.darkMode ? qsTr("Switch to light mode") : qsTr("Switch to dark mode")
                ToolTip.visible: hovered
                ToolTip.text: Accessible.name
                onClicked: backend.toggle_theme()
            }
        }

        Frame {
            Layout.fillWidth: true
            padding: main.cardPadding
            background: Rectangle {
                radius: 15
                color: main.cardColor
                border.width: 1
                border.color: main.darkMode ? "#2b394d" : "#e4eaf3"
            }
            RowLayout {
                anchors.fill: parent
                spacing: 12
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                    RowLayout {
                        Layout.fillWidth: true
                        Label { text: qsTr("FROM"); color: main.secondaryText; font.pixelSize: 11 }
                        Item { Layout.fillWidth: true }
                        Label {
                            text: Math.round(from.value).toString()
                            color: main.primaryText
                            font.pixelSize: 17
                            font.weight: Font.DemiBold
                        }
                    }
                    Slider {
                        id: from
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0
                        from: 2
                        to: 36
                        value: 10
                        stepSize: 1
                        onValueChanged: backend.input_changed(input.text, Math.round(from.value), Math.round(to.value))
                    }
                }
                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 40
                    color: main.darkMode ? "#344258" : "#e5eaf2"
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                    RowLayout {
                        Layout.fillWidth: true
                        Label { text: qsTr("TO"); color: main.secondaryText; font.pixelSize: 11 }
                        Item { Layout.fillWidth: true }
                        Label {
                            text: Math.round(to.value).toString()
                            color: main.primaryText
                            font.pixelSize: 17
                            font.weight: Font.DemiBold
                        }
                    }
                    Slider {
                        id: to
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0
                        from: 2
                        to: 36
                        value: 36
                        stepSize: 1
                        onValueChanged: backend.input_changed(input.text, Math.round(from.value), Math.round(to.value))
                    }
                }
            }
        }

        Frame {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 145
            padding: main.cardPadding
            background: Rectangle {
                radius: 15
                color: main.cardColor
                border.width: 1
                border.color: main.darkMode ? "#2b394d" : "#e4eaf3"
            }
            ColumnLayout {
                anchors.fill: parent
                spacing: 5
                Label {
                    text: qsTr("INPUT · BASE %1").arg(Math.round(from.value))
                    color: main.secondaryText
                    font.pixelSize: 10
                    font.weight: Font.DemiBold
                    font.letterSpacing: 1
                }
                TextField {
                    id: input
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                    Layout.fillHeight: true
                    Layout.minimumHeight: 42
                    placeholderText: qsTr("Type a number")
                    placeholderTextColor: main.darkMode ? "#a8b5c8" : "#7b8798"
                    font.family: "Monospace"
                    font.pixelSize: main.compact ? 17 : 19
                    selectByMouse: true
                    focus: true
                    color: main.primaryText
                    onTextChanged: {
                        var sanitized = input.text.toUpperCase().replace(/[^A-Z0-9.]/g, "")
                        if (input.text !== sanitized)
                            input.text = sanitized
                        backend.input_changed(input.text, Math.round(from.value), Math.round(to.value))
                    }
                    background: Rectangle {
                        radius: 9
                        color: main.darkMode ? "#141d2a" : "#f7f9fd"
                        border.width: input.activeFocus ? 2 : 1
                        border.color: input.activeFocus ? main.accent : (main.darkMode ? "#35445a" : "#dce3ee")
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    Label {
                        text: qsTr("RESULT · BASE %1").arg(Math.round(to.value))
                        color: main.secondaryText
                        font.pixelSize: 10
                        font.weight: Font.DemiBold
                        font.letterSpacing: 1
                    }
                    Item { Layout.fillWidth: true }
                    Button {
                        text: "↔  " + qsTr("FLIP")
                        Accessible.name: qsTr("Flip input and output bases")
                        onClicked: {
                            var oldFrom = from.value
                            var oldTo = to.value
                            var outputText = output.text
                            to.value = oldFrom
                            from.value = oldTo
                            if (outputText !== "Output")
                                input.text = outputText
                        }
                        palette.button: main.darkMode ? "#315a9f" : "#315fe8"
                        palette.buttonText: "#ffffff"
                    }
                }
                TextField {
                    id: output
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                    Layout.fillHeight: true
                    Layout.minimumHeight: 42
                    text: backend.result
                    readOnly: true
                    selectByMouse: true
                    font.family: "Monospace"
                    font.pixelSize: main.compact ? 17 : 20
                    color: main.primaryText
                    background: Rectangle {
                        radius: 9
                        color: main.darkMode ? "#202c3e" : "#e9efff"
                    }
                }
            }
        }

        Frame {
            id: keypadPanel
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 150
            padding: main.compact ? 6 : 9
            background: Rectangle {
                radius: 15
                color: main.cardColor
                border.width: 1
                border.color: main.darkMode ? "#2b394d" : "#e4eaf3"
            }
            ColumnLayout {
                anchors.fill: parent
                spacing: main.compact ? 3 : 6
                RowLayout {
                    id: keypadHeader
                    Layout.fillWidth: true
                    Label {
                        text: qsTr("KEYPAD")
                        color: main.secondaryText
                        font.pixelSize: 10
                        font.weight: Font.DemiBold
                        font.letterSpacing: 1
                    }
                    Item { Layout.fillWidth: true }
                    Label {
                        text: qsTr(".")
                        color: main.darkMode ? "#8ff0dc" : "#087e72"
                        font.family: "Monospace"
                        font.pixelSize: 12
                        font.weight: Font.Bold
                    }
                    Label {
                        text: qsTr("Radix point")
                        color: main.secondaryText
                        font.pixelSize: 10
                    }
                }
                GridLayout {
                    id: keypadGrid
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    columns: 10
                    rowSpacing: main.compact ? 2 : 4
                    columnSpacing: main.compact ? 2 : 4
                    Repeater {
                        model: Math.round(from.value) + 1
                        delegate: Button {
                            required property int index
                            property bool pointKey: index === Math.round(from.value)
                            property int digitValue: index
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.minimumWidth: 0
                            Layout.minimumHeight: 0
                            text: pointKey ? "." : (digitValue < 10 ? digitValue.toString() : String.fromCharCode(55 + digitValue))
                            font.family: pointKey ? "Sans Serif" : "Monospace"
                            font.pixelSize: pointKey ? Math.min(22, keypadGrid.height / 5 * 0.78) : Math.min(16, keypadGrid.height / 5 * 0.48)
                            font.weight: pointKey ? Font.Black : Font.DemiBold
                            Accessible.name: pointKey ? qsTr("Radix point") : text
                            palette.button: pointKey
                                ? (main.darkMode ? "#087f75" : "#a5eee1")
                                : (main.darkMode ? "#29384d" : "#f0f3f9")
                            palette.buttonText: pointKey
                                ? (main.darkMode ? "#ffffff" : "#064f4b")
                                : main.primaryText
                            onClicked: input.text += pointKey ? "." : text
                        }
                    }
                }
            }
        }
    }
}
