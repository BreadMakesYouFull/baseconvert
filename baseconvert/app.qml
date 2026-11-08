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
    property bool keypadWasToggled: false
    property bool keypadUserOpen: true
    property bool keypadExpanded: keypadWasToggled ? keypadUserOpen : height >= 560
    property int pageMargin: width < 370 ? 9 : 16
    property int sectionSpacing: compact ? 8 : 14
    property int cardPadding: compact ? 10 : 16
    property int keyHeight: height < 460 ? 30 : (compact ? 36 : 42)

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

    ScrollView {
        id: scroll
        anchors.fill: parent
        anchors.margins: main.pageMargin
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
                Layout.topMargin: 2
                Layout.bottomMargin: 2
                ColumnLayout {
                    spacing: 2
                    Label {
                        text: qsTr("Baseconvert")
                        color: main.primaryText
                        font.pixelSize: main.compact ? 21 : 25
                        font.weight: Font.DemiBold
                    }
                    Label {
                        text: qsTr("Convert numbers between bases")
                        color: main.secondaryText
                        font.pixelSize: main.compact ? 12 : 13
                    }
                }
                Item { Layout.fillWidth: true }
                ToolButton {
                    id: themeToggle
                    text: main.darkMode ? "☀" : "☾"
                    font.pixelSize: 21
                    Accessible.name: main.darkMode ? qsTr("Switch to light mode") : qsTr("Switch to dark mode")
                    ToolTip.visible: hovered
                    ToolTip.text: Accessible.name
                    onClicked: backend.toggle_theme()
                    background: Rectangle {
                        radius: 13
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
                    radius: 18
                    color: main.cardColor
                    border.width: 1
                    border.color: main.darkMode ? "#2b394d" : "#e4eaf3"
                }
                ColumnLayout {
                    spacing: main.compact ? 8 : 14
                    Label {
                        text: qsTr("CONVERSION")
                        color: main.secondaryText
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                        font.letterSpacing: 1.2
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: main.compact ? 8 : 14
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.minimumWidth: 0
                            spacing: 4
                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: qsTr("FROM")
                                    color: main.secondaryText
                                    font.pixelSize: 11
                                    font.weight: Font.DemiBold
                                }
                                Item { Layout.fillWidth: true }
                                Label {
                                    text: Math.round(from.value).toString()
                                    color: main.primaryText
                                    font.pixelSize: main.compact ? 18 : 22
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
                            Layout.preferredHeight: 52
                            color: main.darkMode ? "#344258" : "#e5eaf2"
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.minimumWidth: 0
                            spacing: 4
                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: qsTr("TO")
                                    color: main.secondaryText
                                    font.pixelSize: 11
                                    font.weight: Font.DemiBold
                                }
                                Item { Layout.fillWidth: true }
                                Label {
                                    text: Math.round(to.value).toString()
                                    color: main.primaryText
                                    font.pixelSize: main.compact ? 18 : 22
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
                    radius: 18
                    color: main.cardColor
                    border.width: 1
                    border.color: main.darkMode ? "#2b394d" : "#e4eaf3"
                }
                ColumnLayout {
                    spacing: 8
                    Label {
                        text: qsTr("INPUT")
                        color: main.secondaryText
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                        font.letterSpacing: 1.2
                    }
                    TextField {
                        id: input
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0
                        placeholderText: qsTr("Type a number")
                        font.family: "Monospace"
                        font.pixelSize: main.compact ? 17 : 20
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
                            radius: 11
                            color: main.darkMode ? "#141d2a" : "#f7f9fd"
                            border.width: input.activeFocus ? 2 : 1
                            border.color: input.activeFocus ? main.accent : (main.darkMode ? "#35445a" : "#dce3ee")
                        }
                    }
                }
            }

            Frame {
                Layout.fillWidth: true
                padding: main.cardPadding
                background: Rectangle {
                    radius: 18
                    color: main.darkMode ? "#202c3e" : "#e9efff"
                    border.width: 1
                    border.color: main.darkMode ? "#2b394d" : "#dce6ff"
                }
                ColumnLayout {
                    spacing: 6
                    RowLayout {
                        Layout.fillWidth: true
                        Label {
                            text: qsTr("RESULT")
                            color: main.secondaryText
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                            font.letterSpacing: 1.2
                        }
                        Item { Layout.fillWidth: true }
                        Label {
                            text: Math.round(from.value) + "  →  " + Math.round(to.value)
                            color: main.accent
                            font.pixelSize: 12
                            font.weight: Font.DemiBold
                        }
                    }
                    TextField {
                        id: output
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0
                        text: backend.result
                        readOnly: true
                        selectByMouse: true
                        font.family: "Monospace"
                        font.pixelSize: main.compact ? 18 : 22
                        color: main.primaryText
                        background: Rectangle { color: "transparent" }
                    }
                }
            }

            ButtonRow {
                Layout.fillWidth: true
                Layout.preferredHeight: main.keyHeight + 4
                darkMode: main.darkMode
                text1: main.compact ? "FLIP" : "↔ FLIP"
                text2: "RESET"
                text3: "CLEAR"
                text4: main.compact ? "DEL" : "⌫"
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

            Frame {
                Layout.fillWidth: true
                padding: main.compact ? 8 : 12
                background: Rectangle {
                    radius: 18
                    color: main.cardColor
                    border.width: 1
                    border.color: main.darkMode ? "#2b394d" : "#e4eaf3"
                }
                ColumnLayout {
                    spacing: main.compact ? 5 : 7
                    RowLayout {
                        Layout.fillWidth: true
                        Label {
                            text: qsTr("KEYPAD")
                            color: main.secondaryText
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                            font.letterSpacing: 1.2
                        }
                        Item { Layout.fillWidth: true }
                        Label {
                            visible: !main.compact
                            text: qsTr("Digits available up to base %1").arg(Math.round(from.value))
                            color: main.secondaryText
                            font.pixelSize: 11
                        }
                        ToolButton {
                            text: main.keypadExpanded ? "⌃" : "⌄"
                            Accessible.name: main.keypadExpanded ? qsTr("Collapse keypad") : qsTr("Expand keypad")
                            onClicked: {
                                main.keypadWasToggled = true
                                main.keypadUserOpen = !main.keypadExpanded
                            }
                        }
                    }
                    Label {
                        visible: main.compact && main.keypadExpanded
                        text: qsTr("Digits available up to base %1").arg(Math.round(from.value))
                        color: main.secondaryText
                        font.pixelSize: 10
                    }
                    ButtonRow {
                        visible: main.keypadExpanded
                        Layout.fillWidth: true
                        Layout.preferredHeight: main.keyHeight
                        darkMode: main.darkMode
                        text1: "V"; text2: "W"; text3: "X"; text4: "Y"; text5: "Z"; text6: "."
                        enable1: from.value >= 32; enable2: from.value >= 33; enable3: from.value >= 34
                        enable4: from.value >= 35; enable5: from.value >= 36; enable6: true
                        color6: main.darkMode ? "#176b70" : "#c9f1ef"
                        colorText6: main.darkMode ? "#e6fffb" : "#075e61"
                        onButtonPressed: (text) => { input.text += text }
                    }
                    ButtonRow {
                        visible: main.keypadExpanded
                        Layout.fillWidth: true
                        Layout.preferredHeight: main.keyHeight
                        darkMode: main.darkMode
                        text1: "P"; text2: "Q"; text3: "R"; text4: "S"; text5: "T"; text6: "U"
                        enable1: from.value >= 26; enable2: from.value >= 27; enable3: from.value >= 28
                        enable4: from.value >= 29; enable5: from.value >= 30; enable6: from.value >= 31
                        onButtonPressed: (text) => { input.text += text }
                    }
                    ButtonRow {
                        visible: main.keypadExpanded
                        Layout.fillWidth: true
                        Layout.preferredHeight: main.keyHeight
                        darkMode: main.darkMode
                        text1: "J"; text2: "K"; text3: "L"; text4: "M"; text5: "N"; text6: "O"
                        enable1: from.value >= 20; enable2: from.value >= 21; enable3: from.value >= 22
                        enable4: from.value >= 23; enable5: from.value >= 24; enable6: from.value >= 25
                        onButtonPressed: (text) => { input.text += text }
                    }
                    ButtonRow {
                        visible: main.keypadExpanded
                        Layout.fillWidth: true
                        Layout.preferredHeight: main.keyHeight
                        darkMode: main.darkMode
                        text1: "D"; text2: "E"; text3: "F"; text4: "G"; text5: "H"; text6: "I"
                        enable1: from.value >= 14; enable2: from.value >= 15; enable3: from.value >= 16
                        enable4: from.value >= 17; enable5: from.value >= 18; enable6: from.value >= 19
                        onButtonPressed: (text) => { input.text += text }
                    }
                    ButtonRow {
                        visible: main.keypadExpanded
                        Layout.fillWidth: true
                        Layout.preferredHeight: main.keyHeight
                        darkMode: main.darkMode
                        text1: "7"; text2: "8"; text3: "9"; text4: "A"; text5: "B"; text6: "C"
                        enable1: from.value >= 8; enable2: from.value >= 9; enable3: from.value >= 10
                        enable4: from.value >= 11; enable5: from.value >= 12; enable6: from.value >= 13
                        onButtonPressed: (text) => { input.text += text }
                    }
                    ButtonRow {
                        visible: main.keypadExpanded
                        Layout.fillWidth: true
                        Layout.preferredHeight: main.keyHeight
                        darkMode: main.darkMode
                        text1: "1"; text2: "2"; text3: "3"; text4: "4"; text5: "5"; text6: "6"
                        enable1: from.value >= 2; enable2: from.value >= 3; enable3: from.value >= 4
                        enable4: from.value >= 5; enable5: from.value >= 6; enable6: from.value >= 7
                        onButtonPressed: (text) => { input.text += text }
                    }
                    ButtonRow {
                        visible: main.keypadExpanded
                        Layout.fillWidth: true
                        Layout.preferredHeight: main.keyHeight
                        darkMode: main.darkMode
                        text1: "0"
                        enable2: false; enable3: false; enable4: false; enable5: false; enable6: false
                        onButtonPressed: (text) => { input.text += text }
                    }
                }
            }

            Label {
                visible: !main.compact
                Layout.fillWidth: true
                Layout.bottomMargin: 4
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Made for curious number people")
                color: main.secondaryText
                font.pixelSize: 11
            }
        }
    }
}
