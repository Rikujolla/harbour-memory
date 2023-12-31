/*Copyright (c) 2015-2019, Riku Lahtinen
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
//import QtQuick.LocalStorage 2.0
import Sailfish.Pickers 1.0
import harbour.memory.sender 1.0

Page {
    id: page
    //onStatusChanged: game.text = openingGame
    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {

            MenuItem {
                text: qsTr("Save settings")
                onClicked: Mysets.saveSettings()
            }
        }

        PushUpMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }

        }
        contentHeight: column.height

        Item {
            id: sets
            property bool indexUpdater: false;
            //: Reduce time by 1 minute
            property var labels: [
                //: Increase time by 10 seconds
                {lab:qsTr("+10 s")},
                //: Reduce time by 10 seconds
                {lab:qsTr("-10 s")}
            ]

        }

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingMedium
            PageHeader {
                title: qsTr("Settings page")
            }

            UdpSender {
                id:usend
            }
            SectionHeader { text: qsTr("Time settings")}

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingLarge
                Text {
                    width: page.width /2
                    color: Theme.secondaryHighlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    text: qsTr("Move time") +" "
                }

                Button {
                    text: sets.labels[0].lab
                    width: page.width /6
                    onClicked: {
                    }
                }
                Button {
                    text: sets.labels[1].lab
                    width: page.width /6
                    onClicked: {
                    }
                }
            }


            SectionHeader { text: qsTr("Network settings")}

            ComboBox {
                id: setOpponent
                width: parent.width
                //contentHeight: Theme.paddingMedium
                label: qsTr("Opponent")
                currentIndex: playMode == "othDevice" ? 2 : (playMode == "human" ? 1 : 0)

                menu: ContextMenu {
                    MenuItem {
                        //: Stockfish is a name of the chess engine, more info https://stockfishchess.org/
                        text: qsTr("Only me")
                        onClicked: {
                            playMode = "only_me"
                            setOpponent.currentIndex = 0
                            console.log("Play mode: " + playMode)
                        }
                    }
                    MenuItem {
                        text: qsTr("Human")
                        onClicked: {
                            playMode = "human"
                            setOpponent.currentIndex = 1
                            console.log("Play mode: " + playMode)
                        }
                    }
                    MenuItem {
                        text: qsTr("Local network")
                        onClicked: {
                            playMode = "othDevice"
                            setOpponent.currentIndex = 2
                            //pageStack.push(Qt.resolvedUrl("Chat3.qml"));
                            console.log("Play mode: " + playMode)
                        }
                    }
                }
            }

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingMedium
                anchors.left: parent.left
                visible: setOpponent.currentIndex == 2
                ComboBox { // for dynamic creation see Pastie: http://pastie.org/9813891
                    id: portSettings
                    //width: page.width*2/3
                    width: currentIndex == 0 ? page.width : page.width*2/3
                    label: qsTr("Port number")
                    currentIndex: portFixed
                    menu: ContextMenu {
                        MenuItem {
                            text: qsTr("Random")
                            onClicked: {
                                portSettings.currentIndex = 0;
                                //myPort = 0;
                                //console.log(myPort);
                            }
                        }
                        MenuItem {
                            text: qsTr("Fixed")
                            onClicked: {
                                portSettings.currentIndex = 1;
                                //myPort = portValue.text;
                            }
                        }
                    }
                }

                TextField {
                    id: portValue
                    text: "myPort"
                    placeholderText: "12345"
                    //label: qsTr("ECO code")
                    visible: portSettings.currentIndex == 1
                    width: page.width/4
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints:  Qt.ImhDigitsOnly
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        myPort = text;
                        //console.log(myPort);

                    }
                }
            }


            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingMedium
                visible: playMode == "othDevice"
                Text {
                    text: qsTr("Player name")
                    color: Theme.secondaryHighlightColor
                    x: Theme.paddingLarge
                    font.pixelSize: Theme.fontSizeSmall
                    width:page.width/2
                    wrapMode: Text.WordWrap
                }

                TextField {
                    id: player
                    placeholderText: "Hopo"
                    text:myPlayerName
                    width: page.width/2
                    //validator: RegExpValidator { regExp: /^\d*\.?\d*$/ }
                    //color: errorHighlight? "red" : Theme.primaryColor
                    //inputMethodHints: Qt.ImhDigitsOnly
                    //EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        myPlayerName = player.text
                        usend.sipadd = myPlayerName
                        console.log(myPlayerName, usend.sipadd);
                    }
                }
            }

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingMedium
                visible: playMode == "othDevice"
                Text {
                    text: qsTr("Player ID")
                    color: Theme.secondaryHighlightColor
                    x: Theme.paddingLarge
                    font.pixelSize: Theme.fontSizeSmall
                    width:page.width/2
                    wrapMode: Text.WordWrap
                }

                TextField {
                    id: playerIdBox
                    placeholderText: "ID"
                    text:player_id
                    width: page.width/2
                    validator: RegExpValidator { regExp: /^\d*\.?\d*$/ }
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhDigitsOnly
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        player_id = playerIdBox.text
                        //usend.sipadd = myPlayerName
                        //console.log(myPlayerName, usend.sipadd);
                    }
                }
            }

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingMedium
                visible: playMode == "othDevice"
                Text {
                    text: qsTr("Number of players")
                    color: Theme.secondaryHighlightColor
                    x: Theme.paddingLarge
                    font.pixelSize: Theme.fontSizeSmall
                    width:page.width/2
                    wrapMode: Text.WordWrap
                }

                TextField {
                    id: numberPlayers
                    placeholderText: "mount"
                    text:numberOfPlayers
                    width: page.width/2
                    validator: RegExpValidator { regExp: /^\d*\.?\d*$/ }
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhDigitsOnly
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        numberOfPlayers = numberPlayers.text
                    }
                }
            }


            SectionHeader { text: qsTr("View settings")
            }

            ComboBox {
                id: setPieces
                width: parent.width
                //: The style of the pieces selector
                label: qsTr("Style of the pieces")
                currentIndex: pieceStyle

                menu: ContextMenu {
                    MenuItem {
                        //: The style of the pieces is unlike
                        text: qsTr("Unlike")
                        onClicked: {
                            pieceStyle = 0
                            piePat = "images/piece0/"
                            setPieces.currentIndex = 0
                        }
                    }
                    MenuItem {
                        //: The style of the pieces is classic
                        text: qsTr("Classic")
                        onClicked: {
                            pieceStyle = 1
                            piePat = "images/piece1/"
                            setPieces.currentIndex = 1
                        }
                    }

                    MenuItem {
                        //: Player can select the pieces of her or his choice
                        text: qsTr("Personal art")
                        onClicked: {
                            var dialog = pageStack.push(Qt.resolvedUrl("Settings_dialog_personal_art.qml"),
                                                        {"name": "test"})
                            dialog.accepted.connect(function() {
                                filepicker_timer.start()
                            })
                            dialog.rejected.connect(function() {
                                setPieces.currentIndex = pieceStyle
                            })
                        }
                    }
                }
            }

            Timer {
                id:filepicker_timer
                interval: 500
                running: false
                repeat: false

                onTriggered: pageStack.push(filePickerPage)
            }

            property string personal_art_filename
            property string personal_art_path

            Component {
                id: filePickerPage
                FilePickerPage {
                    nameFilters: ['*.png']
                    onSelectedContentPropertiesChanged: {
                        column.personal_art_filename = selectedContentProperties.fileName
                        column.personal_art_path = selectedContentProperties.filePath;
                        piePat = column.personal_art_path.slice(0,column.personal_art_path.length-column.personal_art_filename.length)
                        pieceStyle = 2
                        setPieces.currentIndex = 2
                    }
                }
            }



            VerticalScrollDecorator {}

            // This timer is requested to change currentIndex values to global variables
            Timer {
                interval:50
                running:sets.indexUpdater && Qt.ApplicationActive
                repeat:true
                onTriggered: {
                    openingMode = opsiSettings.currentIndex;
                    countDirInt = timeCounting.currentIndex;
                    sets.indexUpdater = false;
                }
            }
            //loppusulkeet
        }
    }
}
