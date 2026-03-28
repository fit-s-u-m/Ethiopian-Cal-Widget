import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Modules.DesktopWidgets
import qs.Widgets

DraggableDesktopWidget {
  id: root

  property var pluginApi: null

  // Scale dimensions by widgetScale
  implicitWidth: Math.round(200 * widgetScale)
  implicitHeight: Math.round(120 * widgetScale)
  width: implicitWidth
  height: implicitHeight

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: Math.round(Style.marginL * widgetScale)
    spacing: Math.round(Style.marginS * widgetScale)

    NText {
      text: "Hello"
      pointSize: Math.round(Style.fontSizeM * widgetScale)
      Layout.alignment: Qt.AlignHCenter
    }
    Rectangle {
      width: 100
      height: 100
      radius: width / 2
      color: "red"
    }
  }
}
