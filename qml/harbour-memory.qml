import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow {
    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
    // Global variables
    property string piePat_up: "images/" // Piece sub path
    property string piePat: "images/piece0/" // Piece sub path
    property string myPlayerName:""
    property int myPort: 45454
    property string playMode: "othDevice"
    property string cardPositionString:""
    property string cardMoveString:""
    property int player_id:1 // Default id for playleader 1
    property int numberOfPlayers:2
    property int currentPlayer:1

}
