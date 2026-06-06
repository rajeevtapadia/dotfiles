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
    property string lastError: ""
    property bool isFetching: false
    property int retryAttempt: 0
    readonly property int maxRetries: 3

    compactRepresentation: Item {
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
                text: priceText
                font.bold: false
                font.pointSize: 11
                color: diffColor
            }

            Label {
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

        Label {
            visible: lastError.length > 0
            text: "⚠ " + lastError
            font.pointSize: 8
            color: "#f59e0b"
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Button {
            text: "Refresh"
            enabled: !isFetching
            onClicked: startFetch()
        }

        Label {
            text: "Symbol: " + symbol + " • every " + refreshMinutes + " min"
            font.pointSize: 10
            color: Kirigami.Theme.textColor
        }
    }

    Component.onCompleted: startFetch()

    Timer {
        id: refreshTimer
        interval: refreshMinutes * 60 * 1000
        running: true
        repeat: true
        onTriggered: startFetch()
    }

    Timer {
        id: retryTimer
        repeat: false
        onTriggered: doFetch()
    }

    onRefreshMinutesChanged: {
        refreshTimer.interval = refreshMinutes * 60 * 1000
        refreshTimer.restart()
    }

    function startFetch() {
        if (isFetching) return
        retryAttempt = 0
        lastError = ""
        isFetching = true
        doFetch()
    }

    function doFetch() {
        var attempt = retryAttempt + 1
        console.log("[StockWidget] Fetching " + symbol + " (attempt " + attempt + "/" + maxRetries + ")")

        PriceApi.fetchPrice(
            symbol,
            function (data) {
                isFetching = false
                retryAttempt = 0
                lastError = ""
                priceText = data.latest_price.toString()
                diffText = data.diff_percent.toFixed(2) + "%"
                diffColor = data.diff > 0 ? "#22c55e" : data.diff < 0 ? "#ef4444" : "#cbd5e1"
                console.log("[StockWidget] OK — " + symbol + " = " + data.latest_price)
            },
            function (errMsg) {
                console.log("[StockWidget] Attempt " + attempt + " failed: " + errMsg)
                lastError = errMsg

                if (retryAttempt < maxRetries - 1) {
                    retryAttempt++
                    var delay = 2000 * Math.pow(2, retryAttempt - 1)
                    console.log("[StockWidget] Retrying in " + delay + "ms")
                    retryTimer.interval = delay
                    retryTimer.start()
                } else {
                    isFetching = false
                    if (priceText === "—") priceText = "Err"
                    diffText = ""
                    diffColor = "orange"
                    console.log("[StockWidget] All attempts failed: " + errMsg)
                }
            }
        )
    }
}
