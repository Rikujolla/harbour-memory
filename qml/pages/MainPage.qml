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
                text: qsTr("Settings")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("Settings.qml"))
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
                onRmoveChanged: MyHelpers.showOthersMove()
            }

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
                                        myPoints++
                                        cards_img.set(first_card_id,{"owner":player_id})
                                        cards_img.set(second_card_id,{"owner":player_id})
                                        cardMoveString = MyHelpers.movestring(cards_img.count, first_card_id, second_card_id, player_id)
                                        usend.sipadd = "MOVE," + myPlayerName + "," + cardMoveString
                                        usend.broadcastDatagram()
                                        first_card_id = -1;
                                        second_card_id = -1;
                                        console.log("Sama")
                                    } else {
                                        cards_img.set(first_card_id,{"owner":99})
                                        cards_img.set(second_card_id,{"owner":99})
                                        cardMoveString = MyHelpers.movestring(cards_img.count, first_card_id, second_card_id, 99)
                                        usend.sipadd = "MOVE," + myPlayerName + "," + cardMoveString
                                        usend.broadcastDatagram()
                                        cardCloser.start()
                                        if (playMode == "othDevice"){
                                        opponentMoveDiscloser.start()
                                        }
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
                //"Initiate the game, start listening datagrams"
                text:"Initiate the game"
                visible: playMode == "othDevice"
                onClicked: {
                    urecei.processPendingDatagrams();
                    console.log("Initiate the game, start listening datagrams")
                    if (player_id > 1) {
                        initialPositionTimer.start()
                    }
                }
            }
            Button {
                // If player_id == 1 send my position to other players
                text:"Start the game"
                visible: playMode == "othDevice" && player_id < 2
                onClicked: {
                    console.log("Participate")
                    visible: playMode == "othDevice"
                    console.log(cardPositionString)
                    usend.cmove = "INIT," + myPlayerName +"," + cardPositionString
                    usend.sendPosition()
                    console.log(usend.cmove)

                }
            }

            Button {
                text:"Cards lifted"
                visible: playMode == "othDevice"
                onClicked: {
                    //usend.startSender();
                    usend.sipadd = "MOVE," + myPlayerName + "," + cardMoveString
                    usend.sport = myPort
                    console.log("MOVE," + myPlayerName + "," + cardMoveString  )
                }
            }

            Button { // Not needed??
                text:"Send move"
                visible: playMode == "othDevice"
                onClicked: {
                    console.log("Send move")
                    usend.broadcastDatagram()
                    test_test.text = "test" + urecei.rmove
                }
            }

            Label {
                id:test_test
                visible: playMode == "othDevice"
                x: Theme.horizontalPageMargin
                text: "M"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraSmall

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
                    cards_img.set(first_card_id,{"owner":0})
                    cards_img.set(second_card_id,{"owner":0})
                    first_card_id = -1;
                    second_card_id = -1;
                    cardCloser.stop()
                    if (playMode == "othDevice"){
                    opponentMoveDiscloser.start()
                    }
                }
            }

            Timer {
                id:opponentMoveDiscloser
                interval: 1000
                running:false
                repeat:true
                onTriggered: {
                    var time = 0
                    console.log("opponent discloser")
                    if (urecei.rmove != usend.sipadd ||time>60){
                        test_test.text = urecei.rmove
                        MyHelpers.showOthersMove()
                        opponentMoveDiscloser.stop()
                    }
                    time++
                }
            }

            Timer {
                id:initialPositionTimer
                interval: 2000
                running:false
                repeat:true
                onTriggered: {
                    var time = 0
                    console.log("Initial position")
                        MyHelpers.makeInitialPosition()
                    time++
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
