define("communication", [], ()->

    InitializeCardPlayer = (card_player_data, message) ->
        cards_module = require("cards")

        for card, index in message.playableCards
            card_player_data.set("Card#{index}", cards_module.Construct(card.value, card.element, index))

        for element, number of message.remainingCardsNumber
            card_player_data.set("RemainingNumber#{element}", number)

        if message.id? == true
            card_player_data.set("UserId", message.id)

        if message.currentLife? == true
            card_player_data.set("CurrentLife", message.currentLife)

        if message.isBusy? == true
            require("player_actions").SetAvailableForPlayer(card_player_data, !message.isBusy)
            if message.isBusy
                if require("global_data").IsBottomPlayer(message.id)
                    require("player_actions").LaunchLoaderForPlayer()
                else
                    require("player_actions").LaunchLoaderForOpponent()


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

    UpdateFromSnapshot = (message) ->
        game_data = require("game_data")
        [player, opponent] = if require("global_data").IsBottomPlayer(message.players[0].id) then [message.players[0], message.players[1]] else [message.players[1], message.players[0]]
        # SetCardsToPlayer(player.playableCards)
        # SetCardsToOpponent(opponent.playableCards)
        player_data = require("player_data")
        opponent_data = require("opponent_data")
        InitializeCardPlayer(player_data, player)
        InitializeCardPlayer(opponent_data, opponent)
        opponent_data.set("MaxLife", require("shared_constants").maxLife)
        if message.stackTopCard?
            game_data.set("TopCard", message.stackTopCard)

    serverMessagesHandlers = {
        "duel_countdown": (message) ->
            console.log("duel is going to start in #{message.countdownDuration} ms. OpponentID: #{if require("global_data").IsBottomPlayer(message.players_ids[0]) then message.players_ids[1] else message.players_ids[0]}")
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
            game_data.set("IsGameRoomReady", true)
            UpdateFromSnapshot(message)

        "player_preparing_play": (message) ->
            if require("global_data").IsBottomPlayer(message.player_id)
                console.log("I prepare play !")
                if require("game_data").get("IsPlayer") == false #if is spectator (but on the bottom side)
                    require("player_actions").LaunchLoaderForPlayer()
                    require("player_actions").SetAvailableForPlayer(require("player_data"), false)


            else
                console.log("opponent is preparing play")
                require("player_actions").LaunchLoaderForOpponent()
                require("player_actions").SetAvailableForPlayer(require("opponent_data"), false)


        "card_played": (message) ->

            card_player_data = null
            target_player_data = null
            if require("global_data").IsBottomPlayer(message.player_id)
                card_player_data = require("player_data")
                target_player_data = require("opponent_data")
                require("player_actions").RemoveLoaderForPlayer()
                require("game_data").set("isDiscardButtonAvailable", true)
            else
                card_player_data = require("opponent_data")
                target_player_data = require("player_data")
                require("player_actions").RemoveLoaderForOpponent()
            require("player_actions").SetAvailableForPlayer(card_player_data, true)

            newTopCard = card_player_data.get("Card#{message.cardPlayedIndex}")

            SetNewCardFromReserveFunc = do (message, card_player_data, target_player_data) ->
                () ->
                    cards_module = require("cards")
                    card_player_data.set("Card#{message.cardPlayedIndex}", cards_module.Construct(message.newCard.value, message.newCard.element, message.cardPlayedIndex))
                    for element, number of message.remainingCardsNumber
                        card_player_data.set("RemainingNumber#{element}", number)


            SetTopCardOnStack = do (newTopCard) ->
                () ->
                    require("feedback_launcher").LaunchChangeEnvironmentTo(newTopCard.element)
                    game_data = require("game_data")
                    oldTopCard = game_data.get("TopCard")
                    game_data.set("TopCard", newTopCard)
                    if oldTopCard?
                        stackCards = game_data.get("StackCards")
                        stackCards.unshift(oldTopCard)
                        stackCards = stackCards[0..1]
                        game_data.set("StackCards", stackCards)

            FinalResultFunc = do (message, card_player_data, target_player_data) ->
                () ->
                    game_data = require("game_data")
                    cards_module = require("cards")

                    if require("global_data").IsBottomPlayer(message.player_id)
                        require("feedback_launcher").LaunchScoreGeneratedFeedbackForOpponent(message.otherCurrentLife - target_player_data.get("CurrentLife"), message.damageCriticalityValue)
                        require("animation_utils").Shake($("#opponent-side .life-bar")[0], 25, 0.010, 10, 10, 0.5)
                        require("animation_utils").Shake($("#opponent-side .card-player-icon")[0], 25, 0.010, 10, 10, 0.5)
                        
                    else
                        require("feedback_launcher").LaunchScoreGeneratedFeedbackForPlayer(message.otherCurrentLife - target_player_data.get("CurrentLife"), message.damageCriticalityValue)
                        require("animation_utils").Shake($("#player-side .life-bar")[0], 25, 0.010, 10, 10, 0.5)
                        require("animation_utils").Shake($("#player-side .card-player-icon")[0], 25, 0.010, 10, 10, 0.5)
                    target_player_data.set("CurrentLife", message.otherCurrentLife)

                    if message.otherCurrentLife <= 0
                        game_data.set("IsGameFinished", true)
                        if require("global_data").IsBottomPlayer(message.player_id)
                            console.log("player wins !")
                            game_data.set("IsWinner", true)
                        else
                            console.log("opponent wins !")
                            game_data.set("IsWinner", false)
            $parent = $("#central-stack")[0]
            Blaze.renderWithData(Template.cardPutOnTop, {
                    card: newTopCard, FinalResultFunc: FinalResultFunc, SetTopCardOnStack: SetTopCardOnStack, SetNewCardFromReserveFunc: SetNewCardFromReserveFunc, isPlayerSide: require("global_data").IsBottomPlayer(message.player_id), cardPlayedIndex: message.cardPlayedIndex
                }, $parent
            )
            # $parent = $("#central-stack")[0]
            # Blaze.renderWithData(Template.cardPutOnTop, {card: {element: "ROCK", value: 9}, FinalResultFunc: null, isPlayerSide: true}, $parent)


        "cards_discarded": (message) ->
            game_data = require("game_data")
            cards_module = require("cards")

            card_player_data = null
            if require("global_data").IsBottomPlayer(message.player_id)
                card_player_data = require("player_data")
                require("player_actions").RemoveLoaderForPlayer()
                require("game_data").set("isDiscardButtonAvailable", true)
                # SetCardsToPlayer(message.playableCards)

            else
                card_player_data = require("opponent_data")
                require("player_actions").RemoveLoaderForOpponent()
                # SetCardsToOpponent(message.playableCards)

            require("player_actions").SetAvailableForPlayer(card_player_data, true)

            $parent = $("#central-stack")[0]
            for index in [0..2]
                Blaze.renderWithData(Template.discardedCardFeedback, {
                        card: card_player_data.get("Card#{index}"), FinalResultFunc: (() -> console.log("ok lol")), isPlayerSide: require("global_data").IsBottomPlayer(message.player_id), cardPlayedIndex: index
                    }, $parent
                )

            Meteor.setTimeout(() ->
                InitializeCardPlayer(card_player_data, message)
            , 50)


    }

    HandleServerMessage = (serverMessage) ->
        console.log("ServerMessageHandler received: #{JSON.stringify(serverMessage)}")
        serverMessagesHandlers[serverMessage.functionId](serverMessage)


    ListenToServerMessages = (roomId) ->
        id_keys = require("id_keys")
        collection = new Meteor.Collection(id_keys.GetServerMessagesCollectionName())
        Meteor.subscribe(id_keys.GetServerMessagesPublicationName(), roomId)
        collection.find().observeChanges({
            added: (id, field) ->
                HandleServerMessage(field)
                console.log("msg nb: " + collection.find().count())
        })


    RegisterToRoom = (roomId) ->
        Meteor.call("register_player_for_game", roomId, (error, result) ->
            console.log("error: '#{error}' | result: '#{JSON.stringify(result)}'")
            ListenToServerMessages(roomId)
            game_data = require("game_data")
            game_data.set("IsPlayer", result.isPlayer)
            if result.isAlreadyPlaying #if the player is already playing another game
                console.log("already ingame at #{result.otherRoomId}")
                game_data.set("IsAlreadyPlayingOtherGame", true)
                game_data.set("OtherRoomId", result.otherRoomId)
            else
                if not result.isPlayer #if the user is a spectator
                    game_data.set("BottomPlayerId", result.snapshot.players[0].id)
                    game_data.set("TopPlayerId", result.snapshot.players[1].id)

                if result.isStarted #if the game is already running
                    console.log("reading from snapshot")
                    game_data.set("IsGameRoomReady", true)
                    UpdateFromSnapshot(result.snapshot)
       )


    return {
        serverMessagesHandlers: serverMessagesHandlers
        HandleServerMessage: HandleServerMessage
        ListenToServerMessages: ListenToServerMessages
        RegisterToRoom: RegisterToRoom
    }
)