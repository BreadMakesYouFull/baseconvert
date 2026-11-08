import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: buttonRow
    property string text1: "1"
    property string text2: "2"
    property string text3: "3"
    property string text4: "4"
    property string text5: "5"
    property string text6: "6"
    property bool enable1: true
    property bool enable2: true
    property bool enable3: true
    property bool enable4: true
    property bool enable5: true
    property bool enable6: true
    signal buttonPressed(text: string)
    property bool darkMode: false
    property color color1: darkMode ? "#d8dfd2" : "#f0f0df"
    property color colorText1: "#18211e"
    property color color2: color1
    property color colorText2: colorText1
    property color color3: color1
    property color colorText3: colorText1
    property color color4: color1
    property color colorText4: colorText1
    property color color5: color1
    property color colorText5: colorText1
    property color color6: color1
    property color colorText6: colorText1

    RowLayout {
        anchors.fill: parent
        spacing: 4

        Repeater {
            model: 6
            delegate: Button {
                required property int index
                property bool enabledKey: index === 0 ? buttonRow.enable1
                    : index === 1 ? buttonRow.enable2
                    : index === 2 ? buttonRow.enable3
                    : index === 3 ? buttonRow.enable4
                    : index === 4 ? buttonRow.enable5 : buttonRow.enable6
                property string keyText: index === 0 ? buttonRow.text1
                    : index === 1 ? buttonRow.text2
                    : index === 2 ? buttonRow.text3
                    : index === 3 ? buttonRow.text4
                    : index === 4 ? buttonRow.text5 : buttonRow.text6
                property color keyColor: index === 0 ? buttonRow.color1
                    : index === 1 ? buttonRow.color2
                    : index === 2 ? buttonRow.color3
                    : index === 3 ? buttonRow.color4
                    : index === 4 ? buttonRow.color5 : buttonRow.color6
                property color keyTextColor: index === 0 ? buttonRow.colorText1
                    : index === 1 ? buttonRow.colorText2
                    : index === 2 ? buttonRow.colorText3
                    : index === 3 ? buttonRow.colorText4
                    : index === 4 ? buttonRow.colorText5 : buttonRow.colorText6
                visible: enabledKey
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: keyText
                font.family: "Monospace"
                font.weight: Font.Bold
                onClicked: buttonRow.buttonPressed(text)
                palette.button: keyColor
                palette.buttonText: keyTextColor
                background: Rectangle {
                    radius: Math.min(8, height * 0.22)
                    color: parent.down ? Qt.darker(parent.keyColor, 1.12) : parent.keyColor
                    border.width: 1
                    border.color: buttonRow.darkMode ? "#f5f4e5" : "#ffffff"
                }
            }
        }
    }
}
