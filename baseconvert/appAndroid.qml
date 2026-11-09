import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: main
    width: 512
    height: 512
    minimumWidth: 320
    minimumHeight: 360
    visible: true
    title: qsTr("Baseconvert")

    property bool darkMode: backend.darkMode
    property bool compact: width < 390 || height < 520
    property int pageMargin: width < 370 ? 8 : 14
    property int cardPadding: compact ? 9 : 14
    property int sectionSpacing: compact ? 7 : 11

    property real barCellHeight: 2.2

    // Convert the result string into individual digit values.
    property var visualDigits: {
        var result = []
        var repeating = false

        for (var i = 0; i < output.text.length; i++) {
            var character = output.text[i]

            if (character === "[") {
                repeating = true
                continue
            }
            if (character === "]") {
                repeating = false
                continue
            }

            if (character === ".") {
                result.push({
                    character: ".",
                    point: true
                })
                continue
            }

            var value = character >= "0" && character <= "9"
                    ? Number(character)
                    : character.charCodeAt(0) - 55

            if (value >= 0 && value < 36) {
                result.push({
                    character: character,
                    value: value,
                    repeating: repeating,
                    point: false
                })
            }
        }
        return result
    }

    property int maxVisualDigit: {
        var maximum = 0
        for (var i = 0; i < visualDigits.length; i++) {
            maximum = Math.max(maximum, visualDigits[i].value || 0)
        }
        return maximum
    }

    // Calculator-inspired casing, warm keycaps, and a high-contrast LCD.
    property color pageColor: darkMode ? "#172321" : "#d8ded6"
    property color cardColor: darkMode ? "#2b3935" : "#c3cbc3"
    property color primaryText: darkMode ? "#f1f0df" : "#202925"
    property color secondaryText: darkMode ? "#a9b8ad" : "#536159"
    property color accent: darkMode ? "#65e6ca" : "#087e72"
    property color lcdColor: darkMode ? "#071512" : "#ffffff"
    property color lcdText: darkMode ? "#70f3d4" : "#168477"
    property color keyColor: darkMode ? "#d8dfd2" : "#f0f0df"
    property color keyText: "#18211e"
    property color keyBorder: darkMode ? "#f5f4e5" : "#ffffff"
    property color orange: darkMode ? "#e97832" : "#d95d1c"

    color: pageColor
    palette.window: pageColor
    palette.windowText: primaryText
    palette.base: lcdColor
    palette.alternateBase: cardColor
    palette.text: primaryText
    palette.button: keyColor
    palette.buttonText: keyText
    palette.highlight: accent
    palette.highlightedText: "#071512"
    font.family: "Sans Serif"
    font.pixelSize: compact ? 13 : 14

    background: Rectangle {
        color: main.pageColor
        border.width: 1
        border.color: main.darkMode ? "#43534c" : "#aab4aa"
    }

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
                    text: qsTr("BASECONVERT")
                    color: main.primaryText
                    font.family: "Monospace"
                    font.pixelSize: main.compact ? 19 : 22
                    font.weight: Font.Black
		    font.letterSpacing: 1.2
                }
            }


		// Magnitude visualization.
		Item {
		    visible: input.text.length > 0  // Hide if no input
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    Layout.minimumHeight: 10
                    clip: true

                    Flickable {
                        anchors.fill: parent
                        contentWidth: digitRow.width
                        contentHeight: height
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds

                        Row {
                            id: digitRow
                            anchors.bottom: parent.bottom
                            height: parent.height
                            spacing: 3

                            Repeater {
                                model: main.visualDigits

                                delegate: Item {
                                    required property var modelData
				    width: modelData.point ? 10 : 8
                                    height: digitRow.height

                                    Rectangle {
                                        visible: !modelData.point
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: parent.width
                                        height: main.maxVisualDigit > 0
                                            ? parent.height * modelData.value
                                                / main.maxVisualDigit
                                            : 0
                                        radius: 1
                                        color: modelData.repeating
                                            ? main.orange
                                            : main.accent
                                    }
                                }
                            }
                        }
                    }
                }
		
		Item {
                    visible: input.text.length == 0  // Hide if no input
                    Layout.fillWidth: true
		}

            ToolButton {
                id: themeToggle
                text: main.darkMode ? "☀" : "🌙"
                font.pixelSize: 20
                Accessible.name: main.darkMode ? qsTr("Switch to light mode") : qsTr("Switch to dark mode")
                ToolTip.visible: hovered
                ToolTip.text: Accessible.name
                onClicked: backend.toggle_theme()
                background: Rectangle {
                    radius: 8
                    color: themeToggle.down ? (main.darkMode ? "#43534c" : "#b0bab0") : main.cardColor
                    border.color: main.darkMode ? "#53645b" : "#aab4aa"
                    border.width: 1
                }
                contentItem: Text {
                    text: themeToggle.text
                    font: themeToggle.font
                    color: main.darkMode ? "#ffffff" : main.primaryText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Frame {
            Layout.fillWidth: true
            padding: main.cardPadding
            background: Rectangle {
                radius: 12
                color: main.cardColor
                border.width: 1
                border.color: main.darkMode ? "#53645b" : "#aab4aa"
            }
            RowLayout {
                anchors.fill: parent
                spacing: 12
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                    RowLayout {
                        Layout.fillWidth: true
                        Label { text: qsTr("FROM"); color: main.secondaryText; font.family: "Monospace"; font.pixelSize: 10; font.weight: Font.Bold }
                        Item { Layout.fillWidth: true }
                        Label {
                            text: Math.round(from.value).toString()
                            color: main.primaryText
                            font.family: "Monospace"
                            font.pixelSize: 17
                            font.weight: Font.Bold
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
                    color: main.darkMode ? "#53645b" : "#aab4aa"
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                    RowLayout {
                        Layout.fillWidth: true
                        Label { text: qsTr("TO"); color: main.secondaryText; font.family: "Monospace"; font.pixelSize: 10; font.weight: Font.Bold }
                        Item { Layout.fillWidth: true }
                        Label {
                            text: Math.round(to.value).toString()
                            color: main.primaryText
                            font.family: "Monospace"
                            font.pixelSize: 17
                            font.weight: Font.Bold
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
                radius: 12
                color: main.cardColor
                border.width: 1
                border.color: main.darkMode ? "#53645b" : "#aab4aa"
            }
            ColumnLayout {
                anchors.fill: parent
                spacing: 5
                Label {
                    text: qsTr("INPUT · BASE %1").arg(Math.round(from.value))
                    color: main.secondaryText
                    font.family: "Monospace"
                    font.pixelSize: 10
                    font.weight: Font.Bold
                    font.letterSpacing: 1
                }
                TextField {
                    id: input
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                    Layout.fillHeight: true
                    Layout.minimumHeight: 42
                    //placeholderText: qsTr("Type a number")
                    placeholderTextColor: "#76988c"
                    font.family: "Monospace"
                    font.pixelSize: main.compact ? 17 : 19
                    selectByMouse: true
                    focus: true
                    color: main.lcdText
                    selectionColor: main.accent
                    selectedTextColor: main.lcdColor
                    onTextChanged: {
                        var sanitized = input.text.toUpperCase().replace(/[^A-Z0-9.]/g, "")
                        if (input.text !== sanitized)
                            input.text = sanitized
                        backend.input_changed(input.text, Math.round(from.value), Math.round(to.value))
                    }
                    background: Rectangle {
                        radius: 7
                        color: main.lcdColor
                        border.width: input.activeFocus ? 2 : 1
                        border.color: input.activeFocus ? main.accent : (main.darkMode ? "#53645b" : "#78877d")
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    Label {
                        text: qsTr("RESULT · BASE %1").arg(Math.round(to.value))
                        color: main.secondaryText
                        font.family: "Monospace"
                        font.pixelSize: 10
                        font.weight: Font.Bold
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
                        palette.button: main.darkMode ? "#176c61" : "#168477"
                        palette.buttonText: "#ffffff"
                        background: Rectangle {
                            radius: 7
                            color: parent.down ? "#12574f" : (main.darkMode ? "#176c61" : "#168477")
                            border.color: main.darkMode ? "#55cbb3" : "#0c6d61"
                            border.width: 1
                        }
                    }
                    Button {
                        text: qsTr("RESET")
                        Accessible.name: qsTr("Reset number and bases")
                        ToolTip.visible: hovered
                        ToolTip.text: qsTr("Clear number and reset bases to 10 and 36")
                        onClicked: {
                            input.text = ""
                            from.value = 10
                            to.value = 36
                        }
                        palette.button: main.orange
                        palette.buttonText: "#ffffff"
                        background: Rectangle {
                            radius: 7
                            color: parent.down ? "#a84717" : main.orange
                            border.color: main.darkMode ? "#ffab69" : "#a9471b"
                            border.width: 1
                        }
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
                    font.weight: Font.DemiBold
                    color: main.lcdText
                    selectionColor: main.accent
                    selectedTextColor: main.lcdColor
                    background: Rectangle {
                        radius: 7
                        color: main.lcdColor
                        border.width: 1
                        border.color: main.darkMode ? "#53645b" : "#78877d"
                    }
                }




            }
        }
    }
}
