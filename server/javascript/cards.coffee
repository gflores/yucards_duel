define("cards", [], ()->

    Construct = (value, element) ->
        return {
            value: value
            element: element
        }

    GenerateStartingCards = () ->
        card_elements = require("card_elements")
        startingCards = []
        for element in [card_elements.elements.ROCK, card_elements.elements.PAPER, card_elements.elements.SCISSOR]
            for value in [2..10]
                startingCards.push(Construct(value, element))
        console.log("generated cards: #{JSON.stringify(startingCards)}")
        require("utils").ShuffleArray(startingCards)
        console.log("generated cards: #{JSON.stringify(startingCards)}")
        return startingCards

    return {
        Construct: Construct
        GenerateStartingCards: GenerateStartingCards
    }
)