import QtQuick 2.0
import QtGraphicalEffects 1.0

import "../qmls/widgets"

Item {
    id: root
    width: 100
    height: 80
    state: "mini"
    visible: !!song

    property url picUrl
    property string artist
    property string album
    property string song
    property string lyric
    property int position
    property alias playing: disc.playing

    onLyricChanged: lyric_view.setLyric(lyric)
    onPositionChanged: lyric_view.setPosition(position)

    Behavior on width {
        SmoothedAnimation { duration: 300 }
    }

    Behavior on height {
        SmoothedAnimation { duration: 300 }
    }

    states: [
        State {
            name: "mini"
            PropertyChanges {
                target: mini_mode
                visible: true
            }
            PropertyChanges {
                target: fullscreen_mode
                visible: false
            }
        },
        State {
            name: "fullscreen"
            PropertyChanges {
                target: mini_mode
                visible: false
            }
            PropertyChanges {
                target: fullscreen_mode
                visible: true
            }
        }
    ]

    HSep { width: parent.width }

    Item {
        id: mini_mode
        anchors.fill: parent

        Row {
            height: parent.height
            spacing: 16

            Item { width: 1; height: parent.height }

            Item {
                id: mini_cover
                width: 60
                height: 60

                anchors.verticalCenter: parent.verticalCenter

                Image {
                    source: root.picUrl
                    anchors.fill: parent

                    Rectangle {
                        id: image_cover
                        color: fullscreen_mouse_area.containsMouse ? Qt.rgba(0, 0, 0, 0.3) : "transparent"
                        border.width: 1
                        border.color: Qt.rgba(0, 0, 0, 0.3)
                        anchors.fill: parent
                    }

                    MouseArea {
                        id: fullscreen_mouse_area
                        hoverEnabled: true
                        anchors.fill: parent

                        onClicked: root.state = "fullscreen"
                    }
                }
            }

            Column {
                spacing: 10
                width: mini_mode.width - mini_cover.width - parent.spacing * 2
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    width: parent.width
                    text: root.song
                    elide: Text.ElideRight
                }
                Text {
                    width: parent.width
                    text: root.artist
                    elide: Text.ElideRight
                }
            }
        }
    }

    Item {
        id: fullscreen_mode
        anchors.fill: parent

        Image {
            id: background_image
            opacity: 0.6
            source: root.picUrl
            anchors.fill: parent
        }

        Rectangle {
            anchors.fill: background_image
            color: "white"
        }

        FastBlur {
            opacity: 0.5
            anchors.fill: background_image
            source: background_image
            radius: 64
        }

        Rectangle {
            anchors.fill: background_image
            color: Qt.rgba(0.5, 0.5, 0.5, 0.4)
        }

        Row {
            id: detail_row
            width: parent.width
            height: parent.height

            RunningDisc { id: disc; width: parent.width / 2; picUrl: root.picUrl }

            Column {
                id: detail_column
                spacing: 5
                width: parent.width / 2
                height: parent.height

                Column {
                    spacing: 5
                    width: parent.width
                    height: childrenRect.height

                    Item {
                        width: parent.width
                        height: 60

                        Text {
                            text: root.song
                            font.pixelSize: 20

                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        spacing: 20

                        Text {
                            text: "专辑: " + root.album
                        }
                        Text {
                            text: "歌手: " + root.artist
                        }
                    }
                }

                HSep { width: detail_column.width * 3 / 4 }

                Item { width: detail_column.width; height: 20 }

                HTLyricView {
                    id: lyric_view
                    width: detail_column.width
                    height: 300
                }
            }
        }

        HTImageButton {
            normalImage: "qrc:/images/cancel_fullscreen.png"
            hoverPressedImage: "qrc:/images/cancel_fullscreen.png"
            onClicked: root.state = "mini"

            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 10
            anchors.rightMargin: 10
        }
    }
}

