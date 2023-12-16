

function populate_view() {

    var cards = ['b','b','B','B','k','k','K','K','n','n','N','N','p','p','P','P','q','q','Q','Q','r','r','R','R']
    shuffleArray(cards)
    console.log(cards)

    cards_img.clear();
    for (var i = 0; i < cards.length; i++) {
        cards_img.append({"memcard": piePat + cards[i] + ".png", "visib": 1, "mareaenab": 1})
        //cards_img.append({})

    }

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

