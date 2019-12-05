import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.2
import Qt.labs.settings 1.0
import "owm.js" as Owm

ApplicationWindow {
    id: window
    visible: true
    width: 375
    height: 430
    title: qsTr("Simple Weather")

    Settings {
        id: settings
        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
        property alias city: cityText.text
        property string apikey
    }

    Action {
        id: refreshAction
        text: qsTr("&Refresh")
        onTriggered: {
            console.log("Doing refresh");
            mainView.refresh()
        }
    }

    Dialog {
        id: apikeyDialog
        title: qsTr("Enter API key")
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        onAccepted: {
            settings.apikey = input.text
            refreshAction.trigger()
        }
        TextField {
            id: input
            width: parent.width
            text: settings.apikey
            onEditingFinished: apikeyDialog.click(StandardButton.Ok)
        }
        Component.onCompleted: {
            if (settings.apikey.length === 0)
                open()
        }
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                action: refreshAction
            }
            MenuItem {
                text: qsTr("&Set API key")
                onTriggered: apikeyDialog.visible = true
            }

            MenuItem {
                text: qsTr("&Exit")
                onTriggered: Qt.quit()
            }
        }
    }
    GridLayout {
        anchors.fill: parent
        columns: 1

        TextField {
            id: cityText
            Layout.fillWidth: true
            placeholderText: qsTr("Enter city...")
            onEditingFinished: refreshAction.trigger()
        }

        TabView {
            id: mainView
            Layout.fillHeight: true
            Layout.fillWidth: true

            property alias city: cityText.text

            function refresh() {
                var tab = getTab(currentIndex)
                if (tab !== null && tab.status === Loader.Ready)
                    tab.item.refresh(city, settings.apikey)
            }

            Tab {
                title: qsTr("Today")
                Today {}
                onLoaded: mainView.refresh()
            }
            Tab {
                title: qsTr("5 Days")
                FewDays {clip: true}
            }
            onCurrentIndexChanged: { refresh() }
        }
    }
}
