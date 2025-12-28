import QtQuick
import Quickshell

PanelWindow {
  id: root
  visible: false
  width: 340
  height: 440
  color: "transparent"
  focusable: true  
  property bool isClosing: false
  signal launchFirst(var tracker)
  onVisibleChanged: {
    if (!visible) {
      searchInput.text = "";
    }
  }
    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        radius: 12
        color: Qt.rgba(0.12, 0.12, 0.12, 0.65) 
        border.color: Qt.rgba(1, 1, 1, 0.32) 
        border.width: 1
        clip: true

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            color: "transparent"
            radius: 11
            border.color: Qt.rgba(1, 1, 1, 0.03)
            border.width: 1
        }

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // --- SEARCH BAR ---
            Rectangle {
                width: parent.width
                height: 45
                color: Qt.rgba(0, 0, 0, 0.2)
                radius: 12
                border.color: Qt.rgba(1, 1, 1, 0.15)

                TextInput {
                    id: searchInput
                    anchors.fill: parent
                    anchors.margins: 12
                    verticalAlignment: TextInput.AlignVCenter
                    horizontalAlignment: TextInput.AlignHCenter
                    font.family: "JetBrains Mono"
                    color: "white"
                    font.pixelSize: 18
                    focus: true
                    
                    Text {
                        text: ""
                        color: Qt.rgba(1, 1, 1, 0.4)
                        visible: searchInput.text === ""
                        anchors.centerIn: parent
                    }

                    Keys.onEscapePressed: root.visible = false
                    Keys.onReturnPressed: {
                        var tracker = { launched: false };
                        root.launchFirst(tracker); 
                    }
                }
            }

            // --- APP LIST ---
            ListView {
                id: appListView
                width: parent.width
                height: parent.height - 80
                clip: true
                model: DesktopEntries.applications
                cacheBuffer: 500 
                leftMargin: 6
                rightMargin: 6
                topMargin: 5
                bottomMargin: 5

                delegate: Rectangle {
                    id: appDelegate
                  // MoRE EffiCieNtT CODeE
                property bool matches: {
                    const lowerName = modelData.name.toLowerCase()
                    const searchText = searchInput.text.toLowerCase()
                    return lowerName.includes(searchText) && !lowerName.startsWith("avahi")
                }
                    
                    readonly property bool isSelected: matches && appDelegate.y < 5
                    
                    visible: matches
                    height: matches ? 50 : 0
                    width: appListView.width - (appListView.leftMargin + appListView.rightMargin)
                    radius: 12
                    
                    // --- Animation ---
                    scale: isSelected ? 1.03 : 1.0
                    opacity: isSelected ? 1.0 : 0.7
                    color: isSelected ? Qt.rgba(0, 0, 0, 0.18) : "transparent"
                    border.color: isSelected ? Qt.rgba(1, 1, 1, 0.18) : "transparent"
                    border.width: 1
                    Behavior on scale { NumberAnimation { duration: 450; easing.type: Easing.OutBack } }
                    Behavior on color { ColorAnimation { duration: 250 } }

                    Connections {
                        target: root
                        function onLaunchFirst(tracker) {
                            if (appDelegate.isSelected) {
                                modelData.execute();
                                root.visible = false;
                            }
                        }
                    }

                    Text {
                        id: appText
                        text: modelData.name
                        color: "white"
                        font.family: "JetBrains Mono"
                        font.pixelSize: appDelegate.isSelected ? 17 : 16
                        anchors.centerIn: parent
                    }

                    // --- ICON ---
                    Item {
                        width: 28; height: 28
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: appText.left
                        anchors.rightMargin: 12
                        
                        visible: appIcon.status === Image.Ready && appIcon.source != ""

   // fixed my dum ahh icon rendering
Image {
    id: appIcon
    anchors.fill: parent
    fillMode: Image.PreserveAspectFit

    property string iconSource: {
        return modelData.icon.startsWith("/")
            ? "file://" + modelData.icon
            : "image://icon/" + modelData.icon;
    }

    source: iconSource
    sourceSize.width: width
    sourceSize.height: height
    asynchronous: true
    smooth: false
    antialiasing: false
    visible: status !== Image.Error
}
                    }

                 }
            }
        }
    }
}
