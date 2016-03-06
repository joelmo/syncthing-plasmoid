import QtQuick 2.2
import QtQuick.Layouts 1.2
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    property int numEventsRead: 0
    property int numDevicesConnected: 0
    property string state: "state-information"

    Plasmoid.icon: state
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: CompactRepresentation { }

    Component.onCompleted: {
        eventsTimer.start()
        eventsRead()
    }

    Timer {
        id: eventsTimer
        interval: plasmoid.configuration.eventsReadTimerInterval * 60 * 1000
        running: true
        repeat: true
        onTriggered: eventsRead()
    }

    function eventsHandle(events) {
        state = "state-offline";
        events.forEach(function (e) {
            if (e.type == "StateChanged") {
                switch (e.data.from + "-" + e.data.to) {
                    case "idle-syncing":
                    state = "state-sync";
                    break;
                    case "syncing-idle":
                    state = "cloudstatus";
                    break;
                }
            } else if (e.type == "DeviceConnected") {
                numDevicesConnected++;
            } else if (e.type == "DeviceDisconnected") {
                numDevicesConnected--;
            }
        });
        if (numDevicesConnected == 0) {
            state = "state-offline";
        }
        numEventsRead = events[events.length - 1]["id"]
        Plasmoid.toolTipSubText = numDevicesConnected + " devices connected"
    }

    function eventsRead() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "http://localhost:8384/rest/events?since=" + numEventsRead, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE && xhr.status == 200) {
                var resp = JSON.parse(xhr.responseText);
                eventsHandle(resp);
            }
        }
        xhr.send(null);
    }

}
