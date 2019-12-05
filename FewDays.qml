import QtQuick 2.0
import "owm.js" as Owm

ListView {
    id: container
    Component {
        id: weatherDelegate
        Item {
            height: Math.max(icon.height, time.height)
            Row {
                spacing: time.height
                Text {
                    id: time
                    anchors.verticalCenter: icon.verticalCenter
                    text: model.time
                }
                Image {
                    id: icon
                    source: Owm.iconUrl(model.icon)
                    sourceSize.height: 50
                    sourceSize.width: 50
                }
                Text {
                    anchors.verticalCenter: icon.verticalCenter
                    text: model.temp
                }
                Text {
                    anchors.verticalCenter: icon.verticalCenter
                    text: model.description
                }
                Text {
                    anchors.verticalCenter: icon.verticalCenter
                    text: model.wind
                }
            }
        }
    }
    model: ListModel {
        id: listModel
    }

    delegate: weatherDelegate

    section.property: "day"
    Component {
            id: sectionHeading
            Rectangle {
                width: container.width
                height: childrenRect.height
                color: "lightgray"

                Text {
                    text: section
                    font.bold: true
                }
            }
        }
    section.delegate:  sectionHeading

    function refresh(city, apikey) {
        Owm.getForecast(city, apikey, listModel)
    }
}
