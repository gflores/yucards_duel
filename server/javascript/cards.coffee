define("cards", [], ()->

    CARD_PREPARATION_TIME = 4.5 * 1000

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

    GetNextCardFromReserve = (player) ->
        if player.reserveCards.length == 0
            player.reserveCards = GenerateStartingCards()
        return player.reserveCards.pop()

    SetupCardActions = () ->
        global_data = require("global_data")
        card_utils_shared = require("card_utils_shared")

        Meteor.methods({
            "play_card_index": (cardIndex) ->
                check(cardIndex, Number)
                if not cardIndex in [0, 1, 2]
                    return "ERROR: cardIndex is :#{cardIndex}, not in [0, 1, 2]"
                if this.userId? == false
                    return "ERROR: no UserId"

                gameRoom = global_data.FindRoomFromPlayerId(this.userId)
                player = global_data.players[this.userId]
                cardToBeplayed = player.playableCards[cardIndex]

                gameRoom.messageCollection.insert({
                    functionId: "player_preparing_play"
                    player_id: player.id
                })
                Meteor.setTimeout(() ->
                    resultingScore = card_utils_shared.GetResultingScore(cardToBeplayed, gameRoom.stackTopCard)
                    gameRoom.stackTopCard = cardToBeplayed
                    player.currentScore += resultingScore

                    newCard = GetNextCardFromReserve(player)
                    player.playableCards[cardIndex] = newCard

                    gameRoom.messageCollection.insert({
                        functionId: "card_played"
                        player_id: player.id
                        currentScore: player.currentScore
                        cardPlayedIndex: cardIndex
                        newCard: newCard
                    })

                , CARD_PREPARATION_TIME
                )







        })

    return {
        Construct: Construct
        GenerateStartingCards: GenerateStartingCards
        GetNextCardFromReserve: GetNextCardFromReserve
        SetupCardActions: SetupCardActions
    }
)