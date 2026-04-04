import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root

  property var pluginApi: null
  property var widgetSettings: null

  spacing: Style.marginM

  // =========================
  // 🎨 COLOR SETTINGS
  // =========================

  property color editPrimaryColor:
    widgetSettings?.data?.primaryColor ?? "green"

  property color editSecondaryColor:
    widgetSettings?.data?.secondaryColor ?? "white"

  property color editHighlightColor:
    widgetSettings?.data?.highlightColor ?? "red"

  property color editMinuteArcColor:
    widgetSettings?.data?.minuteArcColor ?? "yellow"

  property color editHourArcColor:
    widgetSettings?.data?.hourArcColor ?? "green"

  // =========================
  // 🔤 FONT SETTINGS
  // =========================

  property string editFontFamily:
    widgetSettings?.data?.fontFamily ?? "sans-serif"

  property real editFontScale:
    widgetSettings?.data?.fontScale ?? 1.0


  Component.onCompleted: {
    Logger.i("CalendarWidget", "Settings loaded")
  }

  // =========================
  // 🎨 COLORS UI
  // =========================

  NLabel { label: "Colors" }

  function colorPickerRow(labelText, colorProp, setter) {
    return Qt.createQmlObject(`
      import QtQuick
      import QtQuick.Layouts
      import qs.Widgets

      RowLayout {
        spacing: 10

        NLabel {
          label: "${labelText}"
          Layout.fillWidth: true
        }

        NColorPicker {
          Layout.preferredWidth: 40
          Layout.preferredHeight: 40
          selectedColor: root.${colorProp}
          onColorSelected: function(color) {
            root.${colorProp} = color;
            root.saveSettings();
          }
        }
      }
    `, root)
  }

  // Primary
  RowLayout {
    Layout.fillWidth: true
    spacing: 10

    NLabel { label: "Primary" }
    NColorPicker {
      selectedColor: root.editPrimaryColor
      onColorSelected: c => {
        root.editPrimaryColor = c
        root.saveSettings()
      }
    }
  }

  // Secondary
  RowLayout {
    Layout.fillWidth: true
    spacing: 10

    NLabel { label: "Secondary" }
    NColorPicker {
      selectedColor: root.editSecondaryColor
      onColorSelected: c => {
        root.editSecondaryColor = c
        root.saveSettings()
      }
    }
  }

  // Highlight
  RowLayout {
    Layout.fillWidth: true
    spacing: 10

    NLabel { label: "Highlight" }
    NColorPicker {
      selectedColor: root.editHighlightColor
      onColorSelected: c => {
        root.editHighlightColor = c
        root.saveSettings()
      }
    }
  }

  // Minute Arc
  RowLayout {
    Layout.fillWidth: true
    spacing: 10

    NLabel { label: "Minute Arc" }
    NColorPicker {
      selectedColor: root.editMinuteArcColor
      onColorSelected: c => {
        root.editMinuteArcColor = c
        root.saveSettings()
      }
    }
  }

  // Hour Arc
  RowLayout {
    Layout.fillWidth: true
    spacing: 10

    NLabel { label: "Hour Arc" }
    NColorPicker {
      selectedColor: root.editHourArcColor
      onColorSelected: c => {
        root.editHourArcColor = c
        root.saveSettings()
      }
    }
  }

  // =========================
  // 🔤 FONT UI
  // =========================

  NDivider {
    Layout.fillWidth: true
  }

  NLabel { label: "Typography" }

  // Font family
  RowLayout {
    Layout.fillWidth: true
    spacing: 10

    NLabel { label: "Font" }

    ComboBox {
      Layout.fillWidth: true
      model: ["sans-serif", "serif", "monospace"]

      Component.onCompleted: {
        currentIndex = model.indexOf(root.editFontFamily)
      }

      onCurrentTextChanged: {
        root.editFontFamily = currentText
        root.saveSettings()
      }
    }
  }

  // Font scale
  ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.marginS

    NLabel {
      label: "Font Scale"
      description: root.editFontScale.toFixed(1)
    }

    NSlider {
      Layout.fillWidth: true
      from: 0.5
      to: 2.0
      stepSize: 0.1
      value: root.editFontScale

      onValueChanged: {
        root.editFontScale = value
        root.saveSettings()
      }
    }
  }

  // =========================
  // 💾 SAVE FUNCTION
  // =========================

  function saveSettings() {
    if (!widgetSettings || !widgetSettings.data) {
      Logger.e("CalendarWidget", "widgetSettings is null")
      return
    }

    // Colors
    widgetSettings.data.primaryColor = root.editPrimaryColor.toString()
    widgetSettings.data.secondaryColor = root.editSecondaryColor.toString()
    widgetSettings.data.highlightColor = root.editHighlightColor.toString()
    widgetSettings.data.minuteArcColor = root.editMinuteArcColor.toString()
    widgetSettings.data.hourArcColor = root.editHourArcColor.toString()

    // Typography
    widgetSettings.data.fontFamily = root.editFontFamily
    widgetSettings.data.fontScale = root.editFontScale

    widgetSettings.save()

    Logger.i("CalendarWidget", "Settings saved")
  }
  Component.onCompleted: {
      console.log("🔥 SETTINGS LOADED 🔥")
  }
}
