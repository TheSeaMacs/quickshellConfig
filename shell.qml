import QtQuick
import Quickshell
import Quickshell.Hyprland

Scope {
    GlobalShortcut {
        name: "launcher"
        onPressed: {
            // Toggles the visibility of the root item in the loader
            launcherLoader.item.visible = !launcherLoader.item.visible
            console.log("GlobalShortcut pressed. Launcher visible: " + launcherLoader.item.visible)
        }
    }

    Loader {
        id: launcherLoader
        source: "Launcher.qml"
      }
}
