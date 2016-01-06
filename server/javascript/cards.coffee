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

    DiscardAllCards = (player) ->
        player.playableCards[0] = GetNextCardFromReserve(player)
        player.playableCards[1] = GetNextCardFromReserve(player)
        player.playableCards[2] = GetNextCardFromReserve(player)
        ComputeRemainingCardsNumberForPlayer(player)

    ComputeRemainingCardsNumber = (cards) ->
        result = {
            "ROCK": 0
            "PAPER": 0
            "SCISSOR": 0
        }
        for card in cards
            result[card.element] += 1
        return result
    ComputeRemainingCardsNumberForPlayer = (player) ->
        player.remainingCardsNumber = ComputeRemainingCardsNumber(player.reserveCards)



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
                if player.isBusy
                    return "player already busy !"

                player.isBusy = true
                cardToBeplayed = player.playableCards[cardIndex]

                gameRoom.messageCollection.insert({
                    functionId: "player_preparing_play"
                    player_id: player.id
                })
                Meteor.setTimeout(() ->
                    resultingScore = card_utils_shared.GetResultingScore(cardToBeplayed, gameRoom.stackTopCard)
                    gameRoom.stackTopCard = cardToBeplayed
                    player.currentScore += resultingScore
                    player.isBusy = false

                    newCard = GetNextCardFromReserve(player)
                    player.playableCards[cardIndex] = newCard
                    ComputeRemainingCardsNumberForPlayer(player)

                    gameRoom.messageCollection.insert({
                        functionId: "card_played"
                        player_id: player.id
                        currentScore: player.currentScore
                        cardPlayedIndex: cardIndex
                        newCard: newCard
                        remainingCardsNumber: player.remainingCardsNumber
                    })
                , CARD_PREPARATION_TIME
                )

            "discard_all_cards": () ->
                if this.userId? == false
                    return "ERROR: no UserId"
                gameRoom = global_data.FindRoomFromPlayerId(this.userId)
                player = global_data.players[this.userId]
                if player.isBusy
                    return "player already busy !"

                player.isBusy = true
                gameRoom.messageCollection.insert({
                    functionId: "player_preparing_play"
                    player_id: player.id
                })
                Meteor.setTimeout(() ->
                    player.isBusy = false

                    DiscardAllCards(player)

                    gameRoom.messageCollection.insert({
                        functionId: "cards_discarded"
                        player_id: player.id
                        playableCards: player.playableCards
                        remainingCardsNumber: player.remainingCardsNumber
                    })
                , CARD_PREPARATION_TIME
                )


        })

    return {
        Construct: Construct
        GenerateStartingCards: GenerateStartingCards
        GetNextCardFromReserve: GetNextCardFromReserve
        SetupCardActions: SetupCardActions
        ComputeRemainingCardsNumber: ComputeRemainingCardsNumber
        ComputeRemainingCardsNumberForPlayer: ComputeRemainingCardsNumberForPlayer
    }
)