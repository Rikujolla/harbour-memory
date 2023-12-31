

function populate_view() {

    var cards = ['b','b','B','B','k','k','K','K','n','n','N','N','p','p','P','P','q','q','Q','Q','r','r','R','R']
    shuffleArray(cards)
    if (debug) {console.log(cards)}

    cards_img.clear();
    for (var i = 0; i < cards.length; i++) {
        cards_img.append({"memcard": piePat + cards[i] + ".png", "visib": 1, "mareaenab": 1, "owner":0})
        //cards_img.append({})

    }

    cardPositionString = cards.toString();

}

//https://stackoverflow.com/questions/2450954/how-to-randomize-shuffle-a-javascript-array
/* Randomize array in-place using Durstenfeld shuffle algorithm */
function shuffleArray(array) {
    for (var i = array.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
};

// This function return moves as string
function movestring(size,i,j,id) {
    var _movestring = ""
    for (var z = 0; z<size; z++){
        if (z==i || z == j){
            if (z==size-1){
                _movestring = _movestring + cards_img.get(z).owner
            } else {
                //_movestring = _movestring + id.toString() + ","
                _movestring = _movestring + cards_img.get(z).owner + ","

            }
        }
        else {
            if (z==size-1){
                _movestring = _movestring + cards_img.get(z).owner
            } else {
                _movestring = _movestring + cards_img.get(z).owner + ","
            }
        }
    }
    if (debug) {console.log(_movestring)}

    return _movestring

}

function showOthersMove() {
    var table = []
    var cards = []
    updateCurrentPlayer()
    table = urecei.rmove.split(",")
    for (var i = 3; i<table.length;i++){
        cards[i-3] = table[i]
        if (Number(table[i])>0){
            cards_img.set(i-3,{"visib":0})
        }
    }
    cardMoveString = cards.toString();
    if (isInArray("99", cards)) {
        falseMoveCloser.start()
        if (debug) {console.log("falsemove")}
    }
    if (debug) {console.log(currentPlayer + " showOthersMove " + urecei.rmove)}
}

function makeInitialPosition() {
    var table = []
    var cards = []
    table = urecei.rmove.split(",")
    if (debug) {console.log(table[0])}
    if (table[0] == "INIT") {
        cards_img.clear();
        for (var i = 3; i<table.length;i++){
            cards[i-3] = table[i]
            cards_img.append({"memcard": piePat + table[i] + ".png", "visib": 1, "mareaenab": 1, "owner":0})
        }
        cardPositionString = cards.toString();
        initialPositionTimer.stop()
        notification_box.text = "Card positions updated"
    }


}

function hideFalseMove() {
    var table = []
    table = cardMoveString.split(",")
    if (debug) {console.log(cardMoveString)}
    for (var i = 0; i<table.length;i++){
        if (Number(table[i])>98){
            cards_img.set(i,{"visib":1})
        }
    }
}

function isInArray(value, array) {
    return array.indexOf(value) > -1;
}

function updateCurrentPlayer() {

    if (currentPlayer == numberOfPlayers) {currentPlayer = 1}
    else {currentPlayer++}
    notification_current.text = qsTr("Current player: ") + currentPlayer

}

// Function closes my cards
function closeCards() {
    if (first_card_id > -1){
        cards_img.set(first_card_id,{"visib":1})
        cards_img.set(first_card_id,{"mareaenab":1})
        cards_img.set(first_card_id,{"owner":0})
    }
    if (second_card_id > -1){
        cards_img.set(second_card_id,{"visib":1})
        cards_img.set(second_card_id,{"mareaenab":1})
        cards_img.set(second_card_id,{"owner":0})
    }
    first_card_id = -1;
    second_card_id = -1;
}



