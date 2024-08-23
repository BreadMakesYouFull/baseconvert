import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


ApplicationWindow {
    id: main
    width: 400
    height: 400
    minimumWidth: 300
    minimumHeight: 150
    visible: true
    title: "baseconvert"
    property string result: ""

    property bool darkMode: Application.styleHints.colorScheme === Qt.ColorScheme.Dark
    font: Qt.font({
                bold: true,
                underline: false,
                pixelSize: ((main.height > 300) ? ((main.height > main.width) ? main.width / 30 : main.height / 30) : main.height / 8) * 1.1, // resize relative to parent
                family: "monospace"
        })
    property var fontLarge: Qt.font({
                bold: true,
                underline: false,
                pixelSize: main.font.pixelSize * 1.5,
                family: "monospace"
        })

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        RowLayout {
            TextField {
                id: input
                Layout.fillWidth: true
                Layout.columnSpan: 1
                placeholderText: qsTr("Input")
                font: main.fontLarge
                onTextChanged: {
                    input.text = input.text.toUpperCase().replace(/[^A-Z0-9.]/g, '')
                    backend.input_changed(input.text, from.value, to.value);
                }
                width: parent.width
                focus: true
            }
        }
        RowLayout {
            Label {
                id: from_text
                text: "from 10"
                horizontalAlignment: Qt.AlignRight
            }
            Slider {
                id: from
                Layout.fillWidth: true
                Layout.columnSpan: 2
                from: 2
                value: 10
                to: 36
                stepSize: 1
                onValueChanged: {
                    backend.input_changed(input.text, from.value, to.value);
                    from_text.text = "from " + from.value.toString();
                }
                handle.implicitWidth: to_text.height
                handle.implicitHeight: to_text.height
            }
        }
        RowLayout {
            Label {
                id: to_text
                text: "  to 36"
                horizontalAlignment: Qt.AlignRight
            }
            Slider {
                id: to
                Layout.fillWidth: true
                Layout.columnSpan: 2
                from: 2
                value: 36
                to: 36
                stepSize: 1
                onValueChanged: {
                    backend.input_changed(input.text, from.value, to.value);
                    to_text.text = "  to " + to.value.toString();
                }
                handle.implicitWidth: to_text.height
                handle.implicitHeight: to_text.height
            }
        }
        ColumnLayout {
            TextField {
                id: output
                text: backend.result
                Layout.fillWidth: true
                Layout.columnSpan: 1
                font: main.fontLarge
                readOnly: true
                width: parent.width
            }
        }
        ButtonRow{
            visible: (main.height > 300) ? true : false
            Layout.fillWidth: true
            Layout.fillHeight: true
            text1: "FLIP"
            text2: "RESET"
            text3: "CLEAR"
            text4: "< DELETE"
            enable5: false
            enable6: false
            color1: darkMode ? "#0D47A1" : "#275fb8"
            color2: darkMode ? "#C8090B" : "#f51618"
            color3: darkMode ? "#C8090B" : "#f51618"
            color4: darkMode ? "#C63100" : "#ff6633"
            onButtonPressed: (text) => {
                if( text == "FLIP"){
                    var base_from = from.value;
                    var base_to = to.value;
                    var out_text = output.text;
                    out_text = out_text.replace("\\", "");
                    out_text = out_text.replace("\n", "");
                    out_text = out_text.replace("\n", "");
                    out_text = out_text.replace(" ", "");
                    to.value = base_from;
                    from.value = base_to;
                    if (!out_text.includes("Output")){
                        input.text = out_text;
                    }
                }
                if( text == "RESET"){
                    input.text = "";
                    from.value = 10;
                    to.value = 36;
                }
                if( text == "CLEAR"){
                    input.text = "";
                }
                if( text == "< DELETE"){
                    input.text = input.text.slice(0, -1);
                }
            }
        }
        ButtonRow{
            visible: (main.height > 300) ? true : false
            Layout.fillWidth: true
            Layout.fillHeight: true
            text1: "V"
            text2: "W"
            text3: "X"
            text4: "Y"
            text5: "Z"
            enable1: (from.value >= 32) ? true : false
            enable2: (from.value >= 33) ? true : false
            enable3: (from.value >= 34) ? true : false
            enable4: (from.value >= 35) ? true : false
            enable5: (from.value >= 36) ? true : false
            enable6: true
            text6: "."
            color6: darkMode ? "#006064" : "#109ba1"
            onButtonPressed: (text) => {
                input.text += text
            }
        }
        ButtonRow{
            visible: (main.height > 300) ? true : false
            Layout.fillWidth: true
            Layout.fillHeight: (from.value >= 26) ? true : false
            text1: "P"
            text2: "Q"
            text3: "R"
            text4: "S"
            text5: "T"
            text6: "U"
            enable1: (from.value >= 26) ? true : false
            enable2: (from.value >= 27) ? true : false
            enable3: (from.value >= 28) ? true : false
            enable4: (from.value >= 29) ? true : false
            enable5: (from.value >= 30) ? true : false
            enable6: (from.value >= 31) ? true : false
            onButtonPressed: (text) => {input.text += text}
        }
        ButtonRow{
            visible: (main.height > 300) ? true : false
            Layout.fillWidth: true
            Layout.fillHeight: (from.value >= 20) ? true : false
            text1: "J"
            text2: "K"
            text3: "L"
            text4: "M"
            text5: "N"
            text6: "O"
            enable1: (from.value >= 20) ? true : false
            enable2: (from.value >= 21) ? true : false
            enable3: (from.value >= 22) ? true : false
            enable4: (from.value >= 23) ? true : false
            enable5: (from.value >= 24) ? true : false
            enable6: (from.value >= 25) ? true : false
            onButtonPressed: (text) => {input.text += text}
        }
        ButtonRow{
            visible: (main.height > 300) ? true : false
            Layout.fillWidth: true
            Layout.fillHeight: (from.value >= 14) ? true : false
            text1: "D"
            text2: "E"
            text3: "F"
            text4: "G"
            text5: "H"
            text6: "I"
            enable1: (from.value >= 14) ? true : false
            enable2: (from.value >= 15) ? true : false
            enable3: (from.value >= 16) ? true : false
            enable4: (from.value >= 17) ? true : false
            enable5: (from.value >= 18) ? true : false
            enable6: (from.value >= 19) ? true : false
            onButtonPressed: (text) => {input.text += text}
        }
        ButtonRow{
            visible: (main.height > 300) ? true : false
            Layout.fillWidth: true
            Layout.fillHeight: (from.value >= 8) ? true : false
            text1: "7"
            text2: "8"
            text3: "9"
            text4: "A"
            text5: "B"
            text6: "C"
            enable1: (from.value >= 8) ? true : false
            enable2: (from.value >= 9) ? true : false
            enable3: (from.value >= 10) ? true : false
            enable4: (from.value >= 11) ? true : false
            enable5: (from.value >= 12) ? true : false
            enable6: (from.value >= 13) ? true : false
            onButtonPressed: (text) => {input.text += text}
        }
        ButtonRow{
            visible: (main.height > 300) ? true : false
            Layout.fillWidth: true
            Layout.fillHeight: (from.value >= 2) ? true : false
            text1: "1"
            text2: "2"
            text3: "3"
            text4: "4"
            text5: "5"
            text6: "6"
            enable1: (from.value >= 2) ? true : false
            enable2: (from.value >= 3) ? true : false
            enable3: (from.value >= 4) ? true : false
            enable4: (from.value >= 5) ? true : false
            enable5: (from.value >= 6) ? true : false
            enable6: (from.value >= 7) ? true : false
            onButtonPressed: (text) => {input.text += text}
        }
        ButtonRow{
            visible: (main.height > 300) ? true : false
            Layout.fillWidth: true
            Layout.fillHeight: true
            text1: "0"
            color1: darkMode ? "#0D47A1" : "#275fb8"
            onButtonPressed: (text) => {input.text += text}
            enable2: false
            enable3: false
            enable4: false
            enable5: false
            enable6: false
        }
    }
}
