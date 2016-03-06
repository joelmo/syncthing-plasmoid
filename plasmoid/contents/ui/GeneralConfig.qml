import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import org.kde.plasma.components 2.0 as PlasmaComponents

ColumnLayout {

    property alias cfg_eventsReadTimerInterval: eventsReadTimerInterval.value

    GridLayout {
        Layout.fillWidth: false
        columns:2

        Label {
            text: "Timer interval:"
        }

        SpinBox {
            id: eventsReadTimerInterval
            suffix: " min"
            minimumValue: 1
            maximumValue: 120
        }
    }

    Item {
        Layout.fillHeight: true
    }

}
