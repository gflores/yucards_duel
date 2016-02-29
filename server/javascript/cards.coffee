define("cards", [], ()->

    # CARD_PREPARATION_TIME = 4.5 * 1000
    CARD_PREPARATION_TIME = 1 * 1000
    CARD_DISCARD_TIME = 2 * 1000

    Construct = (value, element) ->
        return {
            value: value
            element: element
        }

    NotLastThreeTheSameElement = (cards) ->
        if cards[cards.length - 1].element == cards[cards.length - 2].element && cards[cards.length - 2].element == cards[cards.length - 3].element
            element = cards[cards.length - 1].element
            for card, index in cards
                if card.element != element
                    cards[index] = cards[cards.length - 1]
                    cards[cards.length - 1] = card
                    break


    GenerateStartingCards = () ->
        card_elements = require("card_elements")
        startingCards = []
        for element in [card_elements.elements.ROCK, card_elements.elements.PAPER, card_elements.elements.SCISSOR]
            for value in [1, 2, 3, 4, 5]
                startingCards.push(Construct(value, element))
        console.log("generated cards: #{JSON.stringify(startingCards)}")
        require("utils").ShuffleArray(startingCards)
        NotLastThreeTheSameElement(startingCards)

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
        card_elements = require("card_elements")

        Meteor.methods({
            "play_card_index": (cardIndex) ->
                check(cardIndex, Number)
                if not cardIndex in [0, 1, 2]
                    return "ERROR: cardIndex is :#{cardIndex}, not in [0, 1, 2]"
                if this.userId? == false
                    return "ERROR: no UserId"

                gameRoom = global_data.FindRoomFromPlayerId(this.userId)
                if gameRoom == null
                    return "No ongoing room found for player #{this.userId}"
                player = global_data.players[this.userId]
                if gameRoom.isFinished
                    return "this duel is already finished !"
                if player.isBusy
                    return "player already busy !"

                player.isBusy = true
                cardToBeplayed = player.playableCards[cardIndex]

                gameRoom.messageCollection.insert({
                    functionId: "player_preparing_play"
                    player_id: player.id
                })
                Meteor.setTimeout(() ->
                    if gameRoom.isFinished
                        return "this duel is already finished !"
                    resultingDamage = card_utils_shared.GetResultingDamage(cardToBeplayed, gameRoom.stackTopCard)
                    if gameRoom.stackTopCard? == false
                        damageCriticalityValue = 0
                    else
                        damageCriticalityValue = card_elements.GetResult(cardToBeplayed.element, gameRoom.stackTopCard.element)
                    gameRoom.stackTopCard = cardToBeplayed
                    player.opponent.currentLife -= resultingDamage
                    player.isBusy = false

                    newCard = GetNextCardFromReserve(player)
                    player.playableCards[cardIndex] = newCard
                    ComputeRemainingCardsNumberForPlayer(player)
                    console.log("[#{gameRoom.id}]: CARD PLAYED: #{player.opponent.id} now has #{player.opponent.currentLife} HP")
                    if player.opponent.currentLife <= 0
                        gameRoom.isFinished = true

                    gameRoom.messageCollection.insert({
                        functionId: "card_played"
                        player_id: player.id
                        otherCurrentLife: player.opponent.currentLife
                        damageCriticalityValue: damageCriticalityValue
                        cardPlayedIndex: cardIndex
                        newCard: newCard
                        remainingCardsNumber: player.remainingCardsNumber
                        isGameFinished: gameRoom.isFinished
                    })
                    if gameRoom.isFinished
                        winner = Meteor.users.findOne(player.id)
                        loser = Meteor.users.findOne(player.opponent.id)
                        duelResult = require("game_room").ConstructDuelEndResult(winner, loser)

                        Meteor.users.update(winner._id, {$set: {"status.playing": false, score: winner.score, rank: winner.rank, winNumber: winner.winNumber}})
                        Meteor.users.update(loser._id, {$set: {"status.playing": false, score: loser.score, rank: loser.rank, loseNumber: loser.loseNumber}})

                        gameRoom.messageCollection.insert({
                            functionId: "duel_end_result"
                            duelResult: duelResult
                        })

                        require("game_room").GameRooms.remove({roomId: gameRoom.id})
                        delete global_data.gameRooms[gameRoom.id]
                        delete global_data.players[player.id]
                        delete global_data.players[player.opponent.id]
                        console.log("[#{gameRoom.id}] FINISHED ! total room nb: " + require("game_room").GameRooms.find().count());


                , CARD_PREPARATION_TIME
                )

            "discard_all_cards": () ->
                if this.userId? == false
                    return "ERROR: no UserId"
                gameRoom = global_data.FindRoomFromPlayerId(this.userId)
                if gameRoom == null
                    return "No ongoing room found for player #{this.userId}"
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
                , CARD_DISCARD_TIME
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