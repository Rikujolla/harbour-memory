

function populate_view() {

    var cards = ['b','b','B','B','k','k','K','K','n','n','N','N','p','p','P','P','q','q','Q','Q','r','r','R','R']
    shuffleArray(cards)
    console.log(cards)

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
    console.log(_movestring)

    return _movestring

}

function showOthersMove() {
    //console.log("movee" + urecei.rmove)
    var table = []
    table = urecei.rmove.split(",")
    for (var i = 2; i<table.length;i++){
        if (Number(table[i])>0){
            cards_img.set(i-2,{"visib":0})
        }
    }
}

function makeInitialPosition() {
    var table = []
    var cards = []
    table = urecei.rmove.split(",")
    console.log(table[0])
    if (table[0] == "INIT") {
        cards_img.clear();
        for (var i = 2; i<table.length;i++){
            cards[i-2] = table[i]
            cards_img.append({"memcard": piePat + table[i] + ".png", "visib": 1, "mareaenab": 1, "owner":0})
        }
        cardPositionString = cards.toString();
        initialPositionTimer.stop()
    }


}


