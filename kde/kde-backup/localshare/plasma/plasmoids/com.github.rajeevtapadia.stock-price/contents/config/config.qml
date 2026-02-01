import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import org.kde.kirigami 2.20 as Kirigami

Kirigami.FormLayout {
    id: root
    property alias cfg_symbol: symbolField.text
    property alias cfg_refreshMinutes: refreshSpin.value

    Kirigami.Heading {
        text: "Stock Price Settings"
        level: 3
        Layout.fillWidth: true
    }

    TextField {
        id: symbolField
        Kirigami.FormData.label: "Symbol"
        placeholderText: "^NSEI"
    }

    SpinBox {
        id: refreshSpin
        Kirigami.FormData.label: "Refresh (minutes)"
        from: 1
        to: 120
        stepSize: 1
    }
}

