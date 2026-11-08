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
   property color color1: darkMode ? "#333333" : "#ffffff"
   property color colorText1: darkMode ? "#ffffff" : "#000000"
   property color color2: darkMode ? "#333333" : "#ffffff"
   property color colorText2: darkMode ? "#ffffff" : "#000000"
   property color color3: darkMode ? "#333333" : "#ffffff"
   property color colorText3: darkMode ? "#ffffff" : "#000000"
   property color color4: darkMode ? "#333333" : "#ffffff"
   property color colorText4: darkMode ? "#ffffff" : "#000000"
   property color color5: darkMode ? "#333333" : "#ffffff"
   property color colorText5: darkMode ? "#ffffff" : "#000000"
   property color color6: darkMode ? "#333333" : "#ffffff"
   property color colorText6: darkMode ? "#ffffff" : "#000000"
   RowLayout {
      anchors.fill: parent
      Button {
           visible: buttonRow.enable1
           Layout.fillWidth: true
           Layout.fillHeight: true
           text: buttonRow.text1
           onClicked: buttonRow.buttonPressed(text)
           palette { button: buttonRow.color1; buttonText: buttonRow.colorText1 }
       }
       Button {
           visible: buttonRow.enable2
           Layout.fillWidth: true
           Layout.fillHeight: true
           text: buttonRow.text2
           onClicked: buttonRow.buttonPressed(text)
           palette { button: buttonRow.color2; buttonText: buttonRow.colorText2 }
       }
       Button {
           visible: buttonRow.enable3
           Layout.fillWidth: true
           Layout.fillHeight: true
           text: buttonRow.text3
           onClicked: buttonRow.buttonPressed(text)
           palette { button: buttonRow.color3; buttonText: buttonRow.colorText3 }
       }
       Button {
           visible: buttonRow.enable4
           Layout.fillWidth: true
           Layout.fillHeight: true
           text: buttonRow.text4
           onClicked: buttonRow.buttonPressed(text)
           palette { button: buttonRow.color4; buttonText: buttonRow.colorText4 }
       }
       Button {
           visible: buttonRow.enable5
           Layout.fillWidth: true
           Layout.fillHeight: true
           text: buttonRow.text5
           onClicked: buttonRow.buttonPressed(text)
           palette { button: buttonRow.color5; buttonText: buttonRow.colorText5 }
       }
       Button {
           visible: buttonRow.enable6
           Layout.fillWidth: true
           Layout.fillHeight: true
           text: buttonRow.text6
           onClicked: buttonRow.buttonPressed(text)
           palette { button: buttonRow.color6; buttonText: buttonRow.colorText6 }
       }
   }
}
