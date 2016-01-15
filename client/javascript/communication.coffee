define("communication", [], ()->

    InitializeCardPlayer = (card_player_data, message) ->
        cards_module = require("cards")

        for card, index in message.playableCards
            card_player_data.set("Card#{index}", cards_module.Construct(card.value, card.element, index))

        for element, number of message.remainingCardsNumber
            card_player_data.set("RemainingNumber#{element}", number)

    # SetCardsToPlayer = (playableCards) ->
    #     player_data = require("player_data")
    #     cards_module = require("cards")

    #     for card, index in playableCards
    #         player_data.set("Card#{index}", cards_module.Construct(card.value, card.element, index))



    #     player_data.set("RemainingNumberROCK", 1)
    #     player_data.set("RemainingNumberSCISSOR", 2)
    #     player_data.set("RemainingNumberPAPER", 3)


    # SetCardsToOpponent = (playableCards) ->
    #     opponent_data = require("opponent_data")
    #     cards_module = require("cards")

    #     for card, index in playableCards
    #         opponent_data.set("Card#{index}", cards_module.Construct(card.value, card.element, index))

    serverMessagesHandlers = {
        "duel_countdown": (message) ->
            console.log("duel is going to start in #{message.countdownDuration} ms. OpponentID: #{if message.players_ids[0] == Meteor.userId() then message.players_ids[1] else message.players_ids[0]}")
            game_data = require("game_data")
            game_data.set("IsCountdownStarted", true)

            game_data.set("CountdownValue", message.countdownDuration / 1000)
            CountdownFrameFunction = () ->
                Meteor.setTimeout( () ->
                    currentCountdownValue = game_data.get("CountdownValue")
                    currentCountdownValue -= 1
                    game_data.set("CountdownValue", currentCountdownValue)
                    if currentCountdownValue != 0
                        CountdownFrameFunction()
                , 1000
                )

            CountdownFrameFunction()



        "duel_start": (message) ->
            game_data = require("game_data")
            [player, opponent] = if message.players[0].id == Meteor.userId() then [message.players[0], message.players[1]] else [message.players[1], message.players[0]]
            # SetCardsToPlayer(player.playableCards)
            # SetCardsToOpponent(opponent.playableCards)
            InitializeCardPlayer(require("player_data"), player)
            InitializeCardPlayer(require("opponent_data"), opponent)
            game_data.set("IsGameRoomReady", true)
            opponent_data = require("opponent_data")
            opponent_data.set("UserId", opponent.id)
            opponent_data.set("CurrentScore", 0)
            opponent_data.set("MaxScore", require("shared_constants").maxScore)


        "player_preparing_play": (message) ->
            if message.player_id == Meteor.userId()
                console.log("I prepare play !")
            else
                console.log("opponent is preparing play")
                require("player_actions").LaunchLoaderForOpponent()
                require("player_actions").SetAvailableForPlayer(require("opponent_data"), false)


        "card_played": (message) ->

            card_player_data = null
            if message.player_id == Meteor.userId()
                card_player_data = require("player_data")
                require("player_actions").RemoveLoaderForPlayer()
                require("game_data").set("isDiscardButtonAvailable", true)
            else
                card_player_data = require("opponent_data")
                require("player_actions").RemoveLoaderForOpponent()
            require("player_actions").SetAvailableForPlayer(card_player_data, true)

            newTopCard = card_player_data.get("Card#{message.cardPlayedIndex}")

            SetNewCardFromReserveFunc = do (message, card_player_data) ->
                () ->
                    cards_module = require("cards")
                    card_player_data.set("Card#{message.cardPlayedIndex}", cards_module.Construct(message.newCard.value, message.newCard.element, message.cardPlayedIndex))
                    for element, number of message.remainingCardsNumber
                        card_player_data.set("RemainingNumber#{element}", number)



            FinalResultFunc = do (message, card_player_data, newTopCard) ->
                () ->
                    game_data = require("game_data")
                    cards_module = require("cards")

                    if message.player_id == Meteor.userId()
                        require("feedback_launcher").LaunchScoreGeneratedFeedbackForPlayer(message.currentScore - card_player_data.get("CurrentScore"))
                    else
                        require("feedback_launcher").LaunchScoreGeneratedFeedbackForOpponent(message.currentScore - card_player_data.get("CurrentScore"))                
                    oldTopCard = game_data.get("TopCard")
                    game_data.set("TopCard", newTopCard)
                    if oldTopCard?
                        stackCards = game_data.get("StackCards")
                        stackCards.unshift(oldTopCard)
                        stackCards = stackCards[0..1]
                        game_data.set("StackCards", stackCards)
                    card_player_data.set("CurrentScore", message.currentScore)

                    if message.currentScore >= require("shared_constants").maxScore
                        game_data.set("IsGameFinished", true)
                        if message.player_id == Meteor.userId()
                            console.log("player wins !")
                            game_data.set("IsWinner", true)
                        else
                            console.log("opponent wins !")
                            game_data.set("IsWinner", false)
            $parent = $("#central-stack")[0]
            Blaze.renderWithData(Template.cardPutOnTop, {
                    card: newTopCard, FinalResultFunc: FinalResultFunc, SetNewCardFromReserveFunc: SetNewCardFromReserveFunc, isPlayerSide: message.player_id == Meteor.userId(), cardPlayedIndex: message.cardPlayedIndex
                }, $parent
            )
            # $parent = $("#central-stack")[0]
            # Blaze.renderWithData(Template.cardPutOnTop, {card: {element: "ROCK", value: 9}, FinalResultFunc: null, isPlayerSide: true}, $parent)


        "cards_discarded": (message) ->
            game_data = require("game_data")
            cards_module = require("cards")

            card_player_data = null
            if message.player_id == Meteor.userId()
                card_player_data = require("player_data")
                require("player_actions").RemoveLoaderForPlayer()
                require("game_data").set("isDiscardButtonAvailable", true)
                # SetCardsToPlayer(message.playableCards)

            else
                card_player_data = require("opponent_data")
                require("player_actions").RemoveLoaderForOpponent()
                # SetCardsToOpponent(message.playableCards)

            require("player_actions").SetAvailableForPlayer(card_player_data, true)
            InitializeCardPlayer(card_player_data, message)

    }

    HandleServerMessage = (serverMessage) ->
        console.log("ServerMessageHandler received: #{JSON.stringify(serverMessage)}")
        serverMessagesHandlers[serverMessage.functionId](serverMessage)


    ListenToServerMessages = () ->
        id_keys = require("id_keys")
        collection = new Meteor.Collection(id_keys.GetServerMessagesCollectionName())
        Meteor.subscribe(id_keys.GetServerMessagesPublicationName())
        collection.find().observeChanges({
            added: (id, field) ->
                HandleServerMessage(field)
        })


    RegisterToRoom = (roomId) ->
        Meteor.call("register_player_for_game", roomId, (error, result) ->
            console.log("error: '#{error}' | result: '#{result}'")
            ListenToServerMessages()
        )

    return {
        serverMessagesHandlers: serverMessagesHandlers
        HandleServerMessage: HandleServerMessage
        ListenToServerMessages: ListenToServerMessages
        RegisterToRoom: RegisterToRoom
    }
)