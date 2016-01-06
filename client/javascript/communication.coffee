define("communication", [], ()->

    SetCardsToPlayer = (playableCards) ->
        player_data = require("player_data")
        cards_module = require("cards")

        for card, index in playableCards
            player_data.set("Card#{index}", cards_module.Construct(card.value, card.element, index))

    SetCardsToOpponent = (playableCards) ->
        opponent_data = require("opponent_data")
        cards_module = require("cards")

        for card, index in playableCards
            opponent_data.set("Card#{index}", cards_module.Construct(card.value, card.element, index))

    serverMessagesHandlers = {
        "duel_countdown": (message) ->
            console.log("duel is going to start in #{message.countdownDuration} ms. OpponentID: #{if message.players_ids[0] == Meteor.userId() then message.players_ids[1] else message.players_ids[0]}")

        "duel_start": (message) ->
            game_data = require("game_data")
            [player, opponent] = if message.players[0].id == Meteor.userId() then [message.players[0], message.players[1]] else [message.players[1], message.players[0]]
            SetCardsToPlayer(player.playableCards)
            SetCardsToOpponent(opponent.playableCards)
            game_data.set("IsGameRoomReady", true)
            opponent_data = require("opponent_data")
            opponent_data.set("UserId", opponent.id)
            opponent_data.set("CurrentScore", 0)
            opponent_data.set("MaxScore", 60)

        "player_preparing_play": (message) ->
            if message.player_id == Meteor.userId()
                console.log("I prepare play !")
            else
                console.log("opponent is preparing play")
                require("player_actions").LaunchLoaderForOpponent()
                require("player_actions").SetAvailableForPlayer(require("opponent_data"), false)

        "card_played": (message) ->
            game_data = require("game_data")
            cards_module = require("cards")

            card_player_data = null
            if message.player_id == Meteor.userId()
                card_player_data = require("player_data")
                require("player_actions").RemoveLoaderForPlayer()
                Blaze.remove(require("global_data").playerCardLoadingRenderer)
            else
                card_player_data = require("opponent_data")
                require("player_actions").RemoveLoaderForOpponent()

            require("player_actions").SetAvailableForPlayer(card_player_data, true)
            newTopCard = card_player_data.get("Card#{message.cardPlayedIndex}")
            game_data.set("TopCard", newTopCard)
            card_player_data.set("Card#{message.cardPlayedIndex}", cards_module.Construct(message.newCard.value, message.newCard.element, message.cardPlayedIndex))
            card_player_data.set("CurrentScore", message.currentScore)

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