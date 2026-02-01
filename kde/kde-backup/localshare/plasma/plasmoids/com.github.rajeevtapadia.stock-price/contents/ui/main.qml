import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.20 as Kirigami
import "../code/get-price.js" as PriceApi

PlasmoidItem {
    id: root

    property string symbol: plasmoid.configuration.symbol || "^NSEI"
    property int refreshMinutes: plasmoid.configuration.refreshMinutes || 10

    property string priceText: "—"
    property string diffText: ""
    property color diffColor: "white"

    readonly property int refreshMs: refreshMinutes * 60 * 1000

    compactRepresentation: Item {
        // Explicit size + layout hints so the panel reserves space
        implicitWidth: priceRow.implicitWidth + 12
        implicitHeight: priceRow.implicitHeight + 12
        Layout.minimumWidth: implicitWidth
        Layout.minimumHeight: implicitHeight
        width: implicitWidth
        height: implicitHeight

        RowLayout {
            id: priceRow
            anchors.centerIn: parent
            spacing: 6

            Label {
                id: priceLabel
                text: priceText
                font.bold: false
                font.pointSize: 11
                color: diffColor
            }

            Label {
                id: diffLabel
                text: diffText
                font.bold: false
                font.pointSize: 8
                color: diffColor
            }
        }
    }

    fullRepresentation: ColumnLayout {
        anchors.fill: parent
        spacing: 8

        RowLayout {
            spacing: 6

            Label {
                text: priceText
                font.bold: false
                font.pointSize: 12
                color: diffColor
            }

            Label {
                text: diffText
                font.bold: false
                font.pointSize: 10
                color: diffColor
            }
        }

        Button {
            text: "Refresh"
            onClicked: refresh()
        }

        Label {
            text: "Symbol: " + symbol + " • every " + refreshMinutes + " min"
            font.pointSize: 10
            color: Kirigami.Theme.textColor
        }
    }

    Component.onCompleted: refresh()

    Timer {
        id: refreshTimer
        interval: refreshMs
        running: true
        repeat: true
        onTriggered: refresh()
    }

    function refresh() {
        PriceApi.getPrice(symbol)
            .then(function (data) {
                priceText = data.latest_price.toString()
                diffText = data.diff_percent.toFixed(2) + "%"
                diffColor = data.diff > 0
                    ? "#22c55e"
                    : data.diff < 0
                        ? "#ef4444"
                        : "#cbd5e1"
            })
            .catch(function (err) {
                priceText = "Err"
                diffText = ""
                diffColor = "orange"
                console.log("Stock widget error: " + err)
            })
    }

    onRefreshMinutesChanged: {
        refreshTimer.interval = refreshMs
        refreshTimer.restart()
    }
}
