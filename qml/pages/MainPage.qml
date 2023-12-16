import QtQuick 2.0
import Sailfish.Silica 1.0
import "helpers.js" as MyHelpers
import harbour.memory.sender 1.0
import harbour.memory.receiver 1.0

Page {
    id: page

    property string first_card:""
    property int first_card_id: -1
    property string second_card:""
    property int second_card_id: -1
    property int myPoints: 0

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("About.qml"))
            }
            MenuItem {
                text: qsTr("Restart")
                onClicked: {MyHelpers.populate_view()
                    myPoints = 0
                }

            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Memory")
            }

            UdpSender {
                id:usend
            }
            UdpReceiver {
                id:urecei
            }
            /*Label {
                x: Theme.horizontalPageMargin
                text: qsTr("Hello Sailors")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }*/
            BackgroundItem {
                //height:Orientation.Portrait ? cards_img.count*Screen.width/6/6 : cards_img.count/(Screen.height/Screen.width*6)
                height:cards_img.count*Screen.width/6/6

                GridView {
                    id:memoGrid
                    //height:cards_img.count*Screen.width/6/6
                    cellHeight: Screen.width/6
                    cellWidth: Screen.width/6
                    anchors.fill: parent
                    model:cards_img
                    delegate: Image {
                        asynchronous: true
                        source:memcard
                        sourceSize.width: memoGrid.cellWidth
                        sourceSize.height: memoGrid.cellHeight
                        Image {
                            id:back_side
                            asynchronous: true
                            visible:visib > 0
                            source: piePat_up + "back.png"
                            sourceSize.width: memoGrid.cellWidth
                            sourceSize.height: memoGrid.cellHeight
                        }
                        MouseArea {
                            id:marea
                            anchors.fill: parent
                            height: memoGrid.cellHeight
                            width: memoGrid.cellWidth
                            enabled: !cardCloser.running && mareaenab > 0
                            onClicked: {
                                console.log(index);
                                //back_side.visible = false
                                if (cardCloser.running){
                                    console.log("Nothing")
                                }

                                else if (first_card_id<0) {
                                    first_card_id = index
                                    cards_img.set(first_card_id,{"visib":0})
                                    cards_img.set(first_card_id,{"mareaenab":0})
                                }
                                else if (second_card_id<0){
                                    second_card_id = index
                                    cards_img.set(second_card_id,{"visib":0})
                                    cards_img.set(second_card_id,{"mareaenab":0})

                                    if (cards_img.get(first_card_id).memcard == cards_img.get(second_card_id).memcard) {
                                        //cards_img.set(first_card_id,{"visib":0})
                                        //cards_img.set(second_card_id,{"visib":0})
                                        //cards_img.set(first_card_id,{"mareaenab":0})
                                        //cards_img.set(second_card_id,{"mareaenab":0})
                                        myPoints++
                                        first_card_id = -1;
                                        second_card_id = -1;
                                        console.log("Sama")
                                    } else {
                                        cardCloser.start()
                                    }

                                }
                            }
                        } // End MouseArea

                    }

                }
            }

            Label {
                x: Theme.horizontalPageMargin
                text: qsTr("Player")+":" + myPoints
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }

            Button {
                text:"Start broadcasting"
                onClicked: {
                    urecei.startReceiver();
                    usend.startSender();
                    //console.log("pressed")
                }
            }

            Timer {
                id:cardCloser
                interval: 2000
                running: false
                repeat: false
                onTriggered:{
                    cards_img.set(first_card_id,{"visib":1})
                    cards_img.set(second_card_id,{"visib":1})
                    cards_img.set(first_card_id,{"mareaenab":1})
                    cards_img.set(second_card_id,{"mareaenab":1})
                    first_card_id = -1;
                    second_card_id = -1;
                    cardCloser.stop()
                }
            }

            ListModel {
                id:cards_img
                ListElement {
                    memcard: "images/piece0/Q.png"
                    visib: 1
                    mareaenab: 1
                }
            }

        }
    }
    Component.onCompleted: {
        MyHelpers.populate_view()
    }
}
