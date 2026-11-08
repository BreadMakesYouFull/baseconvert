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
    property bool compact: width < 390 || height < 540
    property int pageMargin: width < 370 ? 9 : 16
    property int cardPadding: compact ? 10 : 16
    property int sectionSpacing: compact ? 8 : 12
    property int keyHeight: Math.max(28, Math.min(42, Math.floor((height - 300) / 8)))
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

    background: Rectangle {
        gradient: Gradient {
            GradientStop { position: 0.0; color: main.darkMode ? "#101827" : "#edf3ff" }
            GradientStop { position: 1.0; color: main.pageColor }
        }
    }

    // Keep the keypad and primary actions pinned while the content above can scroll.
    ScrollView {
        id: scroll
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: keypadPanel.top
        anchors.margins: main.pageMargin
        anchors.bottomMargin: 8
        clip: true
        contentWidth: availableWidth
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        ColumnLayout {
            id: page
            x: Math.max(0, (scroll.availableWidth - width) / 2)
            width: Math.min(scroll.availableWidth, 620)
            spacing: main.sectionSpacing

            RowLayout {
                Layout.fillWidth: true
                ColumnLayout {
                    spacing: 1
                    Label {
                        text: qsTr("Baseconvert")
                        color: main.primaryText
                        font.pixelSize: main.compact ? 20 : 24
                        font.weight: Font.DemiBold
                    }
                    Label {
                        text: qsTr("Convert numbers between bases")
                        color: main.secondaryText
                        font.pixelSize: 12
                    }
                }
                Item { Layout.fillWidth: true }
                ToolButton {
                    id: themeToggle
                    text: main.darkMode ? "☀" : "☾"
                    font.pixelSize: 20
                    Accessible.name: main.darkMode ? qsTr("Switch to light mode") : qsTr("Switch to dark mode")
                    ToolTip.visible: hovered
                    ToolTip.text: Accessible.name
                    onClicked: backend.toggle_theme()
                    background: Rectangle {
                        radius: 12
                        color: themeToggle.down
                            ? (main.darkMode ? "#334155" : "#dce7ff")
                            : (main.darkMode ? "#263449" : "#e4ecff")
                    }
                }
            }

            Frame {
                Layout.fillWidth: true
                padding: main.cardPadding
                background: Rectangle {
                    radius: 16
                    color: main.cardColor
                    border.width: 1
                    border.color: main.darkMode ? "#2b394d" : "#e4eaf3"
                }
                ColumnLayout {
                    spacing: 6
                    Label {
                        text: qsTr("BASES")
                        color: main.secondaryText
                        font.pixelSize: 10
                        font.weight: Font.DemiBold
                        font.letterSpacing: 1.1
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10
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
                                    font.pixelSize: 18
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
                            Layout.preferredHeight: 44
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
                                    font.pixelSize: 18
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
            }

            Frame {
                Layout.fillWidth: true
                padding: main.cardPadding
                background: Rectangle {
                    radius: 16
                    color: main.cardColor
                    border.width: 1
                    border.color: main.darkMode ? "#2b394d" : "#e4eaf3"
                }
                ColumnLayout {
                    spacing: 5
                    Label {
                        text: qsTr("INPUT · BASE %1").arg(Math.round(from.value))
                        color: main.secondaryText
                        font.pixelSize: 10
                        font.weight: Font.DemiBold
                        font.letterSpacing: 1.1
                    }
                    TextField {
                        id: input
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0
                        implicitHeight: main.compact ? 42 : 48
                        placeholderText: qsTr("Type a number")
                        font.family: "Monospace"
                        font.pixelSize: main.compact ? 18 : 20
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
                            radius: 10
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
                            font.letterSpacing: 1.1
                        }
                        Item { Layout.fillWidth: true }
                        Label { text: "→"; color: main.accent; font.pixelSize: 13 }
                    }
                    TextField {
                        id: output
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0
                        implicitHeight: main.compact ? 38 : 42
                        text: backend.result
                        readOnly: true
                        selectByMouse: true
                        font.family: "Monospace"
                        font.pixelSize: main.compact ? 18 : 21
                        color: main.primaryText
                        background: Rectangle {
                            radius: 9
                            color: main.darkMode ? "#202c3e" : "#e9efff"
                        }
                    }
                }
            }
        }
    }

    Frame {
        id: keypadPanel
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: main.pageMargin
        padding: main.compact ? 7 : 10
        background: Rectangle {
            radius: 16
            color: main.cardColor
            border.width: 1
            border.color: main.darkMode ? "#2b394d" : "#e4eaf3"
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: main.compact ? 5 : 8

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: qsTr("KEYPAD")
                    color: main.secondaryText
                    font.pixelSize: 10
                    font.weight: Font.DemiBold
                    font.letterSpacing: 1.1
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
                columns: 8
                rowSpacing: main.compact ? 3 : 5
                columnSpacing: main.compact ? 3 : 5

                Repeater {
                    model: 37
                    delegate: Button {
                        required property int index
                        property bool pointKey: index === 36
                        property int digitValue: index
                        Layout.fillWidth: true
                        Layout.preferredHeight: main.keyHeight
                        visible: pointKey || digitValue < Math.round(from.value)
                        text: pointKey ? "." : (digitValue < 10 ? digitValue.toString() : String.fromCharCode(55 + digitValue))
                        font.family: pointKey ? "Sans Serif" : "Monospace"
                        font.pixelSize: pointKey ? main.keyHeight * 0.7 : Math.min(16, main.keyHeight * 0.48)
                        font.weight: pointKey ? Font.Black : Font.DemiBold
                        Accessible.name: pointKey ? qsTr("Radix point") : text
                        palette.button: pointKey
                            ? (main.darkMode ? "#0d7770" : "#b9f1e7")
                            : (main.darkMode ? "#29384d" : "#f0f3f9")
                        palette.buttonText: pointKey
                            ? (main.darkMode ? "#ffffff" : "#064f4b")
                            : main.primaryText
                        onClicked: input.text += pointKey ? "." : text
                    }
                }
            }

            ButtonRow {
                Layout.fillWidth: true
                Layout.preferredHeight: main.keyHeight + 4
                darkMode: main.darkMode
                text1: "↔ FLIP"
                text2: "RESET"
                text3: "CLEAR"
                text4: "⌫"
                color1: main.darkMode ? "#315a9f" : "#315fe8"
                colorText1: "#ffffff"
                color2: main.darkMode ? "#344258" : "#e3eaf7"
                color3: main.darkMode ? "#344258" : "#e3eaf7"
                color4: main.darkMode ? "#344258" : "#e3eaf7"
                enable5: false
                enable6: false
                onButtonPressed: (text) => {
                    if (text.includes("FLIP")) {
                        var oldFrom = from.value
                        var oldTo = to.value
                        var outputText = output.text
                        to.value = oldFrom
                        from.value = oldTo
                        if (outputText !== "Output")
                            input.text = outputText
                    } else if (text === "RESET") {
                        input.text = ""
                        from.value = 10
                        to.value = 36
                    } else if (text === "CLEAR") {
                        input.text = ""
                    } else {
                        input.text = input.text.slice(0, -1)
                    }
                }
            }
        }
    }
}
