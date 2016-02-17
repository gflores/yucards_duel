Template.duelView.helpers({
    IsGameRoomReady: () ->
        return require("game_data").get("IsGameRoomReady")
    IsGameFinished: () ->
        return require("game_data").get("IsGameFinished")
    IsWinner: () ->
        return require("game_data").get("IsWinner")
    IsAlreadyPlayingOtherGame: () ->
        return require("game_data").get("IsAlreadyPlayingOtherGame")
    OtherRoomUrl: () ->
        return Router.routes.duel.url({roomId: require("game_data").get("OtherRoomId")})

})
