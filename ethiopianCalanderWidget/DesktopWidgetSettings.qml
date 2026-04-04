import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
    id: root
    property var pluginApi: null
    property var widgetSettings: null   // injected by Noctalia

    spacing: Style.marginM

    // =========================
    // Local editable state (best practice)
    // =========================
    property color editPrimaryColor:    widgetSettings?.data?.primaryColor ?? "green"
    property color editSecondaryColor:  widgetSettings?.data?.secondaryColor ?? "white"
    property color editHighlightColor:  widgetSettings?.data?.highlightColor ?? "red"
    property color editMinuteArcColor:  widgetSettings?.data?.minuteArcColor ?? "yellow"
    property color editHourArcColor:    widgetSettings?.data?.hourArcColor ?? "green"

    property string editFontFamily: widgetSettings?.data?.fontFamily ?? "sans-serif"
    property real editFontScale:    widgetSettings?.data?.fontScale ?? 1.0

    Component.onCompleted: {
        Logger.i("EthiopianCalendar", "Settings UI loaded")
    }

    // =========================
    // Colors Section
    // =========================
    NLabel { label: "Colors" }

    // Reusable color row (cleaner version)
    Component {
        id: colorRow
        RowLayout {
            property string labelText: ""
            property color currentColor: "white"
            property string dataKey: ""   // key in widgetSettings.data

            spacing: 10
            NLabel {
                label: labelText
                Layout.fillWidth: true
            }
            NColorPicker {
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                selectedColor: currentColor
                onColorSelected: function(c) {
                    currentColor = c
                    widgetSettings.data[dataKey] = c.toString()
                    widgetSettings.save()
                }
            }
        }
    }

    Loader {
        Layout.fillWidth: true
        sourceComponent: colorRow
        property var modelData: ({ labelText: "Primary",     currentColor: root.editPrimaryColor,    dataKey: "primaryColor" })
    }
    Loader {
        Layout.fillWidth: true
        sourceComponent: colorRow
        property var modelData: ({ labelText: "Secondary",   currentColor: root.editSecondaryColor,  dataKey: "secondaryColor" })
    }
    Loader {
        Layout.fillWidth: true
        sourceComponent: colorRow
        property var modelData: ({ labelText: "Highlight",   currentColor: root.editHighlightColor,  dataKey: "highlightColor" })
    }
    Loader {
        Layout.fillWidth: true
        sourceComponent: colorRow
        property var modelData: ({ labelText: "Minute Arc",  currentColor: root.editMinuteArcColor,  dataKey: "minuteArcColor" })
    }
    Loader {
        Layout.fillWidth: true
        sourceComponent: colorRow
        property var modelData: ({ labelText: "Hour Arc",    currentColor: root.editHourArcColor,    dataKey: "hourArcColor" })
    }

    NDivider { Layout.fillWidth: true }

    // =========================
    // Typography
    // =========================
    NLabel { label: "Typography" }

    RowLayout {
        Layout.fillWidth: true
        spacing: 10
        NLabel { label: "Font Family" }
        ComboBox {
            Layout.fillWidth: true
            model: ["sans-serif", "serif", "monospace"]
            currentIndex: model.indexOf(root.editFontFamily)
            onCurrentTextChanged: {
                if (currentText) {
                    widgetSettings.data.fontFamily = currentText
                    widgetSettings.save()
                }
            }
        }
    }

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
                widgetSettings.data.fontScale = value
                widgetSettings.save()
            }
        }
    }

}
