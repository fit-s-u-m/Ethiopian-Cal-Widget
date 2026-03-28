import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Modules.DesktopWidgets
import qs.Widgets

DraggableDesktopWidget {
  id: root

  property var pluginApi: null

  readonly property string message:
    pluginApi?.pluginSettings?.message ||
    pluginApi?.manifest?.metadata?.defaultSettings?.message ||
    "Hello World"

  // Scale dimensions by widgetScale
  implicitWidth: Math.round(200 * widgetScale)
  implicitHeight: Math.round(120 * widgetScale)
  width: implicitWidth
  height: implicitHeight

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: Math.round(Style.marginL * widgetScale)
    spacing: Math.round(Style.marginS * widgetScale)

    NIcon {
      icon: "noctalia"
      pointSize: Math.round(Style.fontSizeXXL * widgetScale)
      Layout.alignment: Qt.AlignHCenter
    }

    NText {
      text: root.message
      pointSize: Math.round(Style.fontSizeM * widgetScale)
      Layout.alignment: Qt.AlignHCenter
    }

    NText {
      text: "Desktop Widget"
      pointSize: Math.round(Style.fontSizeS * widgetScale)
      color: Color.mOnSurfaceVariant
      Layout.alignment: Qt.AlignHCenter
    }
  }
}
// import qs.Modules.DesktopWidgets // mandatory
// import QtQuick
// import QtQuick.Layouts
// import qs.Commons
// import qs.Widgets
//
// DraggableDesktopWidget {
//   id: root
//
//   // Plugin API (injected by PluginService)
//   property var pluginApi: null
//
//   // Widget dimensions
//   implicitWidth: 200
//   implicitHeight: 120
//     // Custom colors from widget data
//   property color textColor: {
//     var color = widgetData && widgetData.textColor ? widgetData.textColor : ""
//     return (color && color !== "") ? color : Color.mOnSurface
//   }
//
//   // Custom font size
//   property real fontSize: {
//     var size = widgetData && widgetData.fontSize ? widgetData.fontSize : 0
//     return (size && size > 0) ? size : Style.fontSizeL
//   }
//
//   // Opacity
//   property real widgetOpacity: (widgetData && widgetData.opacity) ? widgetData.opacity : 1.0
//
//   // Boolean options
//   property bool showDetails: (widgetData && widgetData.showDetails !== undefined) ? widgetData.showDetails : true
//
//   // Your widget content here
// }
