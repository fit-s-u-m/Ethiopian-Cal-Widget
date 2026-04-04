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
  property var widgetSettings: null

  property color primaryColor: widgetSettings?.data?.primaryColor ?? "green"

  property color secondaryColor: widgetSettings?.data?.secondaryColor ?? "white"

  property color highlightColor: widgetSettings?.data?.highlightColor ?? "red"

  property color minuteArcColor: widgetSettings?.data?.minuteArcColor ?? "yellow"

  property color hourArcColor: widgetSettings?.data?.hourArcColor ?? "green"

  property string fontFamily: widgetSettings?.data?.fontFamily ?? "sans-serif"

  property real fontScale: widgetSettings?.data?.fontScale ?? 1.0

  property real circleSize: Math.min(root.width > 0 ? root.width : implicitWidth,
                                       root.height > 0 ? root.height : implicitHeight)
  property real minuteProgress: (new Date().getMinutes() + new Date().getSeconds()/60)/60
  property real hourProgress:(new Date().getHours() + new Date().getMinutes()/60)/24 
  property real baseFontSize: root.circleSize / 25
  Canvas {
      id: ethioCal
      width: root.circleSize
      height: root.circleSize
      anchors.centerIn: parent

      onPaint: {
          const ctx = getContext("2d")
          ctx.reset()
          ctx.clearRect(0, 0, width, height)

          const n = 28
          const spacing = (2*Math.PI) / n

          const months = ["ታህሳስ-ሐምሌ", "መጋቢት", "ህዳር-ሰኔ", "የካቲት-ጳግሜ", "ጥቅምት-ግንቦት", "ጥር-ነሐሴ", "መስከረም-ሚያዝያ"]
          const allMeris = ["ዘ", "መ", "ን", "በ", "ሀ", "ገ", "ሬ"]
          const meriSeries = ["በ", "ን", "ዘ", "ሬ", "ገ", "ሀ", "ን", "መ", "ነ", "ገ", "ት", "ን", "ን", "መ", "ገ", "ሥ", "ት", "ን", "መ",
            "ዘ", "ሬ", "ገ", "በ", "ን", "መ", "ነ", "ሥ", "ሀ"]

          // Move origin to center
          ctx.translate(width/2, height/2)

          const radius = Math.min(width, height) / 2
          const today = new Date()
          const todayEc = toEthiopian(today)
          const thisYearMeriKal = calculateMeri(todayEc.year)
          const isAfter6Month = todayEc.month > 6


          let monthIndex;
          if(isAfter6Month){
            monthIndex = (todayEc.month  * 2 - 2) % 7;
          }
          else{
            monthIndex = ((todayEc.month  - 8) * 2) % 7;
          }


          const merikalindex = allMeris.findIndex(meri => meri == thisYearMeriKal)
          const baseRotationForMeriKals = -13
          const monthIndexRev = months.length - 1 - monthIndex
          const yearIndexRotation = baseRotationForMeriKals + merikalindex + monthIndexRev;

          // year shower
          for(let i =0; i<allMeris.length; i++) {
            const angle = (yearIndexRotation + i)*spacing
            const radiusMeri = 0.7* (radius /4 + radius/8) /2
            const x = Math.cos(angle)*radiusMeri
            const y = Math.sin(angle)*radiusMeri

            ctx.save()

              ctx.lineWidth = 1
              ctx.font = Math.round(root.baseFontSize * 0.5 * root.fontScale) + "px " + root.fontFamily;
              ctx.fillStyle = root.primaryColor
              ctx.strokeStyle = root.secondaryColor
              ctx.translate(x, y) 
              ctx.rotate(angle+Math.PI/2)

              if(merikalindex == i){
                ctx.strokeStyle = root.highlightColor
              }

              ctx.fillText(allMeris[i], 0, 0)
              ctx.strokeText(allMeris[i], 0, 0)

            ctx.restore()
          }
          
          // month shower
          for(let i =0; i<months.length; i++){
            const startAngle = -6 * spacing
            const a1 = (-(i + 1) * spacing) + startAngle
            const a2 = (-i * spacing) + startAngle

            const midAngle = (a1 + a2) / 2
            const textRadius = radius * 0.73

            const x = textRadius * Math.cos(midAngle)
            const y = textRadius * Math.sin(midAngle)

            ctx.save()

            ctx.translate(x, y) 
            ctx.rotate(midAngle)

            ctx.textAlign = "center"
            ctx.textBaseline = "middle"

            ctx.fillStyle = root.primaryColor
            ctx.strokeStyle = root.secondaryColor

            if( (months.length - 1 -monthIndex) == i){
              ctx.strokeStyle = root.highlightColor
            }
            ctx.lineWidth = 1
            ctx.font = Math.round(root.baseFontSize * 0.5 * root.fontScale) + "px " + root.fontFamily;


            ctx.fillText(months[i], 0, 0)
            ctx.strokeText(months[i], 0, 0)

            ctx.restore() 
          }


          // small arcs for weeek text

          for(let i =0; i<n; i++){
            const a1 = (-i+1+yearIndexRotation) * spacing
            const a2 = (-i+yearIndexRotation) * spacing 
            const weeks = ["ሰኞ", "ማክሰኞ", "ረቡዕ", "ሐሙስ", "አርብ", "ቅዳሜ", "እሁድ"].reverse()

            const midAngle = (a1 + a2) / 2
            const textRadius = radius * 0.38

            const x = textRadius * Math.cos(midAngle)
            const y = textRadius * Math.sin(midAngle)

            ctx.save()

            ctx.translate(x, y) 
            ctx.rotate(midAngle)
            if(x < 0){
              ctx.rotate(Math.PI)
            }

            ctx.font = Math.round(root.baseFontSize * 0.8 * root.fontScale) + "px " + root.fontFamily;

            ctx.textAlign = "center"
            ctx.textBaseline = "middle"

            ctx.fillStyle = root.primaryColor
            ctx.strokeStyle = root.secondaryColor
            
            ctx.lineWidth = 1
            const weekIndex = weeks.length - (i % weeks.length) - 1

            ctx.fillText(weeks[weekIndex], 0, 0)
            ctx.strokeText(weeks[weekIndex], 0, 0)

            ctx.restore() 
          }

          // show day numbers in the right place
          for(let i = 0; i<30; i++){
            const startAngle = 4*spacing
            const horizontalPos = i%7
            const verticalPos = Math.floor(i/7)

            const angle = (7- horizontalPos)*spacing - spacing/2 + startAngle
            const numOfDiv = 5
            const radDiff =(radius - radius/2)/numOfDiv
            const r = radius/2 +  (verticalPos*radDiff) + radDiff/2
            const x = Math.cos(angle) * r
            const y = Math.sin(angle) * r

            ctx.save() 

            ctx.translate(x, y) 
            // ctx.rotate(angle)

            ctx.textAlign = "center"
            ctx.textBaseline = "middle"
            ctx.font = Math.round(root.baseFontSize * 0.75 * root.fontScale) + "px " + root.fontFamily;

            ctx.fillStyle = root.primaryColor
            ctx.strokeStyle = root.secondaryColor

            if(todayEc.day == i+1)
              ctx.strokeStyle = root.highlightColor
            ctx.lineWidth = 1

            ctx.strokeText(i+1, 0, 0)
            ctx.restore() 

          }

          // Draw using progress bar
          const arcRadiusMinute = radius/2
          const arcRadiusHour = radius/4

          // // Draw minute progress
          ctx.beginPath()
          ctx.arc(0, 0, arcRadiusMinute, -Math.PI/2, -Math.PI/2 + 2 * Math.PI * root.minuteProgress)
          ctx.strokeStyle = root.minuteArcColor
          ctx.lineWidth = 4
          ctx.stroke()

          // // Draw hour progress
          ctx.beginPath()
          ctx.arc(0, 0, arcRadiusHour, -Math.PI/2, -Math.PI/2 + 2 * Math.PI * root.hourProgress)
          ctx.strokeStyle = root.hourArcColor
          ctx.lineWidth = 4
          ctx.stroke()

          function  calculateMeri (num) {
            let newNum = 1922
            let val
            if (num >= newNum) {
              val = (num - newNum) % n
            }
            else {
              val = n - (newNum - num) % n
            }
            return meriSeries[val]
          }
          function toEthiopian(date) {
            const gYear = date.getFullYear()
            const gMonth = date.getMonth() + 1 // JS months: 0–11
            const gDay = date.getDate()

            let ethYear = gYear - 8

            const nextYear = gYear + 1
            const isLeap = (nextYear % 4 === 0 && nextYear % 100 !== 0) || (nextYear % 400 === 0)
            const newYearDay = isLeap ? 12 : 11

            const ethNewYear = new Date(gYear, 8, newYearDay) // Sept = 8

            if (date >= ethNewYear) {
                ethYear += 1
            }

            const refYear = ethYear + 7
            const isLeap2 = ((refYear + 1) % 4 === 0 && (refYear + 1) % 100 !== 0) || ((refYear + 1) % 400 === 0)
            const newYearDay2 = isLeap2 ? 12 : 11

            const start = new Date(refYear, 8, newYearDay2)

            const diffDays = Math.floor((date - start) / (1000 * 60 * 60 * 24))

            const ethMonth = Math.floor(diffDays / 30) + 1
            const ethDay = (diffDays % 30) + 1

            return {
                year: ethYear,
                month: ethMonth,
                day: ethDay
            }
        }

      }
  }
  Timer {
    interval: 60000
    running: true
    repeat: true
    onTriggered: {
        const now = new Date()
        root.minuteProgress = (now.getMinutes() + now.getSeconds()/60)/60
        root.hourProgress = (now.getHours() + now.getMinutes()/60)/24
        ethioCal.requestPaint()  // trigger Canvas repaint
    }
  }
  Connections {
    target: widgetSettings

    function onDataChanged() {
        ethioCal.requestPaint()
    }
  }
}
