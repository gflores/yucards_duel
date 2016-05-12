DEF("player_data", [], () ->
    return new ReactiveDict('playerData');
)

DEF("opponent_data", [], () ->
    return new ReactiveDict('opponentData');
)

DEF("game_data", [], () ->
    game_data = new ReactiveDict('gameData');
    return game_data;
)

DEF("global_data", [], () ->
    IsBottomPlayer = (userId) ->
        game_data = REQ("game_data")
        if game_data.get("IsPlayer")
            return Meteor.userId() == userId
        else #if it is spectator
            return game_data.get("BottomPlayerId") == userId
    IsTopPlayer = (userId) ->
        game_data = REQ("game_data")
        if game_data.get("IsPlayer")
            return Meteor.userId() == userId
        else #if it is spectator
            return game_data.get("TopPlayerId") == userId

    return {
        isDuelStartMessageReceived: false
        isBuildupStartFailed: false
        duelStartMessage: {}

        CountdownInterval: null

        playerCardLoadingRenderers: []
        opponentCardLoadingRenderers: []
        IsBottomPlayer: IsBottomPlayer
        IsTopPlayer: IsTopPlayer
        IsRegistrationConfirmed: false

        SubscribeHandler: null
    }
)