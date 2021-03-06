import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: dialog

    property int sourceId
    property alias name: inputName.text
    property alias url: inputUrl.text
    property alias color: swatch.color
    property bool editOnly
    property Item item

    canAccept: inputName.text !== ""
               && inputUrl.text !== ""

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.implicitHeight

        Column {
            id: column

            //height: childrenRect.height
            anchors.left: parent.left
            anchors.right: parent.right

            DialogHeader {
                title: qsTr("Save")
            }

            SectionHeader {
                text: qsTr("Feed")
            }

            TextField {
                id: inputName
                width: parent.width
                label: qsTr("Name")
                placeholderText: qsTr("Enter name")
            }

            TextField {
                id: inputUrl
                width: parent.width
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhUrlCharactersOnly
                label: qsTr("Feed URL")
                placeholderText: qsTr("Enter URL")
            }

            Item {
                width: 1
                height: Theme.paddingLarge
            }

            BackgroundItem {
                id: colorPicker
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Theme.paddingLarge
                height: Theme.itemSizeSmall

                Rectangle {
                    id: swatch
                    width: height
                    height: parent.height
                    border.width: Qt.colorEqual(color, "transparent") ? 2 : 0
                    border.color: Theme.secondaryColor
                    radius: 3
                    color: "#e60003"
                }

                Label {
                    anchors.left: swatch.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: Theme.paddingMedium
                    color: parent.down ? Theme.highlightColor : Theme.primaryColor
                    text: qsTr("Color tag")
                }

                onClicked: {
                    var colors = ["transparent", "#e60003", "#e6007c",
                                  "#e700cc", "#9d00e7", "#7b00e6",
                                  "#5d00e5", "#0077e7", "#01a9e7",
                                  "#00cce7", "#00e696", "#00e600",
                                  "#99e600", "#e3e601", "#e5bc00",
                                  "#e78601"];
                    var props = { "colors": colors };

                    var dlg = pageStack.push("Sailfish.Silica.ColorPickerDialog", props);

                    function f() {
                        swatch.color = dlg.color;
                    }

                    dlg.accepted.connect(f);
                }
            }

            Item {
                width: 1
                height: Theme.paddingLarge * 3
            }

            SectionHeader {
                visible: editOnly
                text: qsTr("Database")
            }

            Label {
                visible: editOnly
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Theme.paddingLarge
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.Wrap
                text: qsTr("Clearing the read status will cause all available items to be reloaded the next time.")
            }

            Item {
                width: 1
                height: Theme.paddingLarge
            }

            Button {
                visible: editOnly
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Clear read status")
                onClicked: {
                    dialog.item.forgetRead();
                    dialog.close();
                }
            }

            Item {
                width: 1
                height: Theme.paddingLarge
            }

            Label {
                visible: editOnly
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Theme.paddingLarge
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.Wrap
                text: qsTr("Deleting will remove the feed and all of its items from the database.")
            }

            Item {
                width: 1
                height: Theme.paddingLarge
            }

            Button {
                visible: editOnly
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Delete")
                onClicked: {
                    dialog.item.remove();
                    dialog.close();
                }
            }

        }//Column

        ScrollDecorator { }

    }//Flickable

    onAccepted: {
        function toHex(n)
        {
            var digits = "0123456789abcdef";
            var result = "";
            while (n > 0)
            {
                var digit = n % 16;
                n /= 16;
                result = digits.charAt(digit) + result;
            }
            result = "00" + result;
            return result.substr(result.length - 2, 2);
        }

        var colorString = "#" +
                toHex(swatch.color.a * 255) +
                toHex(swatch.color.r * 255) +
                toHex(swatch.color.g * 255) +
                toHex(swatch.color.b * 255);

        if (editOnly) {
            console.log("using color tag " + colorString);
            sourcesModel.changeSource(sourceId,
                                      inputName.text,
                                      inputUrl.text,
                                      colorString);
        } else {
            sourcesModel.addSource(inputName.text,
                                   inputUrl.text,
                                   colorString);
        }
    }

}
