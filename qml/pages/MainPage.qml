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
                //onRmoveChanged: MyHelpers.showOthersMove()
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
                            enabled: !cardCloser.running && mareaenab > 0 && player_id == currentPlayer
                            onClicked: {
                                //console.log(index);
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
                                        if (playMode == "othDevice"){
                                            usend.sipadd = "MOVE," + player_id + ","+ myPlayerName + "," + cardMoveString
                                            usend.broadcastDatagram()
                                            notification_move.text = usend.sipadd
                                            MyHelpers.updateCurrentPlayer()
                                        }
                                        first_card_id = -1;
                                        second_card_id = -1;
                                        console.log("Sama")
                                    } else {
                                        cards_img.set(first_card_id,{"owner":99})
                                        cards_img.set(second_card_id,{"owner":99})
                                        cardMoveString = MyHelpers.movestring(cards_img.count, first_card_id, second_card_id, 99)
                                        cardCloser.start()
                                        if (playMode == "othDevice"){
                                            usend.sipadd = "MOVE," + player_id + "," + myPlayerName + "," + cardMoveString
                                            usend.broadcastDatagram()
                                            notification_move.text = usend.sipadd
                                            MyHelpers.updateCurrentPlayer()
                                            //opponentMoveDiscloser.start()
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
                    notification_box.text = qsTr("Listening other devices")
                    //if (player_id > 1) {
                    initialPositionTimer.start()
                    //}
                }
            }
            Button {
                // If player_id == 1 send my position to other players
                text:"Start the game"
                visible: playMode == "othDevice" && player_id < 2
                onClicked: {
                    //console.log("Participate")
                    visible: playMode == "othDevice"
                    //console.log(cardPositionString)
                    usend.cmove = "INIT," + player_id + "," + myPlayerName +"," + cardPositionString
                    usend.sendPosition()
                    console.log(usend.cmove)
                    notification_box.text = qsTr("My cards position sent to other users")

                }
            }

            Label {
                id:notification_box
                visible: playMode == "othDevice"
                x: Theme.horizontalPageMargin
                text: "Press first button"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraSmall
            }

            Label {
                id:notification_current
                visible: playMode == "othDevice"
                x: Theme.horizontalPageMargin
                text: "Current player"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraSmall
            }
            Label {
                id:notification_move
                visible: playMode == "othDevice"
                x: Theme.horizontalPageMargin
                text: "Moves"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraSmall
            }

            Button {
                //"If for some reason I am skipped, take my turn"
                text:qsTr("Try to remove jam")
                visible: playMode == "othDevice"
                onClicked: {
                    currentPlayer = player_id
                    console.log("Forced player change: ", currentPlayer, player_id)
                    usend.cmove = "JUMI," + player_id + "," + myPlayerName +"," + cardPositionString
                    usend.sendPosition()
                    notification_current.text = qsTr("Current player: ") + currentPlayer


                }
            }


            Timer {
                id:cardCloser
                interval: 2130
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
                        //opponentMoveDiscloser.start()
                    }
                }
            }

            Timer {
                id:opponentMoveDiscloser
                interval: 1650
                running:false
                repeat:true
                onTriggered: {
                    var temp = urecei.rmove.split(",")
                    //console.log(temp[0])
                    console.log("Current player ", currentPlayer, temp[0], temp[1], player_id)
                    if (Number(temp[1]) != player_id  && temp[0] != "INIT" && currentPlayer == Number(temp[1])){
                        //if (urecei.rmove != usend.sipadd && temp[0] != "INIT" && currentPlayer == Number(temp[1])){
                        notification_move.text = urecei.rmove
                        MyHelpers.showOthersMove()
                        //opponentMoveDiscloser.stop()
                    }
                    else if (temp[0] == "JUMI"){
                        currentPlayer = Number(temp[1])
                        notification_current.text = qsTr("Current player: ") + currentPlayer
                    }
                }
            }

            Timer {
                id:initialPositionTimer
                interval: 2060
                running:false
                repeat:true
                onTriggered: {
                    console.log("Initial position")
                    MyHelpers.makeInitialPosition()
                    opponentMoveDiscloser.start()
                }
            }

            Timer {
                id:falseMoveCloser
                interval: 2120
                running:false
                repeat:false
                onTriggered: {
                    console.log("Close false move")
                    MyHelpers.hideFalseMove()
                    falseMoveCloser.stop()
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
