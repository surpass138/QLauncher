import QtQuick 2.0
import com.cai.qlauncher 1.0 as QL
import config 1.0 as Config

FocusScope {
    id: root
    Image {
            id: background
            fillMode: Image.PreserveAspectFit
            smooth: true
            verticalAlignment: Image.AlignTop
            source: "qrc:/images/background"
            width: applicationWindow.width
            //height: applicationWindow.height
        }
    property int navbarMargin: QL.DisplayConfig.navBarVisible ? QL.DisplayConfig.navigationBarHeight : 0
    property int statusbarMargin: QL.DisplayConfig.statusBarHeight

    focus: true

    MouseArea {
        anchors.fill: parent

        onPressAndHold: QL.Launcher.pickWallpaper()
    }

    GridView {
        id: gridView

        anchors.fill: parent

        property int highlightedItem

        maximumFlickVelocity: height * 5

        header: Item {
            width: parent.width
            height: 80 * QL.DisplayConfig.dp
        }

        add: Transition {
            NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 450 }
            NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 500 }
        }

        displaced: Transition {
            NumberAnimation { property: "opacity"; to: 1.0 }
            NumberAnimation { property: "scale"; to: 1.0 }
        }

        clip: true
        interactive: visible

        cellHeight: height / Config.Theme.getColumns()
        cellWidth: width / Config.Theme.getRows()

        model: listModelDesktop

        delegate: ApplicationTile {
            id: applicationTile

            height: GridView.view.cellHeight
            width: GridView.view.cellWidth

            source: "file:/usr/local/"+model.name+"/"+model.icon
            text: model.name

            onClicked:
            {
                //console.debug("ThemeMain:onClicked "+model.name+",model.pkgName="+model.pkgName);
                QL.ApplicationManager.launchApplication(model.name,model.pkgName)
            }
            onPressAndHold: root.pressAndHold(model, x, y)
        }

        onHeightChanged: {
            if (height !== 0)
                cacheBuffer = Math.max(1080, height * 5)
        }
    }


    GridView {
        anchors {
            top: parent.top; topMargin: QL.DisplayConfig.statusBarHeight
            left: parent.left
            right: parent.right
        }

        height: 4 * (80 * QL.DisplayConfig.dp)
        model: 16
        enabled: false
        interactive: false
        cellHeight: height / 4
        cellWidth: width / 4

        delegate: DropArea {
            width: GridView.view.cellWidth
            height: GridView.view.cellHeight
        }
    }

    Row {
        id: rowFavorites

        anchors {
            bottom: parent.bottom; bottomMargin: root.navbarMargin
        }

        height: 80 * QL.DisplayConfig.dp

        Repeater {
            model: 5

            DropArea {
                width: 80 * QL.DisplayConfig.dp
                height: 80 * QL.DisplayConfig.dp
            }
        }
    }

    Connections {
        target: QL.Launcher

        onNewIntentReceived: applicationAll.close()
        onMinimized: applicationAll.close()
    }
}
