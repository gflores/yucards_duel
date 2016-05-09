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
        require("music_manager").buildupAudio.pause()
        require("music_manager").mainLoopAnimation()

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

    DuelStartWithMessage = () ->
        console.log("duel starting with message !")
        message = require("global_data").duelStartMessage

        game_data = require("game_data")
        game_data.set("IsGameRoomReady", true)
        if Meteor.userId() != message.players[0].id and Meteor.userId() != message.players[1].id
            game_data.set("IsPlayer", false)
            game_data.set("BottomPlayerId", message.players[0].id)
            game_data.set("TopPlayerId", message.players[1].id)
        else
            game_data.set("IsPlayer", true)
        UpdateFromSnapshot(message)
        Meteor.clearInterval(require("global_data").countdownInterval)

    serverMessagesHandlers = {
        "register_confirmation": (message) ->
            if message.player_id == Meteor.userId()
                if require("global_data").IsRegistrationConfirmed == true
                    console.log("duplicate tab !")
                    require("global_data").SubscribeHandler.stop()
                    window.close()
                    location.replace(Router.routes.mainRoom.url({}))
                else
                    require("global_data").IsRegistrationConfirmed = true
                    console.log("confirming registration")


        "duel_countdown": (message) ->
            game_data = require("game_data")
            game_data.set("CountdownValue", message.countdownDuration / 1000)
            require("music_manager").softLoop.stop()
            require("music_manager").buildupAudioAnimation()
            console.log("duel is going to start in #{message.countdownDuration} ms. OpponentID: #{if require("global_data").IsBottomPlayer(message.players_ids[0]) then message.players_ids[1] else message.players_ids[0]}")
            game_data.set("IsCountdownStarted", true)

            require("opponent_data").set("UserId", if Meteor.userId() == message.players_ids[0] then message.players_ids[1] else message.players_ids[0])
            console.log("userID set: "+ require("opponent_data").get("UserId"))

            if Meteor.userId() == message.players_ids[0]
                new Notification("Opponent Joined !", {
                    body: "Duel starting against #{Meteor.users.findOne(require("opponent_data").get("UserId")).username}",
                    icon: "/images/logo_square.png"
                })
     
            timeStep = 33
            require("global_data").countdownInterval = Meteor.setInterval(() ->
                    currentCountdownValue = game_data.get("CountdownValue")
                    currentCountdownValue -= timeStep / 1000
                    game_data.set("CountdownValue", currentCountdownValue)
                , timeStep)


            # CountdownFrameFunction = () ->
            #     Meteor.setTimeout( () ->
            #         currentCountdownValue = game_data.get("CountdownValue")
            #         currentCountdownValue -= 1
            #         game_data.set("CountdownValue", currentCountdownValue)
            #         if currentCountdownValue != 0
            #             CountdownFrameFunction()
            #     , 1000
            #     )

            # CountdownFrameFunction()



        "duel_start": (message) ->
            console.log("received duelStartMessage !")
            require("global_data").duelStartMessage = message
            require("global_data").isDuelStartMessageReceived = true
            if require("global_data").isBuildupStartFailed == true
                DuelStartWithMessage()

        "player_preparing_play": (message) ->
            now = new Date()
            console.log("Total delay: #{now - message.clientLaunchTime}, Server Received Time: #{message.serverReceivedTime}, current time: #{now}")

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
                console.log("should do somethihng")
                require("player_actions").RemoveLoaderForOpponent()
                console.log("DOING !!")
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
                        require("animation_utils").Shake($("#opponent-side .life-bar")[0], 12, 0.030, 20, 20)
                        require("animation_utils").Shake($("#opponent-side .card-player-icon")[0], 12, 0.030, 20, 20)
                        
                    else
                        require("feedback_launcher").LaunchScoreGeneratedFeedbackForPlayer(message.otherCurrentLife - target_player_data.get("CurrentLife"), message.damageCriticalityValue)
                        require("animation_utils").Shake($("#player-side .life-bar")[0], 12, 0.030, 20, 20)
                        require("animation_utils").Shake($("#player-side .card-player-icon")[0], 12, 0.030, 20, 20)
                    target_player_data.set("CurrentLife", Math.max(message.otherCurrentLife, 0))

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

        "duel_end_result": (message) ->
            game_data = require("game_data")
            SetPlayerResult = (playerResult) ->
                card_player_data = null
                if require("global_data").IsBottomPlayer(playerResult.id)
                    card_player_data = require("player_data")
                else
                    card_player_data = require("opponent_data")
                card_player_data.set("OldScore", playerResult.oldScore)
                card_player_data.set("NewScore", playerResult.newScore)
                card_player_data.set("OldRank", playerResult.oldRank)
                card_player_data.set("NewRank", playerResult.newRank)
                card_player_data.set("WinNumber", playerResult.winNumber)
                card_player_data.set("LoseNumber", playerResult.loseNumber)

            SetPlayerResult(message.duelResult.players[0])
            SetPlayerResult(message.duelResult.players[1])







    }

    HandleServerMessage = (serverMessage) ->
        console.log("ServerMessageHandler received: #{JSON.stringify(serverMessage)}")
        serverMessagesHandlers[serverMessage.functionId](serverMessage)


    ListenToServerMessages = (roomId, readMessagesImmediatly) ->
        id_keys = require("id_keys")
        collection = new Meteor.Collection(id_keys.GetServerMessagesCollectionName())
        require("global_data").SubscribeHandler = Meteor.subscribe(id_keys.GetServerMessagesPublicationName(), roomId)

        if readMessagesImmediatly == false
            Meteor.setTimeout(() ->
                collection.find().observeChanges({
                    added: (id, field) ->
                        HandleServerMessage(field)
                        console.log("msg nb: " + collection.find().count())
                })
            , 1000)
        else
            collection.find().observeChanges({
                added: (id, field) ->
                    HandleServerMessage(field)
                    console.log("msg nb: " + collection.find().count())
            })

    currentRoomId = null

    RegisterToRoom = (roomId) ->
        console.log("CALLING register_player_for_game")
        Meteor.call("register_player_for_game", roomId, (error, result) ->
            console.log("error: '#{error}' | result: '#{JSON.stringify(result)}'")
            if result.playersNb == 1
                Meteor.setTimeout(() ->
                    require("music_manager").softLoopAnimation()
                , 500)
                if window.Notification? == true
                    Notification.requestPermission((res) ->
                        if res == "denied"
                            console.log("NOTIFICATION DENIED")
                        else if res == "granted"
                            console.log("NOTIFICATION DENIED")
                        else
                            console.log(res)
                    )

            currentRoomId = roomId
            game_data = require("game_data")
            game_data.set("IsPlayer", result.isPlayer)
            if result.isAlreadyPlaying #if the player is already playing another game
                console.log("already ingame at #{result.otherRoomId}")
                game_data.set("IsAlreadyPlayingOtherGame", true)
                game_data.set("OtherRoomId", result.otherRoomId)
            else
                if result.isStarted #if the game is already running
                    if not result.isPlayer #if the user is a spectator
                        game_data.set("BottomPlayerId", result.snapshot.players[0].id)
                        game_data.set("TopPlayerId", result.snapshot.players[1].id)

                    console.log("reading from snapshot")
                    game_data.set("IsGameRoomReady", true)

                    Meteor.setTimeout(() ->
                        UpdateFromSnapshot(result.snapshot)
                    , 500)
                    ListenToServerMessages(roomId, false)
                else
                    ListenToServerMessages(roomId)
       )


    return {
        serverMessagesHandlers: serverMessagesHandlers
        HandleServerMessage: HandleServerMessage
        ListenToServerMessages: ListenToServerMessages
        RegisterToRoom: RegisterToRoom
        DuelStartWithMessage: DuelStartWithMessage
        currentRoomId: currentRoomId
    }
)