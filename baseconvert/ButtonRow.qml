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
   property bool darkMode: Application.styleHints.colorScheme === Qt.ColorScheme.Dark
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
           id: button1
           visible: enable1
           Layout.fillWidth: true
           Layout.fillHeight: true
           text: buttonRow.text1
           onClicked:  buttonPressed(text)
           palette {
               button: color1
               buttonText: colorText1
           }
       }
       Button {
           id: button2
           visible: enable2
           Layout.fillWidth: true
           Layout.fillHeight: true
           text: buttonRow.text2
           onClicked:  buttonPressed(text)
           palette {
               button: color2
               buttonText: colorText2
           }
       }
       Button {
           id: button3
           visible: enable3
           Layout.fillWidth: true
           Layout.fillHeight: true
           text: buttonRow.text3
           onClicked:  buttonPressed(text)
           palette {
               button: color3
               buttonText: colorText3
           }
       }
       Button {
           id: button4
           visible: enable4
           Layout.fillWidth: true
           Layout.fillHeight: true
           text: buttonRow.text4
           onClicked:  buttonPressed(text)
           palette {
               button: color4
               buttonText: colorText4
           }
       }
       Button {
           id: button5
           visible: enable5
           Layout.fillWidth: true
           Layout.fillHeight: true
           text: buttonRow.text5
           onClicked:  buttonPressed(text)
           palette {
               button: color5
               buttonText: colorText5
           }
       }
       Button {
           id: button6
           visible: enable6
           Layout.fillWidth: true
           Layout.fillHeight: true
           text: buttonRow.text6
           onClicked:  buttonPressed(text)
           palette {
               button: color6
               buttonText: colorText6
           }
       }
   }
}
