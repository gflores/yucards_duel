Template.duelView.helpers({
    IsGameRoomReady: () ->
        return require("game_data").get("IsGameRoomReady")
    IsGameFinished: () ->
        return require("game_data").get("IsGameFinished")
    IsWinner: () ->
        return require("game_data").get("IsWinner")
    IsAlreadyPlayingOtherGame: () ->
        return require("game_data").get("IsAlreadyPlayingOtherGame")
    IsPlayer: () ->
        return require("game_data").get("IsPlayer")
    OtherRoomUrl: () ->
        return Router.routes.duel.url({roomId: require("game_data").get("OtherRoomId")})
    ScoreChange: () ->
        player_data = require("player_data")
        scoreChange = player_data.get("NewScore") - player_data.get("OldScore")
        if scoreChange >= 0
            return "+#{scoreChange}"
        else
            return scoreChange
    GetPlayerData: () ->
        return require("player_data")
    GetOpponentData: () ->
        return require("opponent_data")

})


Template.duelView.events({
    "click .see-results": (event) ->
        $(".first-part").toggle()
        $(".next-part").toggle()
        # setTimeout(() ->
        #     $(".end-game-buttons").toggle()
        # , 2000
        # )

    "click .play-again": (event) ->
        location.reload()

    "click .go-to-home": (event) ->
        window.location.href = Router.routes.mainRoom.url({})
})

Template.playerResult.helpers({
    GetOldScore: () ->
        this.data.get("OldScore")
    GetNewScore: () ->
        this.data.get("NewScore")
    GetOldRank: () ->
        this.data.get("OldRank")
    GetNewRank: () ->
        this.data.get("NewRank")
    GetWinNumber: () ->
        this.data.get("WinNumber")
    GetLoseNumber: () ->
        this.data.get("LoseNumber")
})