import QtQuick 2.0
import QtQuick.Layouts 1.2
import "owm.js" as Owm

Rectangle {
    color: "white"
    anchors.fill: parent

    function doRefresh(model) {
        if (model === null) return
        icon.source = model.icon
        temp.text = model.temp
        description.text = model.description
        wind.text = model.wind
        humidity.text = model.humidity
        pressure.text = model.pressure
    }

    function refresh(city, apikey) {
        Owm.getCurrentWeather(city, apikey, doRefresh)
    }

    GridLayout {
        columns: 3
        anchors.fill: parent
        Image {
            id: icon
        }
        Text {
            id: temp
        }
        Text {
            id: description
            Layout.fillWidth: true
        }
        Text {
            id: wind
            Layout.columnSpan: 3
        }
        Text {
            id: humidity
            Layout.columnSpan: 3
        }
        Text {
            id: pressure
            Layout.columnSpan: 3
        }
        Item {
            Layout.fillHeight: true
        }
    }
}

